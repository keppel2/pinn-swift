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
        case .multi(let pv):
            if k == nil {
                pv.ar.append(v!)
            } else {
                pv.ar[k as! Int] = v!
            }
        case .map(let ma):
            ma.ma[k as! String] = v
        case .single:
            de(ECASE)
        }
    }
    func getPw() -> Pwrap {
        if case .single(let pw) = self {
            return pw
        }
        de(ECASE)
    }
        func getAr() -> [Pval] {
            if case .multi(let ar) = self {
                return ar.ar
            }
            de(ECASE)
        }
        func getMap() -> [String: Pval] {
            if case .map(let map) = self {
                return map.ma
            }
            de(ECASE)
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
        
        
        private var k: Kind
        var con: Contents
        var prc: ParserRuleContext?
        

        init(_ c: ParserRuleContext?, _ ar: [Pval], _ k: Kind) {
                        prc = c
            self.k = k
            self.con = .multi(arWrap(ar))
        }
        
        init(_ c: ParserRuleContext?, _ ar: [Pval]) {
                        prc = c
            let ka = ar.map { $0.kind }
            k = Kind(ka)
            self.con = .multi(arWrap(ar))
        }
        
        init(_ c: ParserRuleContext?, _ a: Ptype) {
                        prc = c
            let w = Pwrap(a)
            k = Kind(type(of: w.unwrap()))
               self.con = .single(w)
        }
        
        convenience init( _ c: ParserRuleContext?, _ pv: Pval, _ a: Int, _ b: Int) {
            self.init(c, Kind(Kind(pv.kind.ke.getK().ke.getVt()), .gSlice, b - a))
            self.con = .multi(arWrap(pv.con.getSlice(a, b)))
        }

        
        func conset(_ k: Ktype? = nil, _ p: Pval? = nil) {
            con.setCon(k, p)
            self.k.count = con.count()
        }
        
        
        init( _ c: ParserRuleContext?, _ k: Kind) {
                        prc = c
            self.k = k
            switch k.gtype {
            case .gArray, .gSlice:
                
                var ar = [Pval]()
                for _ in 0..<k.count {
                    ar.append(Pval(c, k.ke.getK()))
                }
                con = Contents.multi(arWrap(ar))
            case .gMap:
                let m = [String: Pval]()
                con = Contents.map(maWrap(m))
            case .gPointer:
                con = Contents.single(Pwrap(Nil()))
            case .gScalar:
                let se = Pwrap(k.ke.getVt().self.zeroValue())
                con = Contents.single(se)
            case .gTuple:
                var ar = [Pval]()
                for x in k.ke.getKm() {
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
            return Pval(prc, kind.ke.getK())
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
            switch kind.ke {
            case .k(let ki):
                ade(kind.gtype != .gTuple)
                ade(ki.kindEquivalent(v!.kind))
            case .km(let km):
                ade(kind.gtype == .gTuple)
                let kt = km[k as! Int]
                ade(kt.kindEquivalent(v!.kind.ke.getK()))
            default: de(ECASE)
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
                rt += kind.gtype == .gTuple || kind.gtype == .gPointer ? "(" : "["
                if ar.ar.count > 0 {
                    rt += ar.ar.first!.string()
                    for v in ar.ar[1...] {
                        rt += " " + v.string()
                    }
                }
                rt += kind.gtype == .gTuple || kind.gtype == .gPointer ? ")" : "]"
                

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
            }
        }
}
