
class Kinds {
    // static var ks = Kinds()
    var km = [String: Kind]()
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
    func getPkind(_ s: String) throws -> Kind {
        if km[s] == nil {
            throw Perr(EUNDECLARED)
        }
        var k = km[s]!
        while case .gDefined(let s2) = k.gtype {
            
            if km[s2] == nil {
                throw Perr(EUNDECLARED)
            }
            
            k = km[s2]!
        }
        return k
    }
    init() {}
}
