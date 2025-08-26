#include <stdio.h>
void main()
{
	printf("a)\n");
	printf("Enter natural n=");
	unsigned int n;
	scanf_s("%d", &n);
	double sum=0;
	double temp;
	for (int k = 1; k <= n; k++)
		sum = sum + (double)1 / (k * k * k * k * k);
	printf("sum=%.15lf\nb)\n", sum);
	printf("Enter natural n=");
	scanf_s("%d/n", &n);
	sum = 0;
	short sign = -1;
	for (int k = 1; k <= n; k++)
	{
		sum = sum + sign / (double)((2 * k + 1) * k);
		sign = sign * (-1);
	}
	printf("%.15lf", sum);
}