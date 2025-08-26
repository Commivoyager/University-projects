#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <locale.h>
void main(void)
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	setlocale(LC_ALL, "Rus");
	char str[300], res[300];
	char symb = 0, flag = 1;
	int length, respos = 0, strpos = 0, i = 0, fend = 0;
	FILE* ft;
	//puts("HELLO");
	//scanf("%s\n", str);
	//puts(str);
	puts("Введите текст для перевода (слова пишите прописными буквами, разделяйте символом нижнего подчёркивания):");
	
	do
	{
		gets(str);
		length = strlen(str);
		for (int i = 0; i < length; i++)
		{
			if (((str[i] < 'A') || (str[i] > 'Z')) && (str[i] != '_'))
			{
				puts("Вы ввели некорректный текст");
				i = length;
				length = 0;
			}
		}
	} while (!length);
	
	ft = fopen("BD.txt", "rt");
	if (NULL == ft)
	{
		"Ошибка! Не получилось открыть файл";
	}
	else
	{
		while (flag)
		{
			i = 0;
			if ('_' == str[strpos])
			{
				res[respos] = '_';
				respos++;
				strpos++;
			}
				
			while (('_' != (str[strpos + i]))&&(0 != (str[strpos + i])))
			{
				i++;
				//res[respos+i] = str[strpos++];
				//i++;
			}
			if (0 == (str[strpos + i]))
			{
				flag = 0;
			}
			else
			{
				str[strpos + i] = 0;
			}
			i++;
			//strpos++;
			//res[respos + i] = 0;
			do
			{
				fscanf(ft, "%s", &(res[respos]));
				fscanf(ft, "%s", &(res[respos + i]));
				fend = feof(ft);
				//strlen(&(res[respos + i]));
				//puts(&(res[respos]));
				//puts(&(res[respos + i]));
			} while ((strcmp(&(res[respos]), &(str[strpos])))&&!(fend));
			if (fend)
			{
				flag = 0;
				//if ('_' == str[strpos])
				//{
					//res[respos] = '_';
					//respos = respos + 2;
				///}
				//else
				//{
					strcpy(res, "Сouldn't find the translation");
					respos = strlen(res) + 1;
				//}
				
			}
			else
			{
				strpos = strpos + i;
				if ('-' == res[respos + i])
				{
					res[respos] = 0;
				}
				else
				{
					strcpy(&(res[respos]), &(res[respos + i]));
					i = strlen(&(res[respos]));
					respos = respos + i;
					res[respos] = '_';
					respos++;
				}
				
				fseek(ft, 0, SEEK_SET); 
			}
		}
		fclose(ft);
		res[respos-1] = 0;

		printf("%s", res);
	}
}
