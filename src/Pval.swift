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

class Wrap <T> {
    var w: T
    init(_ x: T) {
        w = x
    }
}

//class arWrap {
//    var ar: [Pval]
//    init(_ a: [Pval]) {
//        ar = a
//    }
//}
//class maWrap {
//    var ma: [String: Pval]
//    init(_ m: [String: Pval]) {
//        ma = m
//    }
//}

enum Contents {
    case single(Pwrap)
    case multi(Wrap<[Pval]>)
    case map(Wrap<[String: Pval]>)
    init(_ c: Contents) {
        switch c {

            case .multi(let pv):
                self = .multi(pv)
            case .map(let ma):
                self = .map(ma)
            case .single(let s):
                self = .single(s)
            }
    }
    func setCon(_ k: Ktype? = nil, _ v: Pval? = nil) {
        switch self{
        case .multi(let pv):
            if k == nil {
                pv.w.append(v!)
            } else {
                pv.w[k as! Int] = v!
            }
        case .map(let ma):
            ma.w[k as! String] = v
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
                return ar.w
            }
            de(ECASE)
        }
        func getMap() -> [String: Pval] {
            if case .map(let map) = self {
                return map.w
            }
            de(ECASE)
        }
    func isNull() -> Bool {
        return equal(Contents.single(Pwrap(Nil())))
    }
        func equal(_ co: Contents) -> Bool {
            switch self {
            case .single(let pw):
                if case .multi(let x) = co {
                    _ = x
                    return false
                }
                return pw.equal(co.getPw())
            case .multi(let ar):
                if case .single(let x) = co {
                    _ = x
                    return false
                }
                return ar.w.elementsEqual(co.getAr(), by: {$0.equal($1)})
            case .map(let map):
                let omap = co.getMap()
                for (key, value) in map.w {
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
                return Array(pvs.w[a..<b])
            default: de(ECASE)
            }
        }
        

        func count() -> Int {
            switch self {
            case .multi(let ar):
                return ar.w.count
            case .map(let map):
                return map.w.count
            case.single:
                return 1
            }
        }
}

class Pval {
    var e: Pvalp
            init(_ p: Pval) {
                e = p.e
            }
            
            init(_ c: ParserRuleContext?, _ ar: [Pval], _ k: Kind) {
                e = Pvalp(k, .multi(Wrap(ar)), c)
            }
            
            init(_ c: ParserRuleContext?, _ ar: [Pval]) {
  //                          prc = c
                let mar = ar
                let ka = ar.map { $0.kind }
                let k = Kind(c, ka)
                for (key, value) in mar.enumerated() {
                    if case .vt(let vt) = value.kind.ke {
                        if vt == Nil.self {
                            mar[key].e.k = k
                        }
                    }
                }
                e = Pvalp(k, .multi(Wrap(ar)), c)
            }
            
            init(_ c: ParserRuleContext?, _ a: Ptype) {
                let w = Pwrap(a)
                let k = Kind(type(of: w.unwrap()))
                e = Pvalp(k, .single(w), c)
            }
            
            convenience init( _ c: ParserRuleContext?, _ pv: Pval, _ a: Int, _ b: Int) {
                self.init(c, Kind(Kind(pv.kind.ke.getK()!.ke.getVt()!), .gSlice, b - a))
                e.con = .multi(Wrap(pv.e.con.getSlice(a, b)))
            }

            
            func conset(_ k: Ktype? = nil, _ p: Pval? = nil) {
                e.con.setCon(k, p)
                self.e.k.count = e.con.count()
            }
            
            
            init( _ c: ParserRuleContext?, _ k: Kind) {
                switch k.gtype {
                case .gArray, .gSlice:
                    
                    var ar = [Pval]()
                    for _ in 0..<k.count {
                        ar.append(Pval(c, k.ke.getK()!))
                    }
                    e = Pvalp(k, Contents.multi(Wrap(ar)), c)
                case .gMap:
                    let m = [String: Pval]()
                                        e = Pvalp(k, Contents.map(Wrap(m)), c)

                case .gPointer:
                                        e = Pvalp(k, Contents.single(Pwrap(Nil())), c)
                case .gScalar:
                    let se = Pwrap(k.ke.getVt()!.self.zeroValue())
                                        e = Pvalp(k, Contents.single(se), c)
                case .gTuple:
                    var ar = [Pval]()
                    for x in k.ke.getKm()! {
                        ar.append(Pval(c, x))
                    }
                                        e = Pvalp(k, Contents.multi(Wrap(ar)), c)
                    break
                }
            }
            func equal(_ p: Pval) -> Bool {
                
                ade(p.kind.kindEquivalent(kind, true))
                return e.con.equal(p.e.con)
            }
            
            func getUnwrap() -> Ptype {
                return get().unwrap()
            }
            private func get() -> Pwrap {
                ade(kind.gtype == .gScalar)
                return e.con.getPw()
            }
    func hasKey(_ s: String) -> Bool {
        return e.con.getMap()[s] != nil
    }
            func getKeys() -> [String] {
                return [String](e.con.getMap().keys)
            }
            
            private func getNewChild() -> Pval {
                return Pval(e.prc, kind.ke.getK()!)
            }
            func get(_ k: Ktype, _ lh: Bool = false) -> Pval {
                switch k {
                case let v1v as Int:
                    if lh && kind.gtype == .gSlice && v1v == e.con.count() {
                        conset(nil, getNewChild())
                                              
                    }
                    return e.con.getAr()[v1v]
                case let v1v as String:
                    if e.con.getMap()[v1v] == nil {
                        if lh {
                            conset(v1v, getNewChild())
                           
    //                        addKey(v1v, getNewChild())
                        } else {
                            return getNewChild()
                        }
                    }
                    return e.con.getMap()[v1v]!
                default:
                    de(ECASE)
                }
            }
            
            
            func setPV(_ v : Pval) {
                if !kind.kindEquivalent(v.kind, true) {
                    de(Perr(ETYPE, v))
                }
//                ade(kind.kindEquivalent(v.kind, true))
                
                e = v.e
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
    //                ade(kind.gtype != .gTuple)
                    ade(ki.kindEquivalent(v!.kind, true))
                case .km(let km):
     //               ade(kind.gtype == .gTuple)
                    let kt = km[k as! Int]
                    ade(kt.kindEquivalent(v!.kind.ke.getK()!, true))
                default: de(ECASE)
                }



       
                switch k {
                case let v1v as Int:
                    if kind.gtype == .gSlice && v1v == e.con.count() {
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
            
            
    func stringOrLetter() -> String {
                if kind.isPointer() {
                    if e.con.isNull() {
                        return "E"
                    } else {
                        return "P"
                    }
                }
        return string(false)
    }
    func string(_ follow: Bool) -> String {
                switch e.con {
                case .single(let pw):
                    return pw.string()
                case .multi(let ar):
                    
                    
                    
                    var rt = ""
                    rt += kind.gtype == .gTuple || kind.gtype == .gPointer ? "(" : "["
                    if ar.w.count > 0 {
                        if follow || kind.gtype != .gPointer {
                        rt += ar.w.first!.string(follow)
                        for v in ar.w[1...] {
                            rt += " " + v.string(follow)
                        }
                        } else {
                            rt += ar.w.first!.stringOrLetter()
                            for v in ar.w[1...] {
                                rt += " " + v.stringOrLetter()
                            }

                        }
                    }
                    rt += kind.gtype == .gTuple || kind.gtype == .gPointer ? ")" : "]"
                    

                    return rt
                case .map(let map):
                    var rt = ""
                    rt += "{"
                    var keys = getKeys()
                    keys.sort()
                    for key in keys {
                        if rt != "{" {
                            rt += " "
                        }
                        rt += key + ":" + map.w[key]!.string(follow)
                    }
                    
                    rt += "}"
                    return rt

                }
            }
            
            
    var kind: Kind { return e.k
            }
            
            func cloneIf() -> Pval {
                
                
                
                switch e.con {
                case .single(let pw):
                    return Pval(e.prc, pw.clone().unwrap())
                case .multi(let ar):
                    
                    if kind.gtype == .gSlice || kind.gtype == .gPointer {
                        return Pval(self)}
                    return Pval(e.prc, ar.w.map { $0.cloneIf() }, kind)
                    
                case .map:
                    return Pval(self)
                }
            }
    }

    
    
    
    
    
    


    class Pvalp {
        var k: Kind
        var con: Contents
        let prc: ParserRuleContext?
        init(_ k: Kind, _ con: Contents, _ prc: ParserRuleContext?) {
            self.k = k
            self.con = con
            self.prc = prc
        }
    }
      
