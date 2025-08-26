#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <sys/time.h>

#include <libgen.h>
#include <time.h>

struct fdata
{
	char fname[300];
	int size;
};
struct fdata allf[300]; 
int count = 0;	
int size1 = 0, size2 = 0;	

void findfiles(char *loc)
{	
	DIR *currdir;
	currdir = opendir(loc);
	struct stat dirbuf;
	struct dirent * prdir;
	prdir = readdir(currdir);
	char path[300];
	while(NULL != prdir)
	{
		sprintf(path, "%s/%s", loc, prdir->d_name);
		if(0 == stat(path,&dirbuf))
		{
			//если это директория
			if(S_ISDIR(dirbuf.st_mode))
			{
				if(strcmp(basename(prdir->d_name),"..") && 
strcmp(basename(prdir->d_name),"."))
				{
					findfiles(path);
				}
			}
			else
			{
				if(((dirbuf.st_size) >= size1)&&
((dirbuf.st_size) <= size2))
				{
					strcpy((allf[count]).fname, path);
					(allf[count]).size = dirbuf.st_size;
					count++;
				}	
			}
		}
		else
		{
			printf("\nStat error\n");
		}
		prdir = readdir(currdir);
	}	
	
}

int main(int argc, char * argv[]) // /home/vadim/Desktop/MyPrograms/lab6/Good/check0
{
	DIR* currdir;
	struct stat dirbuf;
	struct dirent *dirinf;
	char fullname[300], *name;
	FILE *f1, *f2;
	char str1[100], str2[100];
	int cmpflag;
	int same;
	size1 = atoi(argv[2]);
	size2 = atoi(argv[3]);
	//смена текущей директории на введённую
	if(0 != chdir(argv[1]))
	{
		printf("\nchdir - error\n");
	}
	else
	{
	
		getcwd(fullname, 300);
		name = basename(fullname);
		printf("%s\n", name);
		findfiles(".");
		for(int i = 0; i < count; i++)
		{
			same = 0;
			if(allf[i].size != 0)
			{
			for(int j = i+1; j < count; j++)
			{
				if((allf[i].size) == (allf[j].size))
				{
					f1 = fopen(allf[i].fname, "r");
					f2 = fopen(allf[j].fname, "r");
					cmpflag = 0;
					while(((fgets(str1, 99, f1)) != NULL)&&
((fgets(str2, 99, f2)) != NULL)&&
(!cmpflag))
					{
						cmpflag = strcmp(str1,str2);
					}
					if(!cmpflag)
					{
						same++;
						printf("\n%s\t%d\n", allf[j].fname, 
allf[j].size);
						allf[j].size = 0;
					}
				}
					
			}
						
			if(same)//if(!cmpflag)
			{
				printf("\n%s\t%d\n\nQuantity:%d\n\n\n",allf[i].fname, 
allf[i].size, same+1);
			}
			}	
		}
		
	}
	return 0;
}
