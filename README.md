# Pinn is a computer language that lets you be correct.

Pinn is a statically typed, imperative language for computers.

* Syntax taken mostly from Go.
* Carefully chosen ideas from Swift.

# Running.

* `swift run pinn tic.pinn`.

_Implementations as interpreters in Antlr for Go and Swift. Current progress in Swift._

## Element Types

* `int`. Always a signed 64-bit.
* `bool`. Standard, `true` or `false`.
* `string`. Immutable Unicode. `"string"` `"this is a double quote:\""`
* `decimal`. Decimal.
* `nil`. Pointer of tuple type to nothing.
## Group Types

* _Scalar_ is a single element.
* `map`. A map produces a unique _value_ for each _key_. The key is always a string. Like Go, a missing string returns the zero value for an element.
* `array`. An array is a group of elements with a constant size. It is only produced in a variable declaration. It copies on assignment.
* `slice`. A slice is an array that can be grown. It can be produced by variable declaration, slicing, and ranges. It shares a reference on assignment.
* `tuple`. A tuple is a group of elements with a constant size and possibly different types.
* `pointer`. A pointer is a tuple with one or more references to itself. These references are of type `self`, and can be either `nil` or a pointer to a different copy with the same type as itself.

## Expressions

* _From highest precedence_
* `<id> "[" (<expr>? (":" | "@") <expr>?)? "]"` Index expression.
* `"[" <expr_list "]"` Slice literal
  * All expressions must be of the same type.
* `"{" <STRING> ":" <expr> { "," <STRING> ":" <expr> } }` Map literal
  * Expressions must be of the same type.
* `+ - !` Unary
* `<op> := + - * / %` Binary (simplified precedence), _string concatenation_
* `== != < <= > >=` Comparison, _string comparisons_
* `&& ||` Short-circuit AND and OR
* `<id> "(" <expr_list>? ")"` Call function
* `"(" <expr> ")"` Parenthesize expression
* `"(" <expr_list> ")"` Tuple
* `<expr> ( ":" | "@" ) <expr>` Range generator. Both generate one through ten: `1:11 1@10`.
* `<expr> "?" <expr> ":" <expr>` Ternary conditional. First `expr` is evaluated. If true, resolve to second `expr`. If false, resolve to third `expr`.
* `<ID> <FLOAT> <INT> <BOOL> <STRING>` Tokens representing symbols, decimals, integers, booleans, and strings.
## Compilation unit
* `( <function> | <statement>)+ <EOF>`
## Function, `<function>`

* `func <ID> "(" (<fVarDecl> { , <fVarDecl> } )? ")" <kind>? <block>`
  * `fVarDecl := <ID> ...? <kind>`

A function calls a piece of code, assigning each variable in the parameter list to each the value in the calling list. The `...` is allowed for the last parameter. It is expanded into an array carrying zero or more calling expressions.
## block
* `"{" { <statement> } "}"`
  * A block is a series of zero or more statements.

## simple-statement
* `<L-expr> [ "[" <expr> "]" ] = <expr>` Simple set
  * The `expr` to the right of the `=` is assigned to the `L-expr`.
* `<L-expr> <op> = <expr>` Compound set
## grammar fragments
### `<L-expr`
* `<id> ( "[" <expr> "]" )*`
### `<expr_list>`
* `<expr> { , <expr> }`
### `Left expression, <LExpr>`
* `<id> ( [ <expr> ] )*`
  * A left-expression can be assigned a value.
### `<kind>`
* ` int | bool | string | decimal | self`
* `"[" (map | slice | <expr>) "]" <kind>`
* `"(" <kind> ( , <kind>)* ")"`


## `<statement>`
* `while <expr> <block>`
  * Evaluate `expr`. If true, execute `block` and repeat this line. If false, go on.
* `repeat <block> while <expr> ;`
  * Execute `block`. Evaluate `expr`. If true, repeat this line.
* `return [<expr>] ;`
  * Return from function. The `expr` must match the return type, or empty if there is none. If global, there is no return type.
* `if <expr> <statement> [else <statement>]`
  * Evaluate `expr`. If true, exectue first `statement`. If false, either move on or execute second `statement`.
* `guard <expr> else <block>`
  * Evaluate `expr`. If false, execute `block`. The block must relinquish control, with a `return`, `break`, or `continue`.
* `for <id> [, <id>] = range <expr> <block>`
  * If `id` is alone, it becomes the values of the `expr`. If a second `id` is present, it becomes the values and the first `id` are the keys. The `expr` must evaluate to an array, slice, or map. The block iterates through the elements. Note that `id1` and `id2` must be predeclared.
* `"{" { <statement> } "}"` Block statement
* `match <expr> "{" { when <expr_list> : { <statement> } } [ default : { <statement> } ] "}"` `expr` is compared to each `when` clause in order.  two spaces. one space.
* ` ( break | continue | fallthrough ) ;`
* ` ; ` Empty statement
## Variable declaration (`<var_decl>`)
* `var <id> <kind>`
  * Declare `id` of `kind` type.
* `<id> ":=" <expr>`
  * Short declaration. The `id` is set to the type and value of expression.

The grammar is clean of implementation language and is written in ANTLR. It has implementations in Go and Swift. The Swift implementation is more recent.

## Built-in functions
* `exit()`
  * Exit the program. No parameters allowed.
* `len(<expr>)`
  * Return the length of the expression. For compound types, return the count of data. For strings, return the length of the string.
* `print(<expr_list>)`
  * Print each `expr` in the list, with a space between them.
* `println(<expr_list>)`
  * `print()` with a line feed at the end.
* `stringValue(<expr>)`
  * Returns a string representation of the `expr`--the same printed with `print`.
* `delete(<expr>, <expr>)`
  * Delete key(second `expr`) from map(first `expr`). Return `bool` indicating whether the key existed.
* `key(<expr>, <expr>)`
  * Determine if key(second `expr`) exists in map(first `expr`).


## Notation
```
|            alternation
()           grouping
[]           option (0 or 1 times)
{}           repetition (0 to n times)
:=           assign to token or production on left
literal      literal characters as typed--"literal"
<prod>       grammar rule specified elsewhere
<TOKEN>      lexer rule specified elsewhere

"{" "[" ...  notation elements as literals
```
## Solving Tic-Tac-Toe.

```
EMPTY := 0;
TIE := 3;
PLAYER_A := 1;
PLAYER_B := 2;
SIZE := 3;
var rHashMap [map]int;
func coord (x int, y int) int {
	return y * SIZE + x;
}
func rHash(board [SIZE * SIZE]int, player int) int {
    rt := 0;
    var v int;
    for v = range board {
        rt *= SIZE;
        rt += v;
    }
    rt *= 2;
    rt += player - 1;
    return rt;
}
func printBoard (board [SIZE * SIZE]int) {
	var y int;
	var x int;
	for y = range 0:SIZE {
        print (board[coord(0, y)]);
		for x = range 1:SIZE {
        print (" ");
        print (board[coord(x, y)]);
		}
        println();
	}
	println ("---");
}
func full (board [SIZE * SIZE]int) bool {
    var e int;
    for e = range 0:SIZE * SIZE {
        if board[e] == EMPTY {
            return false;
        }
    }
    return true;
}

func line (board [SIZE * SIZE]int, x int, y int, dx int, dy int) int {
    comp := board[coord(x, y)];
    if comp == EMPTY {
        return TIE;
    }
    while x + dx < SIZE && y + dy < SIZE {
        x += dx;
        y += dy;
        if board[coord(x, y)] != comp {
            return TIE;
        }
    }
    return comp;
}

func winner (board [SIZE * SIZE]int) int {
	var i int;
    var rt int;

    for i = range 0:SIZE {
        rt = line(board, i, 0, 0, 1);
        if rt != TIE
            return rt;
        rt = line(board, 0, i, 1, 0);
        if rt != TIE
            return rt;
    }
    rt = line(board, 0, 0, 1, 1);
    if rt != TIE
        return rt;
    rt = line(board, 0, SIZE - 1, 1, -1);
    return rt;
}

func opposite (x int) int { return x == PLAYER_A ? PLAYER_B : PLAYER_A; }
			
func minimax (player int, board [SIZE * SIZE]int) int
{
	var result int;
	var best int = opposite(player);

	result = winner(board);
	if result != TIE {
		return result;
    }
    if full(board) {
        return TIE;
    }
	var x int;
	var y int;
    var strRHash string;
	for x = range 0:SIZE {
		for y = range 0:SIZE {
			if board[coord(x, y)] == EMPTY {
				board[coord(x, y)] = player;
                strRHash = stringValue(rHash(board, player));
                if rHashMap[strRHash] > 0 {
                    result = rHashMap[strRHash];
                } else {
                    result = minimax(opposite(player), board);
                    rHashMap[strRHash] = result;
                }
				if result == player {
					return player;
				}
				if result == TIE {
					best = TIE;
				}
				board[coord(x, y)] = EMPTY;
			}
		}
	}
	return best;
}

func main() {
    var    board [SIZE * SIZE]int;
    println("Initial board");
    ar := [0, 0, 0,
           0, 0, 0,
           0, 0, 0];
           
    var x int;
    for x = range 0:SIZE * SIZE {
        board[x] = ar[x];
    }
    
    printBoard(board);
    
    var result int = minimax (PLAYER_A, board);
   
    resultString := "";
    match result {
        when TIE:
            resultString = "Tie.";
        when PLAYER_A:
            resultString = "Player A.";
        when PLAYER_B:
            resultString = "Player B.";
    }
    println ("Winner:", resultString);
}
main();
```
