CC=$(CROSS)gcc
AR=$(CROSS)ar
RANLIB=$(CROSS)ranlib
STRIPTOOL=$(CROSS)strip
RM=rm


LIBDSP=libdsp.a
LIBRARIES=$(LIBDSP)

SOURCES=fpadd.asm fpsub.asm fpmult.asm fpdiv.asm \
	addfl64.asm subfl64.asm mulfl64.asm divfl64.asm

OBJS=$(SOURCES:.asm=.o)

all: $(LIBRARIES)


$(LIBDSP): $(OBJS)
	$(AR) $(ARFLAGS) $(LIBDSP) $(OBJS) 
	$(RANLIB) $(LIBDSP)

$(OBJS): %.o: %.asm
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@
	$(STRIPTOOL) -x -R .note -R .comment $*.o

clean:
	$(RM) -f $(OBJS) $(LIBDSP)

