//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

class Pwrap: Atype {
    private var wrapped: Ptype
    init(_ p: Ptype) {
        wrapped = p
    }
    func unwrap() -> Ptype {
        return wrapped
    }
    func clone() -> Atype {
        return Pwrap(wrapped)
    }
    func equal(_ a: Atype) -> Bool {
        return unwrap().equal((a as! Pwrap).unwrap())
    }
}

class Pval: Atype {

    private let k: Kind
    private var ar: [Atype]?
    private var map: [String: Atype]?
    let prc: ParserRuleContext?
    static func wrapped(_ c: ParserRuleContext, _ a: Atype) -> Pval {
        if a is Pval {
            return a as! Pval
        }
        return Pval(c, a as! Ptype)
    }

    func sort() {

        ar!.sort {
            let lhs = ($0 as! Pwrap).unwrap() as! Compare
            let rhs = ($1 as! Pwrap).unwrap() as! Compare
            return lhs.lt(rhs)
        }
    }
    init(_ c: ParserRuleContext?, _ ar: [Pval]) {
        prc = c
        let ka = ar.map { $0.kind }
        k = Kind(ka)
        self.ar = ar
    }
    convenience init(_ c: ParserRuleContext, _ a: Ptype) {
        self.init(c, Pwrap(a))
    }
    init( _ c: ParserRuleContext, _ w: Pwrap) {
        prc = c
        k = Kind(type(of: w.unwrap()), .gScalar, nil)
        ar = [w]
    }
    convenience init( _ c: ParserRuleContext, _ pv: Pval, _ a: Int, _ b: Int) {
        self.init(c, Kind(pv.kind.vtype!, .gSlice, pv.ar!.count))
        self.ar = Array(pv.ar![a..<b])
    }
    init( _ c: ParserRuleContext, _ k: Kind, _ i: Ptype? = nil) {
        prc = c
        self.k = k
        switch k.gtype {
        case .gArray, .gSlice:
            ar = [Atype](repeating: Pwrap(i ?? k.vtype!.self.zeroValue()), count: k.count!)
        case .gMap:
            ade(i == nil)
            map = [String: Atype]()
        case .gScalar:
            ar = [Pwrap(i ?? k.vtype!.self.zeroValue())]
        case .gTuple:
            ade(i == nil)
            ar = [Pval]()
            for x in k.ka! {
                ar!.append(Pval(c, x))
            }
            break
        }
    }
    func equal(_ p: Atype) -> Bool {

        guard let p = p as? Pval else {
            de(ETYPE)
        }
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
        default: break
        }
        return false
    }


    func get() -> Pwrap {
        ade(kind.gtype == .gScalar)
        ade(ar!.count == 1)
        return (ar!.first! as! Pwrap)
    }
    func getKeys() -> [String] {
        return [String](map!.keys)

    }
    func get(_ k: Ktype) -> Atype {
        switch k {
        case let v1v as Int:
            if self.k.gtype == .gTuple {
                let pv = ar![v1v] as! Pval
                if pv.kind.gtype == .gScalar {
                    return pv.get()
                }
                return pv
            }
            return ar![v1v]
        case let v1v as String:
            if map![v1v] == nil {
                if kind.vtype == nil {
                    let pv = Pval(prc!, Kind(kind.ka!))
                    return pv
                } else {
                return Pwrap(kind.vtype!.zeroValue())
                }
            }
            return map![v1v]!
        default:
            de(ECASE)
        }
    }
    func set(_ v: Ptype) {
        ade(kind.count == 1)
        ade(kind.gtype == .gScalar)
        ade(ar!.count == 1)
        guard kind.vtype == type(of: v) else {
            de(ETYPE)
        }
        ar![0] = Pwrap(v)
    }
    
    func set(_ k: Ktype?, _ v: Ptype?) {
        if k == nil {
            set(v!)
            return
        }
        ade(kind.gtype != .gScalar)
        if kind.gtype == .gTuple {
            let index = k as! Int
//            ade(ar![index].kind.vtype! == type(of:v!))
            ar![index] = Pval(prc!, v!)
            return
        }
        guard v == nil || kind.vtype == type(of:v!) else {
            de(ETYPE)
        }
        switch k {
        case let v1v as Int:

            if kind.gtype == .gSlice && v1v == ar!.count {
                ar!.append(Pwrap(v!))
                kind.count = ar!.count
            } else {
                ar![v1v] = Pwrap(v!)
            }
        case let v1v as String:
            if v == nil {
                map![v1v] = nil
            } else {
                map![v1v] = Pwrap(v!)
            }
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
            if ar!.count > 0 {
                rt += String(describing: (ar!.first! as! Pwrap).unwrap())
                for v in ar![1...] {
                    rt += " " + String(describing: (v as! Pwrap).unwrap())
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
                rt += key + ":" + String(describing: (value as! Pwrap).unwrap())
            }
            
            rt += "}"
            return rt
        case .gScalar: return String(describing: self.get().unwrap())
        case .gTuple:
            var rt = ""
            rt += "("
            if let pv = ar!.first {
                let pvv = pv as! Pval
                rt += pvv.string
                for pv2 in ar![1...] {
                    rt += " " + (pv2 as! Pval).string//String(describing: v.get())
                }
            }

            rt += ")"
            return rt
        }
    }

    
    var kind: Kind { return k
    }

    func clone() -> Atype {
        if kind.gtype == .gScalar {
            return Pval(prc!, self.get().unwrap())
        }
        let rt = Pval(prc!, kind)
        switch kind.gtype {
        case .gArray, .gTuple:
            rt.ar = ar!.map { $0.clone() }
        case .gMap, .gSlice, .gScalar:
            de(ECASE)
        }
        return rt
    }
}



