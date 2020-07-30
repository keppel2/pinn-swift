class Kind {

//    static func getKind(_ s: String) throws -> Kind {
//        return try Kinds.ks.getKind(s)
//    }

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
    func sk() throws -> Kind {
        return try Kind(gtype.toPGtype())
    }
    func equivalent(_ k: Kind) throws -> Bool {
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
    

  
}
