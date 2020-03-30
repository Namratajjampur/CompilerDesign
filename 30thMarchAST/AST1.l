%{
	#include "header.h"
	#include <stdio.h>
	#include "y.tab.h"
	#include<string.h>


	//#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;

	extern void yyerror(const char *);  /* prints grammar violation message */

	extern int sym_type(const char *);  /* returns type from symbol table */

	#define sym_type(identifier) IDENTIFIER /* with no symbol table, fake it */

	static void comment(void);

	static int check_type(void);
	
	int line = 0;

%}

%option yylineno

DIGIT   		[0-9]
LETTER   		[a-zA-Z_]
ALL   		[a-zA-Z_0-9]
WS  		[ \t\v\n\f]
CHARACTER \'[^\']\' 
STRING \"[^\"]*\"


%%
	/* Unary operators */
"++"		{printf("inc op"); return(INC_OP); }
"--"		{printf("dec op"); return(DEC_OP); }

"/*"		{ comment(); }
"//"[^\n]*	{ /* Consume Comment */ }

	/* Data Types */
int			{ printf("intn");strcpy(yylval.string,yytext); return(INT); }
float		{ printf("floatn op");strcpy(yylval.string,yytext); return(FLOAT); }
char		{ printf("charn op");strcpy(yylval.string,yytext); return(CHAR); }
void		{ printf("voidsn op");strcpy(yylval.string,yytext); return(VOID); }
main		{ printf("mains op");strcpy(yylval.string,yytext); return(MAIN); }
break       { printf("breaks op");strcpy(yylval.string,yytext); return(BREAK); }
switch      { printf("switchs op");strcpy(yylval.string,yytext); return(SWITCH); }
case        { printf("cases op");strcpy(yylval.string,yytext); return(CASE); }
default     { printf("deafulat op");strcpy(yylval.string,yytext); return(DEFAULT); }
return      { printf("ret op");strcpy(yylval.string,yytext); return(RETURN); }

	/* User Defined Data Types */
struct		{ printf("strucctt op");strcpy(yylval.string,yytext); return(STRUCT); }

	/* Headers */
"#include"		{ printf("prepoc op");return PREPROC; }
		
	/* C Libraries */
"math.h"	{ printf("math op");return MATH; }
"stdio.h"	{ printf("stdio op");return STDIO; }
"string.h"	{ printf("stdio strng op");return STRING; }

	/* Control while */
"while"		{ printf("whilee op");return(WHILE); }

	/* User Defined Data Types, Identifiers */
{LETTER}{ALL}*						{	printf("id op"); strcpy(yylval.string,yytext); return IDENTIFIER;}
{DIGIT}+							{ printf("int_lit op");strcpy(yylval.string,yytext); return INTEGER_LITERAL;}
{DIGIT}+\.{DIGIT}+						{ printf("float_loit op");strcpy(yylval.string,yytext); return FLOAT_LITERAL;}
\"{ALL}+(".h"|".c")\"				{printf("headlit op");return HEADER_LITERAL;}
{CHARACTER}		{printf("character op");return(CHARACTER_LITERAL);}
{LETTER}?\"(\\.|[^\\"])*\"	{ printf("string lite op");return(STRING_LITERAL); }

	/* Assignment Operators */
"+="		{printf("addasign op");return(ADD_ASSIGN); }
"-="		{printf("subassign op");return(SUB_ASSIGN); }
"*="		{printf("mulassign op");return(MUL_ASSIGN); }
"/="		{printf("divasign op");return(DIV_ASSIGN); }
"%="		{printf("modassign op");return(MOD_ASSIGN); }

	/*Logical Operation*/
"&&"		{ printf("andand op");strcpy(yylval.string,yytext);return(AND_LOG); }
"||"		{ printf("oror op");strcpy(yylval.string,yytext);return(OR_LOG); }
"!"		{ printf("not op");strcpy(yylval.string,yytext);return(NOT); }

";"		{return(';'); }
"{"	{return('{'); }
"}"	{return('}'); }
","		{printf(",");return(','); }
":"		{printf(":");return(':'); }
"="		{printf("=");return('='); }
"("		{printf("(");return('('); }
")"		{printf(")");return(')'); }
("["|"<:")	{printf("[");return('['); }
("]"|":>")	{printf("]");return(']'); }
"."		{printf(".");return('.'); }
"&"		{printf("&");return('&'); }

	/*Relational op*/
"<"		{ printf("LT op");strcpy(yylval.string,yytext);return(LT); }
">"		{ printf("GT op");strcpy(yylval.string,yytext);return(GT); }
"<="		{ printf("LEOP op");strcpy(yylval.string,yytext); return(LE_OP); }
">="		{ printf("GEOP op");strcpy(yylval.string,yytext); return(GE_OP); }
"=="		{ printf("== op");strcpy(yylval.string,yytext); return(EQ_OP); }
"!="		{ printf("!= op");strcpy(yylval.string,yytext); return(NE_OP); }

	/* eval op */

"-"		{ printf("minus op");strcpy(yylval.string,yytext);return(SUB); }
"+"		{ printf("plus op");strcpy(yylval.string,yytext);return(ADD); }
"*"		{ printf("star op");strcpy(yylval.string,yytext);return(MUL); }
"/"		{ printf("div op");strcpy(yylval.string,yytext);return(DIV); }
"%"		{ printf("mod op");strcpy(yylval.string,yytext);return(MOD); }



{WS}+		{ ;/* whitespace separates tokens */}
	
.		{ printf("%s",yytext[0]);return(yytext[0]); }
"\n"	{yylval.ival = line++; printf("\n%d\n",line);}
%%

int yywrap(void)
{
	return 1;
}


static void comment(void)
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}
