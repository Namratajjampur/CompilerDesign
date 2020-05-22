%{
#include "y.tab.h"
int lineno = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>



%}
start \/\*
end \*\/
SINGLE_LINE_COMMENT \/\/.*
escape [\n|\t|' ']
LETTER [a-zA-Z]
DIGIT [0-9]
IDENTIFIER [A-Za-z_][A-Za-z0-9_]*
NUM [0-9]*
CHARACTER \'[^\']\' 
STRING \"[^\"]*\"
NUMBER {DIGIT}+(.{DIGIT})?([Ee][+-]?{DIGIT}+)?
BOOL "true"|"false"
LABEL {NUMBER}|{CHARACTER}|{STRING}|{BOOL}
BITOP \^|\!|&|\|
ARITHOP2 \*|\/|%
ARITHOP1 \+|\-
UNARYOP \+\+|\-\-
ASSIGN \+=|\-=|\*=|\/=|%=|\^=|&=|=
RELOP ==|\!=|>|<|>=|<=
LOGOP &&|\|\||!
SYMBOL ,|;|\'|\"|\{|\}|\[|\]|\(|\)
PRINTF printf\(\".*\"\)
SCANF scanf\(\".*\",&.*\)
MULTI_LINE_COMMENT \/\*({LETTER}|{ARITHOP2}|{ARITHOP1}|{ASSIGN}|{BITOP}|{PRINTF}|{SCANF}|{UNARYOP}|{RELOP}|{LOGOP}|{DIGIT}|{SYMBOL}|{escape}|{SINGLE_LINE_COMMENT}|(\/\*))*\*\/

%%
{MULTI_LINE_COMMENT}    {;}
{SINGLE_LINE_COMMENT}   {;}
{PRINTF} {return PRINTF;}
{SCANF} {return SCANF;}
#include<stdio.h> {fprintf(yyout,"preproc %s\n",yytext); return PREPROC;}
main {fprintf(yyout,"main %s\n",yytext);return MAIN;}
int {fprintf(yyout,"int  %s\n",yytext);return INT;}
struct {fprintf(yyout,"struct %s\n",yytext);return STRUCT;}
break {fprintf(yyout,"break %s\n",yytext);return BREAK;}
switch {fprintf(yyout,"switch %s\n",yytext);return SWITCH;}
case {fprintf(yyout,"case %s\n",yytext);return CASE;}
typedef {fprintf(yyout,"typedef %s\n",yytext);return TYPEDEF;}
char {fprintf(yyout,"char %s\n",yytext);return CHAR;}
return {fprintf(yyout,"return %s\n",yytext);return RETURN;}
void {fprintf(yyout,"void %s\n",yytext);return VOID;}
while {fprintf(yyout,"while %s\n",yytext);return WHILE;}
default {fprintf(yyout,"default %s\n",yytext);return DEFAULT;}
float {fprintf(yyout,"float %s\n",yytext);return FLOAT;}
{BOOL} {fprintf(yyout,"BOOL %s\n",yytext);return BOOL;}
{NUM} {fprintf(yyout,"NUM %s\n",yytext);return NUM;}
{NUMBER} {fprintf(yyout,"NUMBER %s\n",yytext);return NUMBER;}
{IDENTIFIER} {fprintf(yyout,"ID %s\n",yytext);return ID;}
{RELOP} {fprintf(yyout,"RELOP %s\n",yytext);return RELOP;}
{LOGOP} {fprintf(yyout,"LOGOP %s\n",yytext);return LOGOP;}
{UNARYOP} {fprintf(yyout,"UNARYOP %s\n",yytext);return UNARYOP;}
{ASSIGN} {fprintf(yyout,"ASSIGN %s\n",yytext);return ASSIGN;}
{ARITHOP1} {fprintf(yyout,"ARITHOP1 %s\n",yytext);return ARITHOP1;}
{ARITHOP2} {fprintf(yyout,"ARITHOP2 %s\n",yytext);return ARITHOP2;}
{STRING} {fprintf(yyout,"STRING %s\n",yytext);return STRING;}
{CHARACTER} {fprintf(yyout,"CHARACTER %s\n",yytext); return CHARACTER;}
[\t' '] {;}
\n {lineno++;}
. {fprintf(yyout,"EXTRA %s\n",yytext);return yytext[0];}

%%
int stack[100],i,j,choice=0,n,top=-1;  
char scope[100];
int scope_outer=0;
int flag=1;
void push();  
void pop();  
void show();
void push(int val)  
{  
      
    if (top == 100)   
    printf("\n Overflow");   
    else   
    {  
                
        top = top +1;   
        stack[top] = val;   
    }   
}   
  
void pop()   
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
struct node
{	//for each element and token , token, attr
	char token[100];
    	char attr[100];
	char scope[100];
	int linenumber;
	struct node *next;
};

struct hash
{	//pointing to beginning of hash table array element
	struct node *head;
	int count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr,char *scope,int linenumber)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	strcpy(newnode->scope, scope);
	newnode->linenumber=linenumber;
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{	// using sum of ascii values and diving by 1000 as thresh
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr,char *scope,int linenumber)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr,scope,linenumber);
	/* head of list i as hi */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{	// check for same value, otherwise insert to next
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new ele to list
		newnode->next = (hashTable[hi].head);
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("\nSNo \t\tToken \t\tToken Type \t\tScope \t\t linenumber \t\n\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t", k++);
            		printf("%s\t\t", myNode->token);
            		printf("%s\t\t", myNode->attr);
			printf("sc :%s\t\t", myNode->scope);
			printf("ln :%d\t\n", myNode->linenumber);
            		myNode = myNode->next;
        	}
	}
   	return;
}

int yywrap()
{
    return 1;
}
void scope_main(char c)
{
  
        switch(c)
        {
            case '{':if(top==-1)
            {
                scope_outer+=1;
                push(0);
                sprintf(scope,"%d",scope_outer);
                //printf("Show stack ");
                //show();
    
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
                //printf("Show stack ");
                //show();
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
                //printf("Show stack ");
                //show();             
            }
            
            break;
            
        }
        //printf("char %c scope %s ",c,scope);
          
}
int main()
{
	sprintf(scope,"%d",0);
   int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
   //yyparse();
	//yyin = fopen("test.c","r");
    yyout = fopen("out_trial.txt","w");
	printf("\n\n");
	scan = yylex();
	scope_main(scan);
//int linenumber=lineno;
//printf("%d\n",scan);
	while(scan)
	{	
		if(lineno == slcline)
		{
			scan = yylex();
			scope_main(scan);
			continue;
		}
		
		if((scan>=262 && scan<=273) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "KEYWORD",scope,lineno);
		}
		if(scan==277 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER",scope,lineno);
		}
		
		if(scan==261 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER",scope,lineno);
		}
		if(scan==258 && mlc==0)
		{
			printf("%s\t\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, lineno);
		}
		if(scan==274 && mlc==0)
		{
			printf("%s\t\t\tBOOLEAN\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "BOOLEAN",scope,lineno);
		}
		if(scan==275 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "INTEGER CONSTANT",scope,lineno);
		}
		if(scan==276 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "FLOATING POINT CONSTANT",scope,lineno);
		}
		if(scan==278 && mlc==0)
		{
			printf("%s\t\t\tRELATIONAL OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "RELOP",scope,lineno);
		}
		if(scan==279 && mlc==0)
		{
			printf("%s\t\t\tLOGICAL OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "LOGOP",scope,lineno);
		}
		if(scan==280 && mlc==0)
		{
			printf("%s\t\t\tUNARY OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "UNARYOP",scope,lineno);
		}
		if(scan==281 && mlc==0)
		{
			printf("%s\t\t\tASSIGNMENT OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ASSIGN",scope,lineno);
		}
		if((scan==282||scan==283) && mlc==0)
		{
			printf("%s\t\t\tARITHMETIC OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ARITHOP",scope,lineno);
		}
		if(scan==259 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "STRING CONSTANT",scope,lineno);
		}
		if(scan==260 && mlc==0)
		{
			printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "CHARACTER CONSTANT",scope,lineno);
		}
if(scan==284 && mlc==0)
		{
			printf("%s\t\t\tPRINTF FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "PRINTF FUNCTION",scope,lineno);
		}
if(scan==285 && mlc==0)
		{
			printf("%s\t\t\tSCANF FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "SCANF FUNCTION",scope,lineno);
		}
		if((scan=='}'||scan=='{'||scan=='['||scan==']'||scan==','||scan=='.'||scan==';'||scan=='\''||scan =='\"'||scan == '('||scan == ')') && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "SPECIAL SYMBOL",scope,lineno);
		}
		scan = yylex();
		scope_main(scan);
	}
	if(mlc==1)
		printf("\nEUNMATCHED COMMENT at Line %d\n",mlcline);

	printf("\n");
	printf("\nSYMBOL TABLE:\t\t\n");
	display();
      

    //fclose(yyin);
    fclose(yyout);
} 

