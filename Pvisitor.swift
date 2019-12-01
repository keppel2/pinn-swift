//
//  Pvisitor.swift
//  pinn
//
//  Created by Ryan Keppel on 10/28/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4

public class Pvisitor {
    static var printed = ""
    static var t_explain = ""
    static var t_compare = ""
    static var ft = ""
    static var li = ft.startIndex
    static func assertPvals( _ s: [Pval], _ i: Int) {
        if s.count != i {
            de(EPARAM_LENGTH)
        }
    }
    let builtIns
        : [String: (ParserRuleContext, [Pval]) -> Pval?] =
        [
            "ft": { sctx, s in assertPvals(s, 2)
                print("--", sctx.getStart()!.getLine())
                li = printed.endIndex
                (t_explain, t_compare) = (s[0].get().unwrap() as! String, s[1].get().unwrap() as! String)
                
                return nil
            },
            "ec": { sctx, s in assertPvals(s, 0)
                let compee = printed[li..<printed.endIndex]
                //print(compee, "!")
                //print(printed, "??")
                if compee != t_compare {
                    de(Perr(ETEST_FAIL + "," +  t_explain + ", want: " + t_compare + ", got: " + compee, sctx))
                }
                return nil
            },
            "len": { sctx, s in assertPvals(s, 1)
                if s[0].kind.gtype == .gScalar && s[0].kind.vtype == String.self {
                    return Pval(sctx, (s[0].get().unwrap() as! String).count)
                }
                return Pval(sctx, s[0].kind.count)},
            "stringValue":
                { sctx, s in assertPvals(s, 1)
                    return Pval(sctx, s[0].string()) },
            "print":
                {sctx, s in
                    let rt = Pvisitor.printSpace(s.map {$0.string()})
                    Pvisitor.textout(rt)
                    return nil
            },
            "println":
                {sctx, s in
                    var rt = Pvisitor.printSpace(s.map {$0.string()})
                    Pvisitor.textout(rt + "\n")
                    return nil
            },
            "readLine": {
                sctx, s in assertPvals(s, 0)
                return Pval(sctx, readLine()!)
            },
            "printH": { sctx, s in assertPvals(s, 1)
                Pvisitor.textout(String(s[0].get().unwrap() as! Int, radix: 16, uppercase: false))
                return nil
            },
            "printB": { sctx, s in assertPvals(s, 1)
                Pvisitor.textout(String(s[0].get().unwrap() as! Int, radix: 2, uppercase: false))
                return nil
            },
            "delete": { sctx, s in assertPvals(s, 2)
                s[0].set(s[1].get().unwrap() as! String, nil)
                return nil
            },
            "key": { sctx, s in assertPvals(s, 2)
                return Pval(sctx, s[0].getKeys().contains(s[1].get().unwrap() as! String))
            },
            "debug": { sctx, s in assertPvals(s, 0)
                dbg()
                return nil
            },
//            "sort": { sctx, s in assertPvals(s, 1)
//                s[0].sort()
//                return s[0]
//            },
            "sleep": { sctx, s in assertPvals(s, 1)
                sleep(UInt32(s[0].get().unwrap() as! Int))
                return nil
            }
    ]
    enum Path {
        case pNormal, pExiting, pBreak, pContinue, pFallthrough
    }
    
    
    struct FKind {
        var k: Kind
        var s: String
        var variadic = false
        var prc: ParserRuleContext
    }
    class Fc {
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
    var cfc: Fc {return lfc ?? fc}
    var fc = Fc()
    var lfc: Fc?
    var fkmap = [String:Fheader]()
    
    //    var stack = [ParserRuleContext]()
    
    
    struct Fheader {
        var funcContext: PinnParser.FunctionContext?
        var kind: Kind?
        var fkinds = [FKind]()
    }
    
    func getPv(_ s: String)  -> Pval?  {
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
    static func doOp(_ lhs: Pval, _ rhs: Pval, _ str: String, _ sctx: ParserRuleContext) -> Pval {
        let rt: Pval
        switch str {
        case "+":
            let lh = lhs.get().unwrap() as! Plus
            let rh = rhs.get().unwrap() as! Plus
            rt = Pval(sctx, lh.plus(rh))
            return rt
        case "-", "*", "/":
            let lh = lhs.get().unwrap() as! Arith
            let rh = rhs.get().unwrap() as! Arith
            rt = Pval(sctx, lh.arith(rh, str))
            return rt
        case "<", "<=", ">", ">=":
            let lh = lhs.get().unwrap() as! Compare
            let rh = rhs.get().unwrap() as! Compare
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
        let lhsv = lhs.get().unwrap() as! Int
        var rhsv = rhs.get().unwrap() as! Int
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
                de(Perr(ERANGE, sctx))
            }
            rt = Pval(sctx, Kind(Kind(Int.self), .gSlice, rhsv - lhsv))
            for x in lhsv..<rhsv {
                rt.set(x - lhsv, Pval(sctx, x))
            }
            
        default:
            de(ECASE)
        }
        return rt
    }
    
    var texts = [String]()
    var line = -1
    var prc: ParserRuleContext?
    var oldPrc: ParserRuleContext?
    var pline: Int { return prc!.getStart()!.getLine()}
    static func childToToken(_ child: Tree) -> PinnParser.Tokens {
        return PinnParser.Tokens(rawValue: (child as! TerminalNode).getSymbol()!.getType())!
    }
    static func childToText(_ child: Tree) -> String {
        return (child as! TerminalNode).getText()
    }
    func loadDebug(_ ctx:ParserRuleContext) {
        oldPrc = prc
        prc = ctx
        texts.append(ctx.getText())
        line = ctx.start!.getLine()
    }
    func popDebug() {
        texts.removeLast()
        prc = oldPrc
    }
    
    func reserveFunction(_ s: String) {
        if fkmap[s] != nil {
            de(EREDECLARE + s)
        }
        fkmap[s] = Fheader()
    }
    func putPv(_ s: String, _ pv: Pval) {
        let pvOld: Pval
        if lfc?.m[s] != nil {
            pvOld = lfc!.m.updateValue(pv, forKey: s)!
        } else {
            pvOld = fc.m.updateValue(pv, forKey: s)!
        }
        if !pvOld.kind.kindEquivalent(pv.kind) {
            de(Perr(ETYPE, pvOld, prc))
        }
        
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
    func callFunction(_ sctx: ParserRuleContext, _ str: String, _ s: [Pval])  -> Pval? {
        var rt: Pval?
        let fh = fkmap[str]!
        guard let ctx = fh.funcContext else {
            if str == "ec" {
                //   fc = Fc()
            }
            return builtIns[str]!(sctx, s)
        }
        let oldfc = lfc
        lfc = Fc()
        
        if fh.fkinds.last != nil && fh.fkinds.last!.variadic {
            if s.count < fh.fkinds.count - 1 {
                de(Perr(EPARAM_LENGTH, sctx))
            }
        } else
            if s.count != fh.fkinds.count {
                de(Perr(EPARAM_LENGTH, sctx))
        }
        for (index, v) in fh.fkinds.enumerated() {
            if v.variadic {
                let par = Pval(ctx, Kind(Kind(v.k.vtype!), .gArray, s.count - index), nil)
                
                for (key, varadds) in s[index...].enumerated() {
                    if !varadds.kind.kindEquivalent(v.k) {
                        de(Perr(ETYPE, sctx))
                    }
                    par.set(key, varadds)
                }
                if lfc!.m[fh.fkinds[index].s] != nil {
                    de(Perr(EREDECLARE, sctx))
                }
                lfc!.m[fh.fkinds[index].s] = par
                continue
            }
            if !s[index].kind.kindEquivalent(v.k) {
                de(Perr(ETYPE, sctx))
            }
            if let pv = lfc!.m[fh.fkinds[index].s]  {
                de(Perr(EREDECLARE, pv, sctx))
            }
            lfc!.m[fh.fkinds[index].s] = s[index]
        }
        visit(ctx.block()!)
        switch lfc!.path {
        case .pBreak, .pContinue, .pFallthrough:
            de(Perr(ESTATEMENT, sctx))
        default: break
        }
        
        if lfc!.rt == nil && fh.kind == nil
        {
            
        }
        else {
            if !lfc!.rt!.kind.kindEquivalent(fh.kind!) {
                de(ETYPE)
            }
        }
        rt = lfc!.rt
        lfc = oldfc
        return rt
    }
    static func textout(_ outStr: String) {
        print(outStr, terminator: "")
        printed += outStr
    }
    
    
    public func visitFile(_ sctx: PinnParser.FileContext)  {
        for child in sctx.children! {
            if let spec = child as? PinnParser.FunctionContext {
                visitHeader(spec)
            } else {
                if let spec = child as? PinnParser.StatementContext {
                    visit(spec)
                    switch fc.path {
                    case .pBreak, .pContinue, .pFallthrough:
                        de(Perr(ESTATEMENT, nil, sctx))
                    case .pExiting:
                        if fc.rt != nil {
                            de(ETYPE)
                        }
                    case .pNormal: break
                        
                    }
                }
            }
        }
    }
    
    func visitObjectPair(_ sctx: PinnParser.ObjectPairContext) -> (String, Pval) {
        loadDebug(sctx)
        defer {popDebug()}
        let rt1: String
        let rt2: Pval
        rt1 = stringDequote(sctx.STRING()!.getText())
        rt2 = visitPval(sctx.expr()!)!
        return (rt1, rt2)
    }
    
    func visitHeader(_ sctx:PinnParser.FunctionContext )  {
        loadDebug(sctx)
        defer {popDebug()}
        if fkmap[sctx.ID()!.getText()] != nil {
            
            de(Perr(EREDECLARE, sctx))
        }
        var k: Kind?
        if let kctx = sctx.kind() {
            k = visitKind(kctx)
        }
        var fkinds = [FKind]()
        for (index, child) in sctx.fvarDecl().enumerated() {
            let vfk = visitFKind(child)
            if (fkinds.contains { fk in vfk.s == fk.s }) {
                de(Perr(EREDECLARE, vfk.prc))
            }
            if vfk.variadic && index < sctx.fvarDecl().count - 1 {
                de(Perr(ETYPE, vfk.prc))
            }
            
            fkinds.append(visitFKind(child))
            
            
        }
        fkmap[sctx.ID()!.getText()] = Fheader(funcContext: sctx, kind: k, fkinds: fkinds)
    }
    func visitKind(_ sctx: PinnParser.KindContext) -> Kind {
        loadDebug(sctx)
        defer {popDebug()}
        if let spec = sctx.kindList() {
            let kL = visitKindList(spec)
            let rt = Kind(kL)
            return rt
        }
        let strType = sctx.TYPES()!.getText()
        let litToType: [String: Ptype.Type] = ["int": Int.self, "bool": Bool.self, "string": String.self, "decimal": Decimal.self]
        
        let vtype = litToType[strType]!
        let rt: Kind
        if sctx.MAP() != nil {
            rt = Kind(Kind(vtype), .gMap)
            //        } else if sctx.SLICE() != nil {
            //            rt = Kind(vtype: vtype, gtype: .gSlice, count: 0)
            //
        } else if sctx.SLICE() != nil {
            rt = Kind(Kind(vtype), .gSlice, 0)
        }
        else if let e = sctx.expr() {
            let v = visitPval(e)!
            let x = v.get().unwrap() as! Int
            rt = Kind(Kind(vtype), .gArray, x)
        } else {
            rt = Kind(vtype)
        }
        return rt
    }
    func visitFKind(_ sctx: PinnParser.FvarDeclContext) -> FKind {
        loadDebug(sctx)
        defer {popDebug()}
        
        let str = sctx.ID()!.getText()
        let k = visitKind(sctx.kind()!)
        return FKind(k: k, s: str, variadic: sctx.THREEDOT() != nil, prc: sctx)
    }
    func visitKindList(_ sctx: PinnParser.KindListContext) -> [Kind]
    {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = [Kind]()
        for child in sctx.kind() {
            let v = visitKind(child)
            rt.append(v)
        }
        return rt
    }
    func visitList(_ sctx: PinnParser.ExprListContext) -> [Pval] {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = [Pval]()
        for child in sctx.expr() {
            let v = visitPval(child)!
            rt.append(v)
        }
        return rt
    }
    
    func visitListCase(_ sctx: PinnParser.ExprListContext, _ v: Pval) -> Bool {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt = false
        for child in sctx.expr() {
            let cv = visitPval(child)!
            if cv.equal(v) {
                rt = true
                break
            }
        }
        return rt
    }
    
    
    func visitCase(_ sctx: PinnParser.CaseStatementContext, _ v: Pval) -> Bool {
        loadDebug(sctx)
        defer {popDebug()}
        var rt = false
        if cfc.path == Path.pFallthrough || visitListCase(sctx.exprList()!, v) {
            rt = true
            if cfc.path == Path.pFallthrough {
                cfc.setPath(.pNormal)
            }
            cloop: for (key, child) in sctx.statement().enumerated() {
                visit(child)
                switch cfc.path {
                case .pFallthrough:
                    if key != sctx.statement().count - 1 {
                        de(Perr(ESTATEMENT, sctx))
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
    
    func visitPval(_ sctx: ParserRuleContext) -> Pval? {
        loadDebug(sctx)
        defer {popDebug()}
        
        var rt: Pval?
        switch sctx {
        case let sctx as PinnParser.BinaryExprContext:
            
            let op = Self.childToText(sctx.getChild(1)!)
            
            let lhs = visitPval(sctx.expr(0)!)!
            
            if op == "&&" {
                let lhsv = lhs.get().unwrap() as! Bool
                if !lhsv {
                    rt = Pval(sctx, false)
                    break
                }
                else {
                    rt = Pval(sctx, visitPval(sctx.expr(1)!)!.get().unwrap() as! Bool)
                    break
                }
            }
            if op == "||" {
                let lhsv = lhs.get().unwrap() as! Bool
                if lhsv {
                    rt = Pval(sctx, true)
                    break
                }
                else {
                    rt = Pval(sctx, visitPval(sctx.expr(1)!)!.get().unwrap() as! Bool)
                    break
                }
            }
            let rhs = visitPval(sctx.expr(1)!)!
            if op == "==" {
                rt = Pval(sctx, lhs.equal(rhs))
                break
            }
            if op == "!=" {
                rt = Pval(sctx, !lhs.equal(rhs))
                break
            }
            
            rt = Self.doOp(lhs, rhs, op, sctx)
        case let sctx as PinnParser.UnaryExprContext:
            
            
            switch Self.childToText(sctx.getChild(0)!) {
            case "!":
                guard let e = visitPval(sctx.expr()!)!.get().unwrap() as? Bool else {
                    de(Perr(ETYPE, sctx))
                }
                rt = Pval(sctx, !e)
                break
            case "-":
                guard let e = visitPval(sctx.expr()!)!.get().unwrap() as? Negate else {
                    de(Perr(ETYPE, sctx))
                }
                rt = Pval(sctx, e.neg())
                break
            case "+":
                
                guard let e = visitPval(sctx.expr()!)!.get().unwrap() as? Int else {
                    de(Perr(ETYPE, sctx))
                }
                rt = Pval(sctx, e)
                break
                
                
            default:
                de(Perr(ECASE, sctx))
            }
            
            
        case let sctx as PinnParser.TupleExprContext:
            
            let el = sctx.exprList()!
            let s = visitList(el)
            return Pval(sctx, s)
        case let sctx as PinnParser.CallExprContext:
            var s = [Pval]()
            
            let str =  sctx.ID()!.getText()
            if let el = sctx.exprList() {
                s = visitList(el)
            }
            rt = callFunction(sctx, str, s)
            
            
        case let sctx as PinnParser.ParenExprContext:
            rt = visitPval(sctx.expr()!)
        case let sctx as PinnParser.ObjectLiteralContext:
            let list = sctx.objectPair()
            var kind: Kind?
            for op in list {
                
                let (str, pv) = visitObjectPair(op)
                if kind == nil {
                    kind = Kind(pv.kind, .gMap)
                    rt = Pval(sctx, kind!)
                }
                rt!.set(str, pv)
            }
        //            let kind = Kind(vtype: list.first!.1)
        case let sctx as PinnParser.ArrayLiteralContext:
            let el = sctx.exprList()!
            let ae = visitList(el)
            let aeFirstk = ae.first!.kind
//            let kind: Kind
//            if let aek = aeFirstk.vtype {
//                kind = Kind(Kind(aek), .gSlice, ae.count)
//            } else {
//                kind = Kind(aeFirstk.k!, .gSlice, aeFirstk.count)
//            }
            let kind = Kind(aeFirstk, .gSlice, ae.count)
            rt = Pval(sctx, kind, ae.count)
            for (k, pv) in ae.enumerated() {
                rt!.set(k, pv)
            }
            return rt
        //            rt = Pval(sctx, Kind(vtyp
        case let sctx as PinnParser.LiteralExprContext:
            
            
            
            
            let child = sctx.getChild(0)!
            
            
            switch Self.childToToken(child) {
            case .STRING:
                var str = sctx.STRING()!.getText()
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
            case .BOOL:
                let str = sctx.BOOL()!.getText()
                let x = Bool(str)!
                let pv = Pval(sctx, x)
                rt = pv
            case .ID:
                let str = sctx.ID()!.getText()
                guard let pv = getPv(str) else {
                    de(Perr(EUNDECLARED, sctx))
                }
                if pv.kind.gtype == .gMap || pv.kind.gtype == .gSlice {
                    rt = pv
                } else {
                    rt = pv.clone()
                }
            default:
                de(Perr(ECASE, sctx))
            }
            
            
            
            
            
        case let sctx as PinnParser.ConditionalExprContext:
            
            let b = visitPval(sctx.expr(0)!)!.get().unwrap() as! Bool
            if b {
                rt = visitPval(sctx.expr(1)!)!
            } else {
                rt = visitPval(sctx.expr(2)!)!
            }
        case let sctx as PinnParser.RangeExprContext:
            let op = Self.childToText(sctx.getChild(1)!)
            
            let lhs = visitPval(sctx.expr(0)!)!
                      let rhs = visitPval(sctx.expr(1)!)!
                        rt = Self.doOp(lhs, rhs, op, sctx)
        case let sctx as PinnParser.IndexExprContext:
            
            
            let v = visitPval(sctx.expr(0)!)!
            if (sctx.TWODOTS() != nil || sctx.COLON() != nil) {
                var lhsv = 0
                if let lh = sctx.first {
                    lhsv = visitPval(lh)!.get().unwrap() as! Int
                }
                var rhsv = v.kind.count
                if let rh = sctx.second {
                    rhsv = visitPval(rh)!.get().unwrap() as! Int
                }
                if (sctx.TWODOTS() != nil) {
                    rhsv+=1
                }
                
                rt = Pval(sctx, v, lhsv, rhsv)
                
                
                return rt
                
            }
            
            let e2 = visitPval(sctx.expr(1)!)!.get().unwrap() as! Ktype
            
            let v2 = v.get(e2)
            if v2 is Pval {
                rt = v2 as! Pval
            } else {
                rt = Pval(sctx, v2 as! Pwrap)
            }
            
            case let sctx as PinnParser.ExprContext:
                rt = visitPval(sctx.getChild(0) as! ParserRuleContext)
                
        default:

            de(Perr(ECASE, sctx))
        }
        return rt
    }
    
    func visit(_ sctx: ParserRuleContext)
    {
        loadDebug(sctx)
        defer {popDebug()}
        
        switch sctx {
        case let sctx as PinnParser.SwitchStatementContext:
            let v = visitPval(sctx.expr()!)!
            var broken = false
            for child in sctx.caseStatement()
            {
                if visitCase(child, v) {
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
                        visit(child)
                        switch cfc.path {
                            
                        case .pBreak: cfc.path = .pNormal
                            fallthrough
                        case .pContinue, .pExiting: break loop
                        default: break
                        }
                }
            }
        case let sctx as PinnParser.CompoundSetContext:
            
            let str = sctx.ID()!.getText()
            guard let v = getPv(str) else {
                de(Perr(EUNDECLARED, sctx))
            }
            let lhs: Pval
            var index: Ktype?
            if let cindex = sctx.index {
                index = (visitPval(cindex)!.get().unwrap() as! Ktype)
                lhs = v.get(index!)
            } else {
                lhs = v
            }
            
            let op = sctx.children![sctx.children!.count - 3].getText()
            let rhs = visitPval(sctx.rhs)!
            
            let result = Self.doOp(lhs, rhs, op, sctx).get().unwrap()
            if index == nil {
                v.setPV(Pval(sctx, result))
            } else {
                v.set(index!, Pval(sctx, result))
            }
        case let sctx as PinnParser.StatementContext:
            if let e = sctx.expr() {
                _ = visitPval(e)
                break
            }
            let c0 = sctx.getChild(0)!
            if let child = c0 as? ParserRuleContext {
                visit(child)
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
                de(Perr(ECASE, nil, sctx))
            }
            
        case let sctx as PinnParser.SimpleStatementContext:
            
            if let str = sctx.ID()?.getText() {
                guard let v = getPv(str) else {
                    de(Perr(EUNDECLARED, sctx))
                }
                let rhsv: Int
                switch sctx.DOUBLEOP()!.getText() {
                case "++": rhsv = 1
                case "--": rhsv = -1
                default:
                    de(Perr(ECASE, nil, sctx))}
                
                if let e = sctx.expr() {
                    let ev = visitPval(e)!.get().unwrap()
                    let lhsv = v.get(ev as! Ktype).get().unwrap() as! Int
                    v.set(ev as! Ktype, Pval(sctx, lhsv + rhsv))
                    break
                }
                let lhsv = v.get().unwrap() as! Int
                v.setPV(Pval(sctx, lhsv + rhsv))
                break
            }
            visit(sctx.getChild(0) as! ParserRuleContext)
        case let sctx as PinnParser.ReturnStatementContext:
            cfc.path = .pExiting
            if let e = sctx.expr() {
                cfc.rt = visitPval(e)
            }
        case let sctx as PinnParser.BlockContext:
            for child in sctx.statement() {
                visit(child)
                if cfc.path == .pFallthrough {
                    de(Perr(ESTATEMENT, sctx))
                }
                if cfc.path != .pNormal {
                    break
                }
            }
        case let sctx as PinnParser.SimpleSetContext:
            let str = sctx.ID()!.getText()
            guard let v = getPv(str) else {
                de(Perr(EUNDECLARED, sctx))
            }
            if sctx.expr().count == 2 {
                let key = visitPval(sctx.expr(0)!)!.get().unwrap() as! Ktype
                let value = visitPval(sctx.expr(1)!)!
                v.set(key, value)
            } else {
                
                let e = visitPval(sctx.expr(0)!)!
                if e.kind.gtype == .gScalar {
                    v.setPV(e)
                } else {
                    
                    putPv(str, e)
                }
            }
        case let sctx as PinnParser.IfStatementContext:
            
            let v = visitPval(sctx.expr()!)!
            if v.get().unwrap() as! Bool {
                visit(sctx.statement(0)!)
            } else if let s2 = sctx.statement(1) {
                visit(s2)
            }
        case let sctx as PinnParser.RepeatStatementContext:
            var b = true
            while b {
                visit(sctx.block()!)
                if  cfc.toEndBlock() {
                    break
                }
                let v = visitPval(sctx.expr()!)!
                b = v.get().unwrap() as! Bool
                
            }
        case let sctx as PinnParser.WhStatementContext:
            
            var v = visitPval(sctx.expr()!)!
            
            while v.get().unwrap() as! Bool {
                visit(sctx.block()!)
                if  cfc.toEndBlock() {break}
                v = visitPval(sctx.expr()!)!
            }
        case let sctx as PinnParser.FoStatementContext:
            if sctx.RANGE() != nil {
                var key: Pval?
                var value: Pval?
                if sctx.COMMA() != nil {
                    key = getPv(sctx.ID(0)!.getText())
                    if key == nil  {
                        
                        de(Perr(EUNDECLARED, nil, sctx, sctx.ID(0)!.getSymbol()!))
                    }
                    value = getPv(sctx.ID(1)!.getText())
                    if value == nil {
                        de(Perr(EUNDECLARED, nil, sctx, sctx.ID(1)!.getSymbol()!))
                    }
                } else {
                    value = getPv(sctx.ID(0)!.getText())
                    if value == nil {
                        de(Perr(EUNDECLARED, nil, sctx, sctx.ID(0)!.getSymbol()!))
                    }
                    
                }
                
                
                let ranger = visitPval(sctx.expr()!)!
                switch ranger.kind.gtype {
                case .gSlice, .gArray:
                    for x in 0..<ranger.kind.count {
                        value!.setPV(ranger.get(x))
                        key?.setPV(Pval(sctx, x))
                        
                        visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                    }
                case .gMap:
                    let keys = ranger.getKeys()
                    for mkey in keys {
                        key?.setPV(Pval(sctx, mkey))
                        value!.setPV(ranger.get(mkey))
                        visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                        
                        
                    }
                    break
                default:
                    de(Perr(ECASE, sctx))
                }
                break
            }
            if let vd = sctx.varDecl() {
                visit(vd)
            } else
                if sctx.fss != nil {
                    visit(sctx.fss)
            }
            var v = visitPval(sctx.expr()!)!
            while v.get().unwrap() as! Bool {
                visit(sctx.block()!)
                
                if  cfc.toEndBlock() {break}
                visit(sctx.sss)
                v = visitPval(sctx.expr()!)!
                
            }
        case let sctx as PinnParser.GuardStatementContext:
            let v = visitPval(sctx.expr()!)!
            if !(v.get().unwrap() as! Bool) {
                visit(sctx.block()!)
                if cfc.path == .pNormal {
                    de(Perr(ESTATEMENT, sctx))
                }
            }
            
        case let sctx as PinnParser.VarDeclContext:
            let map = lfc?.m ?? fc.m
            /*
            if sctx.LPAREN() != nil {
                let e = visitPval(sctx.expr()!)!
                ade(e.kind.gtype == .gTuple)
                ade(e.kind.count == sctx.ID().count)
                for (k, v) in sctx.ID().enumerated() {
                    let str = v.getText()
                    let te = e.get(k)
                    let newV = Pval.wrapped(sctx, te)
                    if let prev = map[str] {
                        de(Perr(EREDECLARE, prev, sctx))
                    }
                    if lfc != nil {
                        lfc!.m[str] = newV
                    } else {
                        fc.m[str] = newV
                    }
                }
                return
            }
 */
            let str = sctx.ID(0)!.getText()
            
            var newV: Pval
            if let prev = map[str] {
                de(Perr(EREDECLARE, prev, sctx))
            }
            if sctx.CE() != nil {
                newV = visitPval(sctx.expr()!)!
            } else {
                let k = visitKind(sctx.kind()!)
                    newV = Pval(sctx, k)
            }
            if lfc != nil {
                lfc!.m[str] = newV
            } else {
                fc.m[str] = newV
            }
            
        default: break
        }
    }
    init() {
        for str in builtIns.keys {
            reserveFunction(str)
        }
    }
    
}
