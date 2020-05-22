#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LSIZ 128 
#define RSIZ 100 


int main(void) 
{
    char line[RSIZ][LSIZ];
	char fname[20];
    FILE *fptr = NULL; 
    int i = 0;
    int tot = 0;
    /*printf("\n\n Read the file and store the lines into an array :\n");
	printf("------------------------------------------------------\n"); 
	printf(" Input the filename to be opened : ");
	scanf("%s",fname);	
*/
    fptr = fopen("sample.txt", "r");
    while(fgets(line[i], LSIZ, fptr)) 
	{
        line[i][strlen(line[i]) - 1] = '\0';
        i++;
    }
    tot = i;
   // STarted adding here
   for(int i =0;i<tot;i++)
    {	printf("%s\n",line[i]);
        if(index(line[i],'='))
        {
            char temp[2][10]; char val[3][10];
            strcpy(temp[1],"\0");
            strcpy(temp[0],"\0");
            strcpy(val[0],"\0");
            strcpy(val[1],"\0");
            strcpy(val[2],"\0");
            
            char *tok = strtok (line[i]," ");
            strcpy(temp[0],tok);
            int tmp =1;
            while (tok != NULL)
            {   //printf("tok %s,tmp %d\n",tok,tmp);
                if(tmp==3)
                strcpy(val[0],tok);
                if(tmp==4)
                strcpy(val[1],tok);
                if(tmp==5)
                strcpy(val[2],tok);
                tmp++;
                tok = strtok (NULL, " ");
            }

            if(val[1] && !strcmp(val[1],"*") )
            {
                if(!strcmp(val[0],"0") || !strcmp(val[2],"0"))   //anything multpiled with 0
                {
                    strcpy(temp[1],"0");
                }
                else if(!strcmp(val[0],"1"))            // mult 1
                {
                    strcpy(temp[1],val[2]);
                }
                 else if(!strcmp(val[2],"1"))           // multipl 1
                {
                    strcpy(temp[1],val[0]);
                }
            }

            else if(val[1] && !strcmp(val[1],"+"))
            {
                if(!strcmp(val[0],"0"))            // add 0
                {
                    strcpy(temp[1],val[2]);
                }
                else if(!strcmp(val[2],"0"))           // add 0
                {
                    strcpy(temp[1],val[0]);
                }
            }

            else if(val[1] && !strcmp(val[1],"-"))
            {
                if(!strcmp(val[0],"0"))            //  a = 0-b = -b
                {

                    strcpy(temp[1],"-");
                    strcat(temp[1],val[2]);
                }
                else if(!strcmp(val[2],"0"))           // a = b - 0
                {
                    strcpy(temp[1],val[0]);
                }
            }

            else if(val[1] && !strcmp(val[1],"/"))
            {
                if(!strcmp(val[0],"0"))            // a = 0/n = 0
                {
                    strcpy(temp[1],"0");
                }
                else if(!strcmp(val[2],"0"))           // 
                {
                    printf("EROOR CANT DIVIDE BY ZEROOO");
                }
                 else if(!strcmp(val[2],"1"))           // a = b/1 
                {
                    strcpy(temp[1],val[0]);
                }

            }

            //printf("ALL VALUES %s %s %s %s %s\n", temp[0],temp[1],val[0],val[1],val[2]);

            if(strlen(temp[1]) && i != tot-1)     // we have an optimized value
            {
               // printf("temp1 %s\n",temp[1]);
                char newline[100];
                char substring[100];
                strcpy(substring,line[i+1]);
                char *token = strtok (substring," ");
               strcpy(newline,"\0");
                 while (token != NULL)
                {  
                    if(!strlen(newline))
                    strcpy(newline,token);
                    else if(!strcmp(token,temp[0]))
                    {
                        strcat(newline," ");
                        strcat(newline,temp[1]);
                    }
                    else 
                    {
                        strcat(newline," ");
                        strcat(newline,token);
                    }
                    token = strtok (NULL, " ");
                }
                //printf("newline %s\n",newline);
                strcpy(line[i+1],newline);
                
            }
            

        }
    }
    // finished the for loop here
}