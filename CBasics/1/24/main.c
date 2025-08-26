#include<stdio.h>
int main()
{
	int n;
	printf("Enter n=");
	scanf_s("\n%d",&n);
	int count = 0;
	for (int i = 1; i <= n; i++)
	{
		int a;
		printf("Enter a%d=", i);
		scanf_s("%d", &a);
		if (a > 7)
		{
			a = 7;
			count++;
		}
		printf("\t%d\n", a);
	}
	printf("The count of a>7: count=%d", count);
}