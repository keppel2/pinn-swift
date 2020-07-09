import Foundation
import Antlr4

func exe(_ s: String, _ api: Pvisitor? = nil) throws -> Pvisitor {
    let (tree, parser) = parse(s)
//    gparser = parser
    let pv = try Pvisitor(parser)
    if let apip = api {
        pv.apifkmap = apip.fkmap
//        pv.fkmap = apip.fkmap
    }
//    pv.reset()
    
    if tree != nil {
        //        gtree = tree
        pvisitor = pv
        
        
            try pv.visitFile(tree!, api)
    } else {
        let parser = stringToParser(s)
        try parser.file()
        throw Perr(EPARSE_FAIL)
    }
    return pv
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
    let prefix = "/tmp/"
    let postfix = ".pinn"
    let plib = try exe(fnToString(prefix + "libp" + postfix))
    plib.removeReserved()
    if test {
        let fnames = ["types.pinn", "tcontrol.pinn", "tneg.pinn"]
        for n in fnames {
            print()
            print("Now ", n)
            try exe(fnToString(prefix + n), plib)
        }
        return
    }
    var fname = s == "-c" ? FNAME : s
    
    let myinput = fnToString(prefix + fname + postfix)
    try exe(myinput, plib)

    
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
