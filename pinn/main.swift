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

struct Kind: Equatable {
//
    static func == (k1: Self, k2: Self) -> Bool {
        return k1.vtype == k2.vtype && k1.gtype == k2.gtype && k1.count == k2.count
    }
    var vtype: Any.Type
    var gtype: Gtype
    var count: Int?
//    func new() -> Pval {
//        let rt: Pval
//        switch gtype {
//        case .gMap:
//            if vtype == Int.self {
//                rt = Pmap<Int>()
//            } else if vtype == Bool.self {
//                rt = Pmap<Bool>()
//            } else {
//                fatalError()
//            }
//        case .gScalar:
//            if vtype == Int.self {
//                rt = Pscalar<Int>()
//            } else if vtype == Bool.self {
//                rt = Pscalar<Bool>()
//            } else {
//                fatalError()
//            }
//        case .gArray:
//            if vtype == Int.self {
//                rt = Parray<Int>(count!)
//            } else if vtype == Bool.self {
//                rt = Parray<Bool>(count!)
//            } else {
//                fatalError()
//            }
//        }
//        return rt
//    }
//
    func kindEquivalent(_ k2: Kind) -> Bool {
        switch gtype {
        case .gArray, .gScalar:
            return self == k2
        case .gMap, .gSlice:
            return gtype == k2.gtype && vtype == k2.vtype
        }
    }
//    }
}


//
//func zeroValue<>() throws -> T {
//    if T.self == Int.self {
//        return 0 as! T
//    }
//    if T.self == Bool.self {
//        return false as! T
//    }
//    throw ErrCase()
//}


//
//    class Pmap <V: Equatable>: Pval {
//
//                var string: String { return String(describing: map) }
//        var map = [String: V]()
//
//        func equal(_ p:Pval) -> Bool {
//            guard let p2 = p as? Self else {
//                return false
//            }
//            return p2.map == map
//        }
//        func getv(_ v:Any) -> Any {
//
//        }
//            func get(_ k: String) -> V {
//                return map[k]!
//            }
//            func set(_ k: String, v: V) {
//                map[k] = v
//            }
//        func getScalar(_ k: String) -> Pscalar<V> {
//            return Pscalar(get(k))
//        }
//
//
//
//            func getKind() -> Kind {
//                return Kind(vtype: V.self, gtype: .gMap, count: map.count)
//            }
//
//            init() {
//            }
//
//            func clone() -> Pval {
//                let pa = Pmap<V>()
//                pa.map = map
//                let rt: Pval = pa
//                return rt
//        }
//
//        }
//
//
//
//    class Parray <V: Equatable>: Pval {
//
//                var string: String { return String(describing: ar) }
//            var ar: [V]
//
//        func equal(_ p:Pval) -> Bool {
//            guard let p2 = p as? Self else {
//                return false
//            }
//            return ar == p2.ar
//        }
//
//
//            func get(_ k: Int) -> V {
//                return ar[k]
//            }
//        func getScalar(_ k: Int) -> Pscalar<V> {
//            return Pscalar(get(k))
//        }
//        func getMe(_ x: V) -> Self {
//            return self
//        }
//            func set(_ k: Int, v: V) {
//                ar[k] = v
//            }
//
//            func getKind() -> Kind {
//                return Kind(vtype: V.self, gtype: .gArray, count: ar.count)
//            }
//
//            init(_ x: Int) {
//                ar = [V](repeating: try! zeroValue(), count: x)
//            }
//            func clone() -> Pval {
//                let pa = Parray<V>(getKind().count!)
//                pa.ar = ar
//                let rt: Pval = pa
//                return rt
//        }
//
//        }
//
func de(_ me: MyError) -> Never {
    fatalError(me.str)
}

func newElement(_ vtype: Any.Type)  -> Any {
    var rt: Any
    switch vtype {
    case is Int.Type:
        rt = Int(0)
    case is Bool.Type:
        rt = Bool(false)
    default:
        de(ErrParamLength)
    }
    return rt
}
func zeroValue(_ v:Any.Type) -> Any {
    if v == Int.self {
        return 0
    } else if v == Bool.self {
        return false
    } else if v == String.self {
        return ""
    } else {
        fatalError()
    }
}

//
//func equalValue<T: Equatable>(_ v1: T, _ v2: T) -> Bool {
//    return v1 == v2
//}

func equalValue(_ v1: Any, _ v2: Any) -> Bool {
    guard type(of: v1) == type(of: v2) else {
        return false
    }
    switch v1 {
    case let v1v as Int:
        return v1v == v2 as! Int
    case let v1v as Bool:
        return v1v == v2 as! Bool
    case let v1v as String:
        return v1v == v2 as! String
    default:
        de(ErrCase)
    }
}

func plusValue(_ v1: Any, _ v2: Any) -> Any {
    switch v1 {
    case let v1v as Int:
        return v1v + (v2 as! Int)
    case let v1v as String:
        return v1v + (v2 as! String)
    default:
        de(ErrCase)
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

let myinput = fnToString("/tmp/a.pinn")
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
} else {
    if tokens {
        let stream = parser.getTokenStream() as! CommonTokenStream
        print(stream.getTokens())
    }
    let pv = Pvisitor()
    pv.start(tree!)
}
let TEST = false
if (TEST) {
    print("")
    print("----")
let fString = fnToString(TMP)
let fsplit = fString.split(separator: "\n")
    if fsplit.count == 0 {
        de(ErrTestFail)
    }
    for str in fsplit {
            print(str)
    let hashed = str.split(separator: ":")[1]

    let compare = hashed.split(separator: "#", maxSplits: 2, omittingEmptySubsequences: false)
    if compare[0] != compare[1] {
        de(ErrTestFail)
    }
}
}
//main()
