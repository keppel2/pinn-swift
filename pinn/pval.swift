//
//  pval.swift
//  pinn
//
//  Created by Ryan Keppel on 10/25/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

//import Foundation
protocol PinnType: Equatable {
    static func zeroValue() -> PinnType
}

extension Int: PinnType {
    static func zeroValue() -> PinnType {
        return 0
    }
}

extension Bool: PinnType {
    static func zeroValue() -> PinnType {
        return false
    }
}

struct ErrParamLength: Error {}
struct ErrWrongType: Error {}
struct ErrRedeclare: Error {}
struct ErrUndeclare: Error {}
struct ErrCase: Error{}


func main() {
    let v: PinnType
    v = Int.zeroValue()
    print(type(of: v))
    
    print("hiya")
    let rt: Pval
    rt = Pscalar<Int>()
    var rt2: Pval = rt
    let x = rt2.getv()
    print(type(of:x))
    
}
enum Gtype {
    case gScalar, gArray, gMap
}

func pvAs <V: PinnType> (_ p: Pval) -> V {
    let ps = p as! Pscalar<V>
    return ps.sc
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

protocol Pval {
    var string: String {get}
    func getKind() -> Kind
    func clone() -> Pval
    func equal(_:Pval) -> Bool
    func getv() -> PinnType
}
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
    class Pscalar <V: PinnType>: Pval {
        //convert to ==
        //var klass: Klass<V>
        func getv() -> PinnType {
            return sc
        }
        func new(t: Any.Type)-> Pval {
            let rt: Pval
            if t == Int.self {
                rt = Pscalar<Int>()
            } else if t == Bool.self {
                rt = Pscalar<Bool>()
            } else {
                fatalError()
            }
            return rt
        }
        

        func equal(_ p:Pval) -> Bool {
            guard let p2 = p as? Self else {
                return false
            }
            return true
            sc == p2.sc
        }
  
        var sc: V
        init(_ v: V) {
            sc = v
        }
        init() {
            sc = V.zeroValue() as! V
        }
//        init(_ k: Klass<V>) { sc = try! zeroValue()}
        


        func get() -> V {
            return sc
        }
        var string: String { return String(describing: sc) }
        func getKind() -> Kind {
            return Kind(vtype: V.self, gtype: .gScalar, count: 1)
        }
        func clone() -> Pval {
            return Pscalar<V>(sc)
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
//    func equalsError(_ k2: Kind) throws {
//        switch gtype {
//        case .gArray, .gScalar:
//            if self != k2 {
//                throw ErrWrongType()
//            }
//        case .gMap:
//            if gtype != k2.gtype || vtype != k2.vtype {
//                throw ErrWrongType()
//            }
//
//        }
//    }
}
