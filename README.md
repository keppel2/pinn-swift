_Second version of Pinn. Updated ANTLR and Swift. Archived._
# Pinn is a computer language that lets you be correct..

Pinn is a statically typed, imperative language for computers.

* Syntax taken mostly from Go.
* Carefully chosen ideas from Swift.

# Running.

* `swift run pinn`. plays a game of tic-tac-toe.

_Implementations as interpreters in Antlr for Go and Swift. Current progress in Swift._

## Element Types

* `int`. Always a signed 64-bit.
* `bool`. Standard, `true` or `false`.
* `string`. Immutable Unicode. `"string"` `"this is a double quote:\""`
* `decimal`. Decimal.
* `self`. Only allowed in a pointer--points to itself.
## Group Types

* _Scalar_ is a single element.
* `map`. A map produces a unique _value_ for each _key_. The key is always a string. Like Go, a missing string returns the zero value for an element.
* `array`. An array is a group of elements with a constant size. It is only produced in a variable declaration. It never shares its storage, even if sliced.
* `slice`. A slice is an array that can be grown. It can be produced by variable declaration, slicing, and ranges. It shares a reference on assignment.
* `tuple`. A tuple is a group of elements with a constant size and possibly different types.
* `pointer`. A pointer is a tuple that can be nil. The zero value is nil.

## Tokens
* `<ID>`
  * Consists of the letters `a` through `z`, `A` through `Z`, `_`, and digits `0`-`9`. May not start with a digit.
* `<FLOAT>`
* `<STRING>`
  * Starts and ends with a `"`. In a string, use `\"` to refer to a `"` character. Use `\\` to refer to a `\` character. Otherwise, `\` is illegal.
* `<NIL>`
  * `nil`. The null value.

## Expressions

* _From highest precedence_
* `<ID> "[" (<expr>? (: | @) <expr>? | <expr>) "]"` Index expression. With a `:` or `@`, slices the `ID`. 
* `"[" <expr_list> "]"` Array literal
  * All expressions must be of the same type.
* `..."[" <expr_list> "]"` Slice literal
* `"{" <STRING> ":" <expr> { "," <STRING> ":" <expr> } }` Map literal
  * Expressions must be of the same type.
* `+ - !` Unary
* `<op> := + - * / %` Binary (simplified precedence), _string concatenation_
* `== != < <= > >=` Comparison, _string comparisons_
* `&& ||` Short-circuit AND and OR
* `<ID> "(" <expr_list>? ")"` Call function
* `"(" <expr> ")"` Parenthesize expression
* `"(" <expr_list> ")"` Tuple literal
* `*"(" <expr-list> ")"` Pointer literal
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
  * `x += 2` is equivalent to `x = x + 2`
## grammar fragments
### `<L-expr>`
* `<ID> ( "[" <expr> "]" )*`
  * An `L-expr` can be assigned to.
### `<expr_list>`
* `<expr> { , <expr> }`
  * Used in various productions. Note that at least one `expr` is required.
### `<kind>`
* ` int | bool | string | decimal | self`
  * Primitive types.
* `"[" (map | <expr>)? "]" <kind>`
  * `map` declares a map. An `expr` declares an array. Empty brackets indicates a slice.
* `"(" <kind> ( , <kind>)* ")"`
  * Declares a tuple type.
* `*"(" kind> ( , <kind> )* ")"`, declares a pointer type.
## `<statement>`
* `<var_decl> ;`
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
* `for <ID> [, <ID>] = range <expr> <block>`
  * If `id` is alone, it becomes the values of the `expr`. If a second `id` is present, it becomes the values and the first `id` are the keys. The `expr` must evaluate to an array, slice, or map. The block iterates through the elements. Note that `id1` and `id2` must be predeclared.
* `"{" { <statement> } "}"` Block statement
* `match <expr> "{" { when <expr_list> : { <statement> } } [ default : { <statement> } ] "}"` `expr` is compared to each `when` clause in order.
* ` ( break | continue | fallthrough ) ;`
  * `break` stops execution of the current loop. It then exits the loop.
  * `continue` stops execution of the current loop. It then continues execution of the next loop.
  * `fallthrough` falls through to the next `when` in a `match` block.
* `<expr> ;` Evalutate `expr`. The result is thrown away.
* ` ; ` Empty statement.
* `<ID> | <FLOAT> | <INT> | <BOOL> | <STRING> | <NIL>` Literals.

## Variable declaration (`<var_decl>`)
* `var <ID> <kind> ;`
  * Declare `id` of `kind` type.
* `<ID> ":=" <expr> ;`
  * Short declaration. The `id` is set to the type and value of the `expr`.

The grammar is clean of implementation language and is written in ANTLR as a visitor to the tree. It has implementations in Go and Swift. The Swift implementation is more recent.

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
## Solving Tic-Tac-Toe (`tic.pinn`)

```
EMPTY := 0;
TIE := 3;
PLAYER_A := 1;
PLAYER_B := 2;
SIZE := 3;
var rHashMap [map]int;

func rHash(board [SIZE][SIZE]int, player int) int {
    rt := 0;
    var v int;
    var x int;
    var y int;
    for x = range 0:SIZE {
        for y = range 0:SIZE {
            v = board[x][y];
            rt *= SIZE;
            rt += v;
        }
    }
    rt *= 2;
    rt += player - 1;
    return rt;
}
func printBoard (board [SIZE][SIZE]int) {
	var y int;
	var x int;
	for y = range 0:SIZE {
        print (board[0][y]);
		for x = range 1:SIZE {
        print (" ");
        print (board[x][y]);
		}
        println();
	}
	println ("---");
}

func full (board [SIZE][SIZE]int) bool {
    var x int;
    var y int;
    for x = range 0:SIZE {
        for y = range 0:SIZE {
            if board[x][y] == EMPTY {
                return false;
            }
        }
    }
    return true;
}

func line (board [SIZE][SIZE]int, x int, y int, dx int, dy int) int {
    comp := board[x][y];
    if comp == EMPTY {
        return TIE;
    }
    while x + dx < SIZE && y + dy < SIZE {
        x += dx;
        y += dy;
        if board[x][y] != comp {
            return TIE;
        }
    }
    return comp;
}

func winner (board [SIZE][SIZE]int) int {
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
			
func minimax (player int, board [SIZE][SIZE]int) int
{
	var result int;
	best := opposite(player);

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
			if board[x][y] == EMPTY {
				board[x][y] = player;
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
				board[x][y] = EMPTY;
			}
		}
	}
	return best;
}

func main() {
    var    board [SIZE][SIZE]int;
    println("Initial board");

    printBoard(board);
    
    result := minimax (PLAYER_A, board);
   
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
