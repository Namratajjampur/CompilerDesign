#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

#define LSIZ 128 
#define RSIZ 100 

int main()
{
	char line[RSIZ][LSIZ];
	char fname[20];
    	FILE *fptr = NULL; 
    	int i = 0;
    	int tot = 0;
	int j=0;
	int word_number=1;
    	fptr = fopen("sampleintermediate.txt", "r");
    	while(fgets(line[i], LSIZ, fptr)) 
	{
        	line[i][strlen(line[i]) - 1] = '\0'; //Reading and storing each line as part of a 2 dimensional array
        	i++;
    	}
    	tot = i; // total number of lines
	//printf("total %d", tot);
	int flag=0;
	while(flag==0)
	{
	char temporaries[RSIZ][10];
	char useful_temporaries[RSIZ][10];
	for(i = 0; i<RSIZ ; i++)
	{
		strcpy(useful_temporaries[RSIZ],"");
	}
	for(i = 0; i<RSIZ ; i++)
	{
		strcpy(useful_temporaries[RSIZ],"");
	}
	int no_temps=0;
	int useful_no_temps=0;
	int line_with_temps[100]= {0};
	int useful_line_with_temps[100] ={0};
	//removal of temporaries that are never used in any expression
	
	
	for(i = 0; i < tot; ++i)
    	{
		j=0;
		word_number=1;
		while(line[i][j]!='\0')
		{
        		//printf(" %c\n", line[i][j]);
			char word[10]="";
			int temp=0;
			while(line[i][j]!=' ' && line[i][j]!='\0')
			{
				word[temp]=line[i][j];
				j++;temp++;
			}
			// check if temporary here
			//printf("%c\n",word[0]);
			if(strlen(word)==2 && word[0]=='t')
			{
				line_with_temps[i]=1;
				strcpy(temporaries[atoi(word+1)], word);
				//printf("%s\n",temporaries[atoi(word)]);
				no_temps++;
				if(word_number==3 || word_number==5 || word_number==2)
				{
					useful_line_with_temps[i]=1;
					//printf("%d\n",i);
					strcpy(useful_temporaries[atoi(word+1)], word);
					//printf("%s\n",useful_temporaries[atoi(word+1)]);
					useful_no_temps++;
				}
			}
			word_number++;
			j++;
		}
    	}
	int old_tot=tot;
	//printf("old total %d \n",old_tot);
	tot = 0;
	for(i = 0 ; i <old_tot ; i++)
	{
		if(line_with_temps[i]==1)
		{
			j=0;
			char word[10]="";
			int temp=0;
			while(line[i][j]!=' ')
			{
				word[temp]=line[i][j];
				j++;temp++;
			}
			if(word[0]=='t')
			{
				if(strcmp(useful_temporaries[atoi(word+1)],word)==0){
					strcpy(line[tot],line[i]); tot++;
				}
			}
			else
			{
				strcpy(line[tot],line[i]); tot++;
				//printf("%s \n",word);
			}
		}
		else
		{
			strcpy(line[tot],line[i]); tot++;
		}
	}
    	//printf("\n");
	if(tot==old_tot)
		{
			//printf("in\n");
			flag=1;		
		}
	}
	for(i = 0; i < tot; ++i)
    	{
        	printf(" %s\n", line[i]);
    	}
    	printf("\n");
    	return 0;
}
