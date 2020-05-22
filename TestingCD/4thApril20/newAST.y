%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <ctype.h>
	#include <stdarg.h>
	#include "header.h"
	void yyerror(const char*);
	int yylex();
	
	/* prototypes */
	int ex (nodeType *p, int flag);
	/* function prototype to create a node for an operation */ 
	nodeType *opr(int oper, int nops, ...);
	/* function prototype to create a node for an identifier */
	nodeType *id(char *identifier);
	/* function prototype to create a node for a constat */
	nodeType *con(char *value);

	int if_assign = 1;

%}

%union
{
	int ival;
	nodeType *nPtr;
	char string[128];
}
%token PREPROC  STDIO  MATH STRING 

%token	IDENTIFIER INTEGER_LITERAL FLOAT_LITERAL STRING_LITERAL HEADER_LITERAL CHARACTER_LITERAL

%token	INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP LT GT 

%token  AND_LOG OR_LOG NOT

%token	ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN  

%token	CHAR INT FLOAT VOID MAIN BREAK SWITCH CASE DEFAULT RETURN

%token  SUB ADD MUL DIV MOD

%token	STRUCT

%token	WHILE 


%type <string> IDENTIFIER INTEGER_LITERAL FLOAT_LITERAL STRING_LITERAL HEADER_LITERAL CHARACTER_LITERAL 

%type <nPtr> primary_expression postfix_expression multiplicative_expression array

%type <nPtr> unary_expression additive_expression relational_expression

%type <nPtr> equality_expression conditional_expression assignment_expression switch_statement

%type <nPtr> statement compound_statement expression_statement block_item while_statement

%type <nPtr> expression init_declarator init_declarator_list BREAK

%type <nPtr>  block_item_list translation_unit case_statement case_statement_int

%type <nPtr> external_declaration declaration logical_and_expression logical_or_expression 

%type <nPtr>  struct_declaration_list struct_declaration struct_declarator_list struct_declarator struct_specifier specifier_qualifier_list type_specifier



%start translation_unit

%%
headers
	: PREPROC HEADER_LITERAL 		{printf("61\n");}
	| PREPROC LT libraries GT	{printf("62\n");}
	;

libraries
	: STDIO		{printf("66\n");}
	| MATH		{printf("68\n");}
	| STRING	{printf("69\n");}
	;

primary_expression
	: IDENTIFIER		{$$ = id($1);}
	| INTEGER_LITERAL	{$$ = con($1);}
	| CHARACTER_LITERAL	{$$ = con($1);}
	| FLOAT_LITERAL		{$$ = con($1);}
	| STRING_LITERAL	{$$ = con($1);}
	| '(' expression ')'	{$$ = $2;}
	;

postfix_expression
	: primary_expression	{$$ = $1;}
	| postfix_expression '(' ')'
	| postfix_expression '[' expression ']'
	| postfix_expression '.' IDENTIFIER {
											char *tmp = strcat($1->id.name,".");
											tmp = strcat(tmp, $3);
											printf("TEMP TEMP TEMP TEMP %s\n", tmp); 			
											$$ = id(tmp);
										}
	| postfix_expression INC_OP			{
											$$ = opr('=', 2, $1, opr('+', 2, $1, con("1") ) );
										}
	| postfix_expression DEC_OP			{
											$$ = opr('=', 2, $1, opr('-', 2, $1, con("1") ) );										
										}
	| INC_OP primary_expression			{
											$$ = opr('=', 2, $2, opr('+', 2, $2, con("1") ) );										
										}
	| DEC_OP primary_expression			{
											$$ = opr('=', 2, $2, opr('-', 2, $2, con("1") ) );										
										}

	;

unary_expression
	: postfix_expression 			{$$ = $1;}
	| unary_operator unary_expression			{$$ = opr('!', 1, $2);}
	;

unary_operator
	: NOT		{printf("94\n");}
	;

multiplicative_expression
	: unary_expression						{$$ = $1;}
	| multiplicative_expression MUL unary_expression		{$$ = opr('*', 2, $1, $3);}
	| multiplicative_expression DIV unary_expression		{$$ = opr('/', 2, $1, $3);}		
	| multiplicative_expression MOD unary_expression		{$$ = opr('%', 2, $1, $3);}
	;

additive_expression
	: multiplicative_expression					{$$ = $1;}
	| additive_expression ADD multiplicative_expression		{$$ = opr('+', 2, $1, $3);}
	| additive_expression SUB multiplicative_expression		{$$ = opr('-', 2, $1, $3);}
	;

relational_expression
	: additive_expression
	| relational_expression LT additive_expression			{$$ = opr('<', 2, $1, $3);}
	| relational_expression GT additive_expression			{$$ = opr('>', 2, $1, $3);}
	| relational_expression LE_OP additive_expression		{$$ = opr(LE_OP, 2, $1, $3);}
	| relational_expression GE_OP additive_expression		{$$ = opr(GE_OP, 2, $1, $3);}
	;

equality_expression
	: relational_expression						{$$ = $1;}
	| equality_expression EQ_OP relational_expression 		{$$ = opr(EQ_OP, 2, $1, $3);}
	| equality_expression NE_OP relational_expression		{$$ = opr(NE_OP, 2, $1, $3);}
	;

logical_and_expression
	: equality_expression								{$$ = $1;}
	| logical_and_expression AND_LOG equality_expression{$$=opr(AND_LOG,2,$1,$3);}
	;

logical_or_expression
	: logical_and_expression							{$$ = $1;}
	| logical_or_expression OR_LOG logical_and_expression{$$=opr(OR_LOG,2,$1,$3);}
	;

conditional_expression
	: logical_or_expression 						{$$ = $1;}
	| logical_or_expression  '?' expression ':' conditional_expression	{$$ = opr('?', 2, $1, opr(':', 2, $3, $5) );}
	;
assignment_expression
	: conditional_expression					{$$ = $1;}
	| unary_expression '=' assignment_expression {$$ = opr('=', 2, $1, $3);}
	| unary_expression ADD_ASSIGN assignment_expression {$$ = opr('=', 2, $1, opr('+', 2, $1, $3) );}
	| unary_expression SUB_ASSIGN assignment_expression {$$ = opr('=', 2, $1, opr('-', 2, $1, $3) );}
	;


expression
	: assignment_expression						{$$ = $1;}
	| expression ',' assignment_expression		{$$=opr(SWITCH,2,$1,$3);}
	;


declaration
	: type_specifier ';'								{printf("type specifier in  declaration ");/*$$ = opr(';', 1, $1);*/}
	| type_specifier init_declarator_list ';'			{printf("type specifier in nested declaration");if(if_assign==0){printf("In declaration, nested\n");$$ = opr(';', 2,$2,$1);} else{$$ = opr(';', 1, $2);} }
	;

init_declarator_list
	: init_declarator									{$$ = $1;}
	| init_declarator_list ',' init_declarator			{printf("init_declarator_list\n");$$ = opr(SWITCH, 2, $1, $3);}
	;

init_declarator
	: IDENTIFIER '=' assignment_expression 				{$$ = opr('=', 2, id($1), $3);}
	| IDENTIFIER										{$$ = id($1);}
	| IDENTIFIER array 									{$$ = id($1);}
	;


array
: '['INTEGER_LITERAL']' array					
| '['INTEGER_LITERAL']'							
;


type_specifier
	: VOID 	{if_assign = 1;}				
	| CHAR 	{if_assign = 1;}				
	| INT 	{if_assign = 1;}				
	| FLOAT		{if_assign = 1;}			
	| struct_specifier	{printf("strcutspecifier\n");if_assign = 0; $$=$1;}
	;

struct_specifier
	: STRUCT '{' struct_declaration_list '}'
	| STRUCT IDENTIFIER '{'  struct_declaration_list '}' {printf("struct id {} \n");$$=$4;}
	| STRUCT IDENTIFIER 
	;

struct_declaration_list
	: struct_declaration  {$$=$1;}
	| struct_declaration_list struct_declaration  { printf("struct declaratiom list\n");$$ =  opr(';', 2, $1, $2);}
	;

struct_declaration
	: specifier_qualifier_list ';'	/* for anonymous struct/union */
	| specifier_qualifier_list struct_declarator_list ';' { if(if_assign==0){$$ = opr(BREAK, 2,$1, $2);} else {$$ = $2;}/* printf("struct declaratiom \n");$$ = opr(BREAK, 2,$1, $2); $$ = $2;*/}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list			{ printf("type specifier in nested specifier_qualifier_list");/*printf("nested struct qual list\n");$$=opr(';',2,$1,$2);*/}
	| type_specifier 									{printf("type specifier in specifier_qualifier_list"); if(if_assign==0){$$=$1;}/*printf("struct qual list\n");$$=$1;*/}
	;

struct_declarator_list
	: struct_declarator { printf("struct declarator list\n"); $$ = $1;}
	| struct_declarator_list ',' struct_declarator { printf("with comma struct declarator list\n");$$ = opr(WHILE,2, $1, $3);}
	;

struct_declarator
	: IDENTIFIER	{ printf("id    \n");$$ = id($1);}
	| IDENTIFIER array {$$ = id($1);}
	;

statement
	: compound_statement	{$$ = $1;}
	| expression_statement	{$$ = $1;}
	| while_statement	{$$ = $1;}
	| switch_statement	{$$ = $1;}
	| BREAK ';' {$$=opr(BREAK,1,$1);}
	;
	
switch_statement
: SWITCH '(' expression ')' '{' case_statement '}' {$$=opr(SWITCH,2,$3,$6);}
;
case_statement
: case_statement_int {$$=$1;}
| case_statement case_statement_int {$$ = opr(';', 2, $1, $2);}
;

case_statement_int
: CASE conditional_expression ':' block_item_list{$$=opr(CASE,2,$2,$4);}
| DEFAULT ':' block_item_list {$$=opr(DEFAULT,1,$3);}
;

compound_statement
	: '{' '}'
	| '{' block_item_list '}'	{$$ = $2;}
	;

block_item_list
	: block_item	{$$ = $1;}
	| block_item_list block_item {$$ = opr(';', 2, $1, $2);}
	;

block_item
	: declaration	{$$ = $1;}
	| statement		{$$ = $1;}
	;

expression_statement
	: ';'			
	| expression ';' {$$ = $1;}
	;

while_statement
	: WHILE '(' expression ')' '{' block_item_list '}' {$$ = opr(WHILE, 2, $3, $6);}
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration 	;

external_declaration
	: INT MAIN '(' ')' compound_statement	{printf("in int main\n");ex($5, 0); /*freeNode($2);*/}
	| declaration							{
												//if(if_assign)
												{											
													ex($1, 2); /*freeNode($2);*/
												}
											}	
	| headers 	
	;

%%

void yyerror(const char *str)
{
	fflush(stdout);
	fprintf(stderr, "*** %s\n", str);
}

int main(){
	if(!yyparse())
	{
		printf("Successful\n");
	}
	else
		printf("Unsuccessful\n");

	return 0;
}

nodeType *con(char *value)
{
	nodeType *p;
	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");
	/* copy information */
	p->type = typeCon;
	strcpy(p->con.value, value);
	printf("in con %s\n",value);
	return p;
}
nodeType *id(char *identifier) {
	nodeType *p;
	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");
	/* copy information */
	p->type = typeId;
	strcpy(p->id.name,identifier);
	printf("The copied identifier %s\n", p->id.name);
	return p;
}

nodeType *opr(int oper, int nops, ...)
{
	va_list ap;
	nodeType *p;
	int i;
	/* allocate node, extending op array */
	if ((p = malloc(sizeof(nodeType) +(nops-1) * sizeof(nodeType *))) == NULL)
		yyerror("out of memory");
	/* copy information */
	p->type = typeOpr;
	p->opr.oper = oper;
	p->opr.nops = nops;
	va_start(ap, nops);
	for (i = 0; i < nops; i++)
	{
		p->opr.op[i] = va_arg(ap, nodeType*);
		printf("in opr %d  i   %d\n",oper,i);
	}
	va_end(ap);
	return p;
}
