#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include<stdlib.h>
#include<string.h>
//#include <locale.h>
struct toy
{
	
	char name[50];
	float price;
	int lowerlim, higherlim;
};
typedef struct toy toy;

int fill(void); 
void getinfo(toy** pt, int* num);
void swap(toy* inf1, toy* inf2);
void main(void)
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	int flag;
	toy** ppinfo, *pinfo;
	pinfo = NULL;
	ppinfo = &pinfo;
	int* pnum, num;
	num = 0;
	pnum = &num;
	getinfo(ppinfo, pnum);
	for (int i = num-1; i >= 0; i--)
	{
		for (int j = 0; j < i; j++)
		{
			if (strcmp((*(pinfo + j)).name, (*(pinfo + j + 1)).name)>0)
			{
				swap(pinfo + j, pinfo + j + 1);
			}
		}
	}

	do
	{
		puts("Enter 1 if you want to find all toys for 1-3 years age limit\nEnter 0 to exit or another number to add new toy:");
		scanf("%d", &flag);
		if (flag)
		{
			if (1 == flag)
			{
				for (int i = 0; i < num; i++)
				{
					if ((1 == (*(pinfo + i)).lowerlim) && (3 == (*(pinfo + i)).higherlim))
					{
						puts((*(pinfo + i)).name);
						flag = 0;
					}		
				}
				if (flag)
				{
					puts("There are no corresponding products");
					flag = 0;
				}	
			}
			else
			{
				fill();
				flag = 1;
			}
		}
	} while (flag);
}
void swap(toy* inf1, toy* inf2)
{
	char n[50];
	float pr;
	int llim, hlim;
	strcpy(n,(*inf1).name);
	pr = (*inf1).price;
	llim = (*inf1).lowerlim;
	hlim = (*inf1).higherlim;

	strcpy((*inf1).name,(*inf2).name);
	(*inf1).price = (*inf2).price;
	(*inf1).lowerlim = (*inf2).lowerlim;
	(*inf1).higherlim = (*inf2).higherlim;

	strcpy((*inf2).name, n);
	(*inf2).price = pr;
	(*inf2).lowerlim = llim;
	(*inf2).higherlim = hlim;
}
void getinfo(toy** pt, int* num)
{
	FILE* f;
	char str[50];
	char strbuf[50] = "";
	int i;
	toy *t;
	*num = 0;
	*pt = (toy*)malloc((*num+1) * sizeof(toy));
	t = *pt;
	f = fopen("toys_info.txt", "r");
	while (NULL != fgets(str, 50, f))
	{
		
		*pt = (toy*)realloc(t, (*num+1) * sizeof(toy));
		t = *pt;
		i = 0;
		do
		{
			if (i)
			{
				strbuf[i] = ' ';
				i++;
			}
			sscanf(&(str[i]), "%s", &(strbuf[i]));
			i = i+strlen(&(strbuf[i]));
		} while (',' != strbuf[i-1]);
		strbuf[i - 1] = 0;
		strcpy((*(*pt+*num)).name, strbuf);
		sscanf(&(str[i]), "%f,", &((*(*pt + *num)).price));
		do
		{
			i++;
		} while (',' != str[i-1]);
		sscanf(&(str[i]), "%d,", &((*(*pt + *num)).lowerlim));
		do
		{
			i++;
		} while (',' != str[i-1]);
		sscanf(&(str[i]), "%d;", &((*(*pt + *num)).higherlim));
		(*num)++;
	};
	
	
	fclose(f);
	
}
void enterinfo(FILE* f, char* n, float pr, char llim, char hlim)
{
	//setlocale(LC_ALL, "RUS");
	fprintf(f, "%s, %.2f, %d, %d;\n", n, pr, llim, hlim);
}
int fill(void)
{
	
	FILE* finf;
	int flag;
	toy inf; //= { "abc",1,2,3 };
	finf = fopen("toys_info.txt", "a");
	if (NULL == finf)
		return 0;
	puts("Enter any number except 0 to enter information or 0 to stop:");
	scanf("%d", &flag);
	while (flag)
	{
		printf("\nName: ");
		//scanf("%s", inf.name);
		gets(inf.name);
		gets(inf.name);

		printf("\nPrice: ");
		scanf("%f", &(inf.price));
		
		printf("\nLower age limit: ");
		scanf("%d", &(inf.lowerlim));
		
		printf("\nHigher age: ");
		scanf("%d", &(inf.higherlim));
		
		enterinfo(finf, inf.name, inf.price, inf.lowerlim, inf.higherlim);
		puts("\nEnter any number except 0 to enter information or 0 to stop:");
		scanf("%d", &flag);
	} 
	fclose(finf);
	return flag;
}
