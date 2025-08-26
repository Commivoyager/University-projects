#include<stdio.h>
int main()
{
	char temp[100], str[100];
	int len, pos = 0;
	puts("Enter string: ");
	gets(str);
	len = strlen(str);
	for (int j = len - 1; j >= 0; j--)
	{
		if (((str[j] >= 'a') && (str[j] <= 'z')) || ((str[j] >= 'A') && (str[j] <= 'Z')))
		{
			temp[pos] = str[j];
			pos++;
		}
	}
	for (int i = 0; i < len; i++)
	{
		if ((str[i] >= '0') && (str[i] <= '9'))
		{
			temp[pos] = str[i];
			pos++;
		}	
	}
	temp[pos] = 0;
	strcpy(str,temp);
	puts(str);
}