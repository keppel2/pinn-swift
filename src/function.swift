import Foundation
import Antlr4

func exe(_ s: String, _ failReason: String? = nil) throws {
    let (tree, parser) = parse(s)
    gparser = parser
    if tree != nil {
        //        gtree = tree
        let pv = try Pvisitor()
        
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
        print("Passed positive tests")
//        _ = Perr("Negative start")
//        for ts in negTest {
//            try exe(ts.1, ts.0)
//        }
    }
}

func writeString(_ s: String, _ f: String) {
    let fh = FileHandle(forWritingAtPath: f)!
    fh.write(Data(s.utf8))
}

func fnToString(_ s: String) -> String {
    let fh = FileHandle(forReadingAtPath: s)!
    let data = fh.readDataToEndOfFile()
    return String(data: data, encoding: String.Encoding.utf8)!
}

func stringDequote(_ s: String) -> String {
    var str = s
    str.remove(at: s.startIndex)
    str.remove(at: str.index(before: str.endIndex))
    str = str.replacingOccurrences(of: "\\\"", with: "\"")
    str = str.replacingOccurrences(of: "\\\\", with: "\\")
    return str
}

func tryCast<T> (_ pv: Pval) throws -> T {
    if case .gDefined (let s) = pv.getKind().gtype {
        
    }
    if case .gScalar = pv.getKind().gtype {
        if !(try pv.getUnwrap() is T) {
            throw Perr(ETYPE, pv)
        }
        return try pv.getUnwrap() as! T
    }

    
    throw Perr(ETYPE, pv)
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
    print(me.string)
    fatalError()
}

func de(_ s: String = "") -> Never {
    de(Perr(s))
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
