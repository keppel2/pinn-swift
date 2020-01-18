class Single {
    let nkind: Kind
    fileprivate init() {
        try! nkind = Kind.produceKind(Gtype.gScalar(Nil.self))
    }
}
let gOne = Single()
