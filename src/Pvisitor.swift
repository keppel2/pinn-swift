import Foundation
import Antlr4

class Pvisitor {
    
    static let litToType: [String: Ptype.Type] = ["int": Int.self, "bool": Bool.self, "string": String.self, "decimal": Decimal.self, "self": Ref.self]
    private static let builtIns
        : [String: (ParserRuleContext, Pvisitor, [Pval]) throws -> Pval?] =
        [
            "exit": { sctx, pv, s in
                try assertPvals(s, 0)
                exit(0)
            },
            "bad": { sctx, pv, s in
                try assertPvals(s, 0);
                throw Perr(EASSERTF, sctx);
                return nil
            },
            "at": { sctx, pv, s in
                try assertPvals(s, 1);
                let b: Bool = try tryCast(s[0]);
                if !b {
                    throw Perr(EASSERTF, sctx);
                }
                return nil
            },
            "nat": { sctx, pv, s in
                try assertPvals(s, 1);
                let b: Bool = try tryCast(s[0]);
                if b {
                    throw Perr(EASSERTF, sctx);
                }
                return nil
            },
            "assert": { sctx, pv, s in
                try assertPvals(s, 2)
                if !s[0].gg().gEquivalent(s[1].gg()) {
                    throw try Perr(ETYPE + " " + s[0].string() + " " + s[1].string(), sctx)
                }
                if try !s[0].equal(s[1]) {
                    throw try Perr(ETEST_FAIL + " " + s[0].string() + " " + s[1].string(), sctx)

                }
                return nil
            },
            "gn": { sctx, pv, s in
                try assertPvals(s, 0)

                if pv.trip {
                    throw Perr(ENEGTEST_FAIL, sctx)
                }
                return nil
            },
            "ng": { sctx, pv, s in try assertPvals(s, 1)
                    let str: String = try tryCast(s[0])
                if pv.trip {
                    throw Perr(ENEGTEST_FAIL, sctx)
                }
                try pv.reset()
                pv.trip = true
                pv.neg = str
                return nil
            },
            "xam": { sctx, pv, s in try assertPvals(s, 1)
                let str: String = try tryCast(s[0])
                let xa = pv.getPv(str)
                fatalError()
            },
            "xam2": { sctx, pv, s in try assertPvals(s, 2)
                let str1: String = try tryCast(s[0])
                let xa1 = pv.getPv(str1)
                let str2: String = try tryCast(s[1])
                let xa2 = pv.getPv(str2)
                fatalError()
            },
            "ft": { sctx, pv, s in try assertPvalIn(s, [1, 2])
                if pv.lfc != nil {
                    throw Perr(ESTATEMENT, sctx)
                }
                pv.trip = false
                try pv.reset()
                try pv.test()

                print("--", sctx.getStart()!.getLine())
                pv.li = pv.printed.endIndex
                let s1: String = try tryCast(s[0])
                let s2: String = s.count == 2 ? try tryCast(s[1]) : ""
                pv.tester = Tester(s1, s2)
                return nil
            },
            "len": { sctx, pv, s in try assertPvals(s, 1)
                if case .gScalar(let pt) = s[0].getKind().gtype {
                    if pt != String.self {
                        throw Perr(ETYPE, sctx)
                    }
                    return try Pval(sctx, (s[0].getUnwrap() as! String).count)
                }

                return try Pval(sctx, s[0].getCount())
            },
                            "stringValue":
                { sctx, pv, s in try assertPvals(s, 1)
                    return Pval(sctx, try s[0].string()) },
                            "sprint":
                                {
                                    sctx, pv, s in
                                        if s.count == 0 {
                                            throw Perr(EPARAM_LENGTH, sctx)
                                        }
                                        let rt = Pvisitor.printSpace(try s.map {try $0.string()})
                                        return Pval(sctx, rt)
            },
                            "sprintln":
                                                    {
                                                        sctx, pv, s in
                                                            if s.count == 0 {
                                                                throw Perr(EPARAM_LENGTH, sctx)
                                                            }
                                                            let rt = Pvisitor.printSpace(try s.map {try $0.string()})
                                                            return Pval(sctx, rt + "\n")
                                },
            "print":
                {sctx, pv, s in
                    if s.count == 0 {
                        throw Perr(EPARAM_LENGTH, sctx)
                    }
                    let rt = Pvisitor.printSpace(try s.map {try $0.string()})
                    pv.textout(rt)
                    return nil
            }, "rand":
                             { sctx, pv, s in try assertPvals(s, 1)
                let str: Int = try tryCast(s[0])
                                return Pval(sctx, Int.random(in: 0..<str))
            },
            "println":
                {sctx, pv, s in
                    if s.count == 0 {
                        throw Perr(EPARAM_LENGTH, sctx)
                    }

                    var rt = Pvisitor.printSpace(try s.map {try $0.string()})
                    pv.textout(rt + "\n")
                    return nil
            },
            "readLine": {
                sctx, pv, s in try assertPvals(s, 0)
                return Pval(sctx, readLine()!)
            },
            "delete": { sctx, pv, s in try assertPvals(s, 2)
                let kt: String = try tryCast(s[1])
                let rt = try s[0].hasKey(kt)
                try s[0].delKey(kt)
                return Pval(sctx, rt)
            },
            "key": { sctx, pv, s in try assertPvals(s, 2)
                let str: String = try tryCast(s[1])
                return Pval(sctx, try s[0].hasKey(str))
            },
            "debug": { sctx, pv, s in try assertPvals(s, 0)
                fatalError()
                //                return nil
            },
            "bi": { sctx, pv, s in try assertPvals(s, 2)
                var str: String = try tryCast(s[0])
                let xa1 = pv.getPv(str)!
                str = try tryCast(s[1])
                let xa2 = pv.getPv(str)!
                ade(xa1.getKind() === xa2.getKind())
                return nil
                
            },
            //            "sort": { sctx, s in assertPvals(s, 1)
            //                s[0].sort()
            //                return s[0]
            //            },
            "sleep": { sctx, pv, s in try assertPvals(s, 1)
                let x: Int = try tryCast(s[0])
                sleep(UInt32(x))
                return nil
            }
        ]
    

    private static func doOp(_ lhs: Pval, _ rhs: Pval, _ str: String, _ sctx: ParserRuleContext) throws -> Pval {
         let rt: Pval
         switch str {
         case "==":
             return Pval(sctx, try lhs.equal(rhs))
         case "!=":
             return Pval(sctx, try !lhs.equal(rhs))
             
         case "+":
             let lh: Plus = try tryCast(lhs)
             let rh: Plus = try tryCast(rhs)
             if !pEq(lh, rh) {
                 throw Perr(ETYPE, rhs)
             }
             rt = Pval(sctx, lh.plus(rh))
             return rt
         case "-", "*", "/":
             let lh: Arith = try tryCast(lhs)
             let rh: Arith = try tryCast(rhs)
             if !pEq(lh, rh) {
                 throw Perr(ETYPE, rhs)
             }
             
             rt = Pval(sctx, lh.arith(rh, str))
             return rt
         case "<", "<=", ">", ">=":
             let lh: Compare = try tryCast(lhs)
             let rh: Compare = try tryCast(rhs)
             if !pEq(lh, rh) {
                 throw Perr(ETYPE, rhs)
             }
             
             let result: Bool
             switch str {
                 
             case "<":
                 result = lh.lt(rh)
             case "<=":
                 result = lh.lt(rh) || lh.equal(rh)
             case ">":
                 result = lh.gt(rh)
             case ">=":
                 result = lh.gt(rh) || lh.equal(rh)
             default: de(ECASE)
             }
             return Pval(sctx, result)
         default: break
         }
        
        if str == "in" {
            switch rhs.gg() {
            case .gSlice(let t), .gArray(let t, let _):
                if !lhs.gg().gEquivalent(t.gtype) {
                    throw Perr(ETYPE, sctx)
                }
                                var result = false
                for x in try 0..<rhs.getCount() {
                    if try lhs.equal(rhs.get(x)) {
                        result = true
                        break
                    }
                }
                return Pval(sctx, result)

                
            default: aden()
            }
        }
         
         let lhsv: Int = try tryCast(lhs)
         var rhsv: Int = try tryCast(rhs)
         switch str {
         case "-":
             rt = Pval(sctx, lhsv - rhsv)
         case "*":
             rt = Pval(sctx, lhsv * rhsv)
         case "/":
             rt = Pval(sctx, lhsv / rhsv)
         case "%":
             rt = Pval(sctx, lhsv % rhsv)
         case "&":
             rt = Pval(sctx, lhsv & rhsv)
         case "|":
             rt = Pval(sctx, lhsv | rhsv)
         case "^":
             rt = Pval(sctx, lhsv ^ rhsv)
         case "<<":
             rt = Pval(sctx, lhsv << rhsv)
         case ">>":
             rt = Pval(sctx, lhsv >> rhsv)
         case "<":
             rt = Pval(sctx, lhsv < rhsv)
         case "<=":
             rt = Pval(sctx, lhsv <= rhsv)
         case ">":
             rt = Pval(sctx, lhsv > rhsv)
         case ">=":
             rt = Pval(sctx, lhsv >= rhsv)
         case "@":
             rhsv += 1
             fallthrough
         case ":":
             guard rhsv - lhsv >= 0 else {
                 throw Perr(ERANGE, sctx)
             }
             let ki = try Kind.produceKind(Gtype.gScalar(Int.self))
             rt = try Pval(sctx, Kind.produceKind(Gtype.gSlice(ki)))
             for x in lhsv..<rhsv {
                 try rt.set(x - lhsv, Pval(sctx, x))
             }
             
         default:
             de(ECASE)
         }
         return rt
     }
     
     
     private static func childToToken(_ child: Tree) -> PinnParser.Tokens {
         return PinnParser.Tokens(rawValue: (child as! TerminalNode).getSymbol()!.getType())!
     }
     private static func childToText(_ child: Tree) -> String {
         return (child as! TerminalNode).getText()
     }
    private static func assertPvals( _ s: [Pval], _ i: Int) throws {
        if s.count != i {
            throw Perr(EPARAM_LENGTH)
        }
    }
    private static func assertPvalIn( _ s: [Pval], _ ok: [Int]) throws {
        if !ok.contains(s.count) {
            throw Perr(EPARAM_LENGTH)
        }
    }
    private var aparser: PinnParser
    private var printed = ""
    private var tester: Tester?
    private var neg = ""
    private var li: String.Index
    var trip = false
    
    private var fc = Fc()
    private var lfc: Fc?
    var fkmap = [String:Fheader]()
    var apifkmap = [String:Fheader]()
    private var line = -1
    private var prc: ParserRuleContext?
    private var oldPrc: ParserRuleContext?
    private var cfc: Fc {return lfc ?? fc}

    init(_ ap: PinnParser) throws {
        aparser = ap
        li = printed.startIndex
        try reset()
    }

    
    private func test() throws {
        if let t = tester{
            let compee = printed[li..<printed.endIndex]
            if let bad = t.compare(String(compee)) {
                throw Perr(ETEST_FAIL + bad)
            }
        }
    }
    private func reset() throws {
        fc = Fc()
        lfc = nil
        fkmap = apifkmap //[String:Fheader]()
        
        Kind.clear()
        for str in Self.builtIns.keys {
            reserveFunction(str)
        }
        for (str, x) in Self.litToType {
            try Kind.storeKind(str, Kind.produceKind(Gtype.gScalar(x)))
        }
        
    }
    func removeReserved() {
        for str in Self.builtIns.keys {
            fkmap.removeValue(forKey: str)
        }
    }
    

    
    
    private func getPv(_ s: String)  -> Pval?  {
        for m in [lfc?.m, fc.m] {
            if m == nil {
                continue
            }
            if let v = m![s] {
                return v
            }
        }
        return nil
        
    }
 
    private func loadDebug(_ ctx:ParserRuleContext) {
        oldPrc = prc
        prc = ctx
        //        texts.append(ctx.getText())
        line = ctx.start!.getLine()
    }
    private func popDebug() {
        //        texts.removeLast()
        prc = oldPrc
    }
    
    private func reserveFunction(_ s: String) {
        if fkmap[s] != nil {
            de(EREDECLARE + s)
        }
        fkmap[s] = Fheader()
    }
    private static func printSpace(_ sa: [String]) -> String {
        var rt = ""
        guard sa.count > 0 else {
            return rt
        }
        rt += sa[0]
        for v in sa[1...] {
            rt += " " + v
        }
        return rt
    }
    private func callFunction(_ sctx: ParserRuleContext, _ str: String, _ s: [Pval]) throws -> Pval? {
        var rt: Pval?
        guard var fh = fkmap[str] else {
            throw Perr(EUNDECLAREDF, sctx)
        }
        
        
        
        
        if let fx = fh.kind {
            fh.kind = Kind(fx.gtype)
        }
                for (index, v) in fh.fkinds.enumerated() {
                    fh.fkinds[index].k = Kind(v.k.gtype)
        }
        
        
        guard let ctx = fh.funcContext else {
            return try Self.builtIns[str]!(sctx, self, s)
        }
        let oldfc = lfc
        lfc = Fc()
        
        if fh.fkinds.last != nil && fh.fkinds.last!.variadic {
            if s.count < fh.fkinds.count - 1 {
                throw Perr(EPARAM_LENGTH, sctx)
            }
        } else
            if s.count != fh.fkinds.count {
                throw Perr(EPARAM_LENGTH, sctx)
        }
        for (index, v) in fh.fkinds.enumerated() {
            if v.variadic {
                let par = try Pval(ctx, Kind.produceKind(Gtype.gArray(v.k, s.count - index)))
                
                for (key, varadds) in s[index...].enumerated() {
                    if !v.k.equivalent(varadds.getKind())  {
                                    throw Perr(ETYPE, sctx)
                    }
                    try par.set(key, varadds)
                }
                if lfc!.m[fh.fkinds[index].s] != nil {
                    throw Perr(EREDECLARE, sctx)
                }
                lfc!.m[fh.fkinds[index].s] = par//Pval(par)
                continue
            }
            if !s[index].getKind().equivalent(v.k) {
                throw Perr(ETYPE, sctx)
            }
            if let pv = lfc!.m[fh.fkinds[index].s]  {
                throw Perr(EREDECLARE, sctx, pv)
            }
            lfc!.m[fh.fkinds[index].s] = try Pval(s[index])//.cloneType()
        }
        try visit(ctx.block()!)
        switch lfc!.path {
        case .pBreak, .pContinue, .pFallthrough:
            throw Perr(ESTATEMENT, sctx)
        default: break
        }
        
        if let k = fh.kind {
            
            guard let rp = lfc!.rt else {
                throw Perr(ETYPE, sctx)
            }
            if !k.equivalent(rp.getKind())  {
                throw Perr(ETYPE, sctx)
            }
        } else {
            if lfc!.rt != nil {
                throw Perr(ETYPE, sctx)
            }
        }
        rt = lfc!.rt
        lfc = oldfc
        return rt
    }
    private func textout(_ outStr: String) {
        print(outStr, terminator: "")
        printed += outStr
    }
    
    
    public func visitFile(_ sctx: PinnParser.FileContext, _ api: Pvisitor? = nil) throws {

        
        for child in sctx.children! {
            if let spec = child as? PinnParser.FunctionContext {
                if trip {
                    do {
                         try visitHeader(spec)
                     } catch let err where err is Perr {
                         let perr = err as! Perr
                         if perr.str == ENEGTEST_FAIL {
                             perr.str += ", " + neg
                             throw perr
                         }
                         trip = false
                     }
                } else {
                    try visitHeader(spec)
                }
            } else {
                if let spec = child as? PinnParser.StatementContext {
                    if trip {
                        do {
                            try visit(spec)
                        } catch let err where err is Perr {
                            let perr = err as! Perr
                            if perr.str == ENEGTEST_FAIL {
                                perr.str += ", " + neg
                                throw perr
                            }
                            trip = false
                        }
                    } else {
                        try visit(spec)
                    }
                    switch fc.path {
                    case .pBreak, .pContinue, .pFallthrough:
                        throw Perr(ESTATEMENT, sctx)
                    case .pExiting:
                        if fc.rt != nil {
                            throw Perr(ETYPE, sctx)
                        }
                    case .pNormal: break
                        
                    }
                }
            }
        }
        //try test()
    }
    
    private func visitObjectPair(_ sctx: PinnParser.ObjectPairContext) throws -> (String, Pval) {
        loadDebug(sctx)
        defer {popDebug()}
        let rt1: String
        //let rt2: Pval
        if let s = sctx.ID() {
            rt1 = s.getText()
        } else {
            rt1 = stringDequote(sctx.STRING()!.getText())
        }
        let rt = try _visitPval(sctx.expr()!)
        return (rt1, rt)
    }
    
    private func visitStructurePair(_ sctx: PinnParser.StructurePairContext) throws -> (String, Kind) {
        loadDebug(sctx)
        defer {popDebug()}
        let rt1 = sctx.ID()!.getText()
        let rt2 = try visitKind(sctx.kind()!)
        return (rt1, rt2)
    }
    
    
    
    
    private func visitHeader(_ sctx:PinnParser.FunctionContext ) throws  {
        loadDebug(sctx)
        defer {popDebug()}
        if fkmap[sctx.ID()!.getText()] != nil {
            
            throw Perr(EREDECLARE, sctx)
        }
        var k: Kind?
        if let kctx = sctx.kind() {
            k = try visitKind(kctx)
//            if k === gOne.rkind {
//                throw Perr(ETYPE, sctx)
//            }
        }
        var fkinds = [FKind]()
        for (index, child) in sctx.fvarDecl().enumerated() {
            let vfks = try visitFKind(child)
            for vfk in vfks {
                if (fkinds.contains { fk in vfk.s == fk.s }) {
                    throw Perr(EREDECLARE, vfk.prc)
                }
                fkinds.append(vfk)
            }
            
        }
        for (k, fk) in fkinds.enumerated() {
            if fk.variadic && k != fkinds.indices.last {
               throw Perr(ETYPE, sctx)
            }
        }
        
        
        fkmap[sctx.ID()!.getText()] = Fheader(funcContext: sctx, kind: k, fkinds: fkinds)
    }
    
    
    private func visitKind(_ sctx: PinnParser.KindContext) throws -> Kind {
        loadDebug(sctx)
        defer {popDebug()}
        let rt: Kind
        if let spec = sctx.kindList() {
            let kL = try visitKindList(spec)
            if sctx.AST() != nil {
                rt = try Kind.produceKind(Gtype.gPointer(kL))
            } else {
                rt = try Kind.produceKind(Gtype.gTuple(kL))
            }
        } else
            if sctx.LPAREN() != nil {
                rt = try Kind.emptyTuple()
        } else
                if sctx.structurePair().count > 0 {
                    var stki = [String: Kind]()
                    for sp in sctx.structurePair() {
                        let (s, k) = try visitStructurePair(sp)
                        if stki.keys.contains(s) {
                            throw Perr(EREDECLARE, sctx)
                        }
                        stki[s] = k
                    }
                    rt = try Kind(Gtype.gStructure(stki))
                }
            else if let type = sctx.ID() {
                let strType = type.getText()
//                if Kind.isNil(strType) {
//                    rt = gOne.nkind
//                } else {
                rt = try Kind(Gtype.gDefined(strType))
                
            }
                else {
                let kind = try visitKind(sctx.kind()!)
                if sctx.MAP() != nil {
                    rt = try Kind.produceKind(Gtype.gMap(kind))
                } else if sctx.expr() != nil {
                      let v = try _visitPval(sctx.expr()!)
                    
                      let x: Int = try tryCast(v)
                      rt = try Kind.produceKind(Gtype.gArray(kind, x))

                }
                else {
                    rt = try Kind.produceKind(Gtype.gSlice(kind))
                }
        }
        return rt
    }
    private func visitFKind(_ sctx: PinnParser.FvarDeclContext) throws -> [FKind] {
        loadDebug(sctx)
        defer {popDebug()}
        
        
        let ai = try visitIdList(sctx.idList()!)
            let k = try visitKind(sctx.kind()!)
        
        
        var rt = [FKind]()
        for str in ai  {
            rt.append(FKind(k: k, s: str, variadic: sctx.THREEDOT() != nil, prc: sctx))
        }
        return rt
    }
    private func visitKindList(_ sctx: PinnParser.KindListContext) throws -> [Kind]
    {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = [Kind]()
        for child in sctx.kind() {
            let v = try visitKind(child)
            rt.append(v)
        }
        return rt
    }
    private func visitList(_ sctx: PinnParser.ExprListContext) throws -> [Pval] {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = [Pval]()
        for child in sctx.expr() {
            let v = try _visitPval(child)
            rt.append(v)
        }
        return rt
    }
    
    private func visitLList(_ sctx: PinnParser.LExprListContext) throws -> [Pval] {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = [Pval]()
        for child in sctx.lExpr() {
            let v = try _visitPval(child)
            rt.append(v)
        }
        return rt
    }

    private func visitIdList(_ sctx: PinnParser.IdListContext) -> [String] {
        loadDebug(sctx)
        defer {popDebug()}
        
//        var rt = [String]()
//        for s in sctx.ID() {
//            rt.append(s.getText())
//        }
        return sctx.ID().map { $0.getText()}
    }
    
    private func visitListCase(_ sctx: PinnParser.ExprListContext, _ v: Pval) throws -> Bool {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = false
        for child in sctx.expr() {
            guard let cv = try visitPval(child) else {
                throw Perr(ENIL, sctx)
            }
            if try cv.equal(v) {
                rt = true
                break
            }
        }
        return rt
    }
    
    
    private func visitCase(_ sctx: PinnParser.CaseStatementContext, _ v: Pval) throws -> Bool {
        loadDebug(sctx)
        defer {popDebug()}
        var rt = false
        if try cfc.path == Path.pFallthrough ||  visitListCase(sctx.exprList()!, v) {
            rt = true
            if cfc.path == Path.pFallthrough {
                cfc.path = .pNormal
            }
            cloop: for (key, child) in sctx.statement().enumerated() {
                try visit(child)
                switch cfc.path {
                case .pFallthrough:
                    if key != sctx.statement().count - 1 {
                        throw Perr(ESTATEMENT, sctx)
                    }
                    
                case .pBreak:
                    cfc.path = .pNormal
                    fallthrough
                case .pContinue, .pExiting:
                    break cloop
                case .pNormal: break
                }
            }
            
        }
        return rt
    }
    private func _visitPval(_ sctx: ParserRuleContext) throws -> Pval {
        guard let rt = try visitPval(sctx) else {
            throw Perr(ENIL, sctx)
        }
        return rt
    }
    private func visitPval(_ sctx: ParserRuleContext) throws -> Pval? {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt: Pval?
        switch sctx {
        case let sctx as PinnParser.LExprContext:
            let str =  sctx.ID()!.getText()
            guard let v = getPv(str) else {
                throw Perr(EUNDECLARED, sctx)
            }
            if v.const {
                throw Perr(ECONST)
            }
            var cv = v
            for e in sctx.expr() {
                let pv = try _visitPval(e) 
                let kt: Ktype = try tryCast(pv)
                cv = try cv.get(kt, true)
            }
            rt = cv
        case let sctx as PinnParser.IntExprContext:
            let op = Self.childToText(sctx.getChild(1)!)
            guard let lhs = try visitPval(sctx.expr(0)!) else {
                throw Perr(ENIL)
            }
            guard let rhs = try visitPval(sctx.expr(1)!) else {
                throw Perr(ENIL)
            }

            rt = try Self.doOp(lhs, rhs, op, sctx)
            
            
            
        case let sctx as PinnParser.CompExprContext:
            let op = Self.childToText(sctx.getChild(1)!)
            guard let lhs = try visitPval(sctx.expr(0)!) else {
                throw Perr(ENIL)
            }
            guard let rhs = try visitPval(sctx.expr(1)!) else {
                throw Perr(ENIL)
            }
            
            
            try rt = Self.doOp(lhs, rhs, op, sctx)
            
            
        case let sctx as PinnParser.BoolExprContext:
            
            let op = Self.childToText(sctx.getChild(1)!)
            guard let lhs = try visitPval(sctx.expr(0)!) else {
                throw Perr(ENIL)
            }
            if op == "&&" {
                let lhsv: Bool = try tryCast(lhs)
                if !lhsv {
                    rt = Pval(sctx, false)
                    break
                }
                else {
                    
                    guard let rhs = try visitPval(sctx.expr(1)!) else {
                        throw Perr(ENIL)
                    }
                    let rhsv: Bool = try tryCast(rhs)
                    rt = Pval(sctx, rhsv)
                    break
                }
            }
            if op == "||" {
                let lhsv: Bool = try tryCast(lhs)
                if lhsv {
                    rt = Pval(sctx, true)
                    break
                }
                else {
                    guard let rhs = try visitPval(sctx.expr(1)!) else {
                         throw Perr(ENIL)
                     }
                     let rhsv: Bool = try tryCast(rhs)
                     rt = Pval(sctx, rhsv)
                }
            }
            
            
        case let sctx as PinnParser.UnaryExprContext:
            
            
            switch Self.childToText(sctx.getChild(0)!) {
            case "!":
                guard let pv = try visitPval(sctx.expr()!) else {
                    throw Perr(ENIL, sctx)
                }
                let b: Bool = try tryCast(pv)
                rt = Pval(sctx, !b)
            case "-":
                guard let pv = try visitPval(sctx.expr()!) else {
                    throw Perr(ENIL, sctx)
                }
                let b: Negate = try tryCast(pv)
                rt = Pval(sctx, b.neg())
            case "+":
                guard let pv = try visitPval(sctx.expr()!) else {
                    throw Perr(ENIL, sctx)
                }
                let b: Int = try tryCast(pv)
                rt = Pval(sctx, b)
                
            default:
                aden()
                
            }
            
            
        case let sctx as PinnParser.TupleExprContext:
            if sctx.exprList() == nil {
                if sctx.AST() == nil {
                rt = try Pval(sctx, Kind.emptyTuple())
                } else {
                    rt = try Pval(sctx, Kind.nilPointer())
                }
            } else {
            let el = sctx.exprList()!
            let s = try visitList(el)
            rt = try Pval(sctx, s, sctx.AST() != nil)
            }
        case let sctx as PinnParser.CallExprContext:
            var s = [Pval]()
            
            let str =  sctx.ID()!.getText()
            if let el = sctx.exprList() {
                s = try visitList(el)
            }
            rt = try callFunction(sctx, str, s)
            
            
        case let sctx as PinnParser.ParenExprContext:
            rt = try _visitPval(sctx.expr()!)
        case let sctx as PinnParser.ObjectLiteralContext:
            let list = sctx.objectPair()
            let ast = sctx.AST() != nil
            var kind: Kind?
            var ckind: Kind?
            if list.count == 0 {
                rt = try Pval(sctx, Kind.nilMap())
                return rt
            }
            
            var olist = [String: Pval]()
            for op in list {
                let (str, pv) = try visitObjectPair(op)
                if olist[str] != nil {
                    throw Perr(EREDECLARE, sctx)
                }
                olist[str] = pv
            }
            if ast {
                var klist = [String: Kind]()
                for (k, v) in olist {
                    klist[k] = v.getKind()
                }
                rt = try Pval(sctx, Kind(Gtype.gStructure(klist)))
                
                
                
                
                            
                            for (str, pv) in olist {

                                try rt!.set(str, pv)
                            }

                return rt
                
                
                
                
                
                
            }
            let vt: Kind
            let val = olist.values
            if let aef = (val.first {
                !($0.gg().isNilSlice() || $0.gg().isNilMap() || $0.gg().isNilPointer())
            }) {
                vt = aef.getKind()
            } else {
                vt = val.first!.getKind()
            }
            rt = try  Pval(sctx, Kind(Gtype.gMap(vt)))
            
            
            
            for (str, pv) in olist {
                
//                if kind == nil {
//                    ckind = pv.getKind()
//                    kind = try Kind.produceKind(Gtype.gMap(ckind!))
//                    rt = try Pval(sctx, kind!)
//                }
                if !pv.gg().gEquivalentSym(vt.gtype) {
                    throw Perr(ETYPE, sctx)
                }
                try rt!.set(str, pv)
            }
        //            let kind = Kind(vtype: list.first!.1)
        case let sctx as PinnParser.ArrayLiteralContext:
            
                     if sctx.exprList() == nil {
                        if sctx.THREEDOT() == nil {
                            throw Perr(EPARSE_FAIL, sctx)
                        }
                rt = try Pval(sctx, Kind.nilSlice())
            } else {
            
            
            let el = sctx.exprList()!
            let ae = try visitList(el)
//            let aeFirstk = ae.first!.getKind()
             if let aek = (ae.first {
                !($0.gg().isNilSlice() || $0.gg().isNilMap() || $0.gg().isNilPointer())
                }) {
                rt = try Pval(sctx, ae, sctx.THREEDOT() != nil, aek.getKind())
                     }
             else {
                rt = try Pval(sctx, ae, sctx.THREEDOT() != nil, ae.first!.getKind())
                        }
            
            }
            return rt
            
        case let sctx as PinnParser.LiteralExprContext:
            let child = sctx.getChild(0)!
            
            
            switch Self.childToToken(child) {
            case .STRING:
                let str = sctx.STRING()!.getText()
                let str2 = stringDequote(str)
                let pv = Pval(sctx, str2)
                rt = pv
            case .INT:
                let str = sctx.INT()!.getText()
                let x = Int(str)!
                let pv = Pval(sctx, x)
                rt = pv
            case .FLOAT:
                let str = sctx.FLOAT()!.getText()
                let d = Decimal(string: str)!
                let pv = Pval(sctx, d)
                rt = pv
//            case .NIL:
//                let pv = Pval(sctx, Nil())
//                rt = pv
            case .BOOL:
                let str = sctx.BOOL()!.getText()
                let x = Bool(str)!
                let pv = Pval(sctx, x)
                rt = pv
            case .ID:
                let str = sctx.ID()!.getText()
                guard let pv = getPv(str) else {
                    throw Perr(EUNDECLARED, sctx)
                }
                
                rt = try pv.cloneIf()
            default:
                aden()
            }
            
            
            
            
            
        case let sctx as PinnParser.ConditionalExprContext:
            
            
            
            
            let b: Bool = try tryCast(_visitPval(sctx.expr(0)!))
            if b {
                rt = try _visitPval(sctx.expr(1)!)
            } else {
                rt = try _visitPval(sctx.expr(2)!)
            }
        case let sctx as PinnParser.RangeExprContext:
            let op = Self.childToText(sctx.getChild(1)!)
            
            let lhs = try _visitPval(sctx.expr(0)!)
            let rhs = try _visitPval(sctx.expr(1)!)
            rt = try Self.doOp(lhs, rhs, op, sctx)
        case let sctx as PinnParser.DotIndexExprContext:
            let v = try _visitPval(sctx.expr()!)
            
            let str = sctx.INT()!.getText()
            let x = Int(str)!
            if !(v.gg().isTuple() || v.gg().isPointer()) {
                throw Perr(ETYPE, sctx)
            }
            rt = try v.get(x)
            
        case let sctx as PinnParser.IndexExprContext:
            
            
            let v = try _visitPval(sctx.expr(0)!)
            if (sctx.AT() != nil || sctx.COLON() != nil) {
                
                var lhsv = 0
                if let lh = sctx.first {
                    lhsv = try tryCast(try _visitPval(lh))
                }
                
                
                if case .gScalar(let pt) = v.getKind().gtype {
                    if pt == String.self {
                        let str = try v.getUnwrap() as! String
                        var rhsv = str.count
                        if let rh = sctx.second {
                            rhsv = try tryCast(_visitPval(rh))
                        } else if (sctx.AT() != nil) {
                            throw Perr(ENIL, sctx)
                        }
                        if (sctx.AT() != nil) {
                            rhsv += 1
                        }
                        
                        if lhsv < 0 || lhsv >= str.count {
                            throw Perr(ERANGE)
                        }
                        if rhsv < lhsv || rhsv > str.count {
                            throw Perr(ERANGE)
                        }
                        
                        let start = str.index(str.startIndex, offsetBy: lhsv)
                        let end = str.index(str.startIndex, offsetBy: rhsv)
                        let newstr = str[start..<end]
                        rt = Pval(sctx, String(newstr))
                        return rt


                    }
                }
                
                
                
                
                
                var rhsv = try v.getCount()
                if let rh = sctx.second {
                    rhsv = try tryCast(_visitPval(rh))
                }
                if (sctx.AT() != nil) {
                    rhsv += 1
                }
                
                rt = try Pval(sctx, v, lhsv, rhsv)
                
                
                return rt
                
            }
   
            
            let e2 = try _visitPval(sctx.expr(1)!)
            let i: Ktype = try tryCast(e2)
            
            rt = try v.get(i)
            
            
            
        case let sctx as PinnParser.ExprContext:
            rt = try visitPval(sctx.getChild(0) as! ParserRuleContext)
            
        default:
            
            aden()
        }
        return rt
    }
    
    private func visit(_ sctx: ParserRuleContext) throws
    {
        loadDebug(sctx)
        defer {popDebug()}
        //        throw Perr("tst", sctx)
        switch sctx {
        case let sctx as PinnParser.SwitchStatementContext:
            let v = try _visitPval(sctx.expr()!)
            var broken = false
            for child in sctx.caseStatement()
            {
                if try visitCase(child, v) {
                    broken = true
                    if cfc.path == .pFallthrough {
                        broken = false
                        continue
                    }
                    break
                }
            }
            if !broken {
                if cfc.path == .pFallthrough {
                    cfc.path = .pNormal
                }
                loop:
                    for child in sctx.statement() {
                        try visit(child)
                        switch cfc.path {
                            
                        case .pBreak: cfc.path = .pNormal
                            fallthrough
                        case .pContinue, .pExiting: break loop
                        default: break
                        }
                }
            }
        case let sctx as PinnParser.CompoundSetContext:
            
            guard let lh = try visitPval(sctx.lExpr()!) else {
                throw Perr(ENIL, sctx)
            }
            let rh = try _visitPval(sctx.expr()!)
            
            let op = sctx.children![sctx.children!.count - 3].getText()
            
            
            let result = try Self.doOp(lh, rh, op, sctx)
            try lh.setPV(result)
            
        case let sctx as PinnParser.StatementContext:
            if let e = sctx.expr() {
                _ = try visitPval(e)
                break
            }
            let c0 = sctx.getChild(0)!
            if let child = c0 as? ParserRuleContext {
                try visit(child)
                break
            }
            switch Self.childToText(c0) {
            case "break":
                cfc.path = .pBreak
            case "continue":
                cfc.path = .pContinue
            case "fallthrough":
                cfc.path = .pFallthrough
                
            case ";":
                break
            default:
                aden()
            }
            
        case let sctx as PinnParser.DoubleSetContext:
            
            let lh = try _visitPval(sctx.lExpr()!)
            
            let rhsv: Int
            let str = Self.childToText(sctx.getChild(1)!)
            switch str {
            case "++": rhsv = 1
            case "--": rhsv = -1
            default:
                aden()
            }
            let lhsv: Int = try tryCast(lh)
            try lh.setPV(Pval(sctx, lhsv + rhsv))
        case let sctx as PinnParser.ReturnStatementContext:
            cfc.path = .pExiting
            if let e = sctx.expr() {
                cfc.rt = try visitPval(e)
            }
        case let sctx as PinnParser.BlockContext:
            for child in sctx.statement() {
                try visit(child)
                if cfc.path == .pFallthrough {
                    throw Perr(ESTATEMENT, sctx)
                }
                if cfc.path != .pNormal {
                    break
                }
            }
        case let sctx as PinnParser.DestructureSetContext:
      
                let lel = sctx.lExprList()!
                
                let ae = try visitLList(lel)
                let lae = try _visitPval(sctx.expr()!)
            
                if !lae.getKind().gtype.isTuple() {
                    throw Perr(ETYPE, sctx)
                }
                if try ae.count != lae.getCount() {
                    throw Perr(ERANGE, sctx)
                }
                                for (k, v) in ae.enumerated() {
                                    try v.setPV(lae.get(k))
                }

            
        case let sctx as PinnParser.SimpleSetContext:
            
            

                let el = sctx.exprList()!
                let lel = sctx.lExprList()!
                
                let ae = try visitList(el)
                let lae = try visitLList(lel)

                if ae.count != lae.count {
                    throw Perr(ERANGE, sctx)
                }
                    for (k, v) in ae.enumerated() {
                        try lae[k].setPV(v)

                    }
            
            
            
            
            
            
//            let lh = try visitPval(sctx.lExpr()!)!
//            let rh = try _visitPval(sctx.expr()!)
//            return try lh.setPV(rh)
            
        case let sctx as PinnParser.IfStatementContext:
            
            let v = try _visitPval(sctx.expr()!)
            let b: Bool = try tryCast(v)
            if b {
                try visit(sctx.statement(0)!)
            } else if let s2 = sctx.statement(1) {
                try visit(s2)
            }
        case let sctx as PinnParser.RepeatStatementContext:
            var b = true
            while b {
                try visit(sctx.block()!)
                if  cfc.toEndBlock() {
                    break
                }
                let v = try _visitPval(sctx.expr()!)
                b = try tryCast(v)
                
            }
        case let sctx as PinnParser.WhStatementContext:
            
            var v = try _visitPval(sctx.expr()!)
            var b: Bool = try tryCast(v)
            while b {
                try visit(sctx.block()!)
                if  cfc.toEndBlock() {break}
                v = try _visitPval(sctx.expr()!)
                b = try tryCast(v)
            }
        case let sctx as PinnParser.LoopStatementContext:
            
            while true {
                try visit(sctx.block()!)
                if  cfc.toEndBlock() {break}
            }
            
        case let sctx as PinnParser.FoStatementContext:
            if sctx.RANGE() != nil {
                var key: Pval?
                var value: Pval?
                if sctx.ID().count == 2 {
                    key = getPv(sctx.ID(0)!.getText())
                    if key == nil  {
                        
                        throw Perr(EUNDECLARED, sctx, nil, sctx.ID(0)!.getSymbol()!)
                    }
                    value = getPv(sctx.ID(1)!.getText())
                    if value == nil {
                        throw Perr(EUNDECLARED, sctx, nil, sctx.ID(1)!.getSymbol()!)
                    }
                } else {
                    value = getPv(sctx.ID(0)!.getText())
                    if value == nil {
                        throw Perr(EUNDECLARED, sctx, nil, sctx.ID(0)!.getSymbol()!)
                    }
                    
                }
                
                let ranger = try _visitPval(sctx.expr()!)
                switch ranger.getKind().gtype {
                case .gScalar(let pt):
                    if pt != String.self {
                        throw Perr(ETYPE, sctx)
                    }
                    let str: String = try tryCast(ranger)
                    for (k, ch) in str.enumerated() {
                        try value!.setPV(Pval(sctx, String(ch)))
                        try key?.setPV(Pval(sctx, k))
                                        try visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                    }
                    
                    
                case .gSlice, .gArray:
                    for x in try 0..<ranger.getCount() {
                        try value!.setPV(ranger.get(x))
                        try key?.setPV(Pval(sctx, x))
                        
                        try visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                    }
                case .gMap:
                    let keys = ranger.getKeys()
                    for mkey in keys {
                        try key?.setPV(Pval(sctx, mkey))
                        try value!.setPV(ranger.get(mkey))
                        try visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                        
                        
                    }
                    break
                default:
                    throw Perr(ETYPE, sctx, ranger)
                }
                break
            }
            if let vd = sctx.varDecl() {
                try visit(vd)
            } else
                if sctx.fss != nil {
                    try visit(sctx.fss)
            }
            var v: Bool = try tryCast(try _visitPval(sctx.expr()!))
            while v {
                try visit(sctx.block()!)
                
                if  cfc.toEndBlock() {break}
                try visit(sctx.sss)
                v = try tryCast(try _visitPval(sctx.expr()!))
                
            }
        case let sctx as PinnParser.GuardStatementContext:
            let v = try _visitPval(sctx.expr()!)
            let b: Bool = try tryCast(v)
            if !b {
                try visit(sctx.block()!)
                if cfc.path == .pNormal {
                    throw Perr(ESTATEMENT, sctx)
                }
            }
            
        case let sctx as PinnParser.TypeDeclContext:
            
            let str = sctx.ID()!.getText()
            
            let k = try visitKind(sctx.kind()!)
            try Kind.storeKind(str, k)
                
            
        case let sctx as PinnParser.VarDeclContext:
            let map = lfc?.m ?? fc.m

            if sctx.CONST() != nil {
                let id = sctx.ID(0)!.getText()
                if id == "_" {
                    throw Perr(ENIL)
                }
                let pv = try _visitPval(sctx.expr()!)
                let rt = Pval(pv, true)
                if lfc != nil {
                    lfc!.m[id] = rt
                } else {
                    fc.m[id] = rt
                }
                return
                
            }
            if sctx.CE() != nil {
                var ae = [Pval]()
                if sctx.LPAREN() != nil {
                    let pv = try visitPval(sctx.expr()!)!
                    if !pv.getKind().gtype.isTuple() {
                        throw Perr(ETYPE, sctx)
                    }
                    for index in try 0..<pv.getCount() {
                        try ae.append(pv.get(index))
                    }
                } else {
                    let el = sctx.exprList()!
                    ae = try visitList(el)
                }
                if ae.count != sctx.ID().count {
                    throw Perr(ERANGE, sctx)
                }
                    for (k, v) in sctx.ID().enumerated() {
                            let str = v.getText()
                        if str == "_" {
                            continue
                        }
                        let pv = try ae[k]//.cloneType()
                            if let prev = map[str] {
                                throw Perr(EREDECLARE, sctx, prev)
                            }
//                        if pv.getKind().hasNil() {
//                            throw Perr(ETYPE, sctx)
//                        }
                            if lfc != nil {
                                lfc!.m[str] = pv
                            } else {
                                fc.m[str] = pv
                            }
                    }
                        return
            }
            
            

            let ai = try visitIdList(sctx.idList()!)
            let k = try visitKind(sctx.kind()!)

            for v in ai {
                
                if v == "_" {
                    continue
                }
                            var newV: Pval
                            if let prev = map[v] {
                                throw Perr(EREDECLARE, sctx, prev)
                            }
                                newV = try Pval(sctx, k)

                            if lfc != nil {
                                lfc!.m[v] = newV
                            } else {
                                fc.m[v] = newV
                            }
                
            }

            
        default: break
        }
    }
    struct FKind {
        var k: Kind
        var s: String
        var variadic = false
        var prc: ParserRuleContext
        
        
    }
    private class Tester {
        private let desc: String
        private let compare: String
        init(_ d: String, _ c: String) {
            desc = d
            compare = c
        }
        func compare(_ s: String) -> String? {
            if s != compare {
                return ". " + desc + ", want: " + compare + ", got: " + s
            }
            return nil
        }
        
    }
    private class Fc {
        var m = [String: Pval]()
        var rt: Pval?
        var path = Path.pNormal
        func toEndBlock()  -> Bool {
            switch path {
            case .pNormal, .pContinue:
                path = .pNormal
                return false
            case .pBreak:
                path = .pNormal
                fallthrough
            case .pExiting:
                return true
            default:
                de(ECASE)
            }
        }
        
    }
    struct Fheader {
        var funcContext: PinnParser.FunctionContext?
        var kind: Kind?
        var fkinds = [FKind]()
    }
    private enum Path {
        case pNormal, pExiting, pBreak, pContinue, pFallthrough
    }
}
