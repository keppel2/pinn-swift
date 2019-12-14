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
func f() {};
g();
"""),
("Wrong type assignment from short declaration", """
x := 0;
x = true;
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





]
