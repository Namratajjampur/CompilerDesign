#include <stdio.h>  
#include <string.h>  
int stack[100],i,j,choice=0,n,top=-1;  
char scope[100];
//strcpy(scope,(char)0);
int scope_outer=0;
int flag=1;
void push();  
void pop();  
void show();  
void main ()  
{  
    sprintf(scope,"%d",0);
    char c;
   FILE *file  = fopen("trial.txt", "r"); // read only
   while ((c = fgetc(file)) != EOF && flag==1)
    {
        switch(c)
        {
            case '{':if(top==-1)
            {
                scope_outer+=1;
                push(0);
                sprintf(scope,"%d",scope_outer);
                printf("Show stack ");
                show();
   
            }
            else
            {
                stack[top]+=1;
                char buff[5];
                sprintf(buff,"%d",stack[top]);
                char ch='.';
                strncat(scope,&ch,1);
                strcat(scope,buff);
                push(0);
                printf("Show stack ");
                show();
            }
            break;
            case '}':if(top==-1)
            {
                printf("ERROR!");
                flag=0;
            }
            else
            {
                char *temp;
if(top==0)
sprintf(scope,"%d",0);
else{
                temp = strrchr(scope,'.');  
                *temp = '\0';
}
                pop();
                /*if(top==-1)
                {
                    sprintf(scope,"%d",0);
                }*/
                printf("Show stack ");
                show();            
            }
           
            break;
           
        }
        printf("char %c scope %s ",c,scope);
    }      
}  
 
void push (int val)  
{  
     
    if (top == 100)  
    printf("\n Overflow");  
    else  
    {  
               
        top = top +1;  
        stack[top] = val;  
    }  
}  
 
void pop ()  
{  
    if(top == -1)  
    printf("Underflow");  
    else  
    top = top -1;  
}  
void show()  
{  
   
    for (i=top;i>=0;i--)  
    {  
        printf("%d ",stack[i]);  
    }  
    if(top == -1)  
    {  
        printf("Stack is empty");  
    }  
    printf("\n");
} 
