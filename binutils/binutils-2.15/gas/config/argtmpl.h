/*
 * Copyright (c) 2000, 2001 Analog Devices Inc.,
 * Copyright (c) 2000, 2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin Architecture by 
 *	      Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *            Tony Kou <tony.ko@arcturusnetworks.com>
 */

#ifndef NAME
#define NAME "noname"
#endif

#ifndef DESCRIPTION
#define DESCRIPTION "no description"
#endif

#ifndef VERSION
#define VERSION "0.1a"
#endif

int verbose;

/* @CL-ARG-PAR */
struct arg args[] = {
  { 'v', "version",      AOP_VERSION,   "print version number",     0,          0 },
  { 'h', "help",         AOP_HELP,      "print help information",   0,          0 },
  { '?', "syntax",       AOP_SYNTAX,    "print syntax information", 0,          0 },
  { 'V', "verbose",      AOP_BOOL,      "verbose information",      &verbose,   0 },
  ARGS
  0
};
  
cmdline_t cargs = {
  NAME,
  VERSION,
  DESCRIPTION,
  0,
  MAXDEFARGS,
  0,0,
  args
};


#define PARSE_ARGS(argc, argv) 		\
  do {					\
    parse_args (&cargs, argc, argv);	\
    if (verbose)			\
      print_args (&cargs);		\
  } while (0)
