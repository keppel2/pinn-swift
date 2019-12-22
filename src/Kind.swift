
import Foundation
import Antlr4

class Kind {
    private var ke: Kinde
    var gtype: Gtype
    var count: Int?
//    var kinds = [Kind]()
    init(_ k: Kind, _ gtype: Gtype, _ count: Int? = nil) {
        self.gtype = gtype
        switch gtype {
        case .gScalar, .gTuple, .gPointer:
            de(ECASE)
        case .gMap:
            ade(count == nil)
//            self.count = 0
            ke = .k(k)
        case .gArray, .gSlice:
            self.count = count!
            ke = .k(k)
        }
        self.assert()
    }
    init(_ ka: [Kind]) throws {
        gtype = .gTuple
        var kar = ka
        self.count = kar.count
        ke = .vt(Nil.self)
        for v in kar {
            if v.isPointer() {
                gtype = .gPointer
            }
            if v.isNil() {
                gtype = .gPointer
                v.gtype = .gPointer
            }
        }
        if gtype == .gPointer {
            for (k, v) in kar.enumerated() {
                if v.isPointer() {
                    if !v.isOneNil() {
                        if !kar.elementsEqual(v.ke.getKm()!, by: {$0.kindEquivalent($1)}) {
                            throw Perr(ETYPE)
                        }
                    }
                    kar[k] = self
                    
                }
            }
        }
        ke = .km(kar)
        self.assert()
    }
    init(_ vtype: Ptype.Type) {
        ke = .vt(vtype)
        gtype = .gScalar
//        count = 1
        self.assert()
    }


    func assert() {
        switch gtype {
        case .gScalar:
            ade(ke.getVt() != nil)
            ade(count == nil)
        case .gArray, .gSlice, .gMap:
            ade(ke.getK() != nil)
        case .gTuple, .gPointer:
            ade(ke.getKm() != nil)
//            for k in ke.getKm()! {
//                k.assert()
//            }
        }
    }
    

    func cKind() -> Kind {
        switch ke {
        case .vt(let vt):
            return Kind(vt)
        case .k(let k):
            return k
        default:
            de(ECASE)
        }
    }
    func tKind() -> Ptype.Type {
        return ke.getVt()!
    }
    func aKind() -> [Kind] {
        return ke.getKm()!
    }
    func isOneNil() -> Bool {
        return ke.getVt() == Nil.self
    }
    func isNil() -> Bool {
        return gtype == .gScalar && isOneNil()
    }
    func isPointer() -> Bool {
        return gtype == .gPointer
    }
    func isType(_ p: Ptype.Type) -> Bool {
        return gtype == .gScalar && ke.getVt()! == p
    }
    
    func kindEquivalent(_ k2: Kind) -> Bool {
        //     if isNil() && k2.isPointer() || isPointer() && k2.isNil() {
        if isOneNil() && k2.isPointer() || isPointer() && k2.isOneNil() {
            return true
        }
        if gtype != k2.gtype {
            return false
        }
        switch ke {
        case .vt(let vt):
            ade(gtype == .gScalar && k2.gtype == .gScalar)
            
            return k2.ke.getVt() != nil && vt == k2.ke.getVt()!
        case .k(let k):
            if k2.ke.getK() == nil {
                return false
            }
            switch gtype {
            case .gArray:
                return k.kindEquivalent(k2.ke.getK()!) && count == k2.count
            case .gMap, .gSlice:
                return k.kindEquivalent(k2.ke.getK()!)
            case .gTuple, .gScalar, .gPointer:
                de(ECASE)
            }
        case .km(let km):
            return k2.ke.getKm() != nil && km.elementsEqual(k2.ke.getKm()!, by: {
                if self === $0 && k2 === $1 {
                    return true
                }
                return $0.kindEquivalent($1)
            })
        }
    }
    
    private enum Kinde {
        case vt(Ptype.Type)
        case k(Kind)
        case km([Kind])
        
        func getVt() -> Ptype.Type? {
            if case .vt(let pw) = self {
                return pw
            }
            return nil
        }
        func getK() -> Kind? {
            if case .k(let ar) = self {
                return ar
            }
            return nil
        }
        func getKm() -> [Kind]? {
            if case .km(let map) = self {
                return map
            }
            return nil
            
        }
    }
}
