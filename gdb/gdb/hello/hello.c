void func()
{
	int x, y, z;
        printf("func got called\n");
	x = 10;
	y = 20;
	z = 30;
	printf("called from main");
}
int func2(int i)
{
  printf("func2 got called\n");
  return 2*i;
}
int func3(int i, int j);
int func4(int i, int j);
main()
{
int ret;
printf("gdb testing");
func();
 ret = func3(1, func2(2));
 ret = func4(func2(ret), ret);
 

return ret;
}

int func3(int i, int j)
{
   printf("func3 got called\n");
   return i + j;
}

int func4(int i, int j)
{
  printf("func4 got called\n");
  return i*j;
}
