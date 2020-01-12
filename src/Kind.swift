
import Foundation
import Antlr4

class Kind {
//    private var ke: Kinde
    var gtype: Gtype
//    var count: Int?
    static var kinds = [Kind]()
    static var nkind: Kind {
        return produceKind(Gtype.gScalar(Nil.self))
    }
//    init(_ k: Kind){
//        self.ke = k.ke
//        self.gtype = k.gtype
//        self.count = k.count
//    }
    private init(_ g: Gtype) {
        gtype = g
    }
    
    

    static func has(_ g: Gtype) -> Kind? {
        let ki = kinds.firstIndex {
            $0.gtype.gEquivalent(g)
        }
        guard ki != nil else {
            return nil
        }
        return kinds[ki!]
        
    }
    static func produceKind(_ g: Gtype) -> Kind {

//        if (kinds.contains {
//            $0 === k
//        }) {
//            return k
//        }
        
        let k = has(g)
        if k != nil {
            return k!
        }
        let k2 = Kind(g)

        kinds.append(k2)
        return k2
    }

    
    func assert() {

    }
    
    
    

    func hasSelf() -> Bool {

//        ade(gtype.isPointer())
        guard case .gPointer(let ka) = gtype  else {
            return false
        }
        return ka.contains {
            $0 === Kind.nkind
        }
        
    }
   
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

}
