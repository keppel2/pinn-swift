
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
