CC=$(CROSS)gcc
AR=$(CROSS)ar
RANLIB=$(CROSS)ranlib
STRIPTOOL=$(CROSS)strip
RM=rm


LIBBFFASTFP=libbffastfp.a
LIBBFDSP=# libbfdsp.a
LIBRARIES=$(LIBBFFASTFP) $(LIBBFDSP)

SOURCES=fpadd.asm fpsub.asm fpmult.asm fpdiv.asm \
	addfl64.asm subfl64.asm mulfl64.asm divfl64.asm \
	f32tof64.asm f64tof32.asm \
	f32toi32z.asm f64toi32z.asm f64toi64z.asm \
	f32tou32z.asm f64tou32z.asm f64tou64z.asm \
	fltsif.asm i32tof64.asm i64tof64.asm \
	fltuif.asm u32tof64.asm u64tof64.asm \
	fltcmp.asm cmpfl64.asm \
	eqsf2.asm gesf2.asm gtsf2.asm lesf2.asm nesf2.asm \
	eqdf2.asm gedf2.asm gtdf2.asm ledf2.asm nedf2.asm

OBJS=$(SOURCES:.asm=.o)

all: $(LIBRARIES)


$(LIBBFFASTFP): $(OBJS)
	$(AR) $(ARFLAGS) $(LIBBFFASTFP) $(OBJS) 
	$(RANLIB) $(LIBBFFASTFP)

$(OBJS): %.o: %.asm
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@
	$(STRIPTOOL) -x -R .note -R .comment $*.o

clean:
	$(RM) -f $(OBJS) $(LIBBFFASTFP)

