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



    //    class Pmap <V>: Pval {
    //        var m = [String: V]()
    //        func get(_ k: String) -> V {
    //            return m[k]!
    //        }
    //        func set(_ k: String, v: V) {
    //            m[k] = v
    //        }
    //        func toString() -> String {
    //            return String(describing: m)
    //        }
    //        func getKind() -> Kind {
    //            return Kind(vtype: V.self, gtype: .gArray, count: m.count)
    //        }
    //        func clone() -> Pval {
    //            return self
    //        }
    //    }

    

    enum Path {
        case pNormal, pExiting, pBreak, pContinue, pFallthrough
    }
    

    struct FKind {
        var k: Kind
        var s: String
        var variadic = false
    }
    struct Fc {
        var m = [String: Pval]()
        var rt: Pval?
        var path = Path.pNormal
        mutating func toEndBlock()  -> Bool {
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
    
    var fc = Fc()
    var lfc: Fc?
    var fkmap = [String:Fheader]()

//    var stack = [ParserRuleContext]()
    
    let litToType: [String: Any.Type] = ["int": Int.self, "bool": Bool.self, "string": String.self]
    
    struct Fheader {
        var funcContext: PinnParser.FunctionContext
        var kind: Kind?
        var fkinds: [FKind]
    }
    
    struct Debug {
        var textStack = [String]()
    }
    var debug = Debug()

    func loadDebug(_ ctx:ParserRuleContext) {
        debug.textStack.append(ctx.getText())
    }
    func popDebug() {
        debug.textStack.removeLast()
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
            fkinds.append(visitFKind(child))
            if fkinds.last!.variadic && index < ctx.fvarDecl().count - 1 {
                de(ErrWrongType)
            }
        }
        fkmap[ctx.ID()!.getText()] = Fheader(funcContext: ctx, kind: k, fkinds: fkinds)
    }
    
    func visitFunction(_ str: String, _ s: [Pval])  -> Pval? {
        let oldfc = lfc
        lfc = Fc()
        let fh = fkmap[str]!
        let ctx = fh.funcContext
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
                let par = Pval(Kind(vtype: v.k.vtype, gtype: .gArray, count: s.count - index), nil)

                for (key, varadds) in s[index...].enumerated() {
                    if !varadds.getKind().kindEquivalent(v.k) {
                        de(ErrWrongType)
                    }
                    par.set(key, varadds.get())
                }
                fc.m[fh.fkinds[index].s] = par
                continue
            }
            if !s[index].getKind().kindEquivalent(v.k) {
                de(ErrWrongType)
            }
            fc.m[fh.fkinds[index].s] = s[index]
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
            if !lfc!.rt!.getKind().kindEquivalent(fh.kind!) {
                de(ErrWrongType)
            }
        }
        let rt = lfc!.rt
        lfc = oldfc
        return rt
    }
    
    
    func start(_ ctx: PinnParser.FileContext)  {
        
        for child in ctx.function() {
             header(child)
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

    func visitKind(_ sctx: PinnParser.KindContext) -> Kind {
        loadDebug(sctx)
        defer {popDebug()}
        let strType = sctx.TYPES()!.getText()
        let vtype = litToType[strType]!
        let rt: Kind
        if sctx.MAP() != nil {
            rt = Kind(vtype: vtype, gtype: .gMap, count: 0)
//        } else if sctx.SLICE() != nil {
//            rt = Kind(vtype: vtype, gtype: .gSlice, count: 0)
//
        } else if sctx.FILL() != nil {
            rt = Kind(vtype: vtype, gtype: .gArray, count: nil)
        } else if sctx.SLICE() != nil {
            rt = Kind(vtype: vtype, gtype: .gSlice, count: 0)
        }
        else if let e = sctx.expr() {
            let v = visitPval(e)!
            let x = v.get() as! Int
            rt = Kind(vtype: vtype, gtype: .gArray, count: x)
        } else {
            rt = Kind(vtype: vtype, gtype: .gScalar, count: 1)
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
    func doOp(_ lhs: Pval, _ rhs: Pval, _ str: String) -> Pval {
        let rt: Pval
        if str == "+" {
            return lhs.plus(rhs)
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
                        rt = Pval(Kind(vtype: Int.self, gtype: .gArray, count: rhsv - lhsv), nil)
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
        if !pvOld.getKind().kindEquivalent(pv.getKind()) {
            de(ErrWrongType)
        }

    }
    func visitCase(_ sctx: PinnParser.CaseStatementContext, _ v: Pval) -> Bool {
        loadDebug(sctx)
        defer {popDebug()}
        var rt = false
        if fc.path == Path.pFallthrough || visitListCase(sctx.exprList()!, v) {
            rt = true
            if fc.path == Path.pFallthrough {
                fc.path = .pNormal
            }
            cloop: for (key, child) in sctx.statement().enumerated() {
                visit(child)
                switch fc.path {
                case .pFallthrough:
                    if key != sctx.statement().count - 1 {
                        de(ErrWrongStatement)
                    }
                    
                case .pBreak:
                    fc.path = .pNormal
                fallthrough
                    case .pContinue, .pExiting:
                        break cloop
                case .pNormal: break
                }
            }
            
        }
        return rt
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
                case .BOOL:
                    let str = sctx.BOOL()!.getText()
                    let x = Bool(str)!
                    let pv = Pval(x)
                    rt = pv
                case .ID:
                    let str = sctx.ID()!.getText()
                    let pv = getPv(str)
                    if pv.getKind().gtype == .gMap {
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
               //     lhs.getKind().equalsError(rhs.getKind())
                    rt = Pval(lhs.equal(rhs))
                    break
                }
                if op == "!=" {
               //     lhs.getKind().equalsError(rhs.getKind())
                    rt = Pval(!lhs.equal(rhs))
                    break
                }

                rt = doOp(lhs, rhs, op)
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
                    let e = visitPval(sctx.expr(0)!)!.get() as! Int
                    rt = Pval(-e)
                    break
                    case "+":
                        let e = visitPval(sctx.expr(0)!)!.get() as! Int
                        rt = Pval(e)
                    break


                default:
                    de(ErrCase)
                }
            

        case let sctx as PinnParser.FuncExprContext:
                switch sctx.getStart()!.getText()! {
                case "len":
                    let str = sctx.ID()!.getText()
                    let v = getPv(str)
                    rt = Pval(v.getKind().count!)
                case "strLen":
                    let e = visitPval(sctx.expr()!)!
                    rt = Pval((e.get() as! String).count)
                case "stringValue":
                    let v = visitPval(sctx.expr()!)!.string
                    rt = Pval(v)
                case "println", "print":
                    var outStr = ""
                    var s = visitList(sctx.exprList()!)
                    if s.count == 1 {

                        print(s[0].string, terminator: "", to: &outStr)
                    } else {
                        print(s[0].string, terminator: "", to: &outStr)
                        s.removeFirst()
                        for e in s {
                            print(", " + e.string, terminator: "", to: &outStr)
                        }
                        print(".", terminator: "", to: &outStr)
                    }
                    if sctx.getStart()!.getText()! == "println" {
                        print(to: &outStr)
                    }
                    print(outStr, terminator: "")
                    fh.write(Data(outStr.utf8))

                case "printH":
                    let e = visitPval(sctx.expr()!)!.get() as! Int
                    print(String(e, radix: 16, uppercase: false))
                    case "printB":
                                       let e = visitPval(sctx.expr()!)!.get() as! Int
                                       print(String(e, radix: 2, uppercase: false))
                case "delete":
                    let e = visitPval(sctx.expr()!)!
                    let v = getPv(sctx.ID()!.getText())
                    v.set(e.get(), nil)
                
                    
                default:
                    break
                }
        case let sctx as PinnParser.IndexExprContext:
            let v =  getPv(sctx.ID()!.getText())
            if (sctx.TWODOTS() != nil || sctx.COLON() != nil) {
                var lhsv = 0
                if let lh = sctx.first {
                    lhsv = visitPval(lh)!.get() as! Int
                }
                var rhsv = v.getKind().count!
                if let rh = sctx.second {
                    rhsv = visitPval(rh)!.get() as! Int
                }
                if (sctx.TWODOTS() != nil) {
                    rhsv+=1
                }
                rt = Pval(Kind(vtype: v.getKind().vtype, gtype: .gSlice, count: rhsv - lhsv), nil)
                rt!.ar = Array(v.ar![lhsv..<rhsv])
            
                
                break
            }
            let e = visitPval(sctx.expr(0)!)!
            let x = e.get()
            let v2 = v.get(x)
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
                    if fc.path == .pFallthrough {
                        broken = false
                        continue
                    }
                    break
                }
            }
            if !broken {
                if fc.path == .pFallthrough {
                    fc.path = .pNormal
                }
                loop:
                    for child in sctx.statement() {
                        visit(child)
                        switch fc.path {
                            
                        case .pBreak: fc.path = .pNormal
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
        let result = doOp(v, rhs, op).get()
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
            fc.path = .pBreak
        case "continue":
            fc.path = .pContinue
        case "fallthrough":
            fc.path = .pFallthrough
        case "debug":
            dbg()
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
                let lhsv = v.get(ev) as! Int
                v.set(ev, lhsv + rhsv)
                break
            }
            let lhsv = v.get() as! Int
            v.set(lhsv + rhsv)
            break
        }
        visit(sctx.getChild(0) as! ParserRuleContext)
    case let sctx as PinnParser.ReturnStatementContext:
        fc.path = .pExiting
        if let e = sctx.expr() {
            fc.rt = visitPval(e)
        }
    case let sctx as PinnParser.BlockContext:
        for child in sctx.statement() {
            visit(child)
            if fc.path == .pFallthrough {
                de(ErrWrongStatement)
            }
            if fc.path != .pNormal {
                break
            }
        }
    case let sctx as PinnParser.SimpleSetContext:
        let str = sctx.ID()!.getText()
        let v = getPv(str)
        if sctx.expr().count == 2 {
            let key = visitPval(sctx.expr(0)!)!.get()
            let value = visitPval(sctx.expr(1)!)!.get()
            v.set(key, value)
        } else {
            
            let e = visitPval(sctx.expr(0)!)!
            if e.getKind().gtype == .gScalar {
                
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
            if  fc.toEndBlock() {
                break
            }
            let v = visitPval(sctx.expr()!)!
            b = v.get() as! Bool
            
        }
    case let sctx as PinnParser.WhStatementContext:
        
        var v = visitPval(sctx.expr()!)!

        while v.get() as! Bool {
            visit(sctx.block()!)
            if  fc.toEndBlock() {break}
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
            switch ranger.getKind().gtype {
            case .gArray:
                for x in 0..<ranger.getKind().count! {
                    value.set(ranger.get(x))
                    key?.set(x)
                    
                    visit(sctx.block()!)
                    if fc.toEndBlock() {
                        break
                    }
                }
            case .gMap:
                let map = ranger.map!
                for (mkey, mvalue) in map {
                    key?.set(mkey)
                    value.set(mvalue)
                    visit(sctx.block()!)
                    if fc.toEndBlock() {
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

            if  fc.toEndBlock() {break}
            visit(sctx.sss)
            v = visitPval(sctx.expr()!)!

        }
    case let sctx as PinnParser.GuardStatementContext:
        let v = visitPval(sctx.expr()!)!
        if !(v.get() as! Bool) {
            visit(sctx.block()!)
            if fc.path == .pNormal {
                de(ErrWrongStatement)
            }
        }
        
    case let sctx as PinnParser.VarDeclContext:
        let str = sctx.ID()!.getText()
        let map = lfc?.m ?? fc.m
        var newV: Pval
        if map[str] != nil {
            de(ErrRedeclare)
        }
        if sctx.CE() != nil {
            newV = visitPval(sctx.expr()!)!
        } else {
            
            var k = visitKind(sctx.kind()!)
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
                newV = Pval(k, nil)
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
