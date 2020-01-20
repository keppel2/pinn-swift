let negTest = [
    ("Call undeclared function:" + String(#line), """
    func f() {}
    g();
    """),
    ("Redeclare function:" + String(#line), """
    func f() {};
    func f() int {return 42;}
    """),
("Send parameter to function without any:" + String(#line), """
func f() {}
x := f(5);
"""),
("Send no parameter to function with one:" + String(#line), """
func f(i int) {}
x := f();
"""),
("Send bad parameter to function with one:" + String(#line), """
func f(i int) {}
x := f("abc");
"""),
("Use void return:" + String(#line), """
func f() {}
x := f();
"""),
("Return int when no return parameter specified:" + String(#line), """
func f() { return 5; }
f();
"""),
("Return int in global context:" + String(#line), """
return 42;
"""),
("Return string in global context:" + String(#line), """
return "aap";
"""),
("Mix up parameters to function:" + String(#line), """
func f(i int, s string) {}
x := f("abc", 10);
"""),
("Wrong type assignment from short declaration:" + String(#line), """
x := 0;
x = true;
"""),
("Wrong type assignment from short declaration:" + String(#line), """
x := [1, 5];
y := ["aap", "noot"];
y = x;
"""),
("Wrong type assignment from short declaration:" + String(#line), """
x := ...[1, 5];
var y [2]int;
y = x;
"""),
("Wrong short declaration:" + String(#line), """
sdns := [[2, 1], 24];
"""),
("Wrong short declaration:" + String(#line), """
sd := nil;
"""),
("Wrong short declaration:" + String(#line), """
func f() {}
sd := f();
"""),
("Wrong short declaration:" + String(#line), """
sdns := (5, (true, "foo"), [true, "foo"]);
"""),
("Wrong short declaration:" + String(#line), """
sdns := [[2, 1], [true, true, true]];
"""),
("Wrong short declaration:" + String(#line), """
sdns := {"aap": 5, "noot": false};
"""),
("Wrong short declaration:" + String(#line), """
func f() {}
sdns := [4, f()];
"""),
/*
("Wrong self declaration" + String(#line), """
var n self;
//"""),

("Wrong self declaration:" + String(#line), """
var n [3]self;
"""),
("Wrong self declaration:" + String(#line), """
var n [slice]self;
"""),
("Wrong self declaration:" + String(#line), """
var n [map]self;
"""),
("Wrong self declaration:" + String(#line), """
var n (int, self);
"""),
*/
("Wrong array declaration:" + String(#line), """
var ar [true]int;
"""),
("Wrong array declaration:" + String(#line), """
func f() {}
var ar [f()]int;
"""),
("Wrong type assignment defined types:" + String(#line), """
var x [1]int;
var y [2]int;
y = x;
"""),
("Wrong type assignment defined types:" + String(#line), """
var x [2]int;
var y [2]string;
y = x;
"""),
("Wrong type assignment defined types (scalar = array):" + String(#line), """
var x [slice]bool;
var y [2]bool;
x = y;
"""),
("Wrong type assignment (array = slice, both size 2):" + String(#line), """
var x [2]int;
y := ...[42, 101];
x = y;
"""),
("Wrong type assignment defined types (array = slice, both size 2):" + String(#line), """
var x [2]int;
var y [slice]int;
y[0] = 10;
y[1] = 20;
x = y;
"""),

("Wrong type assignment defined types (tuple = array):" + String(#line), """
var x (int, int);
var y [2]int;
y = x;
"""),
("Wrong type assignment defined types (map = tuple):" + String(#line), """
var x [map]int;
var y (int, int);
x = y;
"""),
("Wrong type assignment defined types (scalar = array):" + String(#line), """
var x int;
var y [2]int;
x = y;
"""),
("Wrong type assignment defined types (array = scalar):" + String(#line), """
var x int;
var y [2]int;
y = x;
"""),
("Wrong type assignment defined types pointers:" + String(#line), """
var point1 *(int, self);
var point2 *(bool, self);
point1 = point2;
"""),
("Wrong types, declared:" + String(#line), """
var cdn [slice][slice]int;
var cdns [slice]int;
cdns[0] = "aap";
cdns[1] = "noot";
cdn[0] = cdns;
"""),
("Wrong types, declared:" + String(#line), """
var cdn [slice][slice]int;
var cdns [slice]int;
cdns[0] = 42;
cdns[1] = "noot";
"""),
("Wrong types, declared:" + String(#line), """
var cdn [slice][2]int;
var cdns [slice]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[0] = cdns;
"""),
("Wrong types, declared:" + String(#line), """
var cdn [2][slice]int;
var cdns [slice]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[2] = cdns;
"""),
("Wrong types, declared:" + String(#line), """
var cdn [slice][2]int;
var cdns [3]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[0] = cnds;
"""),
("Wrong types, declared:" + String(#line), """
var cdn [3][slice]int;
var cdns [2]int;
cdns[0] = 42;
cdns[1] = 101;
cdn[0] = cnds;
"""),
("Wrong types, declared:" + String(#line), """
var cdn [3][slice]int;
var cdns [slice]bool;
cdns[0] = true;
cdn[0] = cnds;
"""),
("Wrong type get from short declaration:" + String(#line), """
x := 0;
y := true;
y = x;
"""),
("Wrong type assignment from declaration:" + String(#line), """
var x bool;
x = "bad";
"""),
("Wrong type assignment from declaration:" + String(#line), """
var x int;
x = nil;
"""),
("Redeclare both short:" + String(#line), """
x := 5;
x := 10;
"""),
("Redeclare both short, different type:" + String(#line), """
x := 5;
x := true;
"""),
("Assign in global context a local variable:" + String(#line), """
func f() {
  x := 5;
}
f();
x = 10;
"""),
("Attempt to append to array:" + String(#line), """
var ar [3]int;
ar[3] = 42;
"""),
("Attempt to append to one more than length of slice:" + String(#line), """
s := [1, 4];
s[3] = 42;
"""),
("Index map by integer:" + String(#line), """
var m[map]int;
m[23] = 42;
"""),
("Index slice by string:" + String(#line), """
s := [1, 4];
s["a"];
"""),

("Delete a non-map:" + String(#line), """
var x int;
delete(x, "k");
"""),
("Object literal with different types:" + String(#line), """
obj := {"a": 5, "b": true};
"""),
("Array set element with wrong type:" + String(#line), """
var arStr [3]string;
arStr[0] = "alpha";
arStr[1] = "bravo";
arStr[2] = 42;
print(arStr);
"""),
("Slice literal with different types:" + String(#line), """
s := [4, 1, true];
"""),
("Slice literal with an int and a tuple of 2 ints:" + String(#line), """
s := [5, (1, 3)];
"""),
("Test statement in function:" + String(#line), """
func f() {
  ft("Test", "");
}
f();
"""),
("Binary op:" + String(#line), """
4 + true;
"""),
("Binary op:" + String(#line), """
"aap" + false;
"""),
("Binary op:" + String(#line), """
true + false;
"""),
//("Binary op:" + String(#line), """
//true && 1;
//"""),
("Binary op:" + String(#line), """
func f() {}
3 + f();
"""),
("Binary op:" + String(#line), """
func f() {}
3 + nil;
"""),
("Binary op:" + String(#line), """
func f() {}
+nil;
"""),
("Binary op:" + String(#line), """
3 + [1, 5];
"""),
("Equal with mismatched types:" + String(#line), """
3 == true;
"""),
("Equal with mismatched types:" + String(#line), """
3 == nil;
"""),
("Binary op:" + String(#line), """
4 > true;
"""),
("Ternary op:" + String(#line), """
10 ? 5 : false;
"""),
("Ternary op:" + String(#line), """
nil ? true : false;
"""),
("Unary op:" + String(#line), """
-true;
"""),
("Unary op:" + String(#line), """
!5;
"""),
("Parenthesize call:" + String(#line), """
func f() {}
(f());
"""),
("Empty call for if:" + String(#line), """
func f() {}
if (f()) {}
"""),
("Nil for if:" + String(#line), """
func f() {}
if (nil) {}
"""),
("Zero for if:" + String(#line), """
if (0) {}
"""),
("Zero for if:" + String(#line), """
if (0) ; else ;
"""),
("Zero for while:" + String(#line), """
while 0 {}
"""),
("Bad return in loop:" + String(#line), """
func f() int {
loop {
  return false;
}
}
f();
"""),
("No exit from guard:" + String(#line), """
guard false else {
}
"""),
("Range:" + String(#line), """
for x = range 1@10 {}
"""),
("Range:" + String(#line), """
var x int;
for x = range true {}
"""),
("Range:" + String(#line), """
var x int;
for x = range ["aap", "noot"] {}
"""),
("Range:" + String(#line), """
var x [2]int;
for x = range [5, 10] {}
"""),
("Range:" + String(#line), """
var x int;
for x = range (5, 10) {}
"""),
("Range:" + String(#line), """
var x string;
var y int;
for x, y = range [5, 10] {}
"""),
("Range:" + String(#line), """
var x int;
var y int;
for x, y = range {"aap": 5, "noot": 23} {}
"""),
("Range:" + String(#line), """
var x int;
var y int;
for x, y = range 23 {}
"""),
("Range:" + String(#line), """
var x string;
var y int;
for x, y = range ["aap", "noot"] {}
"""),
("For triple:" + String(#line), """
for var x int; i < 5; i += "aap" {}
"""),
("For triple:" + String(#line), """
for var x int; 2; i += 10 {}
"""),
("For triple:" + String(#line), """
for var x string; i < 2; i += "aap" {}
"""),
("For triple:" + String(#line), """
for var i [2]int; i[1] < 2; i++ {}
"""),

("Slice operator fail:" + String(#line), """
[5, 42, 101][0@3];
"""),
("Slice operator fail:" + String(#line), """
(2, true, false)[0@1];
"""),
("Slice operator fail:" + String(#line), """
[[1, 2], [10, 11], [101, 102]][1@2][0][0@2];
"""),
("Index operator fail:" + String(#line), """
[4, 5][-1];
"""),
("Index operator fail:" + String(#line), """
(4, false)[-1];
"""),
("Index operator fail:" + String(#line), """
5[0];
"""),
("Exit with a value:" + String(#line), """
exit(5);
"""),
("Exit with two values:" + String(#line), """
exit(true, true);
"""),
("len:" + String(#line), """
len(4);
"""),
("len:" + String(#line), """
len(true);
"""),
("len:" + String(#line), """
len(nil);
"""),

("len:" + String(#line), """
len("abc", "def");
"""),
("stringValue:" + String(#line), """
stringValue();
"""),
("stringValue:" + String(#line), """
stringValue(5, ",");
"""),
("Print empty:" + String(#line), """
func f() {}
print(f());
"""),
("Delete:" + String(#line), """
m := {"key": 42};
delete(m);
"""),
("Delete:" + String(#line), """
m := {"key": 42};
delete(m, 2);
"""),
("Delete:" + String(#line), """
m := 42;
delete(m, "k");
"""),
("Delete:" + String(#line), """
m := [2, 24];
delete(m, "k");
"""),
("Delete:" + String(#line), """
m := {"key": 42};
x := delete(m, "k");
x = 101;
"""),
("key:" + String(#line), """
m := {"key": 42};
key(m);
"""),
("Pointer:" + String(#line), """
s := (10, nil);
s = (false, nil);
"""),
("Pointer:" + String(#line), """
s := *(4, nil);
s[1] = *(true, nil);
"""),

    ("Deeply nested bad assignment:" + String(#line), """
    var dnt [2](bool, int, [map](int, string));
     dnt[1][2]["aap"] = (42, true);
    """),

    
    
    
//("Binary search tree error:" + String(#line), """
//    var i int;
//    bst := (nil, 7, nil);
//    cur := bst;
//    for i = range [1, 5, 10, 2, 3] {
//        cur = bst;
//        loop {
//            if i < cur[1] {
//                if cur[0] == nil {
//                    cur[0] = (nil, i, nil, 4);
//                    break;
//                } else {
//                    cur = cur[0];
//                    continue;
//                }
//            } else if i > cur[1] {
//                if cur[2] == nil {
//                    cur[2] = (nil, i, nil);
//                    break;
//                } else {
//                    cur = cur[2];
//                    continue;
//                }
//            } else {
//                break;
//            }
//        }
//    }
//"""),
    
    

]
