%{
//#include "y.tab.h"
%}
start \/\*
end \*\/
SINGLE_LINE_COMMENT \/\/.*
escape [\n|\t|' ']
LETTER [a-zA-Z]
DIGIT [0-9]
IDENTIFIER [A-Za-z_][A-Za-z0-9_]*
NUM {DIGIT}*
CHARACTER \'[^\']\' 
STRING \"[^\"]*\"
NUMBER {DIGIT}+(\.{DIGIT})?([Ee][+-]?{DIGIT}+)?
BOOL "true"|"false"
LABEL {NUMBER}|{CHARACTER}|{STRING}|{BOOL}
BITOP \^|\!|&|\|
ARITHOP \*|\/|%|\+|\-
UNARYOP \+\+|\-\-
ASSIGN \+=|\-=|\*=|\/=|%=|\^=|&=|=
RELOP ==|\!=|>|<|>=|<=
LOGOP &&|\|\||!
SYMBOL ,|;|\'|\"|\{|\}|\[|\]|\(|\)
MULTI_LINE_COMMENT \/\*({LETTER}|{DIGIT}|{SYMBOL}|{escape}|{SINGLE_LINE_COMMENT}|(\/\*))*\*\/

%%
{MULTI_LINE_COMMENT}    {;}
{SINGLE_LINE_COMMENT}   {;}
double|int|struct|break|long|switch|case|typedef|char|return|void|while|default|float|include {fprintf(yyout,"keyword %s\n",yytext);} 
{NUMBER} {fprintf(yyout,"number %s\n",yytext);}
{CHARACTER} {fprintf(yyout,"Char %s\n",yytext);}
{STRING} {fprintf(yyout,"string %s\n",yytext);}
{BOOL} {fprintf(yyout,"boolen %s\n",yytext);}
{IDENTIFIER} {fprintf(yyout,"id %s\n",yytext);}
{RELOP} {fprintf(yyout,"relop %s\n",yytext);}
{LOGOP} {fprintf(yyout,"logop %s\n",yytext);}
{UNARYOP} {fprintf(yyout,"unaryop %s\n",yytext);}
{ASSIGN} {fprintf(yyout,"assign %s\n",yytext);}
{ARITHOP} {fprintf(yyout,"arithop %s\n",yytext);}
{NUM} {fprintf(yyout,"num %s\n",yytext);}
[ \t] {;}
\n ;
. {fprintf(yyout,"rest %s\n",yytext); }

%%
int yywrap()
{
    return 1;
}
   
int main()
{
    yyin=fopen("test.c","r"); 
    yyout = fopen("trial_wo_comments.c","w");
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 1;

} 
    
