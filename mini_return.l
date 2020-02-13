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
#include<stdio.h> {return PREPROC;}
main {return MAIN;}
int {return INT;}
struct {return STRUCT;}
break {return BREAK;}
switch {return SWITCH;}
case {return CASE;}
typedef {return TYPEDEF;}
char {return CHAR;}
return {return RETURN;}
void {return VOID;}
while {return WHILE;}
default {return DEFAULT;}
float {return FLOAT;}
{BOOL} {return BOOL;}
{NUM} {yylval = atoi(yytext);return NUM;}
{NUMBER} {yylval = atoi(yytext);return NUMBER;}
{IDENTIFIER} {return ID;}
{RELOP} {return RELOP;}
{LOGOP} {return LOGOP;}
{UNARYOP} {return UNARYOP;}
{ASSIGN} {return ASSIGN;}
{ARITHOP1} {return ARITHOP1;}
{ARITHOP2} {return ARITHOP2;}
{STRING} {return STRING;}
{CHARACTER} {return CHARACTER;}
[\t\n' '] {;}
. {return yytext[0]; }

%%
int yywrap()
{
    return 1;
}

/*
int main()
{
    yyin=fopen("test.c","r"); 
    yyout=fopen("out.txt","w"); 
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 1;

}*/
