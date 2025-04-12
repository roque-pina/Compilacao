grammar MOC;

/* ------------------------------------------------------------------
   LEXER RULES: Keywords, operators, literals, comments, etc.
   ------------------------------------------------------------------ */

INT      : 'int';
DOUBLE   : 'double';
VOID     : 'void';
IF       : 'if';
ELSE     : 'else';
FOR      : 'for';
WHILE    : 'while';
RETURN   : 'return';
SWITCH   : 'switch';
CASE     : 'case';

/* Input/Output functions */
READ     : 'read';
READC    : 'readc';
READS    : 'reads';
WRITE    : 'write';
WRITEC   : 'writec';
WRITES   : 'writes';
WRITEV   : 'writev';

/* Flow Control */
BREAK    : 'break';
CONTINUE : 'continue';

/* Operators and Symbols */
MAIS     : '+';
MENOS    : '-';
MULT     : '*';
DIV      : '/';
MOD      : '%';

/* Assignment and Comparison */
IG       : '=';
IGIG     : '==';
DIFER    : '!=';
MENOR    : '<';
MAIOR    : '>';
MENOIG   : '<=';
MAIOIG   : '>=';

/* Logical Operators */
AND      : '&&';
OR       : '||';
NOT      : '!';

/* Delimiters and punctuation */
PARENE   : '(';
PAREND   : ')';
CHAVE    : '{';
CHAVR    : '}';
RETOE    : '[';
RETOD    : ']';
PTVG     : ';';
VIRG     : ',';

/* Identifiers and Literals */
ID : [a-zA-Z_][a-zA-Z0-9_]* ;

INT_CONST : [0-9]+ ;

DOUBLE_CONST : [0-9]+ '.' [0-9]+ ;

STRING : '"' .*? '"' ;

/* Comments and Whitespace */
COMMENT : '/*' .*? '*/' -> skip ;
WS : [ \t\r\n]+ -> skip ;

/* ------------------------------------------------------------------
   PARSER RULES: The structure of the language
   ------------------------------------------------------------------ */

/* Entry point for the parser */
program
    : (prototypeDecl
      | globalVarDecl
      | funcDef
      | statement
      )* EOF
    ;

/* Prototypes: e.g. int fact(int); */
prototypeDecl
    : type ID '(' paramList? ')' PTVG
    ;

/* Global variable declarations: e.g. int x, y=10, z=read(); */
globalVarDecl
    : type varDeclList PTVG
    ;

varDeclList
    : varDecl (VIRG varDecl)*
    ;

/* A single variable declaration: e.g. x, x=10, v[], v[10], s[]=reads() */
varDecl
    : ID arrayDimension? (IG initValue)?
    ;

/* Optional array size declaration: [] or [INT_CONST] */
arrayDimension
    : RETOE INT_CONST? RETOD
    ;

/* Initialization: a single expression or a list enclosed in braces */
initValue
    : expression
    | CHAVE expression (VIRG expression)* CHAVR
    ;

/* Function definitions: e.g. int fact(int k){ ... } */
funcDef
    : type ID '(' paramList? ')' compoundStatement
    ;

/* Function parameter list: e.g. (int k, double x) */
paramList
    : paramDecl (VIRG paramDecl)*
    ;

paramDecl
    : type ID arrayDimension?
    ;

/* Compound statement/block: a sequence of statements enclosed in braces */
compoundStatement
    : CHAVE statement* CHAVR
    ;

/* Statements: variable declaration, if/while/for/return, assignment, function call, or nested block */
statement
    : varDeclList PTVG                # localVarDecl
    | ifStatement                     # ifStmt
    | whileStatement                  # whileStmt
    | forStatement                    # forStmt
    | returnStatement                 # returnStmt
    | assignStatement PTVG            # assignment
    | functionCall PTVG               # callStmt
    | compoundStatement               # blockStmt
    ;

/* if-statement: if (condition) { ... } (else { ... })? */
ifStatement
    : IF PARENE condition PAREND compoundStatement (ELSE (compoundStatement | ifStatement))?
    ;

/* while-statement: while (condition) { ... } */
whileStatement
    : WHILE PARENE condition PAREND compoundStatement
    ;

/* for-statement: for (assign? ; condition? ; assign?) { ... } */
forStatement
    : FOR PARENE (assignStatement PTVG)? (condition PTVG)? (assignStatement)? PAREND compoundStatement
    ;

/* return-statement: return expression?; */
returnStatement
    : RETURN expression? PTVG
    ;

/* Assignment: lvalue = expression */
assignStatement
    : lvalue IG expression
    ;

/* lvalue: variable identifier with optional array index */
lvalue
    : ID arrayIndex?
    ;

/* Array index: e.g. [ expression ] */
arrayIndex
    : RETOE expression RETOD
    ;

/* Function call: built-in functions or user-defined, e.g. fact(n) */
functionCall
    : (READ | READC | READS | WRITE | WRITEC | WRITES | WRITEV | ID) PARENE argList? PAREND
    ;

/* Argument list for function calls */
argList
    : expression (VIRG expression)*
    ;

/* Condition: A logical or relational expression */
condition
    : logicalOrExpr
    ;

/* Logical OR expression */
logicalOrExpr
    : logicalAndExpr (OR logicalAndExpr)*
    ;

/* Logical AND expression */
logicalAndExpr
    : logicalNotExpr (AND logicalNotExpr)*
    ;

/* Logical NOT expression */
logicalNotExpr
    : NOT logicalNotExpr
    | relationalExpr
    ;

/* Relational expression */
relationalExpr
    : additiveExpr ((IGIG | DIFER | MENOR | MAIOR | MENOIG | MAIOIG) additiveExpr)?
    ;

/* The main expression rule (for arithmetic and more) */
expression
    : additiveExpr
    ;

/* Additive expression: addition and subtraction */
additiveExpr
    : multiplicativeExpr ((MAIS | MENOS) multiplicativeExpr)*
    ;

/* Multiplicative expression: multiplication, division, modulus */
multiplicativeExpr
    : unaryExpr ((MULT | DIV | MOD) unaryExpr)*
    ;

/* Unary expression: negation, casting */
unaryExpr
    : MENOS unaryExpr
    | castExpr
    ;

/* Casting expression: e.g. (double)x or (int)z */
castExpr
    : PARENE type PAREND castExpr
    | primaryExpr
    ;

/* Primary expression: literal, parenthesized expression, lvalue, or function call */
primaryExpr
    : INT_CONST
    | DOUBLE_CONST
    | STRING
    | PARENE expression PAREND
    | lvalue
    | functionCall
    ;

/* Type specification: int, double, or void */
type
    : INT
    | DOUBLE
    | VOID
    ;
