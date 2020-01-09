enum Gtype {
    case gScalar(Ptype.Type)
    case gArray(Kind, Int)
    case gSlice(Kind)
    case gMap(Kind)
    case gPointer([Kind])
    func isPointer() -> Bool {
        if case .gPointer = self {
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
        case .gPointer:
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
            
        }
        
        
    }
    
    
    
}
