//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
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

let pv = Pvisitor()

func execute(_ s: String) {
    let myinput = fnToString("/tmp/\(s)")
    if let tree = parse(myinput) {
        pv.visitFile(tree)
    } else {
        err(myinput)
        de(ETEST_FAIL)
    }
}
print("wot")
execute("tic.pinn")
