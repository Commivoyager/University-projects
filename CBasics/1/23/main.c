#include<stdio.h>
int main(void)
{
	printf("Enter n=");
	int n;
	scanf_s("%d",&n);
	int a;
	int sum=0;
	int count=0;
	for (int i = 1; i <= n; i++)
	{
		printf("\nEnter a%d=", i);
		scanf_s("%d",&a);
		if (a < 0) 
			count++;
		else 
			sum = sum+a;
	}
	printf("\nCount of negative: %d \n\nSum of positive: %d\n", count, sum);
}