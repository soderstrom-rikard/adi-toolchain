void func()
{
        int x, y, z;
        x = 10;
        y = 20;
        z = 30;
        printf("called from main");
}

int func2(int i)
{
	return 2*i;
}

int func3(int i, int j);
int func4(int i, int j);
main()
{
  int ret = 0;
printf("gdb testing");
func();
  ret = func3(2, func2(2));
  ret = func4(ret, func2(ret));
return ret;
}

int func3(int i, int j)
{
	return i + j;
}

int func4(int i, int j)
{
	return i*j;
}
