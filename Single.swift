class Single {
    let nkind: Kind
    let rkind: Kind
    fileprivate init() {
        try! nkind = Kind.produceKind(Gtype.gScalar(Nil.self))
        try! rkind = Kind.produceKind(Gtype.gScalar(Ref.self))
    }
}

let gOne = Single()
