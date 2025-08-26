#include <stdio.h>//29
void main() {
	const str = 3, clmn = 4;
	int arr[4][5];
	for (int i = 0; i <= str; i++)
	{
		for (int ind = 0; ind <= clmn; ind++) {
			arr[i][ind] = rand()%100;
			printf_s("%d ", arr[i][ind]);
		};
		printf_s("\n");
	};
	printf("\n");
	for (int i = 0; i <= clmn; i = i + 2) {
		//int b;
		//b = arr[0][i];
		for (int end = str; end >= 0; end--)
		{
			for (int ind = 1; ind <= end; ind++) {
				int min;
				if (arr[ind-1][i] < arr[ind][i]) {
					min = arr[ind - 1][i];
					arr[ind - 1][i] = arr[ind][i];
					arr[ind][i] = min;
				}
			}
		}
	}
	for (int i = 1; i <= clmn; i = i + 2)
	{
		for (int end = str; end >= 0; end--)
		{
			for (int ind = 0; ind <= end; ind++)
			{
				int max;
				if (arr[ind - 1][i] > arr[ind][i])
				{
					max = arr[ind - 1][i];
					arr[ind - 1][i] = arr[ind][i];
					arr[ind][i] = max;
				}
			}
		}
	}
	for (int i = 0; i <= str; i++)
	{
		for (int ind = 0; ind <= clmn; ind++)
		{
			printf("%d ", arr[i][ind]);
		}
		printf("\n");
	}
}