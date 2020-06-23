enum Gtype {
    case gScalar(Ptype.Type)
    case gArray(Kind, Int)
    case gSlice(Kind)
    case gMap(Kind)
    case gTuple([Kind])
    case gPointer([Kind])
    case gDefined(String)
    func isValid() -> Bool {
        switch self {
        case .gScalar:
            return true
        case .gArray(let k, let x):
            _ = x
            return !k.isNr()
        case .gSlice(let k), .gMap(let k):
            return !k.isNr()
        case .gTuple://(let ka):
            return true
//            !ka.contains {
//                $0 === gOne.rkind
//            }
        case .gPointer, .gDefined:
            return true
        
        }
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
    func toFill(_ k: Kind) -> Gtype {
        if case .gPointer(let ka) = self {
            let ka2: [Kind] = ka.map {
                if $0 === gOne.rkind || $0 === gOne.nkind {
                    return k
                }
                return $0
            }
            return Gtype.gPointer(ka2)
        }
        aden()
    }
//    func refMatch(_ k: Kind) -> Bool {
//        if case .gPointer(let ka) = self {
//            
//        }
//    }
    func openString() -> String {
        switch self {
        case .gArray, .gSlice:
            return "["
        case .gMap:
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
        case .gMap:
            return "}"
        case .gPointer, .gTuple:
            return ")"
        default:
            aden()
        }
    }
    func toPGtype() -> Gtype {
        if case .gDefined(let s) = self {
            return Kind.getPKind(s).gtype
        }
        return self
    }
    func toPGR() -> Gtype {
        switch self {
        case .gScalar:
            return self
            
        case .gArray(let k, let i):
            return Gtype.gArray(Kind(k.gtype.toPGR()), i)
        case .gSlice(let k):
            return Gtype.gSlice(Kind(k.gtype.toPGR()))
        case .gMap(let k):
            return Gtype.gMap(Kind(k.gtype.toPGR()))

            
        case .gPointer(let ka):
            return Gtype.gPointer(ka.map { Kind($0.gtype.toPGR())})

        case .gTuple(let ka):
            return Gtype.gTuple(ka.map { Kind($0.gtype.toPGR())})
            
        case .gDefined(let s):
            return Kind.getPKind(s).gtype.toPGR()
        }
        
        
        
        
        
        
        
        
        
    }
    func gAssignable(_ gB: Gtype, _ ik: Kind)  -> Bool {
        let gA = self//.toPGtype()
        let g2 = gB//.toPGtype()
        switch gA {
        case .gScalar(let pt):
            if case .gScalar(let pt2) = g2 {
                return pt == pt2
            }
            return false
        case .gArray(let k, let i):
            if case .gArray(let k2, let i2) = g2 {
                return i == i2 && k.assignable(k2)
            }
            return false
        case .gSlice(let k):
            if case .gSlice(let k2) = g2 {
                return k.assignable(k2)
            }
            return false
        case .gMap(let k):
            if case .gMap(let k2) = g2 {
                return k.assignable(k2)
            }
            return false
            
        case .gPointer(let ka):
            if case .gPointer(let ka2) = g2 {
                
                return ka.elementsEqual(ka2) {
                    if $0.gtype.isPointer() {
                        if $1 === ik {
                            return true
                        }
                    }
                    return $0.assignable($1)
                }
            }
            return false
            
            
        case .gTuple(let ka):
            if case .gTuple(let ka2) = g2 {
                
                return ka.elementsEqual(ka2) {
                    $0.assignable($1)
                }
            }
            return false
        case .gDefined:
            aden()
        }
        
    }
  
    
    
//    func hasNil(_ k: Kind) -> Bool {
//        switch self {
//        case .gScalar(let pt):
//            return pt == Nil.self
//        case .gArray(let k, let i):
//            if case .gArray(let k2, let i2) = g2 {
//                return i == i2 && k === k2
//            }
//            return false
//        case .gSlice(let k):
//            if case .gSlice(let k2) = g2 {
//                return k === k2
//            }
//            return false
//        case .gMap(let k):
//            if case .gMap(let k2) = g2 {
//                return k === k2
//            }
//            return false
//            
//        case .gPointer(let ka):
//            if case .gPointer(let ka2) = g2 {
//                return ka.elementsEqual(ka2) {
//                    if $1 === gOne.rkind {
//                        return $0 === k
//                    }
//                    return $0 === $1
//                }
//            }
//            return false
//        case .gTuple(let ka):
//            if case .gTuple(let ka2) = g2 {
//                
//                return ka.elementsEqual(ka2) {
//                    $0 === $1
//                }
//            }
//            return false
//        }
//    }
    
    func gEquivalent(_ g2: Gtype, _ k: Kind) -> Bool {
        switch self {
        case .gScalar(let pt):
            if case .gScalar(let pt2) = g2 {
                return pt == pt2
            }
            return false
        case .gArray(let k, let i):
            if case .gArray(let k2, let i2) = g2 {
                return i == i2 && k === k2
            }
            return false
        case .gSlice(let k):
            if case .gSlice(let k2) = g2 {
                return k === k2
            }
            return false
        case .gMap(let k):
            if case .gMap(let k2) = g2 {
                return k === k2
            }
            return false
            
        case .gPointer(let ka):
            if case .gPointer(let ka2) = g2 {
                return ka.elementsEqual(ka2) {
                    if $1 === gOne.rkind {
                        return $0 === k
                    }
                    return $0 === $1
                }
            }
            return false
        case .gTuple(let ka):
            if case .gTuple(let ka2) = g2 {
                
                return ka.elementsEqual(ka2) {
                    $0 === $1
                }
            }
            return false
            
                        case .gDefined(let s):
aden()
            
        }
    }
}
