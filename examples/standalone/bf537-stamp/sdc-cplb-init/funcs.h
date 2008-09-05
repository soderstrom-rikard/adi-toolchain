void interrupts_init(void);
void exception_init(void);
void cache_init(void);
void hang(void) __attribute__((noreturn));
int func_in_external_memory(int arg);
