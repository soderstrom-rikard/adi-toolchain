#include <stdlib.h>
#include <stdio.h>

int baz (int c)
{
    int x [950];
    void *sp;
    memset (x, 0, sizeof x);
    asm ("%0 = SP;": "=da" (sp):);
    printf ("baz %p\n", sp);
    return x[c];
}

int bar (int c)
{
    int x [40000];
    void *sp;
    memset (x, 0, sizeof x);
    asm ("%0 = SP;": "=da" (sp):);
    printf ("bar %p\n", sp);
    return x[c];
}

int main ()
{
    puts ("calling baz\n");
    baz (3);
    sleep (3); 
    puts ("calling bar\n");
    bar (3);
    puts ("end\n");
    return 0;
}
