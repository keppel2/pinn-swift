
protocol Ptype {
    static func zeroValue() -> Ptype
    func equal(_: Ptype) -> Bool
}
protocol Ktype {}

protocol Plus: Ptype {
    func plus(_: Plus) -> Plus
}

protocol Negate: Ptype {
    func neg() -> Negate
}

protocol Arith: Ptype {
    func arith(_: Arith, _: String) -> Arith
}

protocol Compare: Ptype {
    func lt(_: Compare) -> Bool
    func gt(_: Compare) -> Bool
}
