import Antlr4

class Pval {
    private var e: Pvalp

    init(_ p: Pval) {
        e = p.e
    }
    
    init(_ c: ParserRuleContext, _ ar: [Pval], _ k: Kind) throws {
        if (try ar.contains {
            try $0.getKind() !== k
        }) {
            throw Perr(ETYPE, c)
        }
        let k2 = Kind.produceKind(Gtype.gSlice(k))
        e = Pvalp(k2, .multi(Wrap(ar)), c)
    }
    
    init(_ c: ParserRuleContext, _ ar: [Pval]) throws {
        //                          prc = c
        let mar = ar
        let ka = try ar.map { try $0.getKind() }
        let k = Kind.produceKind(Gtype.gTuple(ka))
//        let k = try Kind(ka)
//        for (key, value) in mar.enumerated() {
//            if try value.getKind().isOneNil() {
//                mar[key].e.k = k
//            }
//        }
//        k.count = nil
        e = Pvalp(k, .multi(Wrap(mar)), c)
    }
    
    init(_ c: ParserRuleContext, _ a: Ptype) {
        let w = Pwrap(a)
        let k = Kind.produceKind(Gtype.gScalar(type(of: a)))
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
            
        case .gPointer:
aden()
        case .gScalar(let pt):
            let se = Pwrap(pt.zeroValue())
            e = Pvalp(k, Contents.single(se), c)
        case .gTuple(let ka):
            var ar = [Pval]()
            for x in ka {
                try ar.append(Pval(c, x))
            }
            e = Pvalp(k, Contents.multi(Wrap(ar)), c)
            break
        }
    }
    
    
    convenience init( _ c: ParserRuleContext, _ pv: Pval, _ a: Int, _ b: Int) throws {
        switch try pv.getKind().gtype {
        case .gSlice(let k):
                    try self.init(c, Kind.produceKind(Gtype.gSlice(k)))
                    e.con = .multi(Wrap(try pv.e.con.getSlice(a, b)))
        case .gArray(let k, let i):
            try self.init(c, Kind.produceKind(Gtype.gSlice(k)))
            e.con = .multi(Wrap(try pv.e.con.getSlice(a, b)))

               default:
                throw Perr(ETYPE, pv)
                
                }
        
    }
    

    var prc: ParserRuleContext {e.prc}
    func equal(_ p: Pval) throws -> Bool {
        
        ade(getKind() === p.getKind())
        return try e.con.equal(p.e.con)
    }
    
    func getUnwrap() throws -> Ptype {
        return try get().unwrap()
    }
    private func get() throws -> Pwrap {
//        ade(try getKind().gtype == .gScalar)
        return e.con.getPw()
    }
    func hasKey(_ s: String) throws -> Bool {
//        if try getKind().gtype != .gMap {
//            throw Perr(ETYPE, self)
//        }
        if case .gMap = getKind().gtype {
           return e.con.getMap()[s] != nil
        }
        throw Perr(ETYPE, self)

    }
    func getKeys() -> [String] {
        return [String](e.con.getMap().keys)
    }
    
    private func getNewChild() throws  -> Pval {
        if case .gMap(let k) = try getKind().gtype {
            return try Pval(e.prc, k)
        } else {
            throw Perr(ETYPE, self)
        }
    }
    
    func get(_ k: Ktype, _ lh: Bool = false) throws -> Pval {
        switch k {
        case let v1v as Int:
            switch try getKind().gtype {
            case .gSlice(let k):
                if lh && v1v == e.con.count() {
                    try e.con.appendCon(Pval(e.prc, k))
                }
                fallthrough
            case .gArray, .gTuple, .gPointer:
                if !e.con.getAr().indices.contains(v1v) {
                    throw Perr(ERANGE, self)
                }
                return e.con.getAr()[v1v]
            default:
                throw Perr(ETYPE, self)
            }
        case let v1v as String:
            if case .gMap(let k) = getKind().gtype {

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
        if getKind() !== v.getKind() {
            throw Perr(ETYPE, v)
        }
        e = v.e
    }
    
    func delKey(_ s: String) {
        e.con.setCon(s, nil)
    }
    
    func set(_ k: Ktype, _ v: Pval) throws {
        
//        ade(try getKind().gtype != .gScalar)
        
//        switch try getKind().gtype {
//        case .gArray, .gSlice, .gMap:
//
////            if try !getKind().cKind().kindEquivalent(try v!.getKind().cKind()) {
////                throw Perr(ETYPE, self)
////            }
//        default:
//            let index = k as! Int
//
////            if try !getKind().aKind()[index].kindEquivalent(try v!.getKind().aKind()[index]) {
////                throw Perr(ETYPE, self)
////            }
//        }
//
//
//
//
        switch k {
        case let v1v as Int:

//            if case .gSlice = try getKind().gtype {
//
//            }
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
        
        switch try getKind().gtype {
        case .gSlice, .gTuple, .gArray:
            return e.con.getAr().count
        case .gMap:
            return e.con.getMap().count
        default:
            throw Perr(ETYPE, self)
        }
    }
    func getKind() -> Kind {
        return e.k
//        let k = e.k
//
//               switch e.con {
//                case .single:
////                    if e.k.gtype != .gScalar{
////                        throw Perr(EASSERT, self)
////                    }
//                    return k
//                case .multi(let ar):
//                    k.count = ar.w.count
//                case .map(let m):
//                    k.count = m.w.count
//        //            de(ECASE)
//                }

        
        
        
        
        
        

//        
//        switch e.con {
//        case .single(let pw):
//            if e.k.gtype != .gScalar{
//                throw Perr(EASSERT, self)
//            }
//            return Kind(type(of:pw.unwrap()))
//        case .multi(let ar):
//            switch e.k.gtype {
//            case .gArray, .gSlice:
//                if ar.w.count == 0 {
//                    return k
//                }
//                return try ar.w.first!.getKind()
//            case .gTuple, .gPointer:
//                let ka = try ar.w.map { try $0.getKind() }
//                return try Kind(ka)
//            default:
//                de(ECASE)
//            }
//        case .map:
//            return k
////            de(ECASE)
//        }

        

    }
    
    
    
    func stringOrLetter() throws -> String {
//        if try getKind().isPointer() {
//            if try e.con.isNull() {
//                return "E"
//            } else {
//                return "P"
//            }
//        }
        return try string(false)
    }
    func string(_ follow: Bool) throws -> String {
        switch e.con {
        case .single(let pw):
            return pw.string()
        case .multi(let ar):
            
            
            
            var rt = ""
            rt += try getKind().gtype.openString()
            if ar.w.count > 0 {
                if true {//try follow || getKind().gtype != .gPointer {
                    rt += try ar.w.first!.string(follow)
                    for v in ar.w[1...] {
                        rt += try " " + v.string(follow)
                    }
                } else {
                    rt += try ar.w.first!.stringOrLetter()
                    for v in ar.w[1...] {
                        rt += try " " + v.stringOrLetter()
                    }
                    
                }
            }
            rt += try getKind().gtype.closeString()
            
            return rt
        case .map(let map):
            var rt = ""
            rt += try getKind().gtype.openString()
            var inner = ""
            var keys = getKeys()
            keys.sort()
            for key in keys {
                if inner != "" {
                    inner += " "
                }
                inner += try key + ":" + map.w[key]!.string(follow)
            }
            rt += inner
            
            rt += try getKind().gtype.closeString()
            return rt
            
        }
    }
    
    
    
    func cloneIf() throws -> Pval {
        return Pval(self)
//        switch e.con {
//        case .single(let pw):
//            return Pval(e.prc, pw.clone().unwrap())
//        case .multi(let ar):
//
//            if try getKind().gtype == .gSlice || getKind().gtype == .gPointer {
//                return Pval(self)}
//            if try getKind().gtype == .gArray {
//                return try Pval(e.prc, ar.w.map { try $0.cloneIf() }, getKind())
//            } else {
//                return try Pval(e.prc, ar.w.map {try $0.cloneIf()})
//            }
//        case .map:
//            return Pval(self)
//        }
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
    
    
    
    
    
    
    fileprivate class Pwrap {
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
        init(_ c: Contents) {
            switch c {
                
            case .multi(let pv):
                self = .multi(pv)
            case .map(let ma):
                self = .map(ma)
            case .single(let s):
                self = .single(s)
            }
        }
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







