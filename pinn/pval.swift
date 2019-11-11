//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
protocol Ptype {
    static func zeroValue() -> Ptype
    func equal(_: Ptype) -> Bool
}
protocol Ktype {}


protocol Plus: Ptype {
    func plus(_: Plus) -> Plus
}

protocol Compare: Ptype {
    func lt(_: Compare) -> Bool
    func gt(_: Compare) -> Bool
}

extension Int: Ptype, Ktype, Plus, Compare {
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    
    static func zeroValue() -> Ptype { return 0 }
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! Self)
        return x
    }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
    
}
extension Bool: Ptype, Ktype {
    static func zeroValue() -> Ptype { return false }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}
extension String: Ptype, Ktype, Plus, Compare {
    
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    static func zeroValue() -> Ptype { return "" }
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! String)
        return x
    }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}


class Pval {
    static func sf() {
        
    }
    
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
        if p.getKind() != getKind() {
            return false
        }
        switch getKind().gtype {
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
    
    var sc: Ptype?
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
                map![v1v] = getKind().vtype.zeroValue()
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
        
        guard v == nil || getKind().vtype == type(of:v!) else {
            de(ErrWrongType)
        }
        switch k {
        case let v1v as Int:
            if getKind().gtype == .gSlice && v1v == ar!.count {
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
            
        case .gArray, .gSlice: return String(describing: ar!)
        case .gMap: return String(describing: map!)
        case .gScalar: return String(describing: sc!)
        }
    }
    
    func getKind() -> Kind {
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
        let rt = Pval(getKind(), nil)
        
        switch getKind().gtype {
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



