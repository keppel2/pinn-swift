//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

var myinput = """
func main() {
print(5);
}
"""

var aInput = ANTLRInputStream(myinput)
var lexer = PinnLexer(aInput)
var stream = CommonTokenStream(lexer)
var parser = try? PinnParser(stream)

var tree = try? parser!.file()

print("Hello, World!")
class PVal {
    
}

func visitFile(actx: PinnParser.FileContext) {
    for child in actx.function() {
        print(child.getText())
    }
}
visitFile(actx:tree!)
