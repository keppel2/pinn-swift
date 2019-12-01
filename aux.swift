//
//  aux.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4


func parse(_ s: String) -> (PinnParser.FileContext?, PinnParser) {
    let parser = stringToParser(s)
    parser.setErrorHandler(BailErrorStrategy())
    let tree = try? parser.file()
    return (tree, parser)
}

public func err(_ s: String) {
    let parser = stringToParser(s)
    try! parser.file()
}

func execute(_ s: String) {
    var test = false
    let args = ProcessInfo.processInfo.arguments
    if args.count == 2 {
        test = true
    }
    

    let myinput = fnToString("/tmp/\(test ? "types" : s).pinn")
    let (tree, parser) = parse(myinput)
    _ = parser
    if tree != nil {
        let pv = Pvisitor()
        pv.visitFile(tree!)
        
        if (test) {
//            print();
//            print("----");
//          //  let fString = fnToString(TMP)
//            let fsplit = Pvisitor.printed.split(separator: "\n", omittingEmptySubsequences: false)
//            if fsplit.count == 0 {
//                de(ETEST_FAIL)
//            }
//            for str in fsplit {
//                print(str)
//                let hashed = str.split(separator: "!")[1]
//                
//                let compare = hashed.split(separator: "#", maxSplits: 2, omittingEmptySubsequences: false)
//                if compare[0] != compare[1] {
//                    de(ETEST_FAIL)
//                }
//            }
        }

        
    } else {
        err(myinput)
        de(EPARSE_FAIL)
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
    exit(1)
}
func tryCast<T> (_ pv: Pval) -> T {
    if !(pv.getUnwrap() is T) {
        de(Perr(ETYPE, pv))
    }
    return pv.getUnwrap() as! T
}
func ade(_ b: Bool) {
    if !b {
        de(EASSERT)
    }
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
