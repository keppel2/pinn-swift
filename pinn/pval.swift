//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

class Pval {
    private let k: Kind
//    let g: Gtype
//    let v: Ptype.Type
    
    private var pva: [Pval]?
    
    private var ar: [Ptype]?
    private var map: [String: Ptype]?
    let prc: ParserRuleContext
//    let pv = Pvisitor
    var k2: Kind?
    func sort() {
        ar!.sort { ($0 as! Compare).lt($1 as! Compare) }
    }
    convenience init(_ a: Ptype) {
        self.init(Kind(type(of: a), .gScalar, 1), a)
    }
    
    convenience init(_ pv: Pval, _ a: Int, _ b: Int) {
        self.init(Kind(pv.kind.vtype, .gSlice, pv.ar!.count))
        self.ar = Array(pv.ar![a..<b])
//        self.init(pv.ar![a..<b])
    }
    init(_ k: Kind, _ i: Ptype? = nil) {
        prc = pv.prc!
        self.k = k
        switch k.gtype {
        case .gArray, .gSlice:
            ar = [Ptype](repeating: i ?? k.vtype.self.zeroValue(), count: k.count!)
        case .gMap:
            map = [String: Ptype]()
        case .gScalar:
            ar = [i ?? k.vtype.self.zeroValue()]
        }
    }
    func equal(_ p:Pval) -> Bool {
        if p.kind != kind {
            return false
        }
        switch kind.gtype {
        case .gScalar:
            return ar!.first!.equal(p.ar!.first!)
        case .gArray, .gSlice:
            for (key, value) in p.ar!.enumerated() {
                if !value.equal(p.ar![key]) {
                    return false
                }
            }
            return true
        case .gMap:
            
            for (key, value) in p.map! {
                if map![key] == nil {
                    return false
                }
                if !value.equal(map![key]!) {
                    return false
                }
            }
            return true
        }
    }


    func get() -> Ptype {
        return ar!.first!
    }
    func getKeys() -> [String] {
        return [String](map!.keys)
//        var rt = [String]()
//        for v in map!.keys {
//            rt.append(v)
//        }
//        return rt
    }
    func get(_ k: Ktype) -> Ptype {
        switch k {
        case let v1v as Int:
            return ar![v1v]
        case let v1v as String:
            if map![v1v] == nil {
                map![v1v] = kind.vtype.zeroValue()
            }
            return map![v1v]!
        default:
            de(ECASE)
        }
    }
    func set(_ v: Ptype) {
        guard type(of: ar!.first!) == type(of: v) else {
            de(ETYPE)
        }
        ar![0] = v
    }
    
    func set(_ k: Ktype, _ v: Ptype?) {
        
        guard v == nil || kind.vtype == type(of:v!) else {
            de(ETYPE)
        }
        switch k {
        case let v1v as Int:
            if kind.gtype == .gSlice && v1v == ar!.count {
                ar!.append(v!)
                kind.count = ar!.count
            } else {
                ar![v1v] = v!
            }
        case let v1v as String:
            map![v1v] = v
            kind.count = map!.count
        default:
            de(ECASE)
        }
    }
    
    
    
    var string: String {
        switch kind.gtype {
            
        case .gArray, .gSlice:
            var rt = ""
            rt += "["
            if let f = ar!.first {
                rt += String(describing: f)
                for v in ar![1...] {
                    rt += " " + String(describing: v)
                }
            }

            rt += "]"
            return rt
        case .gMap:
            var rt = ""
            rt += "{"
            for (key, value) in map! {
                if rt != "{" {
                    rt += " "
                }
                rt += key + ":" + String(describing: value)
            }
            rt += "}"
            return rt
        case .gScalar: return String(describing: ar!.first!)
        }
    }

    
    var kind: Kind { return k
    }
    
    func clone() -> Pval {
        let rt = Pval(kind)
        switch kind.gtype {
        case .gArray, .gSlice:
            rt.ar = ar!
        case .gScalar:
            rt.ar![0] = ar!.first!
        case .gMap:
            rt.map = map!
        }
        return rt
    }
}



