%{
#include "y.tab.h"
%}
start               \/\*
end                 \*\/
SINGLE_LINE_COMMENT \/\/(.*)
MULTI_LINE_COMMENT  {start}(.*\n.*)*{end}
LETTER [a-zA-Z]
DIGIT [0-9]
IDENTIFIER  ({LETTER}| _ )({LETTER}|_|{DIGIT})*
INTNUM [1-9]{DIGIT}* | 0
CHARACTER   \'[^\']\' 
STRING \"[^\"]*\"
NUMBER {DIGIT}+(.{DIGIT})?([Ee][+-]?{DIGIT}+)?
BOOL "true"|"false"
LABEL  {NUMBER} | {CHARACTER} | {STRING}| {BOOL}
ARITHOP  \+|-|\*|\/|%
BITOP          \^|\!|&|\|
UNARYOP  \+\+ |\-\-
ASSIGN      \+=|\-=|\*=|\/=|%=|\^=|&=|=
RELOP       ==|\!=|>|<|>=|<=
LOGOP       &&|\|\||!


%%
{MULTI_LINE_COMMENT}    {;}
{SINGLE_LINE_COMMENT}   {;}
double|int|struct|break|long|switch|case|typedef|char|return|void|while|default|float {return keyword;} 
{NUMBER} {yylval = atoi(yytext);return number;}
{IDENTIFIER} {return id;}
{RELOP} {return relop;}
{LOGOP} {return logop;}
{UNARYOP} {return unaryop;}
{ARITHOP} {return arithop;}
{ASSIGN} {return assign;}
,|;|\'|\"|\{|\}|\[|\]|\(|\)|: {return yytext[0];} 
[\n|\t|' '] {;}

%%
int yywrap()
{
    return 1;
}
   
int main()
{
    yyin=fopen("test.c","r"); 
    yylex();
    fclose(yyin);
    return 1;

} 
    
