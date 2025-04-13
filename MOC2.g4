grammar MOC2;

/////////////////////
// Lexer Rules     //
/////////////////////

INT      : 'int';
DOUBLE   : 'double';
FLOAT    : 'float';
CHAR     : 'char';
VOID     : 'void';
IF       : 'if';
ELSE     : 'else';
FOR      : 'for';
WHILE    : 'while';
RETURN   : 'return';
SWITCH   : 'switch';
CASE     : 'case';
READ     : 'read';
READC    : 'readc';
READS    : 'reads';
WRITE    : 'write';
WRITEC   : 'writec';
WRITES   : 'writes';
WRITEV   : 'writev';
BREAK    : 'break';
CONTINUE : 'continue';

MAIS     : '+';
MENOS    : '-';
MULT     : '*';
DIV      : '/';
MOD      : '%';

IG       : '=';
IGIG     : '==';
DIFER    : '!=';
MENOR    : '<';
MAIOR    : '>';
MENOIG   : '<=';
MAIOIG   : '>=';

AND      : '&&';
OR       : '||';
NOT      : '!';

PARENE   : '(';
PAREND   : ')';
CHAVE    : '{';
CHAVR    : '}';
RETOE    : '[';
RETOD    : ']';
PTVG     : ';';
VIRG     : ',';

ID       : [a-zA-Z_][a-zA-Z0-9_]* ;
INT_CONST    : [0-9]+ ;
DOUBLE_CONST : [0-9]+ '.' [0-9]+ ;
STRING   : '"' .*? '"' ;

COMMENT  : '/*' .*? '*/' -> skip ;
WS       : [ \t\r\n]+ -> skip ;

/////////////////////
// Parser Rules    //
/////////////////////

program 
    : (prototypeDecl | globalVarDecl | funcDef | statement)* EOF
    ;

prototypeDecl
    : type ID PARENE paramList? PAREND PTVG
    ;

globalVarDecl
    : type varDeclList PTVG
    ;

varDeclList
    : varDecl (VIRG varDecl)*
    ;

varDecl
    : ID arrayDimension? (IG initValue)?
    ;

arrayDimension
    : RETOE INT_CONST? RETOD
    ;

initValue
    : expr
    | CHAVE expr (VIRG expr)* CHAVR
    ;

funcDef
    : type ID PARENE paramList? PARENE? PAREND ( block | PTVG)
    ;

paramList
    : paramDecl (VIRG paramDecl)*
    ;

paramDecl
    : type ID? arrayDimension?
    ;

// A block is now inlined into the statement rules.
block
    : CHAVE statement* CHAVR
    ;

// Flattened statement rule with labeled alternatives.
statement
   : IF PARENE expr PAREND statement (ELSE statement)?                                      # IfStmt
   | WHILE PARENE expr PAREND statement                                                     # WhileStmt
   | FOR PARENE (assignStatement PTVG)? (expr? PTVG)? (assignStatement)? PAREND statement   # ForStmt
   | RETURN expr? PTVG                                                                      # ReturnStmt
   | CHAVE statement* CHAVR                                                                 # BlockStmt
   | (type)* varDeclList PTVG                                                               # VarDeclStmt
   | (assignStatement | functionCall) PTVG                                                  # ExprStmt
   ;

// Assignment and lvalue.
assignStatement
    : lvalue IG expr
    ;

lvalue
    : ID (RETOE expr RETOD)?
    ;

// Function call can appear as a statement.
functionCall
    : (READ | READC | READS | WRITE | WRITEC | WRITES | WRITEV | ID) PARENE argList? PAREND
    ;

argList
    : expr (VIRG expr)*
    ;

// Unified expression rule with direct left recursion to flatten tree structure.
// The order below gives lower precedence alternatives at the top and higher precedence at the bottom.
expr
    : expr OR  expr                                  # OrExpr
    | expr AND expr                                  # AndExpr
    | expr (IGIG | DIFER) expr                       # EqExpr
    | expr (MENOR | MAIOR | MENOIG | MAIOIG) expr      # RelationalExpr
    | expr (MAIS | MENOS) expr                       # AddSubExpr
    | expr (MULT | DIV | MOD) expr                   # MulDivExpr
    | MENOS expr                                     # NegateExpr
    | NOT expr                                       # NotExpr
    | PARENE expr PAREND                             # ParensExpr
    | atom                                           # AtomExpr
    ;

// Atom handles basic expressions and inlined function calls.
atom
    : INT_CONST
    | DOUBLE_CONST
    | STRING
    | (READ | READC | READS | WRITE | WRITEC | WRITES | WRITEV) PARENE argList? PAREND
    | ID (PARENE argList? PAREND)?
    ;

type
    : INT
    | DOUBLE
    | VOID
    ;
