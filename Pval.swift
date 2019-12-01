//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

class Pwrap {
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
//    func getAtype() -> Atype {
//        return se ?? self
//    }
    func akind() -> Kind {
        return kind
    }

    private var k: Kind
    private var se: Pwrap?
    private var ar: [Pval]?
    private var map: [String: Pval]?
    let prc: ParserRuleContext?


//    func sort() {
//
//        ar!.sort {
//            let lhs = ($0 as! Pwrap).unwrap() as! Compare
//            let rhs = ($1 as! Pwrap).unwrap() as! Compare
//            return lhs.lt(rhs)
//        }
//    }
    init(_ c: ParserRuleContext?, _ ar: [Pval]) {
        prc = c
        let ka = ar.map { $0.kind }
        k = Kind(ka)
        self.ar = ar
    }
    convenience init(_ c: ParserRuleContext?, _ a: Ptype) {
        self.init(c, Pwrap(a))
    }
    init( _ c: ParserRuleContext?, _ w: Pwrap) {
        prc = c
        k = Kind(type(of: w.unwrap()))
        se = w
    }
    convenience init( _ c: ParserRuleContext?, _ pv: Pval, _ a: Int, _ b: Int) {
        self.init(c, Kind(Kind(pv.kind.k!.vtype!), .gSlice, b - a))
        self.ar = Array(pv.ar![a..<b])
    }
    init( _ c: ParserRuleContext?, _ k: Kind) {
        prc = c
        self.k = k
        switch k.gtype {
        case .gArray, .gSlice:
            ar = [Pval](repeating: Pval(c, k.k!), count: k.count)
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


    func get() -> Pwrap {
        ade(kind.gtype == .gScalar)
        return (se!)
    }
    func getKeys() -> [String] {
        return [String](map!.keys)

    }
    func get(_ k: Ktype) -> Pval {
        switch k {
        case let v1v as Int:
            if self.k.gtype == .gTuple {
                let pv = ar![v1v]
                if pv.kind.gtype == .gScalar {
                    return Pval(prc, pv.get())
                }
                return pv
            }
            return ar![v1v]
        case let v1v as String:
            if map![v1v] == nil {
                if kind.vtype == nil {
                    let pv = Pval(prc!, Kind(kind.k!.vtype!))
                    return pv
                } else {
                return Pval(prc, kind.vtype!.zeroValue())
                }
            }
            return map![v1v]!
        default:
            de(ECASE)
        }
    }
//    func set(_ v: Ptype) {
//        ade(kind.count == 1)
//        ade(kind.gtype == .gScalar)
//        ade(se != nil)
//        guard kind.vtype! == type(of: v) else {
//            de(ETYPE)
//        }
//        se = Pwrap(v)
//    }
    
    func setPV(_ v : Pval) {
        ade(kind.kindEquivalent(v.kind))
        self.k = v.kind
        self.se = v.se
        self.ar = v.ar
        self.map = v.map
    }
    
    func set(_ k: Ktype, _ v: Pval?) {
        if v == nil{
            map![k as! String] = nil
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
                ar!.append(v!)
                kind.count = ar!.count
            } else {
                ar![v1v] = v!
            }
        case let v1v as String:
                map![v1v] = v!
            kind.count = map!.count
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

    func clone() -> Pval {
        if kind.gtype == .gScalar {
            return Pval(prc, get().clone())
        }
        let rt = Pval(prc, kind)
        switch kind.gtype {
        case .gArray, .gTuple:
            rt.ar = ar!.map { $0.clone() }
        case .gMap, .gSlice, .gScalar:
            de(ECASE)
        }
        return rt
    }
}



