enum Gtype {
    case gScalar(Ptype.Type)
    case gArray(Kind, Int)
    case gSlice(Kind)
    case gMap(Kind)
    case gTuple([Kind])
    case gPointer([Kind])
    func isValid() -> Bool {
        switch self {
        case .gScalar:
            return true
        case .gArray(let k, let x):
            _ = x
            return k !== gOne.nkind
        case .gSlice(let k), .gMap(let k):
            return k !== gOne.nkind
        case .gTuple(let ka):
            return !ka.contains {
                $0 === gOne.nkind
            }
        case .gPointer:
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
    
    func gEquivalent(_ g2: Gtype) -> Bool {
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
                    $0 === $1
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
        }
    }
}
