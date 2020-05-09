class Kind {
    static func storeKind(_ s: String, _ k: Kind) throws {
        
    }
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

    private init(_ g: Gtype) {
        gtype = g
        if g.isPointer() {
            gtype = g.toFill(self)
        }
    }
    
    func assignable(_ k: Kind) -> Bool {
        if self === k {
            return true
        }
        if gtype.isPointer() && k === gOne.nkind {
            return true
        }
        return gtype.gAssignable(k.gtype, k)

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
        func hasKind(_ s: String) -> Bool {
            return km.keys.contains(s)
        }
        func getKind(_ s: String) throws -> Kind {
            return km[s]!
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
