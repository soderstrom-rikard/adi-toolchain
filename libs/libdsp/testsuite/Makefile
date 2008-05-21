include Makerules

PROGS = math stats vector filter ifft
subdirs = cfft fir float16 matrix_mul_vec24_8 matrix_mul_vec28_4

all: $(PROGS)
	for subdir in $(subdirs); do \
		$(MAKE) $(FLAGS_TO_PASS) -C $$subdir all; \
	done
		
%: %.c
	$(CC) -DDO_CYCLE_COUNTS $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f  *.o $(PROGS) *.gdb
	for subdir in $(subdirs); do \
		$(MAKE) $(FLAGS_TO_PASS) -C $$subdir clean; \
	done
