/****************************************************************************/
/*
 *	A simple program to manipulate flat files
 *
 *	Copyright (C) 2001-2003 SnapGear Inc, davidm@snapgear.com
 *	Copyright (C) 2001 Lineo, davidm@lineo.com
 *
 * This is Free Software, under the GNU Public Licence v2 or greater.
 *
 */
/****************************************************************************/

#include <stdio.h>    /* Userland pieces of the ANSI C standard I/O package  */
#include <unistd.h>   /* Userland prototypes of the Unix std system calls    */
#include <time.h>
#include <stdlib.h>   /* exit() */
#include <string.h>   /* strcat(), strcpy() */
#include <assert.h>

/* macros for conversion between host and (internet) network byte order */
#ifndef WIN32
#include <netinet/in.h> /* Consts and structs defined by the internet system */
#define	BINARY_FILE_OPTS
#else
#include <winsock2.h>
#define	BINARY_FILE_OPTS "b"
#endif

#include <zlib.h>
#include <libiberty.h>

/* from uClinux-x.x.x/include/linux */
#include "flat.h"     /* Binary flat header description                      */

#if defined(__MINGW32__)
#include <getopt.h>

#define mkstemp(p) mktemp(p)

#endif

/****************************************************************************/

char *program_name;

static char cmd[1024];
static int print = 0, docompress = 0, ramload = 0, stacksize = 0, ktrace = 0;
static int l1stack = 0;

/****************************************************************************/

typedef enum
{
  INVALID,
  UNCOMPRESSED,
  COMPRESSED
} stream_type;

/* Tagged union holding either a regular FILE* handle or a zlib gzFile
   handle.  */

typedef struct
{
  stream_type type;
  const char *mode;
  union
    {
      FILE *filep;
      gzFile gzfilep;
    } u;
} stream;

/* Open an (uncompressed) file as a stream.  Return 0 on success, 1 on
   error.
   NOTE: The MODE argument must remain valid for the lifetime of the stream,
   because it is referred to by reopen_stream_compressed() if it is called.
   String constants work fine.  */

static int
fopen_stream_u(stream *fp, const char *path, const char *mode)
{
	fp->u.filep = fopen(path, mode);
	fp->type = (fp->u.filep) ? UNCOMPRESSED : INVALID;
	fp->mode = mode;
	return (fp->u.filep) ? 0 : 1;
}

/* Read from stream.  Return number of elements read.  */

static size_t
fread_stream(void *ptr, size_t size, size_t nmemb, stream *str)
{
	size_t read;

	switch (str->type) {
		case UNCOMPRESSED:
		read = fread(ptr, size, nmemb, str->u.filep);
		break;

		case COMPRESSED:
		read = gzread(str->u.gzfilep, ptr, size * nmemb) / size;
		break;

		default:
		abort();
	}

	return read;
}

/* Write to stream.  Return number of elements written.  */

static size_t
fwrite_stream(const void *ptr, size_t size, size_t nmemb, stream *str)
{
	size_t written;

	switch (str->type) {
		case UNCOMPRESSED:
		written = fwrite(ptr, size, nmemb, str->u.filep);
		break;

		case COMPRESSED:
		written = gzwrite(str->u.gzfilep, ptr, size * nmemb) / size;
		break;

		default:
		abort();
	}

	return written;
}

/* Close stream.  */

static int
fclose_stream(stream *str)
{
	switch (str->type) {
		case UNCOMPRESSED:
		return fclose(str->u.filep);

		case COMPRESSED:
		return gzclose(str->u.gzfilep);

		default:
		abort();
	}
	
	return 0;
}

static int
ferror_stream(stream *str)
{
	switch (str->type) {
		case UNCOMPRESSED:
		return ferror(str->u.filep);
		
		case COMPRESSED:
		{
			const char *err;
			int errno;
			
			err = gzerror(str->u.gzfilep, &errno);
			if (errno == Z_OK || errno == Z_STREAM_END)
				return 0;
			else if (errno == Z_ERRNO)
				return 1;
			else {
				fprintf(stderr, "%s\n", err);
				return 1;
			}
		}
		break;
		
		default:
		abort();
	}

	return 0;
}

/* Reopen a stream at the current file position.  */

static void
reopen_stream_compressed(stream *str)
{
	int fd;
	long offset, roffset;

	/* Already a compressed stream, return immediately  */
	if (str->type == COMPRESSED)
		return;

	if (str->type == INVALID)
		abort();

	fd = fileno(str->u.filep);
	/* Get current (buffered) file position.  */
	offset = ftell(str->u.filep);
	
	/* Make sure there's nothing left in buffers.  */
	fflush(str->u.filep);
  
	/* Reposition underlying FD.  (Might be unnecessary?)  */
	roffset = lseek(fd, offset, SEEK_SET);
  
	assert(roffset == offset);
  
	/* Reopen as compressed stream.  */
	str->u.gzfilep = gzdopen(fd, str->mode);
	gzsetparams(str->u.gzfilep, 9, Z_DEFAULT_STRATEGY);
	str->type = COMPRESSED;
}

void
transfer(stream *ifp, stream *ofp, int count)
{
	int n, num;

	while (count == -1 || count > 0) {
		if (count == -1 || count > sizeof(cmd))
			num = sizeof(cmd);
		else
			num = count;
		n = fread_stream(cmd, 1, num, ifp);
		if (n == 0)
			break;
		if (fwrite_stream(cmd, n, 1, ofp) != 1) {
			fprintf(stderr, "Write failed :-(\n");
			exit(1);
		}
		if (count != -1)
			count -= n;
	}
	if (count > 0) {
		fprintf(stderr, "Failed to transfer %d bytes\n", count);
		exit(1);
	}
}

/****************************************************************************/

void
process_file(char *ifile, char *ofile)
{
	int old_flags, old_stack, new_flags, new_stack;
	stream ifp, ofp;
	struct flat_hdr old_hdr, new_hdr;
	char *tfile, tmpbuf[256];
	int input_error, output_error;
	FILE *tifp, *tofp;

	*tmpbuf = '\0';

	if (fopen_stream_u(&ifp, ifile, "r" BINARY_FILE_OPTS)) {
		fprintf(stderr, "Cannot open %s\n", ifile);
		return;
	}

	if (fread_stream(&old_hdr, sizeof(old_hdr), 1, &ifp) != 1) {
		fprintf(stderr, "Cannot read header of %s\n", ifile);
		return;
	}

	if (strncmp(old_hdr.magic, "bFLT", 4) != 0) {
		fprintf(stderr, "Cannot read header of %s\n", ifile);
		return;
	}

	new_flags = old_flags = ntohl(old_hdr.flags);
	new_stack = old_stack = ntohl(old_hdr.stack_size);
	new_hdr = old_hdr;

	if (docompress == 1) {
		new_flags |= FLAT_FLAG_GZIP;
		new_flags &= ~FLAT_FLAG_GZDATA;
	} else if (docompress == 2) {
		new_flags |= FLAT_FLAG_GZDATA;
		new_flags &= ~FLAT_FLAG_GZIP;
	} else if (docompress < 0)
		new_flags &= ~(FLAT_FLAG_GZIP|FLAT_FLAG_GZDATA);
	
	if (ramload > 0)
		new_flags |= FLAT_FLAG_RAM;
	else if (ramload < 0)
		new_flags &= ~FLAT_FLAG_RAM;
	
	if (ktrace > 0)
		new_flags |= FLAT_FLAG_KTRACE;
	else if (ktrace < 0)
		new_flags &= ~FLAT_FLAG_KTRACE;

	if (l1stack > 0)
		new_flags |= FLAT_FLAG_L1STK;
	else if (l1stack < 0)
		new_flags &= ~FLAT_FLAG_L1STK;
	
	if (stacksize)
		new_stack = stacksize;

	if (print == 1) {
		time_t t;

		printf("%s\n", ifile);
		printf("    Magic:        %4.4s\n", old_hdr.magic);
		printf("    Rev:          %d\n",    ntohl(old_hdr.rev));
		t = (time_t) htonl(old_hdr.build_date);
		printf("    Build Date:   %s",      t?ctime(&t):"not specified\n");
		printf("    Entry:        0x%x\n",  ntohl(old_hdr.entry));
		printf("    Data Start:   0x%x\n",  ntohl(old_hdr.data_start));
		printf("    Data End:     0x%x\n",  ntohl(old_hdr.data_end));
		printf("    BSS End:      0x%x\n",  ntohl(old_hdr.bss_end));
		printf("    Stack Size:   0x%x\n",  ntohl(old_hdr.stack_size));
		printf("    Reloc Start:  0x%x\n",  ntohl(old_hdr.reloc_start));
		printf("    Reloc Count:  0x%x\n",  ntohl(old_hdr.reloc_count));
		printf("    Flags:        0x%x ( ",  ntohl(old_hdr.flags));
		if (old_flags) {
			if (old_flags & FLAT_FLAG_RAM)
				printf("Load-to-Ram ");
			if (old_flags & FLAT_FLAG_GOTPIC)
				printf("Has-PIC-GOT ");
			if (old_flags & FLAT_FLAG_GZIP)
				printf("Gzip-Compressed ");
			if (old_flags & FLAT_FLAG_GZDATA)
				printf("Gzip-Data-Compressed ");
			if (old_flags & FLAT_FLAG_KTRACE)
				printf("Kernel-Traced-Load ");
			if (old_flags & FLAT_FLAG_L1STK)
				printf("L1-Scratch-Stack ");
			printf(")\n");
		}
	} else if (print > 1) {
		static int first = 1;
		unsigned int text, data, bss, stk, rel, tot;

		if (first) {
			printf("Flag Rev   Text   Data    BSS  Stack Relocs    RAM Filename\n");
			printf("-----------------------------------------------------------\n");
			first = 0;
		}
		*tmpbuf = '\0';
		strcat(tmpbuf, (old_flags & FLAT_FLAG_KTRACE) ? "k" : "");
		strcat(tmpbuf, (old_flags & FLAT_FLAG_RAM) ? "r" : "");
		strcat(tmpbuf, (old_flags & FLAT_FLAG_GOTPIC) ? "p" : "");
		strcat(tmpbuf, (old_flags & FLAT_FLAG_GZIP) ? "z" :
					((old_flags & FLAT_FLAG_GZDATA) ? "d" : ""));
		printf("-%-3.3s ", tmpbuf);
		printf("%3d ", ntohl(old_hdr.rev));
		printf("%6d ", text=ntohl(old_hdr.data_start)-sizeof(struct flat_hdr));
		printf("%6d ", data=ntohl(old_hdr.data_end)-ntohl(old_hdr.data_start));
		printf("%6d ", bss=ntohl(old_hdr.bss_end)-ntohl(old_hdr.data_end));
		printf("%6d ", stk=ntohl(old_hdr.stack_size));
		printf("%6d ", rel=ntohl(old_hdr.reloc_count) * 4);
		/*
		 * work out how much RAM is needed per invocation, this
		 * calculation is dependent on the binfmt_flat implementation
		 */
		tot = data; /* always need data */

		if (old_flags & (FLAT_FLAG_RAM|FLAT_FLAG_GZIP))
			tot += text + sizeof(struct flat_hdr);
		
		if (bss + stk > rel) /* which is bigger ? */
			tot += bss + stk;
		else
			tot += rel;

		printf("%6d ", tot);
		/*
		 * the total depends on whether the relocs are smaller/bigger than
		 * the BSS
		 */
		printf("%s\n", ifile);
	}

	/* if there is nothing else to do, leave */
	if (new_flags == old_flags && new_stack == old_stack)
		return;
	
	new_hdr.flags = htonl(new_flags);
	new_hdr.stack_size = htonl(new_stack);

	tfile = make_temp_file("flthdr");

	if (fopen_stream_u(&ofp, tfile, "w" BINARY_FILE_OPTS)) {
		fprintf(stderr, "Failed to open %s for writing\n", tfile);
		unlink(tfile);
		exit(1);
	}

	/* Copy header (always uncompressed).  */
	if (fwrite_stream(&new_hdr, sizeof(new_hdr), 1, &ofp) != 1) {
		fprintf(stderr, "Failed to write to  %s\n", tfile);
		unlink(tfile);
		exit(1);
	}

	/* Whole input file (including text) is compressed: start decompressing
	   now.  */
	if (old_flags & FLAT_FLAG_GZIP)
		reopen_stream_compressed(&ifp);

	/* Likewise, output file is compressed. Start compressing now.  */
	if (new_flags & FLAT_FLAG_GZIP) {
		printf("zflat %s --> %s\n", ifile, ofile);
		reopen_stream_compressed(&ofp);
	}
	
	transfer(&ifp, &ofp,
		  ntohl (old_hdr.data_start) - sizeof (struct flat_hdr));

	/* Only data and relocs were compressed in input.  Start decompressing
	   from here.  */
	if (old_flags & FLAT_FLAG_GZDATA)
		reopen_stream_compressed(&ifp);
	
	/* Only data/relocs to be compressed in output.  Start compressing
	   from here.  */
	if (new_flags & FLAT_FLAG_GZDATA) {
		printf("zflat-data %s --> %s\n", ifile, ofile);
		reopen_stream_compressed(&ofp);
	}

	transfer(&ifp, &ofp, -1);

	input_error = ferror_stream(&ifp);
	output_error = ferror_stream(&ofp);
	
	if (input_error || output_error) {
		fprintf(stderr, "Error on file pointer%s%s\n",
				input_error ? " input" : "",
				output_error ? " output" : "");
		unlink(tfile);
		exit(1);
	}

	fclose_stream(&ifp);
	fclose_stream(&ofp);

	/* Copy temporary file to output location.  */
	fopen_stream_u(&ifp, tfile, "r" BINARY_FILE_OPTS);
	fopen_stream_u(&ofp, ofile, "w" BINARY_FILE_OPTS);
	
	transfer(&ifp, &ofp, -1);
	
	fclose_stream(&ifp);
	fclose_stream(&ofp);

	unlink(tfile);
	free(tfile);
}

/****************************************************************************/

void
usage(char *s)
{
	if (s)
		fprintf(stderr, "%s\n", s);
	fprintf(stderr, "usage: %s [options] flat-file\n", program_name);
	fprintf(stderr, "       Allows you to change an existing flat file\n\n");
	fprintf(stderr, "       -p      : print current settings\n");
	fprintf(stderr, "       -z      : compressed flat file\n");
	fprintf(stderr, "       -d      : compressed data-only flat file\n");
	fprintf(stderr, "       -Z      : un-compressed flat file\n");
	fprintf(stderr, "       -r      : ram load\n");
	fprintf(stderr, "       -R      : do not RAM load\n");
	fprintf(stderr, "       -k      : kernel traced load (for debug)\n");
	fprintf(stderr, "       -K      : normal non-kernel traced load\n");
	fprintf(stderr, "       -u      : place stack in L1 scratchpad memory\n");
	fprintf(stderr, "       -U      : place stack in normal SDRAM memory\n");
	fprintf(stderr, "       -s size : stack size\n");
	fprintf(stderr, "       -o file : output-file\n"
	                "                 (default is to modify input file)\n");
	exit(1);
}

/****************************************************************************/

int
main(int argc, char *argv[])
{
	int c;
	char *ofile = NULL, *ifile;

	program_name = argv[0];

	while ((c = getopt(argc, argv, "pdzZrRuUkKs:o:")) != EOF) {
		switch (c) {
		case 'p': print = 1;                break;
		case 'z': docompress = 1;           break;
		case 'd': docompress = 2;           break;
		case 'Z': docompress = -1;          break;
		case 'r': ramload = 1;              break;
		case 'R': ramload = -1;             break;
		case 'k': ktrace = 1;               break;
		case 'K': ktrace = -1;              break;
		case 'u': l1stack = 1;              break;
		case 'U': l1stack = -1;             break;
		case 'o': ofile = optarg;           break;
		case 's':
			if (sscanf(optarg, "%i", &stacksize) != 1)
				usage("invalid stack size");
			break;
		default:
			usage("invalid option");
			break;
		}
	}

	if (optind >= argc)
		usage("No input files provided");

	if (ofile && argc - optind > 1)
		usage("-o can only be used with a single file");
	
	if (!print && !docompress && !ramload && !stacksize) /* no args == print */
		print = argc - optind; /* greater than 1 is short format */
	
	for (c = optind; c < argc; c++) {
		ifile = argv[c];
		if (!ofile)
			ofile = ifile;
		process_file(ifile, ofile);
		ofile = NULL;
	}
	
	exit(0);
}

/****************************************************************************/
