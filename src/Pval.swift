import Antlr4

class Pval {
    private var e: Pvalp
    private init(_ x: Pvalp) {
        e = x
    }
    init(_ p: Pval) {
        e = p.e
    }

    init(_ c: ParserRuleContext, _ ar: [Pval], _ k: Kind, _ td: Bool) throws {
        if (ar.contains {
            !$0.getKind().equivalent(k)
            }) {
            throw Perr(ETYPE, c)
        }
        let k2 = td ? try Kind.produceKind(Gtype.gSlice(k)) : try Kind.produceKind(Gtype.gArray(k, ar.count))

        e = Pvalp(k2, .multi(Wrap(ar)), c)
    }
    
    init(_ c: ParserRuleContext, _ ar: [Pval], _ pointer: Bool) throws {
        let ka = ar.map { $0.getKind() === gOne.nkind ? gOne.rkind : $0.getKind() }
//        if pointer {
//            let gt = Gtype.gPointer(ka)
//        }
        let k = try Kind.produceKind(pointer ? Gtype.gPointer(ka) : Gtype.gTuple(ka))
        if pointer {
            for value in ar {
                if value.getKind() === gOne.nkind {
                    value.e.k = k
                }
            }
        } else {
            if (ar.contains {
                $0.getKind() === gOne.nkind
            }) {
              //  throw Perr(ENIL)
            }
        }
        e = Pvalp(k, .multi(Wrap(ar)), c)
    }
    
    init(_ c: ParserRuleContext, _ a: Ptype) {
        let w = Pwrap(a)
        let k = try! Kind.produceKind(Gtype.gScalar(type(of: a)))
        e = Pvalp(k, .single(w), c)
    }
    init( _ c: ParserRuleContext, _ k: Kind) throws {
        switch k.gtype {
        case .gSlice:
            e = Pvalp(k, Contents.multi(Wrap([Pval]())), c)
        case .gArray(let k2, let i):
            var ar = [Pval]()
            for _ in 0..<i {
                try ar.append(Pval(c, k2))
            }
            e = Pvalp(k, Contents.multi(Wrap(ar)), c)
        case .gMap:
            let m = [String: Pval]()
            e = Pvalp(k, Contents.map(Wrap(m)), c)
        case .gScalar(let pt):
            let se = Pwrap(pt.zeroValue())
            e = Pvalp(k, Contents.single(se), c)
        case .gTuple(let ka):
            var ar = [Pval]()
            for x in ka {
                try ar.append(Pval(c, x))
            }
            e = Pvalp(k, Contents.multi(Wrap(ar)), c)
        case .gPointer:
            e = Pvalp(k, Contents.single(Pwrap(Nil())), c)
        case .gDefined(let s):
            let pv = try Pval(c, Kind.getKind(s))
            e = Pvalp(k, pv.e.con, c)
        }
    }
        
    convenience init( _ c: ParserRuleContext, _ pv: Pval, _ a: Int, _ b: Int) throws {
        switch pv.getKind().gtype {
        case .gSlice(let k):
            try self.init(c, Kind.produceKind(Gtype.gSlice(k)))
            e.con = .multi(Wrap(try pv.e.con.getSlice(a, b)))
        case .gArray(let k, let x):
            _ = x
            try self.init(c, Kind.produceKind(Gtype.gSlice(k)))
            e.con = .multi(Wrap(try pv.e.con.getSlice(a, b)))
        
        default:
            throw Perr(ETYPE, pv)
            
        }
        
    }
    var prc: ParserRuleContext {e.prc}
    func cloneType() throws -> Pval {
        let rt = try Pval(self.prc, self.e.k)
        try rt.setPV(self)
        return rt
    }
    func equal(_ p: Pval) throws -> Bool {
        if !getKind().equivalent(p.getKind()) {
            throw Perr(ETYPE, self)
        }
        
        
        if case .gPointer = getKind().gtype {
            return try e.con.pEqual(p.e.con)
//            pv.w.append(v)
        }
        
        return try e.con.equal(p.e.con)
    }
    func resolve() {
        if case .gDefined = getKind().gtype {
            e.k = Kind(e.k.gtype.toPGtype())
        }
    }
    func getUnwrap() throws -> Ptype {
        return try get().unwrap()
    }
    private func get() throws -> Pwrap {
        return e.con.getPw()
    }
    func hasKey(_ s: String) throws -> Bool {
        if case .gMap = getKind().gtype {
            return e.con.getMap()[s] != nil
        }
        throw Perr(ETYPE, self)
        
    }
    func getKeys() -> [String] {
        return [String](e.con.getMap().keys)
    }
    
    private func getNewChild() throws  -> Pval {
        if case .gMap(let k) = getKind().gtype {
            return try Pval(e.prc, k)
        } else {
            throw Perr(ETYPE, self)
        }
    }
    
    func get(_ k: Ktype, _ lh: Bool = false) throws -> Pval {
        let g = getKind().gtype.toPGtype()
        switch k {
        case let v1v as Int:
            switch g {
            case .gSlice(let k):
                if lh && v1v == e.con.count() {
                    try e.con.appendCon(Pval(e.prc, k))
                }
                fallthrough
            case .gArray, .gPointer, .gTuple:
                if try e.con.isNull() {
                    throw Perr(ENIL, self)
                }
                if !e.con.getAr().indices.contains(v1v) {
                    throw Perr(ERANGE, self)
                }
                return e.con.getAr()[v1v]
            default:
                throw Perr(ETYPE, self)
            }
        case let v1v as String:
            if case .gMap(let k) = g {
                if e.con.getMap()[v1v] == nil {
                    if lh {
                        try e.con.setCon(v1v, Pval(e.prc, k))
                    } else {
                        return try Pval(e.prc, k)
                    }
                }
                return e.con.getMap()[v1v]!
            } else {
                throw Perr(ETYPE, self)
            }
        default:
            de(ECASE)
        }
    }
    
    
    func setPV(_ v : Pval) throws {

        if !getKind().assignable(v.getKind()) {
            throw Perr(ETYPE, v)
        }
        
        e.con = v.e.con
    }
    
    func delKey(_ s: String) throws {
        if case .gMap = getKind().gtype {
            e.con.setCon(s, nil)
            return
        }
        throw Perr(ETYPE, self)
    }
    
    func set(_ k: Ktype, _ v: Pval) throws {
     
        switch k {
        case let v1v as Int:

            if v1v == e.con.count() {
                e.con.appendCon(v)
            } else {
                e.con.setCon(v1v, v)
            }
        case let v1v as String:
            e.con.setCon(v1v, v)
        default:
            de(ECASE)
        }
    }
    
    
    func getCount() throws -> Int {
        
        switch getKind().gtype {
        case .gSlice, .gPointer, .gArray, .gTuple:
            return e.con.getAr().count
        case .gMap:
            return e.con.getMap().count
        default:
            throw Perr(ETYPE, self)
        }
    }
    func getKind() -> Kind {
        return e.k
    }
    func stringOrLetter() throws -> String {
        if try getKind().gtype.isPointer() && !e.con.isNull() {
            return "P"
        }
        return try string()
    }
    func string() throws -> String {
        switch e.con {
        case .single(let pw):
            return pw.string()
        case .multi(let ar):
            var rt = ""
            rt += getKind().gtype.openString()
            if ar.w.count > 0 {
                rt += try ar.w.first!.stringOrLetter()
                for v in ar.w[1...] {
                    rt += try " " + v.stringOrLetter()
                }
            }
            rt += getKind().gtype.closeString()
            return rt
        case .map(let map):
            var rt = ""
            rt += getKind().gtype.openString()
            var inner = ""
            var keys = getKeys()
            keys.sort()
            for key in keys {
                if inner != "" {
                    inner += " "
                }
                inner += try key + ":" + map.w[key]!.stringOrLetter()
            }
            rt += inner
            rt += getKind().gtype.closeString()
            return rt
        }
    }
    
    func cloneIf() throws -> Pval {
        switch e.con {
        case .single(let pw):
            if getKind().gtype.isPointer() {
                return Pval(self)
            }
            return Pval(e.prc, pw.clone().unwrap())
        case .multi(let ar):
            switch getKind().gtype {
            case .gSlice, .gPointer:
                return Pval(self)
            case .gArray, .gTuple:
                let con = try Contents.multi(Wrap(ar.w.map { try $0.cloneIf() }))
                let pvp = Pvalp(e.k, con, e.prc)
                return Pval(pvp)
            default: aden()
            }
        case .map:
            return Pval(self)
        }
    }
    private class Pvalp {
        fileprivate var k: Kind
        fileprivate var con: Contents
        let prc: ParserRuleContext
        fileprivate init(_ k: Kind, _ con: Contents, _ prc: ParserRuleContext) {
            self.k = k
            self.con = con
            self.prc = prc
        }
    }
    
    private class Pwrap {
        private var wrapped: Ptype

        init(_ p: Ptype) {
            wrapped = p
        }
        func unwrap() -> Ptype {
            return wrapped
        }
        func clone() -> Pwrap {
            return Pwrap(wrapped)
        }
        func equal(_ a: Pwrap) -> Bool {
            return unwrap().equal(a.unwrap())
        }
        func string() -> String {
            return String(describing: wrapped)
        }
    }

    private enum Contents {
        case single(Pwrap)
        case multi(Wrap<[Pval]>)
        case map(Wrap<[String: Pval]>)
        func appendCon(_ v: Pval) {
            if case .multi(let pv) = self {
                pv.w.append(v)
            }
            else {
                de(ETYPE)
            }
        }
        func setCon(_ k: Ktype, _ v: Pval? = nil) {
            switch self{
            case .multi(let pv):
                pv.w[k as! Int] = v!
            case .map(let ma):
                ma.w[k as! String] = v
            case .single:
                de(ECASE)
            }
        }
        fileprivate func getPw() -> Pwrap {
            if case .single(let pw) = self {
                return pw
            }
            de(ECASE)
        }
        func getAr() -> [Pval] {
            if case .multi(let ar) = self {
                return ar.w
            }
            de(ECASE)
        }
        func getMap()  -> [String: Pval] {
            if case .map(let map) = self {
                return map.w
            }
            de(ECASE)
        }
        func isNull() throws -> Bool {
            return try equal(Contents.single(Pwrap(Nil())))
        }
        func pEqual(_ co: Contents) throws -> Bool {
            switch self {
            case .single(let pw):
                if case .multi(let x) = co {
                    _ = x
                    return false
                }
                return pw.equal(co.getPw())
            case .multi(let ar):
                if case .single(let x) = co {
                    _ = x
                    return false
                }
                return ar.w.elementsEqual(co.getAr(), by: {$0 === $1})
                        default:
            aden()
            }

          //  return false
        }
        func equal(_ co: Contents) throws -> Bool {
            switch self {
            case .single(let pw):
                if case .multi(let x) = co {
                    _ = x
                    return false
                }
                return pw.equal(co.getPw())
            case .multi(let ar):
                if case .single(let x) = co {
                    _ = x
                    return false
                }
                return try ar.w.elementsEqual(co.getAr(), by: {try $0.equal($1)})
            case .map(let map):
                let omap = co.getMap()
                for (key, value) in map.w {
                    if omap[key] == nil {
                        return false
                    }
                    if try !value.equal(omap[key]!) {
                        return false
                    }
                }
                return true
            }
        }
        func getSlice(_ a: Int, _ b: Int) throws -> [Pval] {
            if a == b {
                return [Pval]()
            }
            switch self {
            case .multi(let pvs):
                if !pvs.w.indices.contains(a) || !pvs.w.indices.contains(b - 1) {
                    throw Perr(ERANGE)
                }
                return Array(pvs.w[a..<b])
            default: de(ECASE)
            }
        }
        func count() -> Int {
            switch self {
            case .multi(let ar):
                return ar.w.count
            case .map(let map):
                return map.w.count
            case.single:
                return 1
            }
        }
    }
}
