//
//  aux.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4



func parse(_ s: String) -> PinnParser.FileContext? {
    let parser = stringToParser(s)
    parser.setErrorHandler(BailErrorStrategy())
    let tree = try? parser.file()
    return tree
}

func err(_ s: String) {
    let parser = stringToParser(s)
    try! parser.file()
}

func execute(_ s: String) {
    let myinput = fnToString("/tmp/\(s)")
    if let tree = parse(myinput) {
        pv.visitFile(tree)
    } else {
        err(myinput)
        de(EPARSE_FAIL)
    }
}

public func writeString(_ s: String, _ f: String) {
    let fh = FileHandle(forWritingAtPath: f)!
    fh.write(Data(s.utf8))
}
func fnToString(_ s: String) -> String {
    let fh = FileHandle(forReadingAtPath: s)!
    let data = fh.readDataToEndOfFile()
    return String(data: data, encoding: String.Encoding.utf8)!
}


private func _fatalError(_ s: String) -> Never {
    print(s)
    exit(1)
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
