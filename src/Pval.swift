import Antlr4

class Pval {
    private var e: Pvalp
    var const = false
    var pv: Pvisitor?
    private init(_ x: Pvalp) {
        e = x
    }
    init(_ p: Pval, _ c: Bool? = false) {
        e = p.e
        if let cc = c {
            const = cc
        }
    }

    init(_ c: ParserRuleContext, _ ar: [Pval], _ sp: Bool, _ k: Kind? = nil) throws {
        if let ki = k
        {
            if (try ar.contains {
                try !$0.gg().gEquivalentSym(ki.gtype)
                }) {
            throw Perr(ETYPE, c)
            }
        let k2 = sp ? try Kind.produceKind(Gtype.gSlice(ki)) : try Kind.produceKind(Gtype.gArray(ki, ar.count))

        e = Pvalp(k2, .multi(Wrap(ar)), c)
        } else {
            
            
        let ka = ar.map { $0.getKind() }
//        if pointer {
//            let gt = Gtype.gPointer(ka)
//        }
        let ki = try Kind.produceKind(sp ? Gtype.gPointer(ka) : Gtype.gTuple(ka))
//        if sp {
//            for value in ar {
//                if value.getKind() === gOne.nkind {
//                    throw Perr(ENIL)
//                }
//            }
//        }
        e = Pvalp(ki, .multi(Wrap(ar)), c)

        }
    }

    
    init(_ c: ParserRuleContext, _ a: Ptype) {
        let w = Pwrap(a)
        let k = try! Kind.produceKind(Gtype.gScalar(type(of: a)))
        e = Pvalp(k, .single(w), c)
    }
    init( _ c: ParserRuleContext, _ kx: Kind, _ pv: Pvisitor? = nil) throws {
        self.pv = pv
        let ke = try kx.sk()
        switch ke.gtype {
        case .gSlice:
            e = Pvalp(ke, Contents.multi(Wrap([Pval]())), c)
        case .gArray(let k2, let i):
            var ar = [Pval]()
            for _ in 0..<i {
                try ar.append(Pval(c, k2))
            }
            e = Pvalp(ke, Contents.multi(Wrap(ar)), c)
        case .gMap:
            let m = [String: Pval]()
            e = Pvalp(ke, Contents.map(Wrap(m)), c)
        case .gScalar(let pt):
            let se = Pwrap(pt.zeroValue())
            e = Pvalp(ke, Contents.single(se), c)
        case .gTuple(let ka):
            var ar = [Pval]()
            for x in ka {
                try ar.append(Pval(c, x))
            }
            e = Pvalp(ke, Contents.multi(Wrap(ar)), c)
        case .gPointer:
            e = Pvalp(ke, Contents.multi(Wrap([Pval]())), c)
        case .gStructure(let osk):
            var m = [String: Pval]()
            for (str, ki) in osk {
                m[str] = try Pval(c, ki)
            }
            e = Pvalp(ke, Contents.map(Wrap(m)), c)
            
        case .gDefined(let s):
            aden()
//            let pv = try Pval(c, Kind.getPKind(s))
//            e = Pvalp(ke, pv.e.con, c)
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
        if try !getKind().equivalent(p.getKind()) {
            throw Perr(ETYPE, self)
        }
        
        if case .gSlice = getKind().gtype {
            return e === p.e
        }
        if case .gPointer = getKind().gtype {
//            return try e.con.pEqual(p.e.con)
            if p.gg().isNilPointer() {
                return e.con.getAr().count == 0
            }
            return e === p.e
            //            pv.w.append(v)
        }
        if case .gMap = gg() {
            return e === p.e
        }
        
        
        return try e.con.equal(p.e.con)
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
        let g = try getKind().gtype.toPGtype()
        switch k {
        case let v1v as Int:
            switch g {
            case .gScalar(let pt):
                if lh {
                    throw Perr(ECONST, self)
                }
                if pt != String.self {
                    throw Perr(ETYPE, self)
                }
                let str = e.con.getPw().unwrap() as! String
                if v1v < 0 || v1v >= str.count {
                    throw Perr(ERANGE, self)
                }
                let start = str.index(str.startIndex, offsetBy: v1v)
                let end = str.index(str.startIndex, offsetBy: v1v + 1)
let newstr = str[start..<end]
                
                return Pval(e.prc, String(newstr))
            
                
                
                
            case .gSlice(let k):
                if lh && v1v == e.con.count() {
//                    if const {
//                        throw Perr(ECONST)
//                    }
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
//                if g.isArray() {
//                    return try e.con.getAr()[v1v].cloneIf()
//                } else {
//                if !lh {
//                    let pv = try e.con.getAr()[v1v]//.cloneIf()
//                    return pv
//                } else {
                    let pv = e.con.getAr()[v1v]
//                if const {
//                    pv.const = true
//                }
                    return pv
//            }
            default:
                throw Perr(ETYPE, self)
            }
        case let v1v as String:
            if case .gMap(let k) = g {
                if e.con.getMap()[v1v] == nil {
                    if lh {
//                        if const {
//                            throw Perr(ECONST)
//                        }
                        try e.con.setCon(v1v, Pval(e.prc, k))
                    } else {
                        return try Pval(e.prc, k)
                    }
                }
                let pv = e.con.getMap()[v1v]!
                if const {
                pv.const = true;
                }
                return pv
            } else  if case .gStructure(let osk) = g {
                let pv = e.con.getMap()[v1v]!
                if const {
                pv.const = true;
                }
                return pv
            } else {
                throw Perr(ETYPE, self)
            }
        default:
            de(ECASE)
        }
    }
    
    
    func setPV(_ v : Pval) throws {
        if const {
            throw Perr(ECONST, self)
        }
        let b = try getKind().gtype.gEquivalent(v.gg())


        if !b {
            throw Perr(ETYPE, v)
        }
        v.e.k = e.k
        try v.gFix()
//        if v.getKind().gtype.isNilSlice() {
//            e.con = v.e.con
//        } else
//        if v.getKind().gtype.isNil() {
//            if !getKind().gtype.isPointer() {
//                e.con = Contents.multi(Wrap([Pval]()))
//            } else {
//            e.con = v.e.con
//            }
//        } else {
//        try e.con = v.e.con
        e = v.e
    }
    
    func delKey(_ s: String) throws {
        if const {
            throw Perr(ECONST, self)
        }
        if case .gMap = getKind().gtype {
            e.con.setCon(s, nil)
            return
        }
        throw Perr(ETYPE, self)
    }
    
    func set(_ k: Ktype, _ v: Pval) throws {
        if const {
            throw Perr(ECONST, self)
        }
     
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
    
    func gFix() throws {
        
        

                switch gg() {
        case .gScalar(let pt):
break
        case .gArray(let k, let i):
            try e.con.getAr().forEach {
                $0.e.k = k
                try $0.gFix()
            }
        case .gSlice(let k):

            
            
            
            try e.con.getAr().forEach {
                $0.e.k = k
                try $0.gFix()
            }
        case .gMap(let k):

             for (k2, v) in e.con.getMap() {
                v.e.k = k
                try v.gFix()
                
             }
                                
        case .gStructure(let osk):
                    for (k, v) in e.con.getMap() {
                        v.e.k = osk[k]!
                        try v.gFix()
                    }
        case .gPointer(let ka):

           let pva = e.con.getAr()
           if pva.count == 0 {
            return
           }
            for (k, v) in ka.enumerated() {
                if try v.gtype.toPGtype().isRef() {
                    pva[k].e.k = Kind(gg())

                } else {
                pva[k].e.k = v
                }
                try pva[k].gFix()
                
            }
        case .gTuple(let ka):
            let pva = e.con.getAr()
            for (k, v) in ka.enumerated() {
                pva[k].e.k = v
                try pva[k].gFix()
            }
            

                        case .gDefined(let s):
                            e.k = try Kind.getPKind(s)
                            try gFix()
            
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
    func gg() -> Gtype {
        return e.k.gtype
    }
    func stringOrLetter() throws -> String {
        if try getKind().gtype.isPointer() && e.con.getAr().count != 0 {
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
//        resolve()
        switch e.con {
        case .single(let pw):
            if getKind().gtype.isPointer() {
                aden()
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
            switch getKind().gtype {
            case .gMap:
                return Pval(self)
            case .gStructure(let osk):
                var sv = [String: Pval]()
                for (k, v) in e.con.getMap() {
                    sv[k] = try v.cloneIf()
                }
                let con = try Contents.map(Wrap(sv))
                let pvp = Pvalp(Kind(Gtype.gStructure(osk)), con, e.prc)
                return Pval(pvp)
            default:
                aden()
            }
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
                    if try !value.equal(omap[key]!) {
                        return false
                    }
                }
                return true
//                aden()
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
