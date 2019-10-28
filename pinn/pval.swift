//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation


let ErrParamLength    = "Parameter length mismatch."
let ErrWrongStatement = "Wrong statement."
let ErrWrongType      = "Wrong type."
let ErrRange          = "Out of range."
let ErrCase           = "Case unimplemented."
let ErrRedeclare      = "Redeclared."
let ErrUndeclare      = "Undeclared."


func fnToString(_ s: String) -> String {
    let fh = FileHandle(forReadingAtPath: s)!
    let data = fh.readDataToEndOfFile()
    return String(describing: data)
}
func main() {
    print(FileManager.default.currentDirectoryPath)
    let fh = FileHandle(forReadingAtPath: "/Users/ryankeppel/fib.pinn")!
    let data = fh.readDataToEndOfFile()
    let str = String(data: data, encoding: String.Encoding.utf8)!
    print(str)
}
enum Gtype {
    case gScalar, gArray, gMap
}


//
//func zeroValue<>() throws -> T {
//    if T.self == Int.self {
//        return 0 as! T
//    }
//    if T.self == Bool.self {
//        return false as! T
//    }
//    throw ErrCase()
//}


//
//    class Pmap <V: Equatable>: Pval {
//
//                var string: String { return String(describing: map) }
//        var map = [String: V]()
//
//        func equal(_ p:Pval) -> Bool {
//            guard let p2 = p as? Self else {
//                return false
//            }
//            return p2.map == map
//        }
//        func getv(_ v:Any) -> Any {
//
//        }
//            func get(_ k: String) -> V {
//                return map[k]!
//            }
//            func set(_ k: String, v: V) {
//                map[k] = v
//            }
//        func getScalar(_ k: String) -> Pscalar<V> {
//            return Pscalar(get(k))
//        }
//
//
//
//            func getKind() -> Kind {
//                return Kind(vtype: V.self, gtype: .gMap, count: map.count)
//            }
//
//            init() {
//            }
//
//            func clone() -> Pval {
//                let pa = Pmap<V>()
//                pa.map = map
//                let rt: Pval = pa
//                return rt
//        }
//
//        }
//
//
//
//    class Parray <V: Equatable>: Pval {
//
//                var string: String { return String(describing: ar) }
//            var ar: [V]
//
//        func equal(_ p:Pval) -> Bool {
//            guard let p2 = p as? Self else {
//                return false
//            }
//            return ar == p2.ar
//        }
//
//
//            func get(_ k: Int) -> V {
//                return ar[k]
//            }
//        func getScalar(_ k: Int) -> Pscalar<V> {
//            return Pscalar(get(k))
//        }
//        func getMe(_ x: V) -> Self {
//            return self
//        }
//            func set(_ k: Int, v: V) {
//                ar[k] = v
//            }
//
//            func getKind() -> Kind {
//                return Kind(vtype: V.self, gtype: .gArray, count: ar.count)
//            }
//
//            init(_ x: Int) {
//                ar = [V](repeating: try! zeroValue(), count: x)
//            }
//            func clone() -> Pval {
//                let pa = Parray<V>(getKind().count!)
//                pa.ar = ar
//                let rt: Pval = pa
//                return rt
//        }
//
//        }
//

func zeroValue(_ v:Any.Type) -> Any {
    if v == Int.self {
        return 0
    } else if v == Bool.self {
        return false
    } else if v == String.self {
        return ""
    } else {
        fatalError()
    }
}

func equalValue(_ v1: Any, _ v2: Any) -> Bool {
    guard type(of: v1) == type(of: v2) else {
        return false
    }
    switch v1 {
    case let v1v as Int:
        return v1v == v2 as! Int
    case let v1v as Bool:
        return v1v == v2 as! Bool
    case let v1v as String:
        return v1v == v2 as! String
    default:
        fatalError(ErrCase)
    }
}

func plusValue(_ v1: Any, _ v2: Any) -> Any {
    switch v1 {
    case let v1v as Int:
        return v1v + (v2 as! Int)
    case let v1v as String:
        return v1v + (v2 as! String)
    default:
        fatalError(ErrCase)
    }
}

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
//                if v == Int.self {
//                    ar = [Any](repeating: (i ?? 0) as! Int, count: k.count!)
//                } else if v == Bool.self {
//                    ar = [Bool](repeating: (i ?? false) as! Bool, count: k.count!)
//                } else {
//                    fatalError()
//                }
            case .gMap:
                map = [String: Any]()
//                if v == Int.self {
//                    map = [String: Int]()
//                 } else if v == Bool.self {
//                    map = [String: Bool]()
//                 } else {
//                     fatalError()
//                 }
            case .gScalar:
                sc = i ?? zeroValue(k.vtype)
//                if v == Int.self {
//                    sc = i ?? 0
//                } else if v == Bool.self {
//                    sc = i ?? false
//                } else {
//                    fatalError()
//                }
            }
        }
        func equal(_ p:Pval) -> Bool {
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
            sc = v
        }
        
        func set(_ k: Any, _ v: Any?) {
            
            
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
    


struct Kind: Equatable {

    
    static func == (k1: Self, k2: Self) -> Bool {
        return k1.vtype == k2.vtype && k1.gtype == k2.gtype && k1.count == k2.count
    }
    var vtype: Any.Type
    var gtype: Gtype
    var count: Int?
//    func new() -> Pval {
//        let rt: Pval
//        switch gtype {
//        case .gMap:
//            if vtype == Int.self {
//                rt = Pmap<Int>()
//            } else if vtype == Bool.self {
//                rt = Pmap<Bool>()
//            } else {
//                fatalError()
//            }
//        case .gScalar:
//            if vtype == Int.self {
//                rt = Pscalar<Int>()
//            } else if vtype == Bool.self {
//                rt = Pscalar<Bool>()
//            } else {
//                fatalError()
//            }
//        case .gArray:
//            if vtype == Int.self {
//                rt = Parray<Int>(count!)
//            } else if vtype == Bool.self {
//                rt = Parray<Bool>(count!)
//            } else {
//                fatalError()
//            }
//        }
//        return rt
//    }
//
    func equalsError(_ k2: Kind) {
        switch gtype {
        case .gArray, .gScalar:
            if self != k2 {
                fatalError(ErrWrongType)
            }
        case .gMap:
            if gtype != k2.gtype || vtype != k2.vtype {
                fatalError(ErrWrongType)
            }

        }
    }
//    }
}
