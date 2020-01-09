
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
    
    
    static func processKindList(_ kl: [Kind]) -> Kind {
        var isPointer = false
        for (index, value) in kl.enumerated() {
            if value === has(.gScalar(Nil.self)) {
                isPointer = true
            }
        }
        if isPointer {
            return produceKind(Gtype.gPointer(kl))
        }
        return produceKind(Gtype.gTuple(kl))
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
