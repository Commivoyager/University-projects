#include<stdio.h>
void main()
{
	unsigned int n;
	double a;
	printf("a)\nEnter natural n=");
	scanf_s("%d", &n);
	printf("Enter real a=");
	scanf_s("%lf", &a);
	double sum=0;
	double temp=1;
	for (int i = 0; i <= n; i++)
	{
		temp = temp * (a + i);
		sum = sum + 1 / temp;
	}
	printf("sum=%10.5lf\n\nb)\nEnter natural n=",sum);
	scanf_s("%d", &n);
	printf("\nEnter real a=");
	scanf_s("%lf", &a);
	sum = 1/a;
	double dgr = 1;
	for (int i = 1; i <= n; i++)
	{
		dgr = dgr * a*a;
		sum = sum + 1 / dgr;
	}
	printf("\nResult: %10.5lf\n", sum);
}