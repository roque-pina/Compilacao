lexer grammar MOCLexer;

/* ------------------------------------------------------------------
   PALAVRAS-CHAVE
   ------------------------------------------------------------------ */
INT      : 'int';
DOUBLE   : 'double';
VOID     : 'void';
IF       : 'if';
ELSE     : 'else';
FOR      : 'for';
WHILE    : 'while';
RETURN   : 'return';

/* Funções de E/S na MOC */
READ     : 'read';
READC    : 'readc';
READS    : 'reads';
WRITE    : 'write';
WRITEC   : 'writec';
WRITES   : 'writes';
WRITEV   : 'writev';

/* ------------------------------------------------------------------
   OPERADORES E SÍMBOLOS
   ------------------------------------------------------------------ */
PLUS     : '+';
MINUS    : '-';
MULT     : '*';
DIV      : '/';
MOD      : '%';

/* Atribuição e Comparação */
EQ       : '=';
EQEQ     : '==';
NEQ      : '!=';
LT       : '<';
GT       : '>';
LTE      : '<=';
GTE      : '>=';

/* Operadores Lógicos */
AND      : '&&';
OR       : '||';
NOT      : '!';

/* Delimitadores e Pontuação */
LPAREN   : '(';
RPAREN   : ')';
LBRACE   : '{';
RBRACE   : '}';
LBRACK   : '[';
RBRACK   : ']';
SEMI     : ';';
COMMA    : ',';

/* ------------------------------------------------------------------
   IDENTIFICADORES E LITERAIS
   ------------------------------------------------------------------ */

/* Identificadores (variáveis, nomes de funções, etc.) */
ID : [a-zA-Z_][a-zA-Z0-9_]* ;

/* Números inteiros */
INT_CONST : [0-9]+ ;

/* Números "double" bem simples: parte inteira + ponto + parte fracionária */
DOUBLE_CONST : [0-9]+ '.' [0-9]+ ;

/* Strings (usadas em writes("texto"), etc.) */
STRING : '"' .*? '"' ;

/* ------------------------------------------------------------------
   COMENTÁRIOS E ESPAÇOS EM BRANCO
   ------------------------------------------------------------------ */

/* Comentários estilo C, descartados (skip) */
COMMENT : '/*' .*? '*/' -> skip ;

/* Espaços em branco, tabulações, quebras de linha - também descartados */
WS : [ \t\r\n]+ -> skip ;
