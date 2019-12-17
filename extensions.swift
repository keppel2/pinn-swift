import Foundation
extension Bool: Ptype, Ktype {
    static func zeroValue() -> Ptype { return false }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}
extension String: Ptype, Ktype, Plus, Compare {
    
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    static func zeroValue() -> Ptype { return "" }
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! String)
        return x
    }
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}


extension Int: Ptype, Ktype, Plus, Compare, Negate, Arith {
    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    
    static func zeroValue() -> Ptype { return 0 }
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! Self)
        return x
    }
    func neg() -> Negate {
        let x = 0 - self
        return x
    }
    
    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
    
    func arith(_ a: Arith, _ s: String) -> Arith {
        let lhv = self
        let rhv = a as! Self
        let x: Self
        switch s {
        case "-":
            x = lhv - rhv
        case "*":
            x = lhv * rhv
        case "/":
            x = lhv / rhv
        default: de(ECASE)
        }
        return x
    }
    
}

extension Decimal: Ptype, Plus, Compare, Arith, Negate {


    func lt(_ a: Compare) -> Bool {
        let x = self < a as! Self
        return x
    }
    
    func gt(_ a: Compare) -> Bool {
        let x = self > a as! Self
        return x
    }
    
    static func zeroValue() -> Ptype { return Decimal.init() }
    
    func neg() -> Negate {
        let x = 0 - self
        return x
    }
    
    func plus(_ a: Plus) -> Plus {
        let x = self + (a as! Self)
        return x
    }
    func arith(_ a: Arith, _ s: String) -> Arith {
        let lhv = self
        let rhv = a as! Self
        let x: Self
        switch s {
        case "-":
            x = lhv - rhv
        case "*":
            x = lhv * rhv
        case "/":
            x = lhv / rhv
        default: de(ECASE)
        }
        return x
    }

    func equal(_ a: Ptype) -> Bool {
        return self == a as! Self
    }
}

