import Foundation
import Antlr4
//var gtree: PinnParser.FileContext? = nil

func exe(_ s: String, _ failReason: String? = nil) throws {
    let (tree, parser) = parse(s)
    gparser = parser
    if tree != nil {
        //        gtree = tree
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




func execute() throws  {
    let args = ProcessInfo.processInfo.arguments
    let s = args[1]
    test = s == "-t"
    
    let myinput = fnToString(test ? "/tmp/types.pinn" : s)
    try exe(myinput)
    if (test) {
        print()
        for ts in negTest {
            try exe(ts.1, ts.0)
        }
        
        
        
        
        
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
enum Gtype {
    case gScalar, gArray, gMap, gSlice, gTuple, gPointer
}

class Wrap <T> {
    var w: T
    init(_ x: T) {
        w = x
    }
}
struct Nil: Ptype, CustomStringConvertible {
    var description: String { return "N"}
    
    static func zeroValue() -> Ptype { Nil() }
    func equal(_ a: Ptype) -> Bool {
        return a is Nil
    }
}
