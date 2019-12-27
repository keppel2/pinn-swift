//
//  Neg.swift
//  pinn
//
//  Created by Ryan Keppel on 12/11/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

let negTest = [
    ("Redeclare function", """
    func f() {};
    func f() int {return 42;}
    """),
("Call undeclared function", """
func f() {}
g();
"""),
("Send parameter to function without any", """
func f() {}
x := f(5);
"""),
("Send no parameter to function with one", """
func f(i int) {}
x := f();
"""),
("Send bad parameter to function with one", """
func f(i int) {}
x := f("abc");
"""),
("Use void return", """
func f() {}
x := f();
"""),
("Return int when no return parameter specified", """
func f() { return 5; }
f();
"""),
("Return int in global context", """
return 42;
"""),
("Return string in global context", """
return "aap";
"""),
("Mix up parameters to function", """
func f(i int, s string) {}
x := f("abc", 10);
"""),
("Wrong type assignment from short declaration", """
x := 0;
x = true;
"""),
("Wrong type assignment from short declaration", """
x := [1, 5];
y := ["aap", "noot"];
y = x;
"""),
("Wrong type assignment from short declaration", """
x := [1, 5];
var y [2]int;
y = x;
"""),
("Wrong short declaration", """
sdns := [[2, 1], 24];
"""),
("Wrong short declaration", """
sd := nil;
"""),
("Wrong short declaration", """
func f() {}
sd := f();
"""),
("Wrong short declaration", """
sdns := (5, (true, "foo"), [true, "foo"]);
"""),
("Wrong short declaration", """
sdns := [[2, 1], [true, true, true]];
"""),
("Wrong short declaration", """
sdns := {"aap": 5, "noot": false};
"""),
("Wrong short declaration", """
func f() {}
sdns := [4, f()];
"""),
("Wrong array declaration", """
var ar [true]int;
"""),
("Wrong array declaration", """
func f() {}
var ar [f()]int;
"""),
("Wrong type assignment defined types", """
var x [1]int;
var y [2]int;
y = x;
"""),
("Wrong type assignment defined types", """
var x [2]int;
var y [2]string;
y = x;
"""),
("Wrong type assignment defined types (scalar = array)", """
var x [slice]bool;
var y [2]bool;
x = y;
"""),
("Wrong type assignment (array = slice, both size 2)", """
var x [2]int;
y := [42, 101];
x = y;
"""),
("Wrong type assignment (slice = array, both size 2)", """
var x [2]int;
y := [42, 101];
y = x;
"""),
("Wrong type assignment defined types (array = slice, both size 2)", """
var x [2]int;
var y [slice]int;
y[0] = 10;
y[1] = 20;
x = y;
"""),

("Wrong type assignment defined types (tuple = array)", """
var x (int, int);
var y [2]int;
y = x;
"""),
("Wrong type assignment defined types (map = tuple)", """
var x [map]int;
var y (int, int);
x = y;
"""),
("Wrong type assignment defined types (scalar = array)", """
var x int;
var y [2]int;
x = y;
"""),
("Wrong type assignment defined types (array = scalar)", """
var x int;
var y [2]int;
y = x;
"""),
("Wrong types, declared", """
var cdn [slice][slice]int;
var cdns [slice]int;
cdns[0] = "aap";
cdns[1] = "noot";
cdn[0] = cdns;
"""),
("Wrong types, declared", """
var cdn [slice][slice]int;
var cdns [slice]int;
cdns[0] = 42;
cdns[1] = "noot";
"""),
("Wrong types, declared", """
var cdn [slice][2]int;
var cdns [slice]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[0] = cdns;
"""),
("Wrong types, declared", """
var cdn [2][slice]int;
var cdns [slice]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[2] = cdns;
"""),
("Wrong types, declared", """
var cdn [slice][2]int;
var cdns [3]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[0] = cnds;
"""),
("Wrong types, declared", """
var cdn [3][slice]int;
var cdns [2]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[0] = cnds;
"""),
("Wrong types, declared", """
var cdn [3][slice]int;
var cdns [slice]bool;
cdns[0] = true;
cdn[0] = cnds;
"""),
("Wrong type get from short declaration", """
x := 0;
y := true;
y = x;
"""),
("Wrong type assignment from declaration", """
var x bool;
x = "bad";
"""),
("Redeclare both short", """
x := 5;
x := 10;
"""),
("Redeclare both short, different type", """
x := 5;
x := true;
"""),
("Assign in global context a local variable", """
func f() {
  x := 5;
}
f();
x = 10;
"""),
("Attempt to append to array", """
var ar [3]int;
ar[3] = 42;
"""),
("Attempt to append to one more than length of slice", """
s := [1, 4];
s[3] = 42;
"""),
("Index map by integer", """
var m[map]int;
m[23] = 42;
"""),
("Index slice by string", """
s := [1, 4];
s["a"];
"""),

("Delete a non-map", """
var x int;
delete(x, "k");
"""),
("Object literal with different types", """
obj := {"a": 5, "b": true};
"""),
("Array set element with wrong type", """
var arStr [3]string;
arStr[0] = "alpha";
arStr[1] = "bravo";
arStr[2] = 42;
print(arStr);
"""),
("Slice literal with different types", """
s := [4, 1, true];
"""),
("Slice literal with an int and a tuple of 2 ints", """
s := [5, (1, 3)];
"""),
("Test statement in function", """
func f() {
  ft("Test", "");
}
f();
"""),
("Binary op", """
4 + true;
"""),
("Binary op", """
"aap" + false;
"""),
("Binary op", """
true + false;
"""),
//("Binary op", """
//true && 1;
//"""),
("Binary op", """
func f() {}
3 + f();
"""),
("Binary op", """
func f() {}
3 + nil;
"""),
("Binary op", """
func f() {}
+nil;
"""),
("Binary op", """
3 + [1, 5];
"""),
("Binary op", """
4 > true;
"""),
("Ternary op", """
10 ? 5 : false;
"""),
("Ternary op", """
nil ? true : false;
"""),
("Unary op", """
-true;
"""),
("Unary op", """
!5;
"""),
("Parenthesize call", """
func f() {}
(f());
"""),
("Empty call for if", """
func f() {}
if (f()) {}
"""),
("Nil for if", """
func f() {}
if (nil) {}
"""),
("Zero for if", """
if (0) {}
"""),
("Zero for if", """
if (0) ; else ;
"""),
("Zero for while", """
while 0 {}
"""),
("Bad return in loop", """
func f() int {
loop {
  return false;
}
}
f();
"""),
("No exit from guard", """
guard false else {
}
"""),
("Range", """
for x = range 1@10 {}
"""),
("Range", """
var x int;
for x = range true {}
"""),
("Range", """
var x int;
for x = range ["aap", "noot"] {}
"""),
("Range", """
var x [2]int;
for x = range [5, 10] {}
"""),
("Range", """
var x int;
for x = range (5, 10) {}
"""),
("Range", """
var x string;
var y int;
for x, y = range [5, 10] {}
"""),
("Range", """
var x int;
var y int;
for x, y = range {"aap": 5, "noot": 23} {}
"""),
("Range", """
var x int;
var y int;
for x, y = range 23 {}
"""),
("Range", """
var x string;
var y int;
for x, y = range ["aap", "noot"] {}
"""),
("For triple", """
for var x int; i < 5; i += "aap" {}
"""),
("For triple", """
for var x int; 2; i += 10 {}
"""),
("For triple", """
for var x string; i < 2; i += "aap" {}
"""),
("For triple", """
for var i [2]int; i[1] < 2; i++ {}
"""),

("Slice operator fail", """
[5, 42, 101][0@3];
"""),
("Slice operator fail", """
(2, true, false)[0@1];
"""),
("Slice operator fail", """
[[1, 2], [10, 11], [101, 102]][1@2][0][0@2];
"""),
("Index operator fail", """
[4, 5][-1];
"""),
("Index operator fail", """
(4, false)[-1];
"""),
("Index operator fail", """
5[0];
"""),
("Exit with a value", """
exit(5);
"""),
("Exit with two values", """
exit(true, true);
"""),
("Pointer", """
s := (10, nil);
s = (false, nil);
"""),
("Pointer", """
s := (10, nil);
s[1] = (42, 1);
"""),
//("Pointer", """
//s := (4, nil);
//s[1] = (true, nil);
//"""),

    ("Deeply nested bad assignment", """
    var dnt [2](bool, int, [map](int, string));
     print(dnt);
     dnt[1][2]["aap"] = (42, true);
     print(dnt);
    """),

    
    
    
("Binary search tree error", """
    var i int;
    bst := (nil, 7, nil);
    cur := bst;
    for i = range [1, 5, 10, 2, 3] {
        cur = bst;
        loop {
            if i < cur[1] {
                if cur[0] == nil {
                    cur[0] = (nil, i, nil, 4);
                    break;
                } else {
                    cur = cur[0];
                    continue;
                }
            } else if i > cur[1] {
                if cur[2] == nil {
                    cur[2] = (nil, i, nil);
                    break;
                } else {
                    cur = cur[2];
                    continue;
                }
            } else {
                break;
            }
        }
    }
"""),
    
    

]
