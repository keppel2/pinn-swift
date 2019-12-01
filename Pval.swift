//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

fileprivate class Pwrap {
    private var wrapped: Ptype
    init(_ p: Ptype) {
        wrapped = p
    }
    func unwrap() -> Ptype {
        return wrapped
    }
    func clone() -> Pwrap {
        return Pwrap(wrapped)
    }
    func equal(_ a: Pwrap) -> Bool {
        return unwrap().equal(a.unwrap())
    }

    func string() -> String {
        return String(describing: wrapped)
    }
}

class Pval {


    private var k: Kind!
    private var se: Pwrap?
    private var ar: [Pval]?
    private var map: [String: Pval]?
    var prc: ParserRuleContext?
    
    private func append(_ pv: Pval) {
        ade(k.gtype == .gSlice)
        ar!.append(pv)
        kind.count = ar!.count
    }
    
    private func addKey(_ s: String, _ pv: Pval) {
        ade(k.gtype == .gMap)
        map![s] = pv
        kind.count = map!.count
    }

    convenience init(_ c: ParserRuleContext?, _ ar: [Pval], _ k: Kind) {
        self.init(c)
        self.k = k
        self.ar = ar
    }
        
    convenience init(_ c: ParserRuleContext?, _ ar: [Pval]) {
        self.init(c)
        let ka = ar.map { $0.kind }
        k = Kind(ka)
        self.ar = ar
    }

    convenience init(_ c: ParserRuleContext?, _ a: Ptype) {
        self.init(c, Pwrap(a))
    }
    convenience fileprivate init( _ c: ParserRuleContext?, _ w: Pwrap) {
        self.init(c)
        k = Kind(type(of: w.unwrap()))
        se = w
    }
    convenience init( _ c: ParserRuleContext?, _ pv: Pval, _ a: Int, _ b: Int) {
        self.init(c, Kind(Kind(pv.kind.k!.vtype!), .gSlice, b - a))
        self.ar = Array(pv.ar![a..<b])
    }
    init(_ c: ParserRuleContext?) {
        prc = c
    }
    convenience init( _ c: ParserRuleContext?, _ k: Kind) {
        self.init(c)
        self.k = k
        switch k.gtype {
        case .gArray, .gSlice:
            ar = [Pval]()
            for _ in 0..<k.count {
                ar!.append(Pval(c, k.k!))
            }
        case .gMap:
            map = [String: Pval]()
        case .gScalar:
            se = Pwrap(k.vtype!.self.zeroValue())
        case .gTuple:
            ar = [Pval]()
            for x in k.ka! {
                ar!.append(Pval(c, x))
            }
            break
        }
    }
    func equal(_ p: Pval) -> Bool {

        ade(p.kind.kindEquivalent(kind))

        switch kind.gtype {
        case .gScalar:
            return get().equal(p.get())
        case .gArray, .gSlice, .gTuple:
            return ar!.elementsEqual(p.ar!, by: {$0.equal($1)})
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

    func getUnwrap() -> Ptype {
        return get().unwrap()
    }
    private func get() -> Pwrap {
        ade(kind.gtype == .gScalar)
        return (se!)
    }
    func getKeys() -> [String] {
        return [String](map!.keys)

    }
    
    private func getNewChild() -> Pval {
        return Pval(prc, kind.k!)
    }
    func get(_ k: Ktype, _ lh: Bool = false) -> Pval {
        switch k {
        case let v1v as Int:
            if lh && kind.gtype == .gSlice && v1v == ar!.count {
                append(getNewChild())
            }
            return ar![v1v]
        case let v1v as String:
            if map![v1v] == nil {
                if lh {
                    addKey(v1v, getNewChild())
                } else {
                return getNewChild()
                }
            }
            return map![v1v]!
        default:
            de(ECASE)
        }
    }

    
    func setPV(_ v : Pval) {
        ade(kind.kindEquivalent(v.kind))
        self.k = v.kind
        self.se = v.se
        self.ar = v.ar
        self.map = v.map
        self.prc = v.prc
    }
    
    func set(_ k: Ktype, _ v: Pval?) {
        if v == nil{
            map![k as! String] = nil
            kind.count = map!.count
            return
        }
        ade(kind.gtype != .gScalar)
        
        if let vk = kind.k {
            ade(kind.gtype != .gTuple)
            ade(vk.kindEquivalent(v!.kind))
        } else {
            ade(kind.gtype == .gTuple)
            let kt = kind.ka![k as! Int]
            ade(kt.kindEquivalent(v!.kind))
        }
 
        switch k {
        case let v1v as Int:

            if kind.gtype == .gSlice && v1v == ar!.count {
                append(v!)
            } else {
                ar![v1v] = v!
            }
        case let v1v as String:
            addKey(v1v, v!)
        default:
            de(ECASE)
        }
    }
    
    
    
    func string() -> String {
        switch kind.gtype {
        case .gArray, .gSlice:
            var rt = ""
            rt += "["
            if ar!.count > 0 {
                rt += ar!.first!.string()
                for v in ar![1...] {
                    rt += " " + v.string()
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
                rt += key + ":" + value.string()
            }
            
            rt += "}"
            return rt
        case .gScalar: return se!.string()
        case .gTuple:
            var rt = ""
            rt += "("
            if let pv = ar!.first {
                let pvv = pv
                rt += pvv.string()
                for pv2 in ar![1...] {
                    rt += " " + pv2.string()
                }
            }

            rt += ")"
            return rt
        }
    }

    
    var kind: Kind { return k
    }

    func cloneIf() -> Pval {
        switch kind.gtype {
        case .gScalar:
            return Pval(prc, get().clone())
        case .gArray, .gTuple:
             return Pval(prc, ar!.map { $0.cloneIf() }, kind)
            
        case .gMap, .gSlice:
            return self
        }
    }

}



