include ../Makerules
PROGS = addfl16_test subfl16_test mulfl16_test divfl16_test

all: $(PROGS)

%: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f  *.o $(PROGS) *.gdb


