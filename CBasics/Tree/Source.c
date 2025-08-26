#define _CRT_SECURE_NO_WARNINGS //8 6 7 5 2 4 3 10 11 9 

#include <stdio.h>
#include <stdlib.h>
typedef struct node tnode;
struct node
{
	int data;
	int rtag, ltag;
	tnode* pr, * pl;
};

void add_node(tnode** ppn, int num);
void del_pos(tnode** ppn, tnode** deln);
void del_node(tnode** ppn, int num);
void dir_bypass(tnode** ppn);
void rev_bypass(tnode** ppn);
void sym_bypass(tnode** ppn);
void firm_rsym(tnode** curr, tnode** prev);
//void firmware(tnode** curr, tnode** prev);
void firmed_bypass(tnode* head);
void tree_outp(tnode* pn);
void find_way(tnode* pn, int* len, int* curr);
void del_infirm(tnode** ppn, tnode** pptmp, int num);
void nullfirm(tnode* pn);

int main(void)
{
	int elnum, num, el;
	tnode* pn = NULL;
	int curr = 0, len = 0;
	tnode* head, * headcpy;
	int isfirmed = 0;
	head = (tnode*)malloc(sizeof(tnode));
	head->pr = head;
	do
	{
		puts("Enter:");
		puts("1 - add new element");
		puts("2 - delete element");
		puts("3 - make a traversal");
		puts("4 - determine the maximum depth");
		puts("5 - show the tree");
		puts("6 - right symmetric firmware");
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

				add_node(&pn, el, isfirmed, 0, head);
			}
			break;
		case 2:
			puts("Enter element to deleted");
			scanf("%d", &elnum);
			if (isfirmed)
			{
				//headcpy = head;
				//del_infirm(&pn, &headcpy, elnum);
				 
				
				//nullfirm();
				nullfirm(pn);
				del_node(&pn, elnum);
				head->pl = pn;
				headcpy = head;
				firm_rsym(&pn, &headcpy);
				headcpy->pr = head;
				headcpy->rtag = 0;
				firmed_bypass(head);
			}
			else
			{
				del_node(&pn, elnum);
			}
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
			find_way(pn, &len, &curr, isfirmed, head);
			printf("Maximum depth: %d", len);
			break;
		case 5:
			tree_outp(pn, isfirmed, head);
			break;
		case 6:
			head->pl = pn;
			headcpy = head;
			firm_rsym(&pn, &headcpy);
			headcpy->pr = head;
			headcpy->rtag = 0;
			firmed_bypass(head);
			isfirmed = 1;
			break;
		}
		puts("");
	} while (num);
}

void add_node(tnode** ppn, int num, int isfirmed, int tag, tnode* head)
{
	tnode* ptemp;
	if ((NULL == *ppn) || (tag))
	{
		if (isfirmed)
		{
			if (tag == 1)
			{
				ptemp = (*ppn)->pr;
				(*ppn)->rtag = 1;
				(*ppn)->pr = (tnode*)malloc(sizeof(tnode));
				((*ppn)->pr)->data = num;
				((*ppn)->pr)->rtag = 0;
				((*ppn)->pr)->pl = NULL;
				((*ppn)->pr)->pr = ptemp;
			}
			else
			{
				(*ppn)->pl = (tnode*)malloc(sizeof(tnode));
				((*ppn)->pl)->data = num;
				((*ppn)->pl)->pl = NULL;
				((*ppn)->pl)->pr = *ppn;
				((*ppn)->pl)->rtag = 0;
			}
		}
		else
		{
			*ppn = (tnode*)malloc(sizeof(tnode));
			(*ppn)->data = num;
			(*ppn)->pl = NULL;
			(*ppn)->pr = NULL;
		}
	}
	else
	{
		if (num < (*ppn)->data)
		{
			if (isfirmed && (NULL == ((*ppn)->pl)))
			{
				tag = 2;
				add_node(ppn, num, isfirmed, tag, head);
			}
			else
			{
				add_node(&((*ppn)->pl), num, isfirmed, tag, head);
			}
		}
		else
		{
			if (num == (*ppn)->data)
			{
				printf("The %d value has already been entered\n\n", num);
			}
			else
			{
				if (isfirmed)
				{
					if (!((*ppn)->rtag))
					{
						tag = 1;
						add_node(ppn, num, isfirmed, tag, head);
					}
					else
					{
						add_node(&((*ppn)->pr), num, isfirmed, tag, head);
					}
				}
				else
				{
					add_node(&((*ppn)->pr), num, isfirmed, tag, head);
				}
			}
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
		if (num < ((*ppn)->data))
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

//ƒÀﬂ ”ƒ¿À≈Õ»ﬂ — œ–Œÿ»“Œ√Œ >
void nullfirm(tnode* pn) 
{
	if (pn != NULL)
	{
		nullfirm(pn->pl);
		if (0 == (pn->rtag))
		{
			pn->pr = NULL;
		}
		else
		{
			nullfirm(pn->pr);
		}
	}
}
//ƒÀﬂ ”ƒ¿À≈Õ»ﬂ — œ–Œÿ»“Œ√Œ <


void del_firmpos(tnode** ppn, tnode** nextd, tnode** deln)
{
	tnode* temp;
	if ((*nextd)->rtag)
	{
		del_firmpos(ppn, &((*nextd)->pr), nextd);
	}
	else
	{
		(*ppn)->data = (*nextd)->data;
		if (((*nextd)->pl) == NULL)
		{
			(*deln)->rtag = (*nextd)->rtag;
			(*deln)->pr = (*nextd)->pr;
		}
		else
		{
			(*deln)->rtag = 1;//
			//(*deln)->pr = (*nextd)->pl;
			temp = (*nextd)->pl;
			while ((temp->rtag) != 0)
			{
				temp = temp->pr;
			}
			temp->pr = (*nextd)->pr;
		}
		/*if ((*deln)->rtag)
		{
			*nextd = (*nextd)->pl;
		}
		else
		{

		}*/
		temp = *nextd;
		free(temp);
		temp = NULL;
		nextd = NULL;
		//*deln = temp;
	}
}

void del_infirm(tnode** ppn, tnode** pptmp, int num)//pptmp == head ?m/b
{
	tnode* deln = NULL, * temp = NULL;
	if (NULL == *ppn)
	{
		puts("\There is no this element or tree is empty");
	}
	else
	{
		if (num < (*ppn)->data)
		{
			del_infirm(&((*ppn)->pl), ppn, num);
		}
		else
		{
			if (num > ((*ppn)->data))
			{
				if ((*ppn)->rtag)
				{
					del_infirm(&((*ppn)->pr), ppn, num);
				}
				else
				{
					puts("\There is no this element or tree is empty");
				}
			}
			else
			{
				if ((*ppn)->rtag)
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
						/*if (NULL == (*ppn)->pr)
						{
							deln = *ppn;
							*ppn = (*ppn)->pl;
							free(deln);
							deln = NULL;
						}*/
						//else
						//{
						deln = *ppn;
						del_firmpos(ppn, &(deln->pr), &deln);
						//}
					}
				}
				else
				{
					if (NULL == (*ppn)->pl)
					{
						if ((*pptmp)->pl == (*ppn))
						{
							(*pptmp)->pl = NULL;
						}
						else
						{
							if ((*pptmp)->pr == (*ppn))
							{
								(*pptmp)->rtag = 0;
								deln = *ppn;
								(*pptmp)->pr = (*ppn)->pr;
							}
						}
						//deln = *ppn;
						//*ppn = (*ppn)->pr;
						free(deln);
						deln = NULL;
					}
					else
					{
						if ((*pptmp)->pl == (*ppn))
						{
							(*pptmp)->pl = (*ppn)->pl;
							((*ppn)->pl)->rtag = 0;
							((*ppn)->pl)->pr = (*ppn)->pr;
							deln = *ppn;
							//*ppn = (*ppn)->pr;
							free(deln);
							deln = NULL;
						}
						else
						{
							if ((*pptmp)->pr == (*ppn))
							{

								deln = (*ppn)->pl;
								while ((deln->pr)->rtag)
								{
									deln = deln->pr;
								}
								(*ppn)->data = (deln->pr)->data;

								temp = deln->pr;
								deln->pr = temp->pr;
								free(temp);
								deln->rtag = 0;
								//(*ppn)->pr = 

								/*(*pptmp)->rtag = 0;
								(*pptmp)->pr = (*ppn)->pr;*/
							}
						}
					}
				}
			}
		}

	}
	/*while (pn)
	{

	}*/
}

void dir_bypass(tnode** ppn)
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

void firmware(tnode** curr, tnode** prev)
{

	//ÕÛÊÌ‡ ÎË ÔÓ‚ÂÍ‡ NULL == prev
	if (NULL == (*prev)->pr)
	{
		(*prev)->rtag = 0;
		(*prev)->pr = *curr;
	}
	else
	{
		(*prev)->rtag = 1;
	}
	*prev = *curr;

}
void firm_rsym(tnode** curr, tnode** prev)
{
	if (NULL != *curr)
	{
		firm_rsym(&((*curr)->pl), prev);
		firmware(curr, prev);
		firm_rsym(&((*curr)->pr), prev);
	}
}

void firmed_bypass(tnode* head)
{
	printf("\nResult:");
	tnode* temp = head->pl;
	while (head != temp)
	{
		while (NULL != temp->pl)
		{
			temp = temp->pl;
		}
		//if (0 == temp->rtag)
		printf("%d ", temp->data);
		if ((0 == temp->rtag) && ((temp->pr) != head))
		{
			do
			{
				temp = temp->pr;
				printf("%d ", temp->data);
			} while (0 == temp->rtag);
			temp = temp->pr;
		}
		else
		{
			temp = temp->pr;
		}
	}
	printf("\n\n");
}


//Outp

void find_way(tnode* pn, int* len, int* curr, int isfirmed, tnode* head)
{
	if ((NULL != pn) && (pn != head))
	{
		(*curr)++;
		find_way(pn->pl, len, curr, isfirmed, head);
		(*curr)--;
		if (NULL != pn->pr)
		{
			if (isfirmed)
			{
				if (pn->rtag)
				{
					(*curr)++;
					find_way(pn->pr, len, curr, isfirmed, head);
					(*curr)--;
				}

			}
			else
			{
				(*curr)++;
				find_way(pn->pr, len, curr, isfirmed, head);
				(*curr)--;
			}
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

typedef struct queue_node qn;
struct queue_node
{
	tnode* node;
	qn* next;
};



void init_queue(qn** ppfront, qn** pprear)
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

void tree_outp(tnode* pn, int isfirmed, tnode* head)
{
	int len = 0, curr = 0;
	qn* frq = NULL, * rq = NULL;
	find_way(pn, &len, &curr, isfirmed, head);

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
	shift = ((leavs - 1) * 3 + leavs) / 2 + 1;
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
			if ((NULL != pn) && (head != pn))
			{
				if (isfirmed)
				{
					if (!(pn->rtag) && ((pn->pr) != head))
					{
						printf("%*d(%d)%*s", tempshft, pn->data, (pn->pr)->data, gap, " ");
						enqueue(&frq, &rq, pn->pl);
						enqueue(&frq, &rq, NULL);
					}
					else
					{
						printf("%*d%*s", tempshft, pn->data, gap, " ");
						enqueue(&frq, &rq, pn->pl);
						enqueue(&frq, &rq, pn->pr);
					}
				}
				else
				{
					printf("%*d%*s", tempshft, pn->data, gap, " ");
					enqueue(&frq, &rq, pn->pl);
					enqueue(&frq, &rq, pn->pr);
				}
			}
			else
			{
				printf("%*s%*s", tempshft, "_", gap, " ");
				enqueue(&frq, &rq, NULL);
				enqueue(&frq, &rq, NULL);
			}
			tempshft = 0;

		}
		printf("\n\n\n");

		gap = gap / 2;
		shift = shift - (gap / 2) - 1;
		tempshft = shift;
	}
	//free_queue();
}

