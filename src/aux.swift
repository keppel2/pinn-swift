class Wrap <T> {
    var w: T
    init(_ x: T) {
        w = x
    }
}

struct Nil: Ptype, CustomStringConvertible {
    var description: String { return "N"}
    
    static func zeroValue() -> Ptype { Nil() }
    func equal(_ a: Ptype) -> Bool {
        return a is Nil
    }
}

struct Ref: Ptype, CustomStringConvertible {
    var description: String { return "R"}
    
    static func zeroValue() -> Ptype { Ref() }
    func equal(_ a: Ptype) -> Bool {
        return a is Ref
    }
}
