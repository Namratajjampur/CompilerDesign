%{
#include "y.tab.h"
%}
start \/\*
end \*\/
SINGLE_LINE_COMMENT \/\/(.*)
MULTI_LINE_COMMENT {start}(.*\n.*)*{end}
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
ARITHOP \*|\/|%|\+|\-
UNARYOP \+\+|\-\-
ASSIGN \+=|\-=|\*=|\/=|%=|\^=|&=|=
RELOP ==|\!=|>|<|>=|<=
LOGOP &&|\|\||!
SYMBOL ,|;|\'|\"|\{|\}|\[|\]|\(|\)

%%
{MULTI_LINE_COMMENT}    {;}
{SINGLE_LINE_COMMENT}   {;}
double|int|struct|break|long|switch|case|typedef|char|return|void|while|default|float {return keyword;} 
{NUMBER} {yylval = atoi(yytext);return number;}
{IDENTIFIER} {return id;}
{RELOP} {return relop;}
{LOGOP} {return logop;}
{UNARYOP} {return unaryop;}
{ASSIGN} {return assign;}
{ARITHOP} {printf("%s\t\t\tarith\n",yytext);}
{LABEL} {return label;}
{NUM} {return num;}
\t {;}
\n ;
. {return yytext[0]; }

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
    
