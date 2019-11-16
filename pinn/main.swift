//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4
let TEST = true
let TOKENS = false
let inFile = TEST ? "types.pinn" : "a.pinn"
//let myinput = fnToString("/Users/ryankeppel/Documents/pinn/pinn/a.pinn")

let myinput = fnToString("/tmp/\(inFile)")
let TMP = "/tmp/pinn.out"
FileManager.default.createFile(atPath: TMP, contents: nil)
let fh = FileHandle(forWritingAtPath: TMP)!



let parser = stringToParser(myinput)
parser.setErrorHandler(BailErrorStrategy())
var tree =  try? parser.file()
let pv: Pvisitor
if tree == nil {
    let parser2 = stringToParser(myinput)
    try! parser2.file()
    de(ErrTestFail)
} else {
    if TOKENS {
        let stream = parser.getTokenStream() as! CommonTokenStream
        print(stream.getTokens())
    }
    pv = Pvisitor()
    pv.start(tree!)
}

if (TEST) {
    print();
    print("----");
    let fString = fnToString(TMP)
    let fsplit = fString.split(separator: "\n", omittingEmptySubsequences: false)
    if fsplit.count == 0 {
        de(ErrTestFail)
    }
    for str in fsplit {
        print(str)
        let hashed = str.split(separator: "!")[1]
        
        let compare = hashed.split(separator: "#", maxSplits: 2, omittingEmptySubsequences: false)
        if compare[0] != compare[1] {
            de(ErrTestFail)
        }
    }
}
//main()

