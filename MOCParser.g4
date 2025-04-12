parser grammar MOCParser;

options {
    tokenVocab = MOCLexer;  // Link to your MOCLexer
}

/*
 * Parser entry point:
 * A program can have zero or more prototypes, variable declarations,
 * or function definitions, in any sequence, followed by EOF.
 */
program
    : (prototypeDecl
      | globalVarDecl
      | funcDef
      )* EOF
    ;


/* ------------------------------------------------------------------
   Prototypes: e.g.  int fact(int);
   ------------------------------------------------------------------ */

prototypeDecl
    : type ID LPAREN paramList? RPAREN SEMI
    ;


/* ------------------------------------------------------------------
   Global variable declarations: 
   e.g.  int x, y=10, z=read();
         double a=3.14, v[]={1,2,3};
   ------------------------------------------------------------------ */

globalVarDecl
    : type varDeclList SEMI
    ;

varDeclList
    : varDecl (COMMA varDecl)*
    ;

/* A single variable declaration part:
   e.g. 
       x
       x=10
       v[] = {1,2,3}
       v[10]
       s[] = reads()   // etc.
 */
varDecl
    : ID arrayDimension? (EQ initValue)?
    ;

/* Optional array size: e.g. [10], or [] if size is inferred */
arrayDimension
    : LBRACK INT_CONST? RBRACK
    ;

/* An initialization can be:
   - a single expression (e.g. = 10, = read(), = x+1, etc.)
   - a brace-enclosed list of expressions for array init, e.g. = {1,2,3}
 */
initValue
    : expression
    | LBRACE expression (COMMA expression)* RBRACE
    ;


/* ------------------------------------------------------------------
   Function definitions:
   e.g.
       int fact(int k) { ... }
       void main(void) { ... }
   ------------------------------------------------------------------ */

funcDef
    : type ID LPAREN paramList? RPAREN compoundStatement
    ;

/* List of parameters for a function or prototype:
   e.g.  (int k, double x)
 */
paramList
    : paramDecl (COMMA paramDecl)*
    ;

paramDecl
    : type ID arrayDimension?
    ;


/* ------------------------------------------------------------------
   Statements (inside blocks):
   ------------------------------------------------------------------ */

compoundStatement
    : LBRACE statement* RBRACE
    ;

/*
 * Each statement can be:
 *  - A variable declaration (local scope)
 *  - If / While / For / Return
 *  - An assignment (like i = i+1)
 *  - A function call (like write(i))
 *  - A nested compound statement
 */
statement
    : varDeclList SEMI                # localVarDecl
    | ifStatement                     # ifStmt
    | whileStatement                  # whileStmt
    | forStatement                    # forStmt
    | returnStatement                 # returnStmt
    | assignStatement SEMI            # assignment
    | functionCall SEMI               # callStmt
    | compoundStatement               # blockStmt
    ;

/* if-statement: if (cond) { ... } ( else { ... })? */
ifStatement
    : IF LPAREN condition RPAREN compoundStatement (ELSE compoundStatement)?
    ;

/* while-statement: while (cond) { ... } */
whileStatement
    : WHILE LPAREN condition RPAREN compoundStatement
    ;

/* for-statement: for(i=0; i<10; i=i+1) { ... } 
   Note: no ++, --, += etc. in your MOC, so we re-use "assignStatement" for each
   part. Each piece is optional in C-like syntax:
   for ( (assignStatement)? ; (condition)? ; (assignStatement)? ) { ... }
*/
forStatement
    : FOR
      LPAREN
         (assignStatement SEMI)? 
         (condition SEMI)? 
         (assignStatement)?
      RPAREN
      compoundStatement
    ;

/* return-statement: return expr?; */
returnStatement
    : RETURN expression? SEMI
    ;

/* A simple assignment: (lvalue) = (expression) */
assignStatement
    : lvalue EQ expression
    ;

/* lvalue can be an ID or an array-access: e.g.  x,  v[ i ] */
lvalue
    : ID arrayIndex?
    ;

arrayIndex
    : LBRACK expression RBRACK
    ;


/* ------------------------------------------------------------------
   Function calls: can be built-in (read, write, etc.) or user-defined
   e.g.  read(),  write(x),  fact(n)
   ------------------------------------------------------------------ */

functionCall
    : (READ | READC | READS | WRITE | WRITEC | WRITES | WRITEV | ID)
      LPAREN argList? RPAREN
    ;

argList
    : expression (COMMA expression)*
    ;


/* ------------------------------------------------------------------
   Conditions & Expressions
   ------------------------------------------------------------------ */

/* Condition as described can be:
   - Single expression
   - Expression relationalOp Expression
   - Combined by &&, ||, and unary '!'
   (We'll use a standard logical/relational expression breakdown.)
 */
condition
    : logicalOrExpr
    ;

/* logicalOrExpr -> logicalAndExpr (|| logicalAndExpr)* */
logicalOrExpr
    : logicalAndExpr (OR logicalAndExpr)*
    ;

/* logicalAndExpr -> logicalNotExpr (&& logicalNotExpr)* */
logicalAndExpr
    : logicalNotExpr (AND logicalNotExpr)*
    ;

/* logicalNotExpr -> '!' logicalNotExpr | relationalExpr */
logicalNotExpr
    : NOT logicalNotExpr
    | relationalExpr
    ;

/* relationalExpr -> additiveExpr ( (== | != | < | > | <= | >=) additiveExpr )? */
relationalExpr
    : additiveExpr ((EQEQ | NEQ | LT | GT | LTE | GTE) additiveExpr)?
    ;

/* In MOC examples, we have +, -, *, /, %, and possible unary minus,
   plus optional casting. 
   We keep it simpler here—just a typical parse for expressions
   with standard precedence:
   
   expression -> additiveExpr in this simplified grammar.
*/
expression
    : additiveExpr
    ;

/* additiveExpr -> multiplicativeExpr (('+'|'-') multiplicativeExpr)* */
additiveExpr
    : multiplicativeExpr ( (PLUS | MINUS) multiplicativeExpr )*
    ;

/* multiplicativeExpr -> unaryExpr (('*'|'/'|'%') unaryExpr)* */
multiplicativeExpr
    : unaryExpr ( (MULT | DIV | MOD) unaryExpr )*
    ;

/*
 * unaryExpr ->
 *       '-' unaryExpr  (unary minus)
 *     | castExpr
 */
unaryExpr
    : MINUS unaryExpr
    | castExpr
    ;

/* castExpr -> '(' type ')' castExpr | primaryExpr
   e.g.  (double)x, (int)z
 */
castExpr
    : LPAREN type RPAREN castExpr
    | primaryExpr
    ;

/* primaryExpr can be: 
   - numeric literal (int or double)
   - string
   - parenthesized expr
   - lvalue
   - functionCall
*/
primaryExpr
    : INT_CONST
    | DOUBLE_CONST
    | STRING
    | LPAREN expression RPAREN
    | lvalue
    | functionCall
    ;


/* ------------------------------------------------------------------
   Types: int, double, or void
   ------------------------------------------------------------------ */
type
    : INT
    | DOUBLE
    | VOID
    ;
