#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int longest_word(char* text, char** p_res)
{
	int curr_length = 0, length = 0, size = 100, count = 0;
	int start = 0;
	char curr = *text;

	*p_res = (char*)malloc(size);
	while (*text != 0)
	{
		while (((curr >= 'A') && (curr <= 'Z')) || ((curr >= 'a') && (curr <= 'z')))
		{
			curr = *(++text);
			curr_length++;
		}
		if (curr_length >= length)
		{
			if (curr_length > length)
			{
				length = curr_length;
				count = length;
			}
			else
			{
				if(length != 0)
					count = count + 1+ length;
			}
			while (count >= size)
			{
				size = size + size / 2;
				*p_res = (char*)realloc(*p_res,size);
			}
			for (int i = length; i > 0; i--)
			{
				(*p_res)[count - i] = text[-i];
			}
			(*p_res)[count] = ' ';
		}
		curr_length = 0;
		curr = *(++text);
	}
	(*p_res)[count] = 0;
	return length;
}
int main()
{
	int inpway;
	//char* deftxt;
	char* deftxt1 = "Little leaves fall softly down\nRed and yellow, orange and brown\nWhirling, twirlingroundand round\nFalling softly to the ground\nLittle leaves fall softly down\nTo make a carpet on the ground.\nThen, swish, the wind comes whistling by\nAnd sends them dancing to the sky.";
	char* deftxt2 = "";
	char* deftxt3 = "!,;-(/?)";
	char* deftxt4 = "Autumn leaves are falling down,\nFalling down, falling down,\nAutumn leaves are falling down,\nYellow, red, orange and brown!";
	char* text = "";
	char text1[300];
	char* res = "";

	//deftxt
	//deftxt = deftxt0;
	printf("Enter 0 if you want to use default text\nor another number if you want to enter text: ");
	scanf_s("%d", &inpway);
	if (inpway)
	{
		switch (inpway)
		{
		case 1: text = deftxt1; break;
		case 2: text = deftxt2; break;
		case 3: text = deftxt3; break;
		case 4: text = deftxt4; break;
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
	char** p_res = &res;
	printf("\n\nThe longest words: %s\nlength: %d\n\n", res, longest_word(text, p_res));
	
}
