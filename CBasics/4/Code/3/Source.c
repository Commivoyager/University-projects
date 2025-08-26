#include<stdio.h>
#include<stdlib.h>
void change(char* text,char** res)
{
	int i = 0,j, pos = 0, len, count = 0;
	char curr=1;
	len = strlen(text);
	*res = (char *)malloc(len+1);
	j = len-1;

	while ((j + 1) && curr)
	{
		curr = text[j];
		while ((((curr < 'a') || (curr > 'z')) && ((curr < 'A') || (curr > 'Z'))) && j)
		{
			j--;
			curr = text[j];
			
		}
		while ((((curr >= 'a') && (curr <= 'z')) || ((curr >= 'A') && (curr <= 'Z'))) &&j)
		{
			j--;
			curr = text[j];
			
			count++;
			//pos++;
		}
		curr = text[i];
		while (((curr < 'a') || (curr > 'z')) && ((curr < 'A') || (curr > 'Z'))&&curr)
		{
			(*res)[pos] = curr;
			pos++;
			i++;
			curr = text[i];
		}
		while ((((curr >= 'a') && (curr <= 'z')) || ((curr >= 'A') && (curr <= 'Z'))))
		{
			i++;
			curr = text[i];
		}
		if (!j)
		{
			if (((text[j] >= 'a') && (text[j] <= 'z')) || ((text[j] >= 'A') && (text[j] <= 'Z')))
			{
				count++;
				j--;
			}
			
			//if 
			//count++;
		}
		//j--;
		for (int k = j+1; k <= j + count; k++)
		{
			(*res)[pos] = text[k];
			pos++;
		}
		count = 0;
	}
	(*res)[pos] = 0;
}
int main() 
{
	char str[100] = "text if stdioh BSUIR C programming something and so on";
	int inpway;
	//char* deftxt;
	char* deftxt1 = "Autumn leaves are falling down,\nFalling down, falling down,\nAutumn leaves are falling down,\nYellow, red, orange and brown!";
	char* deftxt2 = "!Little leaves fall softly down\nRed and yellow, orange and brown\nWhirling, twirlingroundand round!!!";
	char* deftxt3 = "String";
	char* deftxt4 = "";
	char* deftxt5 = "!,;-(/?)";
	
	char* text = "";
	char text1[300];
	char* res = "";
	char** txt = &res;


	//deftxt
	//deftxt = deftxt0;
	printf("Enter 0 if you want to enter text\nor another number if you want to use default text: ");
	scanf_s("%d", &inpway);
	if (inpway)
	{
		switch (inpway)
		{
		case 1: text = deftxt1; break;
		case 2: text = deftxt2; break;
		case 3: text = deftxt3; break;
		case 4: text = deftxt4; break;
		case 5: text = deftxt5; break;
		default: puts("No text");
		}
		puts("Text:");
		printf("\n%s\n", text);
	}
	else
	{
		gets(text1);
		gets(text1);
		text = text1;
	}
	change(text, txt);
	printf("\n\n");
	puts(* txt);
}

/*H!e'l(l)o, Vasya!!! How're you? Hi))) $$$*/