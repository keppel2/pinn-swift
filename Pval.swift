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

class arWrap {
    var ar: [Pval]
    init(_ a: [Pval]) {
        ar = a
    }
}
class maWrap {
    var ma: [String: Pval]
    init(_ m: [String: Pval]) {
        ma = m
    }
}

enum Contents {
    case single(Pwrap)
    case multi(arWrap)
    case map(maWrap)
    func setCon(_ k: Ktype? = nil, _ v: Pval? = nil) {
        switch self{
        case .multi(var pv):
            if k == nil {
                pv.ar.append(v!)
            } else {
                pv.ar[k as! Int] = v!
            print("hi")
            }
        case .map(var ma):
            ma.ma[k as! String] = v
        case .single:
            de(ECASE)
        }
    }
    func getPw() -> Pwrap {
        switch self {
        case .single(let pw):
            return pw
        default: de(ECASE)
        }
    }
        func getAr() -> [Pval] {
            switch self {
            case .multi(let ar):
                return ar.ar
            default: de(ECASE)
            }
        }
        func getMap() -> [String: Pval] {
            switch self {
            case .map(let map):
                return map.ma
                
            default: de(ECASE)
            }
        }
        
        func equal(_ co: Contents) -> Bool {
            switch self {
            case .single(let pw):
                return pw.equal(co.getPw())
            case .multi(let ar):
                return ar.ar.elementsEqual(co.getAr(), by: {$0.equal($1)})
            case .map(let map):
                let omap = co.getMap()
                for (key, value) in map.ma {
                    if omap[key] == nil {
                        return false
                    }
                    if !value.equal(omap[key]!) {
                        return false
                    }
                }
                return true
                
                
            }
        }
        func getSlice(_ a: Int, _ b: Int) -> [Pval] {
            switch self {
            case .multi(let pvs):
                return Array(pvs.ar[a..<b])
            default: de(ECASE)
            }
        }
        
//        func append(_ pv: Pval, _ k: String? = nil) {
//            switch self {
//            case .multi(var ar):
//                ar.append(pv)
//            case .map(var map):
//                map[k!] = pv
//            case.single:
//                de(ECASE)
//            }
//        }
        func count() -> Int {
            switch self {
            case .multi(let ar):
                return ar.ar.count
            case .map(let map):
                return map.ma.count
            case.single:
                return 1
            }
        }
}

    
    
    class Pval {
        
        
        private var k: Kind!
        var con: Contents!
        var prc: ParserRuleContext?
        
//        private func append(_ pv: Pval) {
//            ade(k.gtype == .gSlice)
//            con.append(pv)
//            kind.count = con.count()
//        }
//
//        private func addKey(_ s: String, _ pv: Pval) {
//            ade(k.gtype == .gMap)
//            con.append(pv, s)
//            kind.count = con.count()
//        }
//
        convenience init(_ c: ParserRuleContext?, _ ar: [Pval], _ k: Kind) {
            self.init(c)
            self.k = k
            self.con = .multi(arWrap(ar))
        }
        
        convenience init(_ c: ParserRuleContext?, _ ar: [Pval]) {
            self.init(c)
            let ka = ar.map { $0.kind }
            k = Kind(ka)
            self.con = .multi(arWrap(ar))
        }
        
        convenience init(_ c: ParserRuleContext?, _ a: Ptype) {
            self.init(c)
            let w = Pwrap(a)
            k = Kind(type(of: w.unwrap()))
               self.con = .single(w)
        }
        
        convenience init( _ c: ParserRuleContext?, _ pv: Pval, _ a: Int, _ b: Int) {
            self.init(c, Kind(Kind(pv.kind.k!.vtype!), .gSlice, b - a))
            self.con = .multi(arWrap(pv.con.getSlice(a, b)))
        }
        init(_ c: ParserRuleContext?) {
            prc = c
//            con = .single(getNewChild())
        }
        
        
        
        func conset(_ k: Ktype? = nil, _ p: Pval? = nil) {
            con.setCon(k, p)
            self.k.count = con.count()
        }
        
        
        convenience init( _ c: ParserRuleContext?, _ k: Kind) {
            self.init(c)
            self.k = k
            switch k.gtype {
            case .gArray, .gSlice:
                
                var ar = [Pval]()
                for _ in 0..<k.count {
                    ar.append(Pval(c, k.k!))
                }
                con = Contents.multi(arWrap(ar))
            case .gMap:
                let m = [String: Pval]()
                con = Contents.map(maWrap(m))
            case .gScalar:
                let se = Pwrap(k.vtype!.self.zeroValue())
                con = Contents.single(se)
            case .gTuple:
                var ar = [Pval]()
                for x in k.ka! {
                    ar.append(Pval(c, x))
                }
                con = Contents.multi(arWrap(ar))
                break
            }
        }
        func equal(_ p: Pval) -> Bool {
            
            ade(p.kind.kindEquivalent(kind))
            return con.equal(p.con)
        }
        
        func getUnwrap() -> Ptype {
            return get().unwrap()
        }
        private func get() -> Pwrap {
            ade(kind.gtype == .gScalar)
            return con.getPw()
        }
        
        func getKeys() -> [String] {
            return [String](con.getMap().keys)
        }
        
        private func getNewChild() -> Pval {
            return Pval(prc, kind.k!)
        }
        func get(_ k: Ktype, _ lh: Bool = false) -> Pval {
            switch k {
            case let v1v as Int:
                if lh && kind.gtype == .gSlice && v1v == con.count() {
                    conset(nil, getNewChild())
                                          
                }
                return con.getAr()[v1v]
            case let v1v as String:
                if con.getMap()[v1v] == nil {
                    if lh {
                        conset(v1v, getNewChild())
                       
//                        addKey(v1v, getNewChild())
                    } else {
                        return getNewChild()
                    }
                }
                return con.getMap()[v1v]!
            default:
                de(ECASE)
            }
        }
        
        
        func setPV(_ v : Pval) {
            ade(kind.kindEquivalent(v.kind))
            self.con = v.con
            self.prc = v.prc
        }
        
        func set(_ k: Ktype, _ v: Pval?) {
            if v == nil {
                conset(k as! String, nil)
                return
            }
//                map![k as! String] = nil
//                kind.count = map!.count
//                return
//            }
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
                if kind.gtype == .gSlice && v1v == con.count() {
                    conset(nil, v!)
 
                } else {
                    conset(v1v, v!)
                }
            case let v1v as String:
                conset(v1v, v)
            default:
                de(ECASE)
            }
        }
        
        
        
        func string() -> String {
            switch con {
            case .single(let pw):
                return pw.string()
            case .multi(let ar):
                
                
                
                var rt = ""
                rt += kind.gtype == .gTuple ? "(" : "["
                if ar.ar.count > 0 {
                    rt += ar.ar.first!.string()
                    for v in ar.ar[1...] {
                        rt += " " + v.string()
                    }
                }
                rt += kind.gtype == .gTuple ? ")" : "]"
                

                return rt
            case .map(let map):
                var rt = ""
                rt += "{"
                for (key, value) in map.ma {
                    if rt != "{" {
                        rt += " "
                    }
                    rt += key + ":" + value.string()
                }
                
                rt += "}"
                return rt

            case .none:
                de(ECASE)
            }
        }
        
        
        var kind: Kind { return k
        }
        
        func cloneIf() -> Pval {
            
            
            
            switch con {
            case .single(let pw):
                return Pval(prc, pw.clone().unwrap())
            case .multi(let ar):
                
                if kind.gtype == .gSlice {
                    return self}
                return Pval(prc, ar.ar.map { $0.cloneIf() }, kind)
                
            case .map:
                return self
            case .none:
                de(ECASE)
            }
        }
}
