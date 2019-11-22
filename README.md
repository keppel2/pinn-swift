# Pinn is a computer language that lets you be correct.

Pinn is a statically typed, imperative language for computers.

* Syntax taken mostly from Go.
* Carefully chosen ideas from Swift.

_Implementations as interpreters in Antlr for Go and Swift_
## Specification

## Lexical

Most lexical elements are borrowed from Go. Later elements include support for `_` in numeric literals and binary floating point.

## Element Types

* `int`. Always a signed 64-bit.
* `bool`. Standard, `true` or `false`.
* `string`. Immutable.
* `decimal`. Decimal.
## Group Types

* _Scalar_ is a single element.
* `map`. A map produces a unique _value_ for each _key_. The key is always a string. Like Go, a missing string returns the zero value for an element.
* `array`. An array is a group of elements with a constant size. It is only produced in a variable declaration.
* `slice`. A slice is an array that can be grown. It can be produced by variable declaration, slicing, and ranges.

## Expressions

* Almost all taken from Go, so much like c/Java. Conditional expression was put back in.
* _From highest precedence_
* `<id> "[" (<expr>? (":" | "@") <expr>?)? "]"` Index expression.
* `"[" <expr_list "]"` Array literal
* `"{" <ID> ":" <expr> { "," <ID> ":" <expr> } }` Map literal
* `+ - !` Unary
* `+ - * / %` Binary (simplified precedence), _string concatenation_
* `== != < <= > >=` Comparison
* `&& ||` Short-circuit AND and OR
* `<id> "(" <expr_list>? ")"` Call
* `<expr> ( ":" | "@" ) <expr>` Range generator. Both generate one through ten: `1:11 1@10`.
* `<expr> "?" <expr> ":" <expr>` Ternary conditional. First `expr` is evaluated. If true, resolve to first `expr`. If false, resolve to second `expr`.
* `<ID> <FLOAT> <INT> <BOOL> <STRING>`
## Compilation unit
* `( <function> | <statement>)+ EOF`

## block
* `"{" { <statement> } "}"`


## simple-statement
* `<id> [ "[" <expr> "]" ] = <expr>` Simple set
* `<id> [ "[" <expr> "]" ] <op> = <expr>` Compount set

## variable-declaration
* `<id> <kind> [ = expr_list ]`
* `<id> := <expr>`

## statement
* `while <expr> <block>`
  * Evaluate `expr`. If true, execute `block` and repeat this line. If false, go on.
* `repeat <block> while <expr>`
  * Execute `block`. Evaluate `expr`. If true, repeat this line.
* `return [<expr>] ;`
  * Return from function. The `expr` must match the return type, or empty if there is none. If global, there is no return type.
* `if <expr> <statement> [else <statement>]`
  * Evaluate `expr`. If true, exectue first `statement`. If false, either move on or execute second `statement`.
* `guard <expr> else <block>`
  * Evaluate `expr`. If false, execute `block`. The block must relinquish control, with a `return`, `break`, or `continue`.
* `for <id1> [, <id2>] = range <expr> <block>
  * If `id1` is alone, it becomes the values of the `expr`. If `id2` is present, it is the values and `id1` is the keys. The `expr` must evaluate to an array, slice, or map. The block iterates through the elements. Note that `id1` and `id2` must be predeclared.
* `"{" { <statement> } "}"` block statement
  
 

## Variable declaration
* `<id> <kind> [ = <expr_list> ]`
  * Declare `id` of `kind` type. Optionally initialize it.
* `<id> := <expr>`
  * Short declaration.


The grammar is clean of implementation language and is written in ANTLR. It has implementations in Go and Swift. The Swift implementation is more recent.

# Running Go version (pinn-go here on Github)

Get ANTLR from https://www.antlr.org/download.html .

Save the following to `hello.pinn`:

> func main ( ) {
> 	print ("Hello, world.");
> }

Then run the ANTLR code and run `go run -f hello.pinn`. You should see:

> Hello, world.

Running ANTLR
-------------

* `java -jar <path_to_antlr_jar> -Dlanguage=Go -o pparser Pinn.g4`

## Notation
```
|  alternation
()  grouping
[]  option (0 or 1 times)
{}  repetition (0 to n times)
literal  type as specified
<production>  rule specified elsewhere
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
