class Kind {
    static func clear() {
        Kinds.ks.clear()
    }
    static func storeKind(_ s: String, _ k: Kind) throws {
        try Kinds.ks.addKind(s, k)
    }

//    static func getKind(_ s: String) throws -> Kind {
//        return try Kinds.ks.getKind(s)
//    }
    static func getPKind(_ s: String)  -> Kind {
        return Kinds.ks.getPkind(s)
    }
//    static func getDkind(_ s: String) throws -> Kind {
//        
//    }
    static func nilKind() -> Kind {
        return Kind(Gtype.gScalar(Nil.self))
    }
    static func nilSlice() -> Kind {
        return Kind(Gtype.gSlice(nilKind()))
    }
    static func nilMap() -> Kind {
        return Kind(Gtype.gMap(nilKind()))
    }
    static func nilPointer() -> Kind {
        return Kind(Gtype.gPointer([Kind]()))
    }
    static func emptyTuple() -> Kind {
        return Kind(Gtype.gTuple([Kind]()))
    }
    static func produceKind(_ g: Gtype) throws -> Kind {
//        if !g.isValid() {
//            throw Perr(ETYPE)
//        }
        return Kind(g)
    }
    var gtype: Gtype

    private init(_ s: String) {
        gtype = Gtype.gScalar(Nil.self)
    }

    init(_ g: Gtype) {
        gtype = g
    }
    
//    func assignable(_ k: Kind)  -> Bool {
//        return equivalent(k)
//        if self === k {
//            return true
//        }
//
//        if gtype.toPGtype().isPointer() && k === gOne.nkind {
//            return true
//        }
//        return try gtype.gAssignable(k.gtype, k)
//
//    }
    func sk() -> Kind {
        return Kind(gtype.toPGtype())
    }
    func equivalent(_ k: Kind) -> Bool {
//        if self === k {
//            return true
//        }
        
//
//        if gtype.isPointer() && k === gOne.nkind || self === gOne.nkind && k.gtype.isPointer() {
//            return true
//        }
        
        return try gtype.gEquivalent(k.gtype)
    }
//    func isNr() -> Bool {
//        return self === gOne.nkind
//    }
//    func hasNil() -> Bool {
//        if self === gOne.nkind {
//            return true
//        }
//        return false //gtype.hasNil(self)
//    }
//    static func isNil( _ s: String) -> Bool {
//        return Kinds.ks.isNil(s)
//    }
    

    private class Kinds {
        fileprivate static var ks = Kinds()
        private var km = [String: Kind]()
//        private var kset = Set<Kind>()
        func clear() {
            km = [String: Kind]()
        }
        func hasKind(_ s: String) -> Bool {
            return km.keys.contains(s)
        }
        func addKind(_ s: String, _ k: Kind) throws {
            if km.keys.contains(s) {
                throw Perr(EREDECLARE)
            }
            km[s] = k
        }
        
//                func isNil(_ s: String) -> Bool {
//                    return km[s] === gOne.nkind
//        }
        func getKind(_ s: String) throws -> Kind {
            return km[s]!
        }
        func getPkind(_ s: String) -> Kind {
            var k = km[s]!
            while case .gDefined(let s2) = k.gtype {
                k = km[s2]!
            }
            return k
        }
        private init() {}
    }
}
