include ../Makerules
PROGS = Verify24_8

all: $(PROGS)

Verify24_8: MatrixMulVec.c Verification.c 
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f  *.o $(PROGS) *.gdb
