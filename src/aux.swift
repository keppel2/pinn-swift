//
//  aux.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

func exe(_ s: String, _ failReason: String? = nil) throws {
       let (tree, parser) = parse(s)
        _ = parser

    if tree != nil {
            let pv = Pvisitor()

        if let fr = failReason {
            if (try? pv.visitFile(tree!)) != nil {
                throw Perr(ETEST_FAIL + ", expected to fail: " + fr + "\n" + s)
            }
        } else {
            try pv.visitFile(tree!)
        }
    } else {
        let parser = stringToParser(s)
        try parser.file()
        throw Perr(EPARSE_FAIL)
    }
}
func parse(_ s: String) -> (PinnParser.FileContext?, PinnParser) {
    let parser = stringToParser(s)
    parser.setErrorHandler(BailErrorStrategy())
    let tree = try? parser.file()
    return (tree, parser)
}



var test = false
func execute() throws {
    let args = ProcessInfo.processInfo.arguments
    let s = args[1]
    test = s == "-t"

    let myinput = fnToString(test ? "/tmp/types.pinn" : s)
    try exe(myinput)
    if (test) {
        print()
        
        
        
        
        
        

        try exe(
        """
        a := 5;
        a = false;
        """
        , "Assign bool to int")
        try exe(
        """
        a := 5;
        a = "abc";
        """
        , "Assign string to int")


        
        
        
        
        
        
        
        
        
        
    }
}

public func writeString(_ s: String, _ f: String) {
    let fh = FileHandle(forWritingAtPath: f)!
    fh.write(Data(s.utf8))
}
public func fnToString(_ s: String) -> String {
    let fh = FileHandle(forReadingAtPath: s)!
    let data = fh.readDataToEndOfFile()
    return String(data: data, encoding: String.Encoding.utf8)!
}

func stringDequote(_ s: String) -> String {
    var str = s
    str.remove(at: s.startIndex)
    str.remove(at: str.index(before: str.endIndex))
    return str.replacingOccurrences(of: "\\\"", with: "\"")
}

private func _fatalError(_ s: String) -> Never {
    print(s)
    fatalError()
//    exit(1)
}
func tryCast<T> (_ pv: Pval) throws -> T {
    if !(pv.getUnwrap() is T) {
        throw Perr(ETYPE, pv)
    }
    return pv.getUnwrap() as! T
}



func ade(_ b: Bool) {
    if !b {
        de(EASSERT)
    }
}

func aden() -> Never{
    de(EASSERT)
}
func de(_ me: Perr) -> Never {
    _fatalError(me.string)
}

func de(_ s: String = "") -> Never {
    de(Perr(s))
}

func dbg() {
    _fatalError("dbg")
}
class Wrap <T> {
    var w: T
    init(_ x: T) {
        w = x
    }
}
func stringToParser(_ s: String) -> PinnParser {
    let aInput = ANTLRInputStream(s)
    let lexer = PinnLexer(aInput)
    let stream = CommonTokenStream(lexer)
    let parser =  try! PinnParser(stream)
    return parser
}
func pEq(_ a: Ptype, _ b: Ptype) -> Bool {
    return type(of:a) == type(of:b)
}

struct Nil: Ptype, CustomStringConvertible {
    var description: String { return "N"}

    static func zeroValue() -> Ptype { Nil() }
    func equal(_ a: Ptype) -> Bool {
        return a is Nil
    }
    
    
}

extension Decimal: Ptype, Plus, Compare, Arith, Negate {


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
        return x
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
        default: de(ECASE)
        }
        return x
    }

    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}
extension Int: Ptype, Ktype, Plus, Compare, Negate, Arith {
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
        return x
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
        default: de(ECASE)
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


