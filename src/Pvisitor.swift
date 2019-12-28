import Foundation
import Antlr4

class Pvisitor {
    private var printed = ""
    private var t_explain = ""
    private var t_compare = ""
    private var ft = ""
    private var li: String.Index?
    
    private var fc = Fc()
    private var lfc: Fc?
    private var fkmap = [String:Fheader]()
    private var line = -1
    private var prc: ParserRuleContext?
    private var oldPrc: ParserRuleContext?
    private var cfc: Fc {return lfc ?? fc}
    init() {
        reset()
    }
    private let litToType: [String: Ptype.Type] = ["int": Int.self, "bool": Bool.self, "string": String.self, "decimal": Decimal.self, "self": Nil.self]
    private let builtIns
        : [String: (ParserRuleContext, Pvisitor, [Pval]) throws -> Pval?] =
        [
            "exit": { sctx, pv, s in
                try assertPvals(s, 0)
                exit(0)
            },
            "xam": { sctx, pv, s in try assertPvals(s, 1)
                let str: String = try tryCast(s[0])
                let xa = pv.getPv(str)
                fatalError()
            },
            //            "xv": { sctx, pv, s in try assertPvals(s, 1)
            //
            //                let xa = pv.getPv(str)
            //                fatalError()
            //            },
            "ft": { sctx, pv, s in try assertPvals(s, 2)
                if pv.lfc != nil {
                    throw Perr(ESTATEMENT, sctx)
                }
                pv.reset()
                if pv.li != nil {
                    try pv.testCompare(sctx)
                }
                print("--", sctx.getStart()!.getLine())
                pv.li = pv.printed.endIndex
                let s1: String = try tryCast(s[0])
                let s2: String = try tryCast(s[1])
                (pv.t_explain, pv.t_compare) = (s1, s2)
                
                return nil
            },
            "len": { sctx, pv, s in try assertPvals(s, 1)
                if try s[0].getKind().isType(String.self) {
                    return Pval(sctx, (try s[0].getUnwrap() as! String).count)
                }
//                guard let c = try s[0].getKind().count else {
//                    throw Perr(ETYPE, sctx)
//                }
                return try Pval(sctx, s[0].getCount())
            },
                            "stringValue":
                { sctx, pv, s in try assertPvals(s, 1)
                    return Pval(sctx, try s[0].string(false)) },
            "depthString":
                {sctx, pv, s in try assertPvals(s, 1)
                    return Pval(sctx, try s[0].string(true))
            },
            "print":
                {sctx, pv, s in
                    let rt = Pvisitor.printSpace(try s.map {try $0.string(false)})
                    pv.textout(rt)
                    return nil
            },
            "println":
                {sctx, pv, s in
                    var rt = Pvisitor.printSpace(try s.map {try $0.string(false)})
                    pv.textout(rt + "\n")
                    return nil
            },
            "readLine": {
                sctx, pv, s in try assertPvals(s, 0)
                return Pval(sctx, readLine()!)
            },
            "printH": { sctx, pv, s in try assertPvals(s, 1)
                let x: Int = try tryCast(s[0])
                pv.textout(String(x, radix: 16, uppercase: false))
                return nil
            },
            "printB": { sctx, pv, s in try assertPvals(s, 1)
                let x: Int = try tryCast(s[0])
                pv.textout(String(x, radix: 2, uppercase: false))
                return nil
            },
            "delete": { sctx, pv, s in try assertPvals(s, 2)
                let kt: String = try tryCast(s[1])
                let rt = try s[0].hasKey(kt)
                try s[0].set(kt, nil)
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
                ade(try xa1.getKind() === xa2.getKind())
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
    
    private static func assertPvals( _ s: [Pval], _ i: Int) throws {
        if s.count != i {
            throw Perr(EPARAM_LENGTH)
        }
    }
    private func reset() {
        fc = Fc()
        fkmap = [String:Fheader]()
        for str in builtIns.keys {
            reserveFunction(str)
        }
    }
    
    private func testCompare(_ sctx: ParserRuleContext) throws{
        let compee = printed[li!..<printed.endIndex]
        //print(compee, "!")
        //print(printed, "??")
        if compee != t_compare {
            throw Perr(ETEST_FAIL + "," +  t_explain + ", want: " + t_compare + ", got: " + compee, sctx)
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
            rt = try Pval(sctx, Kind(Kind(Int.self), .gSlice))
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
        guard let fh = fkmap[str] else {
            throw Perr(EUNDECLARED, sctx)
        }
        guard let ctx = fh.funcContext else {
            if str == "ec" {
                //   fc = Fc()
            }
            return try builtIns[str]!(sctx, self, s)
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
                let par = try Pval(ctx, Kind(v.k, .gArray, s.count - index))
                
                for (key, varadds) in s[index...].enumerated() {
                    if try !varadds.getKind().kindEquivalent(v.k) {
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
            if try !s[index].getKind().kindEquivalent(v.k) {
                throw Perr(ETYPE, sctx)
            }
            if let pv = lfc!.m[fh.fkinds[index].s]  {
                throw Perr(EREDECLARE, sctx, pv)
            }
            lfc!.m[fh.fkinds[index].s] = Pval(s[index])
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
            if !k.kindEquivalent(try rp.getKind()) {
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
    
    
    public func visitFile(_ sctx: PinnParser.FileContext) throws {
        
        for child in sctx.children! {
            if let spec = child as? PinnParser.FunctionContext {
                try visitHeader(spec)
            } else {
                if let spec = child as? PinnParser.StatementContext {
                    try visit(spec)
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
        if li != nil {
            try testCompare(sctx)
        }
    }
    
    private func visitObjectPair(_ sctx: PinnParser.ObjectPairContext) throws -> (String, Pval) {
        loadDebug(sctx)
        defer {popDebug()}
        let rt1: String
        //let rt2: Pval
        rt1 = stringDequote(sctx.STRING()!.getText())
        guard let rt2 = try visitPval(sctx.expr()!) else {
            throw Perr(ETYPE, sctx)
        }
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
        }
        var fkinds = [FKind]()
        for (index, child) in sctx.fvarDecl().enumerated() {
            let vfk = try visitFKind(child)
            if (fkinds.contains { fk in vfk.s == fk.s }) {
                throw Perr(EREDECLARE, vfk.prc)
            }
            if vfk.variadic && index < sctx.fvarDecl().count - 1 {
                throw Perr(ETYPE, vfk.prc)
            }
            
            fkinds.append(try visitFKind(child))
            
            
        }
        fkmap[sctx.ID()!.getText()] = Fheader(funcContext: sctx, kind: k, fkinds: fkinds)
    }
    
    
    private func visitKind(_ sctx: PinnParser.KindContext) throws -> Kind {
        loadDebug(sctx)
        defer {popDebug()}
        let rt: Kind
        if let spec = sctx.kindList() {
            let kL = try visitKindList(spec)
            rt = try Kind(kL)
        } else
            if let type = sctx.TYPES() {
                let strType = type.getText()
                let vtype = litToType[strType]!
                rt = Kind(vtype)
                //            return Kind(vtype)
            } else {
                let kind = try visitKind(sctx.kind()!)
                if sctx.MAP() != nil {
                    rt = Kind(kind, .gMap)
                } else if sctx.SLICE() != nil {
                    rt = Kind(kind, .gSlice)
                }
                else {
                    let v = try _visitPval(sctx.expr()!)
                  
                    let x: Int = try tryCast(v)
                    rt = Kind(kind, .gArray, x)
                }
        }
        return Kind.produceKind(rt)
    }
    private func visitFKind(_ sctx: PinnParser.FvarDeclContext) throws -> FKind {
        loadDebug(sctx)
        defer {popDebug()}
        
        let str = sctx.ID()!.getText()
        let k = try visitKind(sctx.kind()!)
        return FKind(k: k, s: str, variadic: sctx.THREEDOT() != nil, prc: sctx)
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
            guard let v = try visitPval(child) else {
                throw Perr(ENIL, sctx)
            }
            rt.append(v)
        }
        return rt
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
                cfc.setPath(.pNormal)
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
            var cv = v
            for e in sctx.expr() {
                guard let pv = try visitPval(e) else {
                    throw Perr(ENIL, sctx)
                }
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
            
            let el = sctx.exprList()!
            let s = try visitList(el)
            rt = try Pval(sctx, s)
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
            var kind: Kind?
            for op in list {
                
                let (str, pv) = try visitObjectPair(op)
                if kind == nil {
                    kind = Kind(try pv.getKind(), .gMap)
                    rt = try Pval(sctx, kind!)
                }
                try rt!.set(str, pv)
            }
        //            let kind = Kind(vtype: list.first!.1)
        case let sctx as PinnParser.ArrayLiteralContext:
            let el = sctx.exprList()!
            let ae = try visitList(el)
            let aeFirstk = try ae.first!.getKind()
            
            let kind = Kind(aeFirstk, .gSlice)
            rt = try Pval(sctx, ae, kind)
            
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
            case .NIL:
                let pv = Pval(sctx, Nil())
                rt = pv
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
        case let sctx as PinnParser.IndexExprContext:
            
            
            let v = try _visitPval(sctx.expr(0)!)
            if (sctx.TWODOTS() != nil || sctx.COLON() != nil) {
                
                var lhsv = 0
                if let lh = sctx.first {
                    lhsv = try tryCast(try _visitPval(lh))
                }
                var rhsv = try v.getKind().count!
                if let rh = sctx.second {
                    rhsv = try tryCast(try _visitPval(rh))
                }
                if (sctx.TWODOTS() != nil) {
                    rhsv+=1
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
            switch sctx.DOUBLEOP()!.getText() {
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
        case let sctx as PinnParser.SimpleSetContext:
            let lh = try visitPval(sctx.lExpr()!)!
            let rh = try _visitPval(sctx.expr()!)
            return try lh.setPV(rh)
            
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
                if sctx.COMMA() != nil {
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
                switch try ranger.getKind().gtype {
                case .gSlice, .gArray:
                    for x in try 0..<ranger.getKind().count! {
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
            
        case let sctx as PinnParser.VarDeclContext:
            let map = lfc?.m ?? fc.m
            
            if sctx.LPAREN() != nil {
                let e = try _visitPval(sctx.expr()!)
                ade(try e.getKind().gtype == .gTuple)
                ade(try e.getKind().count == sctx.ID().count)
                for (k, v) in sctx.ID().enumerated() {
                    let str = v.getText()
                    let te = try e.get(k)
                    if let prev = map[str] {
                        throw Perr(EREDECLARE, sctx, prev)
                    }
                    if lfc != nil {
                        lfc!.m[str] = te
                    } else {
                        fc.m[str] = te
                    }
                }
                return
            }
            
            let str = sctx.ID(0)!.getText()
            
            var newV: Pval?
            if let prev = map[str] {
                throw Perr(EREDECLARE, sctx, prev)
            }
            if sctx.CE() != nil {
                newV = try visitPval(sctx.expr()!)
                if newV == nil {
                    throw Perr(ENIL, sctx)
                }
                if try newV!.getKind().isNil() {
                    throw Perr(ETYPE, sctx)
                }
            } else {
                let k = try visitKind(sctx.kind()!)
                newV = try Pval(sctx, k)
            }
            if lfc != nil {
                lfc!.m[str] = newV!
            } else {
                fc.m[str] = newV!
            }
            
        default: break
        }
    }
    private struct FKind {
        var k: Kind
        var s: String
        var variadic = false
        var prc: ParserRuleContext
    }
    private class Fc {
        var m = [String: Pval]()
        var rt: Pval?
        var path = Path.pNormal
        func setPath(_ p: Path) {
            path = p
        }
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
    
    private struct Fheader {
        var funcContext: PinnParser.FunctionContext?
        var kind: Kind?
        var fkinds = [FKind]()
    }
    private enum Path {
        case pNormal, pExiting, pBreak, pContinue, pFallthrough
    }
}
