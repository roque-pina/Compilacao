LEXER GRAMMAR:
lexer grammar MOCLexer;

/* ------------------------------------------------------------------
   Key-Words
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

/* Funções Leitura/Escrita */
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

/* 

/* ------------------------------------------------------------------
   OPERADORES E SÍMBOLOS
   ------------------------------------------------------------------ */
MAIS     : '+';
MENOS    : '-';
MULT     : '*';
DIV      : '/';
MOD      : '%';

/* Atribuição e Comparação */
IG       : '=';
IGIG     : '==';
DIFER      : '!=';
MENOR       : '<';
MAIOR      : '>';
MENOIG      : '<=';
MAIOIG    : '>=';

/* Operadores Lógicos */
AND      : '&&';
OR       : '||';
NOT      : '!';

/* Delimitadores e Pontuação */
PARENE   : '(';
PAREND   : ')';
CHAVE   : '{';
CHAVR   : '}';
RETOE   : '[';
RETOD   : ']';
PTVG     : ';';
VIRG    : ',';

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
