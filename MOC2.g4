grammar MOC2;

/////////////////////
// Lexer Rules     //
/////////////////////

INT      : 'int';
DOUBLE   : 'double';
FLOAT    : 'float';
CHAR     : 'char';
VOID     : 'void';
CONST    : 'const';
IF       : 'if';
ELSE     : 'else';
FOR      : 'for';
DO       : 'do';
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
DEFAULT  : 'default';
DEFINE   : '#define';
INCLUDE  : '#include';

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

E_COM         : '&';
QUESTION_MARK : '?';
COLON         : ':';

ID       : [a-zA-Z_][a-zA-Z0-9_]* ;
INT_CONST    : [0-9]+ ;
DOUBLE_CONST : [0-9]+ '.' [0-9]+ ;
STRING   : '"' .*? '"' ;

MACRO: '#' ~[\r\n]* -> skip;
COMMENT  : '/*' .*? '*/' -> skip ;
ONE_LINE_COMMENT : '//' ~[\r\n]* -> skip;
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
    : CONST? type(MULT?) varDeclList PTVG
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
    : type ID PARENE paramList? PARENE? PAREND block
    ;

paramList
    : paramDecl (VIRG paramDecl)*
    ;

paramDecl
    : type(MULT?) ID? arrayDimension?
    ;

// A block is now inlined into the statement rules.
block
    : CHAVE statement* CHAVR
    ;

caseBlock
    : CASE value COLON statement* BREAK? PTVG
    ;

defaultBlock
    : DEFAULT statement* PTVG
    ;

// Flattened statement rule with labeled alternatives.
statement
   : IF PARENE expr PAREND statement (ELSE statement)?                                      # IfStmt
   | SWITCH PARENE expr PAREND CHAVE caseBlock* (defaultBlock | PTVG) CHAVR                 # SwitchStmt
   | WHILE PARENE expr PAREND statement                                                     # WhileStmt
   | DO statement WHILE PARENE expr PAREND PTVG                                             # DoWhileStmt
   | FOR PARENE (assignStatement PTVG)? (expr? PTVG)? (assignStatement)? PAREND statement   # ForStmt
   | RETURN expr? PTVG                                                                      # ReturnStmt
   | CHAVE statement* CHAVR                                                                 # BlockStmt
   | (assignStatement | functionCall) PTVG                                                  # ExprStmt
   | type varDeclList PTVG                                                                  # VarDeclStmt
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
    | expr (MENOR | MAIOR | MENOIG | MAIOIG) expr    # RelationalExpr
    | expr (MAIS | MENOS) expr                       # AddSubExpr
    | expr (MULT | DIV | MOD) expr                   # MulDivExpr
    | expr QUESTION_MARK atom COLON atom PTVG?       # TernaryOpStmt
    | MENOS expr                                     # NegateExpr
    | NOT expr                                       # NotExpr
    | PARENE expr PAREND                             # ParensExpr
    | atom                                           # AtomExpr
    ;

// Atom handles basic expressions and inlined function calls.
atom
    : value
    | (READ | READC | READS | WRITE | WRITEC | WRITES | WRITEV) PARENE argList? PAREND
    | (E_COM?)ID (PARENE argList? PAREND)?
    | ID (RETOE expr RETOD)
    ;

value
    : INT_CONST
    | DOUBLE_CONST
    | STRING
    ;

type
    : INT
    | DOUBLE
    | CHAR
    | VOID
    ;
