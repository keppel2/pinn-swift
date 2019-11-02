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
            case .gArray, .gSlice:
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
            case .gArray, .gSlice:
                for (key, value) in p.ar!.enumerated() {
                    if !equalValue(value, p.ar![key]) {
                        return false
                    }
                }
                return true
            case .gMap:
                
                for (key, value) in p.map! {
                    if map![key] == nil {
                        return false
                    }
                    if !equalValue(value, map![key]!) {
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
                if map![v1v] == nil {
                    map![v1v] = zeroValue(getKind().vtype)
                }
                return map![v1v]!
            default:
                de(ErrCase)
            }
        }
        func set(_ v: Any) {
            guard type(of: sc!) == type(of: v) else {
                de(ErrWrongType)
            }
            sc = v
        }
        
        func set(_ k: Any, _ v: Any?) {

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
    
    func plus(_ p: Pval) -> Pval {
        if getKind() != p.getKind() {
            de(ErrWrongType)
        }
        switch getKind().gtype {
        case .gScalar:
            return Pval(plusValue(sc!, p.sc!))
        case .gMap, .gArray, .gSlice:
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
    

