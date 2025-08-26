#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
typedef struct node tnode;
struct node
{
	int data;
	tnode * pr, *pl;
};

void add_node(tnode** ppn, int num);
void del_pos(tnode** ppn, tnode** deln);
void del_node(tnode** ppn, int num);
void dir_bypass(tnode** ppn);
void rev_bypass(tnode** ppn);
void sym_bypass(tnode** ppn);
void find_way(tnode* pn, int* len, int* curr);
void tree_outp(tnode* pn);

int main(void)
{
	int elnum,num, el;
	tnode* pn = NULL;
	int curr = 0, len = 0;
	do
	{
		puts("Enter:");
		puts("1 - add new element");
		puts("2 - delete element");
		puts("3 - make a traversal");
		puts("4 - determine the maximum depth");
		puts("5 - show the tree");
		puts("0 - exit");
		scanf("%d", &num);
		switch (num)
		{
		case 1:
			puts("Enter number of elements");
			scanf("%d", &elnum);
			puts("\nEnter elements");
			for (int i = 0; i < elnum; i++)
			{
				scanf("%d", &el);
				add_node(&pn, el);
			}
			break;
		case 2:
			puts("Enter element to deleted");
			scanf("%d", &elnum);
			del_node(&pn, elnum);
			break;
		case 3:
			puts("Enter type of traversal:");
			puts("1 - direct");
			puts("2 - reverse");
			puts("3 - symmetric");
			scanf("%d", &elnum);
			switch (elnum)
			{
			case 1:
				puts("Sequence of vertices in a direct traversal");
				dir_bypass(&pn);
				break;
			case 2:
				puts("Sequence of vertices in a reverse traversal");
				rev_bypass(&pn);
				break;
			case 3:
				puts("Sequence of vertices in a symmetric traversal");
				sym_bypass(&pn);
				break;
			}
			break;
		case 4:
			len = 0;
			curr = 0;
			find_way(pn, &len, &curr);
			printf("Maximum depth: %d", len);
			break;
		case 5:
			tree_outp(pn);
			break;
		}
		puts("");
	} while (num);
	
	
}

void add_node(tnode ** ppn, int num)
{
	if (NULL == *ppn)
	{
		*ppn = (tnode*)malloc(sizeof(tnode));
		(*ppn)->data = num;
		(*ppn)->pl = NULL;
		(*ppn)->pr = NULL;
	}
	else
	{
		if (num < (*ppn)->data)
		{
			add_node(&((*ppn)->pl), num);
		}
		else
		{
			add_node(&((*ppn)->pr), num);
		}
	}
}

void del_pos(tnode** ppn, tnode** deln)
{
	tnode* temp;
	if (NULL != (*deln)->pr)
	{
		del_pos(ppn, &((*deln)->pr));
	}
	else
	{
		(*ppn)->data = (*deln)->data;
		temp = *deln;
		*deln = (*deln)->pl;
		free(temp);
		temp = NULL;
		//*deln = temp;
	}
}

void del_node(tnode** ppn, int num)
{
	tnode* deln = NULL;
	if (NULL == *ppn)
	{
		puts("\There is no this element or tree is empty");
	}
	else
	{
		if (num < (*ppn)->data)
		{
			del_node(&((*ppn)->pl), num);
		}
		else
		{
			if (num > (*ppn)->data)
			{
				del_node(&((*ppn)->pr), num);
			}
			else
			{
				if (NULL == (*ppn)->pl)
				{
					deln = *ppn;
					*ppn = (*ppn)->pr;
					free(deln);
					deln = NULL;
				}
				else
				{
					if (NULL == (*ppn)->pr)
					{
						deln = *ppn;
						*ppn = (*ppn)->pl;
						free(deln);
						deln = NULL;
					}
					else
					{
						deln = *ppn;
						del_pos(ppn, &deln);
					}
				}
			}
		}

	}
}

void dir_bypass(tnode **ppn)
{
	if (NULL != *ppn)
	{
		printf("%d", (*ppn)->data);
		dir_bypass(&((*ppn)->pl));
		dir_bypass(&((*ppn)->pr));
	}
}

void rev_bypass(tnode** ppn)
{
	if (NULL != *ppn)
	{
		rev_bypass(&((*ppn)->pl));
		rev_bypass(&((*ppn)->pr));
		printf("%d", (*ppn)->data);
	}
}

void sym_bypass(tnode** ppn)
{
	if (NULL != *ppn)
	{
		sym_bypass(&((*ppn)->pl));
		printf("%d", (*ppn)->data);
		sym_bypass(&((*ppn)->pr));
	}
}

void find_way(tnode* pn, int* len, int * curr)
{
	if (NULL != pn)
	{
		(*curr)++;
		find_way(pn->pl, len, curr);
		(*curr)--;
		if (NULL != pn->pr)
		{
			(*curr)++;
			find_way(pn->pr, len, curr);
			(*curr)--;
		}
		
		//find_way(pn->pr, len, curr);
	}
	else
	{
		if (*curr > *len)
		{
			*len = *curr - 1;
		}
		//*curr = 0;
	}
}

//Outp
typedef struct queue_node qn;
struct queue_node
{
	tnode* node;
	qn* next;
};



void init_queue(qn**ppfront, qn** pprear)
{
	*ppfront = NULL;
	*pprear = NULL;
}

int is_empty(qn* pfront)
{
	if (NULL == pfront)
		return 1;
	else
		return 0;
}

void enqueue(qn** ppfront, qn** pprear, tnode* pn)
{
	qn* ptemp;
	ptemp = (qn*)malloc(sizeof(qn));
	ptemp->next = NULL;
	ptemp->node = pn;
	if (is_empty(*ppfront))
	{
		*ppfront = ptemp;
		*pprear = ptemp;
	}
	else
	{
		(*pprear)->next = ptemp;
		*pprear = (*pprear)->next;
	}
	
}

void dequeue(qn** ppfront, tnode** ppn)
{
	qn* ptemp;
	if (is_empty(*ppfront))
	{
		*ppn = NULL;
	}
	else
	{
		*ppn = (*ppfront)->node;
		ptemp = *ppfront;
		*ppfront = (*ppfront)->next;
		free(ptemp);
		ptemp = NULL;
	}
}

void tree_outp(tnode * pn)
{
	int len = 0, curr = 0;
	qn* frq = NULL, *rq = NULL;
	find_way(pn, &len, &curr);

	init_queue(&frq, &rq);

	enqueue(&frq, &rq, pn);
	int count;
	int leavs = 1;
	int shift = 0, gap = 3, tempshft;
	for (int i = 0; i < len; i++)
	{
		leavs = leavs * 2;
		gap = gap * 2 + 1;
	}
	shift = ((leavs -1) * 3 + leavs)/2+1;
	tempshft = shift;
	for (int i = 0; i <= len; i++)
	{
		count = 1;
		for (int k = 0; k < i; k++)
		{
			count = count * 2;
		}

		for (int j = 0; j < count; j++)
		{
			dequeue(&frq, &pn);
			if (NULL != pn)
			{
				
				printf("%*d%*s", tempshft, pn->data, gap, " ");
				enqueue(&frq, &rq, pn->pl);
				enqueue(&frq, &rq, pn->pr);
			}
			else
			{
				printf("%*s%*s", tempshft, "_", gap," ");
				enqueue(&frq, &rq, NULL);
				enqueue(&frq, &rq, NULL);
			}	
			tempshft = 0;

		}
		printf("\n\n\n");
		
		gap = gap / 2;
		shift = shift - (gap/2)-1;
		tempshft = shift;
	}
	//free_queue();
	
}