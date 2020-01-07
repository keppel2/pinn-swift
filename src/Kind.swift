
import Foundation
import Antlr4

class Kind {
//    private var ke: Kinde
    var gtype: Gtype
//    var count: Int?
    static var kinds = [Kind]()
//    init(_ k: Kind){
//        self.ke = k.ke
//        self.gtype = k.gtype
//        self.count = k.count
//    }
    private init(_ g: Gtype) {
        gtype = g
    }

    static func produceKind(_ g: Gtype) -> Kind {

//        if (kinds.contains {
//            $0 === k
//        }) {
//            return k
//        }
        
        let ki = kinds.firstIndex {
            $0.gtype.gEquivalent(g)
//            return $0.gtype == k.gtype
//                && $0.ke.getVt() == k.ke.getVt()
//                && $0.count == k.count
        }

        if ki != nil {
            return kinds[ki!]
        }
        let k = Kind(g)

        kinds.append(k)
        return k
    }


    func assert() {
//        switch gtype {
//        case .gScalar:
//            ade(ke.getVt() != nil)
//            ade(count == nil)
//        case .gArray, .gSlice, .gMap:
//            ade(ke.getK() != nil)
//        case .gTuple, .gPointer:
//            ade(ke.getKm() != nil)
////            for k in ke.getKm()! {
////                k.assert()
////            }
//        }
    }
    
    
    
//    func clone() throws -> Kind {
//        var gtype: Gtype
//        var count: Int?
//        
//        
//        
//        switch e.con {
//        case .single(let pw):
//            return Pval(e.prc, pw.clone().unwrap())
//        case .multi(let ar):
//            
//            if try getKind().gtype == .gSlice || getKind().gtype == .gPointer {
//                return Pval(self)}
//            if try getKind().gtype == .gArray {
//                return try Pval(e.prc, ar.w.map { try $0.cloneIf() }, getKind())
//            } else {
//                return try Pval(e.prc, ar.w.map {try $0.cloneIf()})
//            }
//        case .map:
//            return Pval(self)
//        }
//    }
//    
    
    

//    func cKind() throws -> Kind {
//        switch ke {
//        case .vt(let vt):
//            return Kind(vt)
//        case .k(let k):
//            return k
//        default:
//            throw Perr(ETYPE)
////            de(ECASE)
//        }
//    }
//    func tKind() -> Ptype.Type {
//        return ke.getVt()!
//    }
//    func aKind() -> [Kind] {
//        return ke.getKm()!
//    }
//    func isOneNil() -> Bool {
//        return ke.getVt() == Nil.self
//    }
//    func isNil() -> Bool {
//        return gtype == .gScalar && isOneNil()
//    }
//    func isPointer() -> Bool {
//        return gtype == .gPointer
//    }
//    func isType(_ p: Ptype.Type) -> Bool {
//        return gtype == .gScalar && ke.getVt()! == p
//    }
//
//    func kindEquivalent(_ k2: Kind) -> Bool {
//        switch gtype {
//        case .gScalar(let pt):
//            if case .gScalar(let pt2) = k2.gtype {
//                return pt == pt2
//            }
//            return false
//        case .gArray(let k, let i):
//            if case .gArray(let k2, let i2) = k2.gtype {
//                return i == i2 && k.kindEquivalent(k2)
//            }
//            return false
//        case .gSlice(let k):
//            if case .gSlice(let k2) = k2.gtype {
//                return k.kindEquivalent(k2)
//            }
//            return false
//        case .gMap(let k):
//            if case .gMap(let k2) = k2.gtype {
//                return k.kindEquivalent(k2)
//            }
//            return false
//        case .gTuple(let ka):
//    
//        if case .gTuple(let ka2) = k2.gtype {
//    
//            return ka.elementsEqual(ka2) {
//                $0.kindEquivalent($1)
//            }
//        }
//            return false
//        case .gPointer:
//        return false
//        }
//    }
//
//    enum Kinde {
//        case vt(Ptype.Type)
//        case k(Kind)
//        case km([Kind])
//
//        func getVt() -> Ptype.Type? {
//            if case .vt(let pw) = self {
//                return pw
//            }
//            return nil
//        }
//        func getK() -> Kind? {
//            if case .k(let ar) = self {
//                return ar
//            }
//            return nil
//        }
//        func getKm() -> [Kind]? {
//            if case .km(let map) = self {
//                return map
//            }
//            return nil
//
//        }
//    }
}
