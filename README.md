# CompilerDesign
TestingCD : consists of the all the initial codes for each phase</br>
FinalCD: Consists of the final codes for all the phases. 

Implement the front end of the compiler for C language using Lex and Yacc for the following constructs :
Structures
While
Switch
How to run
Clone this repository and execute sh run.sh. After execution of various phases of the compiler you may use sh clean.sh to remove output files.

Project details
Following output files are generated upon execution of run.sh :

Symbol Table : ./SymbolTable < filename
Symbol table contains keywords and identifiers, their datatypes and values with some preliminary evaluation of simple expressions. The output of this file will be in symbol_table.txt and the errors while creating the symbol table are stored in errors.txt. The errors handled by the symbol table are
Undeclared variables
Multiple declarations of a variable within the same scope
Invalid value for given datatype
Abstract Syntax Tree : ./AST < filename
Uses graph.c and header.h to display the abstract syntax tree.

Intermediate Code Generation : ./ICG < filename
Generates an if-goto form of intermediate representation of code in output_file.txt. Handles nested for loops, nested ternary operators too.

Code Optimization : python3 CO.py or python3 CO.py filename

Following code optimizations were performed

Dead code elimination
Constant folding
