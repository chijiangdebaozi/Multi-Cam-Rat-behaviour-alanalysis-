
#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void test0()
{
    int d, n = 100;
    for (d = 2; d < n; d++)
    {
        if (d % 5 == 0)
        {
            printf("c is %d\n",&d);
        }

    }
}

int main()
{
    int d, n = 100;
    for (d = 2; d < n; d++)
    {
        if (d % 5 == 0)
        {
            printf("c is %d\n", &d);
        }

    }


    system("pause");
    return 0;
}

