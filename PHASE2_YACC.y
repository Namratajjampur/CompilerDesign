%{
    #include<stdio.h>
    #include<string.h>
    #include"lex.yy.c"
int valid=1;
    
%}

%token PREPROC STRING CHARACTER MAIN INT STRUCT BREAK SWITCH CASE TYPEDEF CHAR RETURN VOID WHILE DEFAULT FLOAT BOOL NUM NUMBER ID RELOP LOGOP UNARYOP ASSIGN ARITHOP1 ARITHOP2 PRINTF SCANF
// setting the precedence
// and associativity of operators
%left ARITHOP1
%left ARITHOP2

/* Rule Section */
%%
PROGRAM : PREPROC_DIRECTIVE STRUCTURE INT MAIN '('')''{'STATEMENT'}'
| PREPROC_DIRECTIVE STRUCTURE VOID MAIN '('')''{'STATEMENT'}'
;
PREPROC_DIRECTIVE: PREPROC PREPROC_DIRECTIVE
|PREPROC
;

STRUCTURE: TYPEDEF STRUCT ID '{'STRUCTINTERNALS'}' ID ';' STRUCTURE
| STRUCT ID '{'STRUCTINTERNALS'}'';' STRUCTURE
|
;

STRUCTINTERNALS: DECLARATION';'STRUCTINTERNALS
| DECLARATION';'
;

DATATYPE : INT
|FLOAT
|CHAR
|STRUCT ID 
;
STATEMENT: BREAK';'STATEMENT
|RETURN NUM';'
|DECLARATION ';'STATEMENT
|ASSIGNMENT';'STATEMENT
|WHILE_STAT STATEMENT
|SWITCH_STAT STATEMENT
|PRINTF STATEMENT
|
;
DECLARATION: DATATYPE DECTYPE
;
DECTYPE: DECEXP','DECTYPE
| DECEXP
;
DECEXP: DECID| DECID ASSIGN EXPRESSION
;
DECID: ID IDLOOP
|ID'['NUM']'IDLOOP
;

IDLOOP: '.'ID A
|
;
A:IDLOOP|'['NUM']'IDLOOP
;
ASSIGNMENT: ID IDLOOP ASSIGN EXPRESSION
| ID'['NUM']'IDLOOP ASSIGN EXPRESSION
| ID IDLOOP ASSIGN '{'EXPRESSION_SET'}'
| ID'['NUM']'IDLOOP ASSIGN '{'EXPRESSION_SET'}'
;

EXPRESSION_SET: EXPRESSION EXPRESSION_SETA
;
EXPRESSION_SETA: ','EXPRESSION_SET
|
;
EXPRESSION: EXPRESSION ARITHOP1 T
|T
;
T: T ARITHOP2 F
|F
;
F: ID'['NUM']'IDLOOP UNARYOP
| ID IDLOOP UNARYOP
| UNARYOP ID'['NUM']'IDLOOP
| UNARYOP ID IDLOOP
| M
;
M: ID IDLOOP
| ID'['NUM']'IDLOOP
| NUMBER
| '('EXPRESSION')'
| NUM
;

WHILE_STAT: WHILE'('CONDITION')''{'STATEMENT'}'
;
CONDITION: RELATIONALEXPRESSION
| LOGICALEXPRESSION
| ID IDLOOP
| NUMBER
| NUM
| ID'['NUM']'IDLOOP
;
RELATIONALEXPRESSION: EXPRESSION RELOP EXPRESSION
;
LOGICALEXPRESSION: RELATIONALEXPRESSION LOGOP RELATIONALEXPRESSION LOGICALNEW
;
LOGICALNEW: LOGOP RELATIONALEXPRESSION LOGICALNEW
|
;

SWITCH_STAT: SWITCH'('CONDITION')''{'CASES DEFAULTSTAT'}'
;
CASES: CASE LABEL':'STATEMENT CASESA
;
CASESA:CASES
|
;
LABEL: NUM 
| NUMBER
| CHARACTER
| STRING
| BOOL
;
DEFAULTSTAT: DEFAULT':' STATEMENT
|
;

%%

int parse(void){ return 1; }

int main()
{

    //yyin=fopen("test.c","r");
yyout=fopen("trial.txt","w"); 
    yyparse();
if(valid==1)
    printf("Valid\n");
fclose(yyout);
	return 1;
}

/* For printing error messages */
int yyerror(char* s)
{
printf("invalid\n");
valid=0;
}
/*int main()
{
   int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
   //yyparse();
	//yyin = fopen("test.c","r");
    yyout = fopen("out_trial.txt","w");
	printf("\n\n");
	scan = yylex();
//printf("%d\n",scan);
	while(scan)
	{	
		if(lineno == slcline)
		{
			scan = yylex();
			continue;
		}
		if(lineno!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n******** ERROR!! INCOMPLETE STRING at Line %d ********\n\n", dqline);
			dq=0;
		}
		if((scan>=262 && scan<=273) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "KEYWORD");
		}
		if(scan==277 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		
		if(scan==261 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		if(scan==258 && mlc==0)
		{
			printf("%s\t\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, lineno);

		}
		if(scan==274 && mlc==0)
		{
			printf("%s\t\t\tBOOLEAN\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "BOOLEAN");
		}

		if(scan==275 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "INTEGER CONSTANT");
		}
		if(scan==276 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "FLOATING POINT CONSTANT");
		}
		if(scan==278 && mlc==0)
		{
			printf("%s\t\t\tRELATIONAL OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "RELOP");
		}
		if(scan==279 && mlc==0)
		{
			printf("%s\t\t\tLOGICAL OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "LOGOP");
		}
		if(scan==280 && mlc==0)
		{
			printf("%s\t\t\tUNARY OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "UNARYOP");
		}
		if(scan==281 && mlc==0)
		{
			printf("%s\t\t\tASSIGNMENT OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ASSIGN");
		}
		if((scan==282||scan==283) && mlc==0)
		{
			printf("%s\t\t\tARITHMETIC OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ARITHOP");
		}
		if(scan==259 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "STRING CONSTANT");
		}
		if(scan==260 && mlc==0)
		{
			printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "CHARACTER CONSTANT");
		}
if(scan==284 && mlc==0)
		{
			printf("%s\t\t\tPRINTF FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "PRINTF FUNCTION");
		}
if(scan==285 && mlc==0)
		{
			printf("%s\t\t\tSCANF FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "SCANF FUNCTION");
		}
		if((scan=='}'||scan=='{'||scan=='['||scan==']'||scan==','||scan=='.'||scan==';'||scan=='\''||scan =='\"'||scan == '('||scan == ')') && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "SPECIAL SYMBOL");
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	printf("\n");
	printf("\n\t******** SYMBOL TABLE ********\t\t\n");
	display();
        printf("-------------------------------------------------------------------\n\n");
if(valid==1){
    printf("Valid\n");
	}
    fclose(yyin);
    fclose(yyout);
} 
*/
