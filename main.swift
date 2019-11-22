//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
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


let global = "glob"
//print("sleep");
//sleep(2);
//print("wakey");
//

//readLine()

let TEST = true
let TOKENS = false
let inFile = TEST ? "types.pinn" : "tic.pinn"

let myinput = fnToString("/tmp/\(inFile)")
let TMP = "/tmp/pinn.out"
FileManager.default.createFile(atPath: TMP, contents: nil)
let fh = FileHandle(forWritingAtPath: TMP)!



let parser = stringToParser(myinput)
parser.setErrorHandler(BailErrorStrategy())
var tree =  try? parser.file()
let pv: Pvisitor?
if tree == nil {
    let parser2 = stringToParser(myinput)
    try! parser2.file()
    de(ETEST_FAIL)
} else {
    if TOKENS {
        let stream = parser.getTokenStream() as! CommonTokenStream
        print(stream.getTokens())
    }
    pv = Pvisitor()
    pv!.visitFile(tree!)
}


if (TEST) {
    print();
    print("----");
    let fString = fnToString(TMP)
    let fsplit = fString.split(separator: "\n", omittingEmptySubsequences: false)
    if fsplit.count == 0 {
        de(ETEST_FAIL)
    }
    for str in fsplit {
        print(str)
        let hashed = str.split(separator: "!")[1]
        
        let compare = hashed.split(separator: "#", maxSplits: 2, omittingEmptySubsequences: false)
        if compare[0] != compare[1] {
            de(ETEST_FAIL)
        }
    }
}
