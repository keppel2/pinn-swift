//
//  aux.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

class MyError {
    let str: String
    var pv: Pval?
    init (_ s: String) {
        str = s
    }
}

let ErrParamLength = ("Parameter length mismatch.")

let ErrWrongStatement = ("Wrong statement.")
let ErrWrongType      = ("Wrong type.")
let ErrRange          = ("Out of range.")
let ErrCase           = ("Case unimplemented.")
let ErrRedeclare      = ("Redeclared.")
let ErrUndeclare      = ("Undeclared.")
let ErrTestFail = ("Test failed.")

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


func de(_ me: MyError, _ s: String = "") -> Never {
    fatalError(me.str + s)
}

func de(_ s: String = "") -> Never {
    fatalError(s)
}

func dbg() {
    fatalError()
}



func stringToParser(_ s: String) -> PinnParser {
    let aInput = ANTLRInputStream(myinput)
    let lexer = PinnLexer(aInput)
    let stream = CommonTokenStream(lexer)
    //   print(stream.getTokens())
    let parser =  try! PinnParser(stream)
    return parser
}
