enum Gtype {
    case gScalar(Ptype.Type)
    case gArray(Kind, Int)
    case gSlice(Kind)
    case gMap(Kind)
    case gTuple([Kind])
    case gPointer([Kind])
    case gDefined(String)
    case gStructure([String: Kind])
    
    func isNilSlice() -> Bool {
        if case .gSlice(let k) = self {
            
            if case .gScalar(let pt) = k.gtype {
                return pt == Nil.self
            }
            
        }
        return false
    }
    func isNilPointer() -> Bool {
        if case .gPointer(let ka) = self {
            return ka.count == 0
        }
        return false
    }
    func isNilMap() -> Bool {
        if case .gMap(let k) = self {
            
            if case .gScalar(let pt) = k.gtype {
                return pt == Nil.self
            }
            
        }
        return false
    }
    func isNil() -> Bool {
        if case .gScalar(let pt) = self {
            
            
            
            return pt == Nil.self
        }
        return false
    }
    func isRef() -> Bool {
        if case .gScalar(let pt) = self {
            
            
            
            return pt == Ref.self
        }
        return false
    }
    func isPointer() -> Bool {
        if case .gPointer = self {
            return true
        }
        return false
    }
    func isTuple() -> Bool {
        if case .gTuple = self {
            return true
        }
        return false
    }
    func isArray() -> Bool {
        if case .gArray = self {
            return true
        }
        return false
    }
    
    func openString() -> String {
        switch self {
        case .gArray, .gSlice:
            return "["
        case .gMap, .gStructure:
            return "{"
        case .gPointer:
            return "*("
        case .gTuple:
            return "("
        default:
            aden()
        }
    }
    
    func closeString() -> String {
        switch self {
        case .gArray, .gSlice:
            return "]"
        case .gMap, .gStructure:
            return "}"
        case .gPointer, .gTuple:
            return ")"
        default:
            aden()
        }
    }
    func toPGtype(_ pvik: Pvisitor) throws -> Gtype {
        if case .gDefined(let s) = self {
            
            return try pvik.ks.getPkind(s).gtype
        }
        return self
    }
    
    //    func toSelf() throws -> Gtype {
    //        let g2 = try toPGtype()
    //        switch g2 {
    //        case .gScalar(let pt):
    //            return self
    //        case .gArray(let k, let i):
    //            return Gtype.gArray(Kind(k.gtype.toSelf()), i)
    //        case .gSlice(let k):
    //            return Gtype.gSlice(Kind(k.gtype.toSelf()))
    //        case .gMap(let k):
    //            return Gtype.gMap(Kind(k.gtype.toSelf()))
    //        case .gPointer(let ka):
    //            var ka2 = [Kind]()
    //            for k in ka {
    //                if k.gtype.isNilPointer() {
    //                    ka2.append(Kind(Gtype.gScalar(Ref.self)))
    //
    //                } else {
    //                    ka2.append(Kind(k.gtype.toSelf()))
    //                }
    //            }
    //            return Gtype.gPointer(ka2)
    //        case .gStructure(let osk):
    //            var osk2 = [String: Kind]()
    //                for (s, k) in osk {
    //                    osk2[s] = Kind(k.gtype.toSelf())
    //            }
    //            return Gtype.gStructure(osk2)
    //        case .gTuple(let ka):
    //        return Gtype.gTuple(ka.map{
    //            Kind($0.gtype.toSelf())
    //
    //        })
    //            case .gDefined(let s):
    //
    //        aden()
    //
    //
    //
    //
    //
    //
    //        }
    //    }
    //
    
    func gEquivalentSym(_ g: Gtype, _ pvik: Pvisitor) throws -> Bool {
        return try gEquivalent(g, pvik) || g.gEquivalent(self, pvik)
    }
    
    
    func gEquivalent(_ g2x: Gtype, _ pvik: Pvisitor) throws -> Bool {
        let g2 = try g2x.toPGtype(pvik)
        switch try self.toPGtype(pvik) {
        case .gScalar(let pt):
            if pt == Ref.self {
                if g2.isNilPointer() {
                    return true
                }
            }
            if case .gScalar(let pt2) = g2 {
                return pt == pt2
            }
            return false
        case .gArray(let k, let i):
            
            if case .gArray(let k2, let i2) = g2 {
                return try i == i2 && k.gtype.gEquivalent(k2.gtype, pvik)
            }
            return false
        case .gSlice(let k):
            if g2.isNilSlice() {
                return true
            }
            if case .gSlice(let k2) = g2 {
                return try k.gtype.gEquivalent(k2.gtype, pvik)
            }
            return false
        case .gMap(let k):
            if g2.isNilMap() {
                return true
            }
            if case .gMap(let k2) = g2 {
                return try k.gtype.gEquivalent(k2.gtype, pvik)
            }
            return false
        case .gPointer(let ka):
            if g2.isNilPointer() {
                return true
            }
            if case .gPointer(let ka2) = g2 {
                return try ka.elementsEqual(ka2) {
                    if try $0.gtype.toPGtype(pvik).isRef() {
                        if try $1.gtype.toPGtype(pvik).isRef() {
                            return true
                        }
                        return try self.gEquivalent($1.gtype, pvik)
                    } else {
                        return try $0.gtype.gEquivalent($1.gtype, pvik)
                    }
                }
            }
            return false
        case .gStructure(let osk):
            if case .gStructure(let osk2) = g2 {
                if osk.count != osk2.count {
                    return false
                }
                for (s, k) in osk {
                    if let sgt = osk2[s]?.gtype {
                        if try !k.gtype.gEquivalent(sgt, pvik) {
                            return false
                        }
                    } else {
                        return false
                    }
                }
                return true
                
            }
            return false
        case .gTuple(let ka):
            if case .gTuple(let ka2) = g2 {
                
                return try ka.elementsEqual(ka2) {
                    return try $0.gtype.gEquivalent($1.gtype, pvik)
                }
            }
            return false
        case .gDefined(_):
            aden()
            //                return Kind.getPKind(s).gtype.gEquivalent(g2)
        }
    }
}
