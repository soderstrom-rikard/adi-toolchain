void func1()
{
        int i, j;
        i = i +j;
}

int func2 (int i, int j)
{
        return i + j;
}

int func3(int i, int j, int k, int l, int m1)
{
        int m, n, o, p, q;
        m = i;
        n = 2*j;
        o = 3*k;
        p = 4*l;
        q = 5*m1;
        return m + n + o + p + q;
}

int func4(int j)
{
        int arr[100];
        int count;
        arr[0] = arr[1] = 1;
        for(count = 2; count < j; count++)
        {
                arr[count] = arr[count -1] + arr[count -2];
        }
        return arr[j];
}

