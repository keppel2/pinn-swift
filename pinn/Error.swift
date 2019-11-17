//
//  Error.swift
//  pinn
//
//  Created by Ryan Keppel on 11/16/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

class Error {
    let str: String
    var pval: Pval?
    var prc: ParserRuleContext?
    init (_ s: String, _ p: Pval? = nil, _ p2: ParserRuleContext? = nil) {
        str = s
        pval = p
        prc = p2 ?? pv.prc
    }
    convenience init(_ s: String, _ p: ParserRuleContext) {
        self.init(s, nil, p)
    }
    
    var string: String {
        var rt = ""
        rt += "Error: \(str)."
        if let pv = pval {
            rt += "Regarding pval at line: " + pv.prc.getStart()!.getLine() + "."
        }
        if let pc = prc {
            rt += "PRC. Line \(pc.getStart()!.getLine()) Col \(pc.getStart()!.getCharPositionInLine())"
        }
        return rt
    }
}
