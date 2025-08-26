#define _CRT_SECURE_NO_WARNINGS
#include <iostream>

int** createarr(int elquantity, int dimension)
{
	int **arr = (int**)malloc(elquantity * sizeof(int*));
	for (int i = 0; i < elquantity; i++)
	{
		arr[i] = (int*)calloc(dimension + 1, sizeof(int));
	}
	return arr;
}

void fillimages(int ** arr, int imgquantity, int dimension)
{
	printf("Entering the values of the training sample:\n");
	for (int i = 0; i < imgquantity; i++)
	{
		printf("Enter values of the %d class image:\n", i);
		for (int j = 0; j < dimension; j++)
		{
			printf("%d: ", j);
			scanf("%d", &arr[i][j]);
		}
		arr[i][dimension] = 1;
		printf("%d: %d\n", dimension, 1);
	}
}

int scalarproduct(int* v1, int* v2, int d)
{
	int res = 0;
	for (int i = 0; i < d+1; i++)
	{
		res += v1[i] * v2[i];
	}
	return res;
}

void vectorsum(int* v1, int* v2, int d, int c)
{
	for (int i = 0; i < d+1; i++)
	{
		v1[i] = v1[i] + c * v2[i];
	}
	
}

void outpvector(int** v, int N, int d)
{
	for (int i = 0; i < N; i++)
	{
		printf("w%d\t", i);
	}
	printf("\n");
	for (int i = 0; i < N; i++)
	{
		printf("------");
	}
	for (int j = 0; j < d+1; j++)
	{
		printf("\n");
		for (int i = 0; i < N; i++)
		{
			printf("%d\t", v[i][j]);
		}
	}
}

void getfunc(int** imgarr, int** warr, int N, int d, int c)
{
	bool flag = true;
	int count = 0;
	while (flag)
	{
		printf("\n");
		for (int i = 0; i < 50; i++)
		{
			printf("=");
		}
		printf("\n%d iteration:", count);
		flag = false;
		for (int i = 0; i < N; i++)
		{
			int maxval = scalarproduct(imgarr[i], warr[i], d);
			int temp;
			bool change = false;
			for (int j = 0; j < N; j++)
			{
				temp = scalarproduct(imgarr[i], warr[j], d);
				if (temp >= maxval && i != j)
				{
					vectorsum(warr[j], imgarr[i], d, -c);
					change = true;
				}
			}
			if (change)
			{
				flag = true;
				vectorsum(warr[i], imgarr[i], d, c);
			}
			printf("\n\nFor %d class:\n\n", i);
			outpvector(warr, N, d);
		}
		count++;
	}
}

void outpfunc(int** w, int N, int d)
{
	printf("\nThe decisive function\n");
	for (int i = 0; i < N; i++)
	{
		printf("d%d(x) = ", i+1);
		for (int j = 0; j < d; j++)
		{
			if (w[i][j] < 0 || j == 0)
			{
				printf("%d*x%d", w[i][j], j + 1);
			}
			else
			{
				printf("+%d*x%d", w[i][j], j + 1);
			}
		}
		if (w[i][d] < 0)
		{
			printf("%d", w[i][d]);
		}
		else
		{
			printf("+%d", w[i][d]);
		}
		printf(" = ");
		for (int j = 0; j < d; j++)
		{
			if (w[i][j] < 0)
			{
				printf("%d*x%d", w[i][j], j + 1);
			}
			else if (w[i][j] != 0)
			{
				printf("%d*x%d", w[i][j], j + 1);
			}
		}
		if (w[i][d] < 0)
		{
			printf("%d", w[i][d]);
		}
		else if(w[i][d] != 0)
		{
			printf("+%d", w[i][d]);
		}
		printf("\n");
	}
	printf("\n");
}




int main()
{
	int N = 3;
	int dimension = 2;
	int c = 1;
	printf("Number of classes: ");
	scanf("%d", &N);
	printf("Dimension of space: ");
	scanf("%d", &dimension);
	printf("C: ");
	scanf("%d", &c);
	int** w = createarr(N, dimension);
	int** x = createarr(N, dimension);
	fillimages(x, N, dimension);
		
	getfunc(x, w, N, dimension, c);
	outpfunc(w, N, dimension);
	int* uservect = (int*)calloc(dimension+1, sizeof(int));
	do
	{
		printf("Enter vectors coordinates:\n");
		for (int i = 0; i < dimension; i++)
		{
			printf("%d: ", i);
			scanf("%d", uservect + i);
		}
		uservect[dimension] = 1;
		int max = scalarproduct(w[0], uservect, dimension);
		int ind = 0;
		for (int i = 1; i < N; i++)
		{
			int temp = scalarproduct(w[i], uservect, dimension);
			if (max < temp)
			{
				max = temp;
				ind = i;
			}
		}
		printf("Vector is belong to %d class\n", ind+1);
		printf("Enter 0 to continue: ");
		scanf("%d", &c);
	} while (!c);
	free(uservect);
	for (int i = 0; i < N; i++)
	{
		free(w[i]);
		free(x[i]);
	}
	free(w);
	free(x);
	return 0;
}