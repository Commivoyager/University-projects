#include <stdio.h>//28
//#include <ctime>
int main()
{
	//srand(time(NULL));
	int arr[9][9];
	int temp;
	for (int i = 0; i <= 8; i++)
	{
		for (int ind = 0; ind <= 8; ind++)
		{
			arr[i][ind] = rand()%50;
			printf("%d ", arr[i][ind]);
		}
		printf("\n");
		temp = arr[i][0];
		arr[i][0] = arr[i][i];
		arr[i][i] = temp;
	}
	printf("\n");
	for (int i = 0; i <= 8; i++)
	{
		for (int ind = 0; ind <= 8; ind++) {
			printf("%d ", arr[i][ind]);
		}
		printf("\n");
	}
}