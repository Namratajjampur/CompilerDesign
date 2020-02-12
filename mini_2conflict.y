%{
    #include<stdio.h>
    #include<string.h>

%}

%token keyword number id label relop logop unaryop arithop assign num
// setting the precedence
// and associativity of operators
%left '+' '-'
%left '*' '/'
%left '%'

/* Rule Section */
%%
PROGRAM : PREPROC_DIRECTIVE STRUCTURE "int main" '('')''{'STATEMENT'}'
| PREPROC_DIRECTIVE STRUCTURE "void main"'('')''{'STATEMENT'}'
;
DATATYPE : "int"
|"float"
|"char"
|"struct"
|"struct id"
;
PREPROC_DIRECTIVE: '#'"include"'<'DIRECTIVE'>'PREPROC_DIRECTIVE
|'#'"include"'<'DIRECTIVE'>'
;
DIRECTIVE: "stdio.h"
| "string.h"
| "math.h"
;
STRUCTURE: "typedef" "struct id" '{'STRUCTINTERNALS'}' id ';'
| "struct id" '{'STRUCTINTERNALS'}'
;
STRUCTINTERNALS: DECLARATION';' STRUCTINTERNALS
| DECLARATION';'
;
STATEMENT: "break"';'
|"return" number';'
|DECLARATION';'STATEMENT
|ASSIGNMENT';'STATEMENT
|WHILE_STAT STATEMENT
|SWITCH_STAT STATEMENT
|';'
|
;
IDLOOP: '.'id IDLOOP
|'.'id
|'.'id'['num']'
|
;
DECLARATION: DATATYPE DECTYPE
;
DECTYPE: DECEXP','DECTYPE
| DECEXP
;
DECEXP: DECID|DECID assign EXPRESSION
DECID: id IDLOOP|id IDLOOP'['num']'
;
ASSIGNMENT: id IDLOOP assign EXPRESSION
| id'['num']'IDLOOP assign EXPRESSION
| id IDLOOP assign '{' EXPRESSION_SET EXPRESSION'}'
| id'['num']'IDLOOP assign '{'EXPRESSION_SET EXPRESSION'}'
;
EXPRESSION_SET: EXPRESSION','EXPRESSION_SET
|
;
WHILE_STAT: "while"'('CONDITION')''{'STATEMENT'}'
|"while"'('CONDITION')'STATEMENT
;
CONDITION: RELATIONALEXPRESSION
| LOGICALEXPRESSION
| id IDLOOP
| number
| id'['num']'IDLOOP
;
UNARYOPERATOR: unaryop
;
RELATIONALOPERATOR: relop
;
LOGICALOPERATOR: logop
;
EXPRESSION: EXPRESSION '+' T
| EXPRESSION '-' T
|T
;
T: T'*'F
|T'/'F
|T'%'F
|F
;
F: id'['num']'IDLOOP UNARYOPERATOR
| id IDLOOP UNARYOPERATOR
| UNARYOPERATOR id'['num']'IDLOOP
| UNARYOPERATOR id IDLOOP
| M
;
M: id IDLOOP
| id'['num']'IDLOOP
| number
| '('EXPRESSION')'
;
RELATIONALEXPRESSION: EXPRESSION RELATIONALOPERATOR EXPRESSION
;
LOGICALEXPRESSION: LOGICAL_CONDITION RELATIONALEXPRESSION
;
LOGICAL_CONDITION: RELATIONALEXPRESSION LOGICALOPERATOR LOGICAL_CONDITION
|
;
SWITCH_STAT: "switch"'('CONDITION')''{'CASES DEFAULTSTAT'}'
;
CASES: "case" label':'STATEMENT CASES
| "case" label':'STATEMENT
;
DEFAULTSTAT: "default"':' STATEMENT
|
;

%%

int main()
{
    yyin=fopen("test.c","r"); 
    yyparse();
}

/* For printing error messages */
int yyerror(char* s)
{
printf("invalid\n");
}

