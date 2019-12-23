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
  print(x);
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



]
