//
//  Error.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

class Perr {
    let str: String
    var pval: Pval?
    var prc: ParserRuleContext?
    var tok: Token?
    init (_ s: String, _ p: Pval? = nil, _ p2: ParserRuleContext? = nil, _ p3: Token? = nil) {
        str = s
        pval = p
        prc = p2 //?? pv.prc
        tok = p3
    }
    convenience init(_ s: String, _ p: ParserRuleContext?) {
        self.init(s, nil, p, nil)
    }
    convenience init(_ s: String, _ t: Token) {
        self.init(s, nil, nil, t)
    }
//    static treeString() {}
    var string: String {
        var rt = ""
        rt += "Error: \(str)."
        if let pv = pval {
            rt += "Pval. Line " + pv.e.prc!.getStart()!.getLine() + " Col " + pv.e.prc!.getStart()!.getCharPositionInLine() + "."
        }
        if let pc = prc {
            rt += "PRC. Text \(pc.getText()). Line \(pc.getStart()!.getLine()) Col \(pc.getStart()!.getCharPositionInLine())."
        }
        if let t = tok {
            rt += "TOKEN \(t.getText()!). Line \(t.getLine()) Col \(t.getCharPositionInLine())."
        }
        return rt
    }
}
