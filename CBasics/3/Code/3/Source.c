#include <stdio.h>
void main() {
	const size = 7;
	int arr[7][7];
	int i, j;
	for (i = 0; i < size; i++) {
		int sum;
		sum = 0;
		for (j = 0; j < size; j++) {
			arr[i][j] = rand() % 100;
			sum = sum + arr[i][j];
			printf("%d ", arr[i][j]);
		}
		printf("	sum = %d\n", sum);
	}
	int k;
	for (i = 0; i < size; i++) {
		int temp;
		for (k=size; k > 0; k--) {
			for (j = 1; j < k; j++) {
				if (arr[i][j - 1] > arr[i][j]) {
					temp = arr[i][j];
					arr[i][j] = arr[i][j - 1];
					arr[i][j - 1] = temp;
				}
			}
		}
	}
	int sum[7];
	for (i = 0; i < size; i++) {
		sum[i] = 0;
		for (j = 0; j < size; j++) {
			sum[i] = sum[i] + arr[i][j];
		}
	}
	for (k = size; k>0;k--) {
		int temp, sum1, sum2;
		for (i = 1; i<k; i++) {
			if (sum[i-1] < sum[i]) {
				temp = sum[i - 1];
				sum[i - 1] = sum[i];
				sum[i] = temp;
				for (j = 0; j < size; j++) {
					temp = arr[i - 1][j];
					arr[i - 1][j] = arr[i][j];
					arr[i][j] = temp;
				}
			}
		}
	}
	for (i = 0; i < size; i++) {
		printf("\n");
		for (j = 0; j < size; j++) {
			printf("%d ", arr[i][j]);
		}
		printf("	sum = %d", sum[i]);
	}
}