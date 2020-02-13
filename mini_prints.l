%{
#include "y.tab.h"
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
MULTI_LINE_COMMENT \/\*({LETTER}|{DIGIT}|{SYMBOL}|{escape}|{SINGLE_LINE_COMMENT}|(\/\*))*\*\/

%%
{MULTI_LINE_COMMENT}    {;}
{SINGLE_LINE_COMMENT}   {;}
#include<stdio.h> {fprintf(yyout,"preproc %s\n",yytext);}
main {fprintf(yyout,"main %s\n",yytext);}
int {fprintf(yyout,"int  %s\n",yytext);}
struct {fprintf(yyout,"struct %s\n",yytext);}
break {fprintf(yyout,"break %s\n",yytext);}
switch {fprintf(yyout,"switch %s\n",yytext);}
case {fprintf(yyout,"case %s\n",yytext);}
typedef {fprintf(yyout,"typedef %s\n",yytext);}
char {fprintf(yyout,"char %s\n",yytext);}
return {fprintf(yyout,"return %s\n",yytext);}
void {fprintf(yyout,"void %s\n",yytext);}
while {fprintf(yyout,"while %s\n",yytext);}
default {fprintf(yyout,"default %s\n",yytext);}
float {fprintf(yyout,"float %s\n",yytext);}
{BOOL} {fprintf(yyout,"BOOL %s\n",yytext);}
{NUM} {fprintf(yyout,"NUM %s\n",yytext);}
{NUMBER} {fprintf(yyout,"NUMBER %s\n",yytext);}
{IDENTIFIER} {fprintf(yyout,"ID %s\n",yytext);}
{RELOP} {fprintf(yyout,"RELOP %s\n",yytext);}
{LOGOP} {fprintf(yyout,"LOGOP %s\n",yytext);}
{UNARYOP} {fprintf(yyout,"UNARYOP %s\n",yytext);}
{ASSIGN} {fprintf(yyout,"ASSIGN %s\n",yytext);}
{ARITHOP1} {fprintf(yyout,"ARITHOP1 %s\n",yytext);}
{ARITHOP2} {fprintf(yyout,"ARITHOP2 %s\n",yytext);}
{STRING} {fprintf(yyout,"STRING %s\n",yytext);}
{CHARACTER} {fprintf(yyout,"CHARACTER %s\n",yytext);}
[\t\n' '] {;}
. {fprintf(yyout,"EXTRA %s\n",yytext);}

%%
int yywrap()
{
    return 1;
}


int main()
{
    yyin=fopen("test.c","r"); 
    yyout=fopen("out.txt","w"); 
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 1;

} 
