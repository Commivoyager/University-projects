#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
typedef struct stack_el stel;
struct stack_el
{
	int num;
	stel* next;
};

void push(stel** ppst, int el)
{
	stel* ptemp;
	ptemp = (stel*)malloc(sizeof(stel));
	ptemp->next = *ppst;
	ptemp->num = el;
	*ppst = ptemp;
}

void pop(stel** ppst, int* el)
{
	stel* ptemp;
	if (NULL != (*ppst))
	{
		ptemp = *ppst;
		*el = (*ppst)->num;
		*ppst = ptemp->next;
		free(ptemp);
		ptemp = NULL;
	}
	else
	{
		puts("There are no items in the stack");
	}
}

void del_even(stel ** ppcurr)
{
	stel* ptemp;
	while (NULL != *ppcurr)
	{
		if (0 == ((*ppcurr)->num) % 2)
		{
			ptemp = *ppcurr;
			*ppcurr = (*ppcurr)->next;
			free(ptemp);
		}
		else
		{
			ppcurr = &((*ppcurr)->next);
		}
	}
}

void displ_st(stel* pst)
{
	puts("\nStack:");
	while (NULL != pst)
	{
		printf("%d\n", pst->num);
		pst = pst->next;
	}
}

int main(void)
{
	int answ, num;
	stel* st;
	st = NULL;
	do
	{
		puts("Enter:");
		puts("1 - add item in stack");
		puts("2 - delete item");
		puts("3 - delete every even number");
		puts("4 - display all stack items");
		puts("0 - exit");
		scanf("%d", &answ);
		switch (answ)
		{
		case 1:
			puts("Enter number:");
			scanf("%d", &num);
			push(&st, num);
			break;
		case 2: 
			pop(&st, &num);
			printf("Deleted: %d\n", num);
			break;
		case 3:
			del_even(&st);
			break;
		case 4:
			displ_st(st);
			break;
		};
	} while (answ);
}