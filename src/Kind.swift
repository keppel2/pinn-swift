class Kind {
    static func clear() {
        Kinds.ks.clear()
    }
    static func storeKind(_ s: String, _ k: Kind) throws {
        try Kinds.ks.addKind(s, k)
    }

    static func getKind(_ s: String) throws -> Kind {
        return try Kinds.ks.getKind(s)
    }
    static func getPKind(_ s: String)  -> Kind {
        return Kinds.ks.getPkind(s)
    }
//    static func getDkind(_ s: String) throws -> Kind {
//        
//    }
    
    static func produceKind(_ g: Gtype) throws -> Kind {
        if !g.isValid() {
            throw Perr(ETYPE)
        }
        let k = Kinds.ks.has(g)
        if k != nil {
            return k!
        }
        let k2 = Kind(g)
        Kinds.ks.append(k2)
        return k2
    }
    var gtype: Gtype
    var str: String?

    private init(_ s: String) {
        gtype = Gtype.gScalar(Nil.self)
        str = s
    }

    init(_ g: Gtype) {
        gtype = g
        if g.isPointer() {
            gtype = g.toFill(self)
        }
    }
    
    func assignable(_ k: Kind)  -> Bool {
        if self === k {
            return true
        }
        
        if gtype.isPointer() && k === gOne.nkind {
            return true
        }
        return try gtype.gAssignable(k.gtype, k)

    }
    func equivalent(_ k: Kind) -> Bool {
        if self === k {
            return true
        }
        
        
        if gtype.isPointer() && k === gOne.nkind || self === gOne.nkind && k.gtype.isPointer() {
            return true
        }
        
        return false
    }
    func isNr() -> Bool {
        return self === gOne.nkind || self === gOne.rkind
    }
    func hasNil() -> Bool {
        if self === gOne.nkind {
            return true
        }
        return false //gtype.hasNil(self)
    }
    

    private class Kinds {
        fileprivate static var ks = Kinds()
        private var km = [String: Kind]()
        private var kd = [Kind]()
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
        func has(_ g: Gtype) -> Kind? {
            let ki = kd.firstIndex {
                
                $0.gtype.gEquivalent(g, $0)
            }
            guard ki != nil else {
                return nil
            }
            return kd[ki!]
        }
        func append(_ k: Kind) {
            kd.append(k)
        }
        private init() {}
    }
}
