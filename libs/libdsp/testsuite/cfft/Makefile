include ../Makerules
PROGS = cfft 

all: $(PROGS)

%: %.c
	$(CC) -D__USE_FFT_REL45__ -DDO_CYCLE_COUNTS $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f  *.o $(PROGS) *.gdb
