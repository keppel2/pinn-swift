//
//  Pvisitor.swift
//  pinn
//
//  Created by Ryan Keppel on 10/28/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4
class Pvisitor {
    enum Path {
        case pNormal, pExiting, pBreak, pContinue, pFallthrough
    }
    
    
    struct FKind {
        var k: Kind
        var s: String
        var variadic = false
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
                de(ErrCase)
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
    
    var textStack = [String]()
    var line = -1
    var prc: ParserRuleContext?
    
    func loadDebug(_ ctx:ParserRuleContext) {
        prc = ctx
        textStack.append(ctx.getText())
        line = ctx.start!.getLine()
    }
    func popDebug() {
        textStack.removeLast()
    }
    
    func header(_ ctx:PinnParser.FunctionContext )  {
        
        
        if fkmap[ctx.ID()!.getText()] != nil {
            
            de(ErrRedeclare)
        }
        var k: Kind?
        if let kctx = ctx.kind() {
            k = visitKind(kctx)
        }
        var fkinds = [FKind]()
        for (index, child) in ctx.fvarDecl().enumerated() {
            let vfk = visitFKind(child)
            if (fkinds.contains { fk in vfk.s == fk.s }) {
                de(ErrRedeclare)
            }
            
            fkinds.append(visitFKind(child))
            
//            let ar = [1,55].contains() {
//
//            }
            
            if fkinds.last!.variadic && index < ctx.fvarDecl().count - 1 {
                de(ErrWrongType)
            }
        }
        fkmap[ctx.ID()!.getText()] = Fheader(funcContext: ctx, kind: k, fkinds: fkinds)
    }
    func reserveFunction(_ s: String) {
        if fkmap[s] != nil {
            de(ErrRedeclare)
        }
        fkmap[s] = Fheader()
        
    }
    
    func visitFunction(_ str: String, _ s: [Pval])  -> Pval? {
        var rt: Pval?
        let fh = fkmap[str]!
        guard let ctx = fh.funcContext else {
            switch str {
            case "len":
                rt = Pval(s[0].kind.count!)
            case "strLen":
                rt = Pval((s[0].get() as! String).count)
            case "stringValue":
                let v = s[0].string
                rt = Pval(v)
            case "println", "print":
                var outStr = ""
                outStr += s[0].string
                for v in s[1...] {
                    outStr += " " + v.string
                }
                
                if str == "println" {
                    print(to: &outStr)
                }
                textout(outStr)
                
            case "printH":
                var outStr = ""
                let e = s[0].get() as! Int

                print(String(e, radix: 16, uppercase: false), terminator: "", to: &outStr)
                textout(outStr)
            case "printB":
                var outStr = ""
                let e = s[0].get() as! Int

                print(String(e, radix: 2, uppercase: false), terminator: "", to: &outStr)
                textout(outStr)
                
            case "delete":
                let mkey = s[1].get() as! String
                s[0].set(mkey, nil)
            case "debug":
                                dbg()
            case "sort":
                s[0].sort()
                rt = s[0]
            default: de(ErrCase)
            }
            return rt
        }
        let oldfc = lfc
        lfc = Fc()

        if fh.fkinds.last != nil && fh.fkinds.last!.variadic {
            if s.count < fh.fkinds.count - 1 {
                de(ErrParamLength)
            }
        } else
            if s.count != fh.fkinds.count {
                de(ErrParamLength)
        }
        for (index, v) in fh.fkinds.enumerated() {
            if v.variadic {
                let par = Pval(Kind(v.k.vtype, .gArray, s.count - index), nil)
                
                for (key, varadds) in s[index...].enumerated() {
                    if !varadds.kind.kindEquivalent(v.k) {
                        de(ErrWrongType)
                    }
                    par.set(key, varadds.get())
                }
                if lfc!.m[fh.fkinds[index].s] != nil {
                    de(ErrRedeclare)
                }
                lfc!.m[fh.fkinds[index].s] = par
                continue
            }
            if !s[index].kind.kindEquivalent(v.k) {
                de(ErrWrongType)
            }
            if lfc!.m[fh.fkinds[index].s] != nil {
                de(ErrRedeclare)
            }
            lfc!.m[fh.fkinds[index].s] = s[index]
        }
        visit(ctx.block()!)
        switch lfc!.path {
        case .pBreak, .pContinue, .pFallthrough:
            de(ErrWrongStatement)
        default: break
        }
        
        if lfc!.rt == nil && fh.kind == nil
        {
            
        }
        else {
            if !lfc!.rt!.kind.kindEquivalent(fh.kind!) {
                de(ErrWrongType)
            }
        }
        rt = lfc!.rt
        lfc = oldfc
        return rt
    }
    
    
    func start(_ ctx: PinnParser.FileContext)  {
        
        for child in ctx.function() {
            header(child)
        }
        
        for str in ["print","println","printB","printH","delete" , "len","strLen", "stringValue", "debug", "sort"] {
            reserveFunction(str)
        }
        
        
        for child in ctx.statement() {
            visit(child)
            switch fc.path {
            case .pBreak, .pContinue, .pFallthrough:
                de(ErrWrongStatement)
            case .pExiting:
                if fc.rt != nil {
                    de(ErrWrongType)
                }
            case .pNormal: break
                
            }
        }
    }
    
    func visitObjectPair(_ sctx: PinnParser.ObjectPairContext) -> (String, Pval) {
        loadDebug(sctx)
        defer {popDebug()}
        let rt1: String
        let rt2: Pval
        rt1 = sctx.ID()!.getText()
        rt2 = visitPval(sctx.expr()!)!
        return (rt1, rt2)
    }
    
    func visitKind(_ sctx: PinnParser.KindContext) -> Kind {
        loadDebug(sctx)
        defer {popDebug()}
        let strType = sctx.TYPES()!.getText()
        let litToType: [String: Ptype.Type] = ["int": Int.self, "bool": Bool.self, "string": String.self, "decimal": Decimal.self]
        
        let vtype = litToType[strType]!
        let rt: Kind
        if sctx.MAP() != nil {
            rt = Kind(vtype, .gMap)
            //        } else if sctx.SLICE() != nil {
            //            rt = Kind(vtype: vtype, gtype: .gSlice, count: 0)
            //
        } else if sctx.FILL() != nil {
            rt = Kind(vtype, .gArray)
        } else if sctx.SLICE() != nil {
            rt = Kind(vtype, .gSlice, 0)
        }
        else if let e = sctx.expr() {
            let v = visitPval(e)!
            let x = v.get() as! Int
            rt = Kind(vtype, .gArray, x)
        } else {
            rt = Kind(vtype, .gScalar)
        }
        return rt
    }
    func visitFKind(_ sctx: PinnParser.FvarDeclContext) -> FKind {
        loadDebug(sctx)
        defer {popDebug()}
        
        let str = sctx.ID()!.getText()
        let k = visitKind(sctx.kind()!)
        return FKind(k: k, s: str, variadic: sctx.THREEDOT() != nil)
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
    static func childToToken(_ child: Tree) -> PinnParser.Tokens {
        return PinnParser.Tokens(rawValue: (child as! TerminalNode).getSymbol()!.getType())!
    }
    static func childToText(_ child: Tree) -> String {
        return (child as! TerminalNode).getText()
    }
    /*
     func doOp(_ lhs: Pval, _ rhs: Pval, op: String) -> Pval {
     var rt: Pval
     switch op {
     case "+":
     rt = lhs + rhs
     
     }
     */
    
    func getPv(_ s: String)  -> Pval  {
        for m in [lfc?.m, fc.m] {
            if m == nil {
                continue
            }
            if let v = m![s] {
                return v
            }
        }
        de(ErrUndeclare)
    }
    static func doOp(_ lhs: Pval, _ rhs: Pval, _ str: String) -> Pval {
        let rt: Pval
        switch str {
        case "+":
            let lh = lhs.get() as! Plus
            let rh = rhs.get() as! Plus
            rt = Pval(lh.plus(rh))
            return rt
        case "-", "*", "/":
            let lh = lhs.get() as! Arith
            let rh = rhs.get() as! Arith
            rt = Pval(lh.arith(rh, str))
            return rt
        case "<", "<=", ">", ">=":
            let lh = lhs.get() as! Compare
            let rh = rhs.get() as! Compare
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
            default: de(ErrCase)
            }
            return Pval(result)
        default: break
        }
        let lhsv = lhs.get() as! Int
        var rhsv = rhs.get() as! Int
        switch str {
        case "-":
            rt = Pval(lhsv - rhsv)
        case "*":
            rt = Pval(lhsv * rhsv)
        case "/":
            rt = Pval(lhsv / rhsv)
        case "%":
            rt = Pval(lhsv % rhsv)
        case "&":
            rt = Pval(lhsv & rhsv)
        case "|":
            rt = Pval(lhsv | rhsv)
        case "^":
            rt = Pval(lhsv ^ rhsv)
        case "<<":
            rt = Pval(lhsv << rhsv)
        case ">>":
            rt = Pval(lhsv >> rhsv)
        case "<":
            rt = Pval(lhsv < rhsv)
        case "<=":
            rt = Pval(lhsv <= rhsv)
        case ">":
            rt = Pval(lhsv > rhsv)
        case ">=":
            rt = Pval(lhsv >= rhsv)
        case "@":
            rhsv += 1
            fallthrough
        case ":":
            guard rhsv - lhsv >= 0 else {
                de(ErrRange)
            }
            rt = Pval(Kind(Int.self, .gSlice, rhsv - lhsv))
            for x in lhsv..<rhsv {
                rt.set(x - lhsv, x)
            }
            
        default:
            de(ErrCase)
        }
        return rt
    }
    func putPv(_ s: String, _ pv: Pval) {
        let pvOld: Pval
        if lfc?.m[s] != nil {
            pvOld = lfc!.m.updateValue(pv, forKey: s)!
        } else {
            pvOld = fc.m.updateValue(pv, forKey: s)!
        }
        if !pvOld.kind.kindEquivalent(pv.kind) {
            de(ErrWrongType)
        }
        
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
                        de(ErrWrongStatement)
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
    func textout(_ outStr: String) {
        print(outStr, terminator: "")
        fh.write(Data(outStr.utf8))
    }
    
    func visitPval(_ ctx: ParserRuleContext) -> Pval? {
        loadDebug(ctx)
        defer {popDebug()}
        
        var rt: Pval?
        switch ctx {
        case let sctx as PinnParser.CallExprContext:
            var s = [Pval]()
            let str =  sctx.ID()!.getText()
            if let el = sctx.exprList() {
                s = visitList(el)
            }
            rt = visitFunction(str, s)
            
            
        case let sctx as PinnParser.ParenExprContext:
            rt = visitPval(sctx.expr()!)
        case let sctx as PinnParser.ObjectLiteralContext:
            let list = sctx.objectPair()
            var kind: Kind?
            for op in list {
                
                let (str, pv) = visitObjectPair(op)
                if kind == nil {
                    kind = Kind(pv.kind.vtype, .gMap)
                    rt = Pval(kind!)
                }
                rt!.set(str, pv.get())
            }
//            let kind = Kind(vtype: list.first!.1)
        case let sctx as PinnParser.ArrayLiteralContext:
            let el = sctx.exprList()!
            let ae = visitList(el)
            let kind = Kind(ae.first!.kind.vtype, .gSlice, ae.count)
            rt = Pval(kind, ae.count)
            for (k, pv) in ae.enumerated() {
                rt!.set(k, pv.get())
            }
            return rt
//            rt = Pval(Kind(vtyp
        case let sctx as PinnParser.ExprContext:
            if sctx.getChildCount() == 1 {
                let child = sctx.getChild(0)!
                
                if let cchild = child as? ParserRuleContext {
                    rt = visitPval(cchild)
                    break
                }
                switch Self.childToToken(child) {
                case .STRING:
                    var str = sctx.STRING()!.getText()
                    str.remove(at: str.startIndex)
                    str.remove(at: str.index(before: str.endIndex))
                    let str2 = str.replacingOccurrences(of: "\\\"", with: "\"")
                    let pv = Pval(str2)
                    rt = pv
                case .INT:
                    let str = sctx.INT()!.getText()
                    let x = Int(str)!
                    let pv = Pval(x)
                    rt = pv
                case .FLOAT:
                    let str = sctx.FLOAT()!.getText()
                    let d = Decimal(string: str)!
                    let pv = Pval(d)
                    rt = pv
                case .BOOL:
                    let str = sctx.BOOL()!.getText()
                    let x = Bool(str)!
                    let pv = Pval(x)
                    rt = pv
                case .ID:
                    let str = sctx.ID()!.getText()
                    let pv = getPv(str)
                    if pv.kind.gtype == .gMap {
                        rt = pv
                    } else {
                        rt = getPv(str).clone()
                    }
                default:
                    de(ErrCase)
                }
                break
            }
            if sctx.expr().count == 2 {
                let op = Self.childToText(sctx.getChild(1)!)
                
                let lhs = visitPval(sctx.expr(0)!)!
                
                if op == "&&" {
                    let lhsv = lhs.get() as! Bool
                    if !lhsv {
                        rt = Pval(false)
                        break
                    }
                    else {
                        rt = Pval(visitPval(sctx.expr(1)!)!.get() as! Bool)
                        break
                    }
                }
                if op == "||" {
                    let lhsv = lhs.get() as! Bool
                    if lhsv {
                        rt = Pval(true)
                        break
                    }
                    else {
                        rt = Pval(visitPval(sctx.expr(1)!)!.get() as! Bool)
                        break
                    }
                }
                let rhs = visitPval(sctx.expr(1)!)!
                if op == "==" {
                    //     lhs.kind.equalsError(rhs.kind)
                    rt = Pval(lhs.equal(rhs))
                    break
                }
                if op == "!=" {
                    //     lhs.kind.equalsError(rhs.kind)
                    rt = Pval(!lhs.equal(rhs))
                    break
                }
                
                rt = Self.doOp(lhs, rhs, op)
                break
                
            }
            if sctx.expr().count == 3 {
                let b = visitPval(sctx.expr(0)!)!.get() as! Bool
                if b {
                    rt = visitPval(sctx.expr(1)!)!
                } else {
                    rt = visitPval(sctx.expr(2)!)!
                }
                break
            }
            
            
            switch Self.childToText(sctx.getChild(0)!) {
            case "!":
                let e = visitPval(sctx.expr(0)!)!.get() as! Bool
                rt = Pval(!e)
                break
            case "-":
                
                let e = visitPval(sctx.expr(0)!)!.get() as! Negate
                rt = Pval(e.neg())
                break
            case "+":
                let e = visitPval(sctx.expr(0)!)!.get() as! Int
                rt = Pval(e)
                break
                
                
            default:
                de(ErrCase)
            }
            
            

        case let sctx as PinnParser.IndexExprContext:
            let v =  getPv(sctx.ID()!.getText())
            if (sctx.TWODOTS() != nil || sctx.COLON() != nil) {
                var lhsv = 0
                if let lh = sctx.first {
                    lhsv = visitPval(lh)!.get() as! Int
                }
                var rhsv = v.kind.count!
                if let rh = sctx.second {
                    rhsv = visitPval(rh)!.get() as! Int
                }
                if (sctx.TWODOTS() != nil) {
                    rhsv+=1
                }
//                rt = Pval(Kind(vtype: v.kind.vtype, gtype: .gSlice, count: rhsv - lhsv))
                
//                rt!.ar = Array(v.ar![lhsv..<rhsv])
                rt = Pval(v, lhsv, rhsv)
                
                
                break
            }
            let e = visitPval(sctx.expr(0)!)!
            let x = e.get()
            let v2 = v.get(x as! Ktype)
            rt = Pval(v2)
            
        default:
            //            let schild = ctx.getChild(0) as! ParserRuleContext
            //            rt = visitPval(schild)
            de(ErrCase)
        }
        return rt
    }
    
    func visit(_ ctx: ParserRuleContext)
    {
        loadDebug(ctx)
        defer {popDebug()}
        
        switch ctx {
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
            let v = getPv(str)
            let op = sctx.children![sctx.children!.count - 3].getText()
            let rhs = visitPval(sctx.rhs)!
            let result = Self.doOp(v, rhs, op).get()
            if let ictx = sctx.index {
                let index = visitPval(ictx)!.get() as! Int
                v.set(index, result)
            } else {
                v.set(result)
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
                de(ErrCase)
            }
            
        case let sctx as PinnParser.SimpleStatementContext:
            
            if let str = sctx.ID()?.getText() {
                let v = getPv(str)
                let rhsv: Int
                switch sctx.DOUBLEOP()!.getText() {
                case "++": rhsv = 1
                case "--": rhsv = -1
                default: de(ErrCase)
                }
                
                if let e = sctx.expr() {
                    let ev = visitPval(e)!.get()
                    let lhsv = v.get(ev as! Ktype) as! Int
                    v.set(ev as! Ktype, lhsv + rhsv)
                    break
                }
                let lhsv = v.get() as! Int
                v.set(lhsv + rhsv)
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
                    de(ErrWrongStatement)
                }
                if cfc.path != .pNormal {
                    break
                }
            }
        case let sctx as PinnParser.SimpleSetContext:
            let str = sctx.ID()!.getText()
            let v = getPv(str)
            if sctx.expr().count == 2 {
                let key = visitPval(sctx.expr(0)!)!.get()
                let value = visitPval(sctx.expr(1)!)!.get()
                v.set(key as! Ktype, value)
            } else {
                
                let e = visitPval(sctx.expr(0)!)!
                if e.kind.gtype == .gScalar {
                    
                    v.set(e.get())
                } else {
                    putPv(str, e)
                }
            }
        case let sctx as PinnParser.IfStatementContext:
            
            let v = visitPval(sctx.expr()!)!
            if v.get() as! Bool {
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
                b = v.get() as! Bool
                
            }
        case let sctx as PinnParser.WhStatementContext:
            
            var v = visitPval(sctx.expr()!)!
            
            while v.get() as! Bool {
                visit(sctx.block()!)
                if  cfc.toEndBlock() {break}
                v = visitPval(sctx.expr()!)!
            }
        case let sctx as PinnParser.FoStatementContext:
            if sctx.RANGE() != nil {
                var key: Pval?
                var value: Pval
                if sctx.COMMA() != nil {
                    key = getPv(sctx.ID(0)!.getText())
                    value = getPv(sctx.ID(1)!.getText())
                } else {
                    value = getPv(sctx.ID(0)!.getText())
                }
                
                let ranger = visitPval(sctx.expr()!)!
                switch ranger.kind.gtype {
                case .gSlice, .gArray:
                    for x in 0..<ranger.kind.count! {
                        value.set(ranger.get(x))
                        key?.set(x)
                        
                        visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                    }
                case .gMap:
                    let keys = ranger.getKeys()
                    for mkey in keys {
                        key?.set(mkey)
                        value.set(ranger.get(mkey))
                        visit(sctx.block()!)
                        if cfc.toEndBlock() {
                            break
                        }
                        
                        
                    }
                    break
                default:
                    de(ErrCase)
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
            while v.get() as! Bool {
                visit(sctx.block()!)
                
                if  cfc.toEndBlock() {break}
                visit(sctx.sss)
                v = visitPval(sctx.expr()!)!
                
            }
        case let sctx as PinnParser.GuardStatementContext:
            let v = visitPval(sctx.expr()!)!
            if !(v.get() as! Bool) {
                visit(sctx.block()!)
                if cfc.path == .pNormal {
                    de(ErrWrongStatement)
                }
            }
            
        case let sctx as PinnParser.VarDeclContext:
            let str = sctx.ID()!.getText()
            let map = lfc?.m ?? fc.m
            var newV: Pval
            if let prev = map[str] {
                de(ErrRedeclare)
            }
            if sctx.CE() != nil {
                newV = visitPval(sctx.expr()!)!
            } else {
                
                let k = visitKind(sctx.kind()!)
                if let el = sctx.exprList() {
                    let ai = visitList(el)
                    k.count = k.count ?? ai.count
                    newV = Pval(k, nil)
                    switch k.gtype {
                    case .gScalar:
                        if ai.count != 1 {
                            de(ErrParamLength)
                        }
                        newV.set(ai[0].get())
                    case .gArray, .gSlice:
                        if k.count! != ai.count {
                            de(ErrParamLength)
                        }
                        for (key, value) in ai.enumerated() {
                            newV.set(key, value.get())
                        }
                    case .gMap:
                        de(ErrWrongType)
                    }
                    
                } else {
                    newV = Pval(k)
                }
            }
            if lfc != nil {
                lfc!.m[str] = newV
            } else {
                fc.m[str] = newV
            }
            
        default: break
        }
    }
    
    
}
