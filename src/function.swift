import Foundation
import Antlr4

func exe(_ s: String, _ api: Pvisitor? = nil) throws -> Pvisitor {
    let (tree, parser) = parse(s)
    let pv = try Pvisitor(parser)
   // pvik = pv
    if let apip = api {
        pv.apifkmap = apip.fkmap
    }
    
    if tree != nil {
//        pvisitor = pv
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

var ds = DispatchSemaphore(value: 0)

class MyT: Thread {
    var str = ""
    override func main() {
        let inp1 = fnToString(prefix + str + postfix)
//        while true {
        
//  try! exe(inp1)
//        do {
//            try exe(inp1)
//        } catch let err{
//            print("here", err)
//        }
    do {
    try exe(inp1)
} catch let err where err is Perr {
    print((err as! Perr).string)
    } catch let err2 {
        print(err2)
        }
        
        
        
//        }
        print(str)
        ds.signal()
    }
}
func execute() throws  {
    let args = ProcessInfo.processInfo.arguments
    let s = args[1]
    let test = s == "-t"
    let fnames = ["a", "xeek"]
//    try! exe(fnToString(prefix + "tic" + postfix))
//    return
//    var mar = [MyT]()
//    for name in fnames {
//        let mt = MyT()
//        mt.str = name
//        mar.append(mt)
//    }
//    for t in mar {
//        t.start()
//    }
//    for _ in fnames {
//        ds.wait()
//    }
//    return
//    sleep(2)
//return
//    let inp1 = fnToString(prefix + "tic" + postfix)
//    try exe(inp1)
//    let inp2 = fnToString(prefix + "xeek" + postfix)
//    try exe(inp2)
//    return
//    
//    
    let plib = try exe(fnToString(prefix + "libp" + postfix))
    plib.removeReserved()
    if test {
        let fnames = ["texpr", "ttypes", "tcontrol", "tneg", "tnegcontrol"]
        for n in fnames {
            print()
            print("Now ", n)
            try exe(fnToString(prefix + n + postfix), plib)
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
