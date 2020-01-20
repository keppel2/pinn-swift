grammar Pinn;

file : ( function | statement )+ EOF ;

function
  : 'func' ID LPAREN (fvarDecl (',' fvarDecl)*)?  RPAREN kind? block ;

block
  : '{' statement* '}' ;

fvarDecl
  : ID THREEDOT? kind ;

varDecl
  : 'var' ID kind
  | ID CE expr
  | LPAREN ID ( ',' ID )* RPAREN CE expr;


kind
  : TYPES
  | (LSQUARE ( MAP | expr)? RSQUARE) kind
  |  AST? LPAREN kindList RPAREN ;


simpleStatement
  : lExpr '=' expr #simpleSet
  | lExpr ('+' | '-' | '*' | '/' | '%') '=' expr #compoundSet
  | lExpr DOUBLEOP #doubleSet ;

lExpr
  : ID (LSQUARE expr RSQUARE)* ;

objectPair
  : STRING ':' expr ;

expr
  :
   expr LSQUARE ( first=expr? (AT | COLON) second=expr? | expr) RSQUARE #indexExpr
  |   THREEDOT? LSQUARE exprList RSQUARE #arrayLiteral
  | '{' objectPair ( ',' objectPair )* '}' #objectLiteral
  |    ('+' | '-' | '!' ) expr #unaryExpr
  | expr ('+' | '-' | AST | '/' | '%') expr #intExpr
  | expr ('==' | '!=' | '>' | '<' | '>=' | '<=' ) expr #compExpr
  | expr ('&&' | '||') expr #boolExpr
  |   ID LPAREN exprList? RPAREN #callExpr
  |  LPAREN expr RPAREN #parenExpr
  |  CARET? AST? LPAREN exprList RPAREN #tupleExpr
  | expr (AT | COLON) expr #rangeExpr
  | expr '?' expr COLON expr #conditionalExpr
  | (ID | FLOAT | INT | BOOL | STRING | NIL ) #literalExpr ;
  
exprList
  : expr (',' expr)* ;
kindList
  : kind (',' kind)* ;

returnStatement
  : 'return' expr? ;

ifStatement
  : 'if' expr statement ('else' statement)?;

guardStatement
  : 'guard' expr 'else' block;

whStatement
  : 'while' expr block ;
  
loopStatement
  : 'loop' block ;

repeatStatement
  : 'repeat' block 'while' expr ;


foStatement
  : 'for' (varDecl | fss=simpleStatement)? ';' expr ';' sss=simpleStatement block
  | 'for' ID COMMA ID '=' RANGE expr block |
    'for' ID '=' RANGE expr block ;
caseStatement
  : 'when' exprList COLON statement* ;

switchStatement
  : 'match' expr '{' caseStatement* ('default' COLON statement*)? '}' ;

statement
  :  expr ';'
  | varDecl ';' 
  | simpleStatement ';'
  | ifStatement
  | guardStatement
  | whStatement 
  | repeatStatement ';'
  | loopStatement
  | switchStatement
  | returnStatement ';'
  | foStatement
  | block
  | 'break' ';'
  | 'continue' ';'
  | 'fallthrough' ';'
  | ';' ;
  
  


TYPES
  : ('int' | 'bool' |'string' | 'decimal' | 'self' ) ;
DOUBLEOP : '++' | '--' ;
BOOL : 'true' | 'false' ;

MAP
 : 'map' ;

LSQUARE : '[' ;
RSQUARE : ']' ;
LPAREN : '(' ;
RPAREN : ')' ;
NIL : 'nil' ;
COMMA : ',' ;
COLON : ':' ;
CE : ':=' ;
IOTA : 'iota' ;
RANGE : 'range' ;
AST: '*' ;
THREEDOT : '...' ;
AT : '@' ;
CARET : '^' ;




ID : [a-zA-Z_]([a-zA-Z_0-9])* ;
INT : '0'
  | [1-9] ('_'? DECIMAL_DIGITS)? ;

FLOAT : DECIMAL_DIGITS '.' DECIMAL_DIGITS? DECIMAL_EXPONENT?
  | DECIMAL_DIGITS DECIMAL_EXPONENT
  | '.' DECIMAL_DIGITS DECIMAL_EXPONENT? ;

WS : ([ \t\n]+ | '//' ~('\n')* '\n' | '/*' .*? '*/' )-> skip ;
STRING : '"' ( '\\"' | '\\\\' | ~('"' | '\\') )*      '"' ;

fragment DECIMAL_DIGIT : [0-9] ;
fragment DECIMAL_DIGITS : DECIMAL_DIGIT ('_'? DECIMAL_DIGIT)* ;
fragment DECIMAL_EXPONENT : 'e' [+-]? DECIMAL_DIGITS ;
