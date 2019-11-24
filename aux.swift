//
//  aux.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

let EPARAM_LENGTH = "Parameter length mismatch"
let ESTATEMENT = "Wrong statement"
let ETYPE      = "Wrong type"
let ERANGE          = "Out of range"
let ECASE           = "Case unimplemented"
let EREDECLARE = "Redeclared"
let EUNDECLARED = "Undeclared"
let ETEST_FAIL = "Test failed"



public func writeString(_ s: String, _ f: String) {
    let fh = FileHandle(forWritingAtPath: f)!
    fh.write(Data(s.utf8))
}
func fnToString(_ s: String) -> String {
    let fh = FileHandle(forReadingAtPath: s)!
    let data = fh.readDataToEndOfFile()
    return String(data: data, encoding: String.Encoding.utf8)!
}

enum Gtype {
    case gScalar, gArray, gMap, gSlice
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
    //   print(stream.getTokens())
    let parser =  try! PinnParser(stream)
    return parser
}
