//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation


class Pval {

    let g: Gtype
    let v: Ptype.Type
    convenience init(_ a: Ptype) {
        self.init(Kind(vtype: type(of: a), gtype: .gScalar, count: 1), a)
    }
    
    init(_ k: Kind, _ i: Ptype?) {
        g = k.gtype
        v = k.vtype
        switch g {
        case .gArray, .gSlice:
            ar = [Ptype](repeating: i ?? v.self.zeroValue(), count: k.count!)
        case .gMap:
            map = [String: Ptype]()
        case .gScalar:
            sc = i ?? v.self.zeroValue()
        }
    }
    func equal(_ p:Pval) -> Bool {
        if p.kind != kind {
            return false
        }
        switch kind.gtype {
        case .gScalar:
            return sc!.equal(p.sc!)
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
    
    private var sc: Ptype?
    var ar: [Ptype]?
    var map: [String: Ptype]?
    
    func get() -> Ptype {
        return sc!
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
            de(ErrCase)
        }
    }
    func set(_ v: Ptype) {
        guard type(of: sc!) == type(of: v) else {
            de(ErrWrongType)
        }
        sc = v
    }
    
    func set(_ k: Ktype, _ v: Ptype?) {
        
        guard v == nil || kind.vtype == type(of:v!) else {
            de(ErrWrongType)
        }
        switch k {
        case let v1v as Int:
            if kind.gtype == .gSlice && v1v == ar!.count {
                ar!.append(v!)
            } else {
                ar![v1v] = v!
            }
        case let v1v as String:
            map![v1v] = v
        default:
            de(ErrCase)
        }
    }
    
    
    
    var string: String {
        switch g {
            
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
        case .gScalar: return String(describing: sc!)
        }
    }

    
    var kind: Kind {
        switch g {
        case .gArray, .gSlice:
            return Kind(vtype: v, gtype: g, count: ar!.count)
        case .gMap:
            return Kind(vtype: v, gtype: g, count: map!.count)
        case .gScalar:
            return Kind(vtype: v, gtype: g, count: 1)
        }
    }
    
    func clone() -> Pval {
        let rt = Pval(kind, nil)
        switch kind.gtype {
        case .gArray, .gSlice:
            rt.ar = ar!
        case .gScalar:
            rt.sc = sc!
        case .gMap:
            rt.map = map!
        }
        return rt
    }
}



