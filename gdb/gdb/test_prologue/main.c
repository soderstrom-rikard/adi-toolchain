void func1();
int  func2(int i , int j);
int  func3(int i, int j, int k, int l, int m);
int  func4(int fib);
void func11();
int  func22(int i , int j);
int  func33(int i, int j, int k, int l, int m);
int  func44(int fib);

int main()
{
   int i = 0, j =1, k;
   func1();
   k = func2(i, j);
   k = func3(i,j,k,j,i);
  k = func4(k);
  func11();
   k = func22(i, j);
   k = func33(i,j,k,j,i);
  k = func44(k);
   return k;
}
