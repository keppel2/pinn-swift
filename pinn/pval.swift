//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation








class Pval {
    static func sf() {}
    
        let g: Gtype
        let v: Any.Type
        convenience init(_ a: Any) {
            self.init(Kind(vtype: type(of: a), gtype: .gScalar, count: 1), a)
        }

        init(_ k: Kind, _ i: Any?) {
            g = k.gtype
            v = k.vtype
            switch g {
            case .gArray:
                ar = [Any](repeating: i ?? zeroValue(k.vtype), count: k.count!)
            case .gMap:
                map = [String: Any]()
            case .gScalar:
                sc = i ?? zeroValue(k.vtype)

            }
        }
        func equal(_ p:Pval) -> Bool {
            if p.getKind() != getKind() {
                return false
            }
            switch getKind().gtype {
            case .gScalar:
                return equalValue(sc!, p.sc!)
            case .gArray:
                for (key, value) in p.ar!.enumerated() {
                    if !equalValue(value, p.ar![key]) {
                        return false
                    }
                }
                return true
            case .gMap:
                for (key, value) in p.map! {
                    if !equalValue(value, p.map![key]!) {
                        return false
                    }
                }
                return true
            }
        }
  
        var sc: Any?
        var ar: [Any]?
        var map: [String: Any]?

        func get() -> Any {
            return sc!
        }
//        func getPV() -> Pval {
//
//        }
        
        func get(_ k: Any) -> Any {
            switch k {
            case let v1v as Int:
                return ar![v1v]
            case let v1v as String:
                return map![v1v]!
            default:
                fatalError(ErrCase)
            }
        }
        func set(_ v: Any) {
            guard type(of: sc) == type(of: v) else {
                fatalError(ErrWrongType)
            }
            sc = v
        }
        
        func set(_ k: Any, _ v: Any?) {

            guard v == nil || getKind().vtype == type(of:v!) else {
                fatalError(ErrWrongType)
            }
            switch k {
            case let v1v as Int:
                ar![v1v] = v!
            case let v1v as String:
                map![v1v] = v
            default:
                fatalError(ErrCase)
            }
        }
    
    func plus(_ p: Pval) -> Pval {
        if getKind() != p.getKind() {
            fatalError(ErrWrongType)
        }
        switch getKind().gtype {
        case .gScalar:
            return Pval(plusValue(sc!, p.sc!))
        case .gMap, .gArray:
            fatalError(ErrCase)
        }
    }
        
        var string: String {
            switch g {
                
            case .gArray: return String(describing: ar!)
            case .gMap: return String(describing: map!)
            case .gScalar: return String(describing: sc!)
            }
        }
        
        func getKind() -> Kind {
            switch g {
            case .gArray:
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
            case .gArray:
                rt.ar = ar!
            case .gScalar:
                rt.sc = sc!
            case .gMap:
                rt.map = map!
            }
            return rt
    }
    }
    

