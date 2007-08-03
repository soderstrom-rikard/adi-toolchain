include ../Makerules
PROGS = Verify28_4

all: $(PROGS)

Verify28_4: MatrixMulVec.c Verification.c 
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f  *.o $(PROGS) *.gdb
