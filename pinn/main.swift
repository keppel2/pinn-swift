//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

_ = 124444;

struct MyError {
    let str: String
    init (_ s: String) {
        str = s
    }
}

let ErrParamLength = MyError("Parameter length mismatch.")

let ErrWrongStatement = MyError("Wrong statement.")
let ErrWrongType      = MyError("Wrong type.")
let ErrRange          = MyError("Out of range.")
let ErrCase           = MyError("Case unimplemented.")
let ErrRedeclare      = MyError("Redeclared.")
let ErrUndeclare      = MyError("Undeclared.")
let ErrTestFail = MyError("Test failed.")

func writeString(_ s: String, _ f: String) {
    let fh = FileHandle(forWritingAtPath: f)!
    fh.write(Data(s.utf8))
}
func fnToString(_ s: String) -> String {
    let fh = FileHandle(forReadingAtPath: s)!
    let data = fh.readDataToEndOfFile()
    return String(data: data, encoding: String.Encoding.utf8)!
}
func main() {
    print(FileManager.default.currentDirectoryPath)
    let fh = FileHandle(forReadingAtPath: "/Users/ryankeppel/fib.pinn")!
    let data = fh.readDataToEndOfFile()
    let str = String(data: data, encoding: String.Encoding.utf8)!
    print(str)
}
enum Gtype {
    case gScalar, gArray, gMap, gSlice
}


func de(_ me: MyError) -> Never {
    fatalError(me.str)
}

protocol Ptype {
    static func zeroValue() -> Ptype
    func equal(_: Ptype) -> Bool
}
protocol Ktype {}

protocol Plus: Ptype {
    func plus(_: Plus) -> Plus
}

protocol Negate: Ptype {
    func neg() -> Negate
}

protocol Arith: Ptype {
    func arith(_: Arith, _: String) -> Arith
}

protocol Compare: Ptype {
    func lt(_: Compare) -> Bool
    func gt(_: Compare) -> Bool
}

extension Decimal: Ptype, Plus, Compare, Arith {
   
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    
    static func zeroValue() -> Ptype { return Decimal.init() }
    
    func neg() -> Negate {
        let x = 0 - self
        return x as! Negate
    }
    
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! Self)
        return x
    }
    func arith(_ a: Arith, _ s: String) -> Arith {
        let lhv = self
        let rhv = a as! Self
        let x: Self
        switch s {
        case "-":
            x = lhv - rhv
        case "*":
            x = lhv * rhv
        case "/":
            x = lhv / rhv
        default: de(ErrCase)
        }
        return x
    }

    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}
extension Int: Ptype, Ktype, Plus, Compare, Arith {
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    
    static func zeroValue() -> Ptype { return 0 }
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! Self)
        return x
    }
    func neg() -> Negate {
        let x = 0 - self
        return x as! Negate
    }
    
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
    
    func arith(_ a: Arith, _ s: String) -> Arith {
        let lhv = self
        let rhv = a as! Self
        let x: Self
        switch s {
        case "-":
            x = lhv - rhv
        case "*":
            x = lhv * rhv
        case "/":
            x = lhv / rhv
        default: de(ErrCase)
        }
        return x
    }
    
}
extension Bool: Ptype, Ktype {
    static func zeroValue() -> Ptype { return false }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}
extension String: Ptype, Ktype, Plus, Compare {
    
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    static func zeroValue() -> Ptype { return "" }
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! String)
        return x
    }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}




func meta(_ m: Any.Type) -> Any {
    if m == Int.self {
        return 0
    }
    return false
}
//let m = meta(Int.self)
//
//let x = 0
//print(type(of:m))
//print(type(of:x))
//






class Klass<V: Equatable> {
    init(_ v: V) {}
    func mytype() {
        print(V.self)
    }
}



func dbg() {
    fatalError()
}


//let myinput = fnToString("/Users/ryankeppel/Documents/pinn/pinn/a.pinn")

let myinput = fnToString("/tmp/types.pinn")
//print(myinput)
let TMP = "/tmp/types.out"
FileManager.default.createFile(atPath: TMP, contents: nil)
let fh = FileHandle(forWritingAtPath: TMP)!
//writeString("first", "/tmp/a.out")
//writeString("second", "/tmp/a.out")

func stringToParser(_ s: String) -> PinnParser {
    let aInput = ANTLRInputStream(myinput)
    let lexer = PinnLexer(aInput)
    let stream = CommonTokenStream(lexer)
    //   print(stream.getTokens())
    let parser =  try! PinnParser(stream)
    return parser
}
let tokens = false

let parser = stringToParser(myinput)
parser.setErrorHandler(BailErrorStrategy())
var tree =  try? parser.file()
if tree == nil {
    let parser2 = stringToParser(myinput)
    try! parser2.file()
    de(ErrTestFail)
} else {
    if tokens {
        let stream = parser.getTokenStream() as! CommonTokenStream
        print(stream.getTokens())
    }
    let pv = Pvisitor()
    pv.start(tree!)
}
let TEST = true
if (TEST) {
    print();
    print("----");
    let fString = fnToString(TMP)
    let fsplit = fString.split(separator: "\n", omittingEmptySubsequences: false)
    if fsplit.count == 0 {
        de(ErrTestFail)
    }
    for str in fsplit {
        print(str)
        let hashed = str.split(separator: "!")[1]
        
        let compare = hashed.split(separator: "#", maxSplits: 2, omittingEmptySubsequences: false)
        if compare[0] != compare[1] {
            de(ErrTestFail)
        }
    }
}
//main()

