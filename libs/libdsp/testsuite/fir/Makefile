include ../Makerules
PROGS = fir 

all: $(PROGS)

%: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f  *.o $(PROGS) *.gdb
						
