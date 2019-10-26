//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4


func meta(_ m: Any.Type) -> Any {
    if m == Int.self {
        return 0
    }
    return false
}
//let m = meta(Int.self)
//
//let x = 0
//print(type(of:m))
//print(type(of:x))
//



var myinput = """
func main()
{
a int;
a = 5;
print(a);
}
"""



class Klass<V: Equatable> {
    init(_ v: V) {}
    func mytype() {
        print(V.self)
    }
}


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

    
    static func newElement(_ vtype: Any.Type)  -> Any {
        var rt: Any
        switch vtype {
        case is Int.Type:
            rt = Int(0)
        case is Bool.Type:
            rt = Bool(false)
        default:
            fatalError(ErrCase)
        }
        return rt
    }
    enum Path {
        case pNormal, pExiting, pBreak, pContinue, pFallthrough
    }
    

    struct FKind {
        var k: Kind
        var s: String
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
                fatalError(ErrCase)
            }
        }
        
    }
    
    var fc: Fc?
    var gm = [String: Pval]()
    var fkmap = [String:Fheader]()
    var prc: ParserRuleContext?
    var stack = [ParserRuleContext]()
    
    let litToType: [String: Any.Type] = ["int": Int.self, "bool": Bool.self]
    
    struct Fheader {
        var fc: PinnParser.FunctionContext
        var kind: Kind?
        var fkinds: [FKind]
    }

    
    func header(_ ctx:PinnParser.FunctionContext )  {
            prc = ctx
        
        if fkmap[ctx.ID()!.getText()] != nil {
 
            fatalError(ErrRedeclare)
        }
        var k: Kind?
        if let kctx = ctx.kind() {
            k = visitKind(kctx)
        }
        var fkinds = [FKind]()
        for child in ctx.fvarDecl() {
            fkinds.append(visitFKind(child))
        }
        fkmap[ctx.ID()!.getText()] = Fheader(fc: ctx, kind: k, fkinds: fkinds)
    }
    
    func visitFunction(_ str: String, _ s: [Pval])  -> Pval? {
        let oldfc = fc
        fc = Fc()
        let fh = fkmap[str]!
        let ctx = fh.fc
        if s.count != fh.fkinds.count {
            fatalError(ErrParamLength)
        }
        var index = 0
        for v in s {
             fh.fkinds[index].k.equalsError(v.getKind())
            fc!.m[fh.fkinds[index].s] = v
            index += 1
        }
        visit(ctx.block()!)
        
        if fc!.rt == nil && fh.kind == nil
        {
            
        }
        else {
             fc!.rt!.getKind().equalsError(fh.kind!)
        }
        let rt = fc!.rt
        fc = oldfc
        return rt
    }
    
    
    func start(_ ctx: PinnParser.FileContext)  {
        prc = ctx
        for child in ctx.function() {
             header(child)
        }
        for child in ctx.varDecl() {
            visit(child)
        }
        _ =  visitFunction("main", [Pval]())
    }

    func visitKind(_ sctx: PinnParser.KindContext) -> Kind {
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
        let str = sctx.ID()!.getText()
        let k = visitKind(sctx.kind()!)
        return FKind(k: k, s: str)
    }
    func visitList(_ sctx: PinnParser.ExprListContext) -> [Pval] {
        var rt = [Pval]()
        for child in sctx.expr() {
            let v = visitPval(child)!
            rt.append(v)
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
        for m in [fc?.m, gm] {
            if m == nil {
                continue
            }
            if let v = m![s] {
                return v
            }
        }
        fatalError(ErrUndeclare)
    }
    func putPv(_ s: String, _ pv: Pval) {
        if fc?.m[s] != nil {
            let pvOld = fc!.m.updateValue(pv, forKey: s)!
             pvOld.getKind().equalsError(pv.getKind())
        } else {
            let pvOld = gm.updateValue(pv, forKey: s)!
             pvOld.getKind().equalsError(pv.getKind())
        }
    }
    func visitPval(_ ctx: ParserRuleContext) -> Pval? {
        var rt: Pval?
        switch ctx {
        case let sctx as PinnParser.ExprContext:
            if sctx.getChildCount() == 1 {
                let child = sctx.getChild(0)!
                
                if let cchild = child as? ParserRuleContext {
                    rt = visitPval(cchild)
                    break
                }
                switch Self.childToToken(child) {
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
                    rt = getPv(str)
                default:
                    fatalError(ErrCase)
                }
                break
            }
            if Self.childToToken(sctx.getChild(0)!) == .LPAREN {
                rt = visitPval(sctx.expr(0)!)
                break
            }

            
            if sctx.expr().count == 2 {
                let op = Self.childToText(sctx.getChild(1)!)
                let lhs = visitPval(sctx.expr(0)!)!
                let lhsv = lhs.get() as! Int
                let rhs = visitPval(sctx.expr(1)!)!
                let rhsv = rhs.get() as! Int
                switch op {
                   case "+":
                           rt = Pval(lhsv + rhsv)
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
                   default:
                    break
                }

                
                
                switch Self.childToText(sctx.getChild(0)!) {
                case "!":
                    let e = visitPval(sctx.expr(0)!)!.get() as! Bool
                    rt = Pval(!e)
                    break
                default:
                    fatalError(ErrCase)
                }
                
                
            }
        case let sctx as PinnParser.FuncExprContext:
                switch sctx.getStart()!.getText()! {
                case "print":
                    let s = visitList(sctx.exprList()!)
                    for pv in s {
                        print(pv.string)
                    
                    }
                default:
                    break
                }
        case let sctx as PinnParser.IndexExprContext:
            let v =  getPv(sctx.ID()!.getText())
            let e = visitPval(sctx.expr(0)!)!
            let x = e.get() as! Int
            let v2 = v.get(x)
            rt = Pval(v2)
            
        default: break
        }
        return rt
    }
    func visit(_ ctx: ParserRuleContext)
    {
    switch ctx {
    case let sctx as PinnParser.StatementContext:
        if let e = sctx.expr() {
            _ = visitPval(e)
        } else {
        visit(sctx.getChild(0) as! ParserRuleContext)
        }
    case let sctx as PinnParser.SimpleStatementContext:
        visit(sctx.getChild(0) as! ParserRuleContext)
    case let sctx as PinnParser.ReturnStatementContext:
        fc!.path = .pExiting
        if let e = sctx.expr() {
            fc!.rt = visitPval(e)
        }
    case let sctx as PinnParser.BlockContext:
        for child in sctx.statement() {
            visit(child)
        }
    case let sctx as PinnParser.SimpleSetContext:
        let str = sctx.ID()!.getText()
        let v = getPv(str)
        if sctx.expr().count == 2 {
            let key = visitPval(sctx.expr(0)!)!.get() as! Int
            let value = visitPval(sctx.expr(1)!)!.get()
            v.set(key, value)
        } else {
            let e = visitPval(sctx.expr(0)!)!
            v.set(e.get())
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
            if  fc!.toEndBlock() {
                break
            }
            let v = visitPval(sctx.expr()!)!
            b = v.get() as! Bool
            
        }
    case let sctx as PinnParser.WhStatementContext:
        var v = visitPval(sctx.expr()!)!
        while v.get() as! Bool {
            visit(sctx.block()!)
            if  fc!.toEndBlock() {break}
            v = visitPval(sctx.expr()!)!
        }
    case let sctx as PinnParser.FoStatementContext:
        if let vd = sctx.varDecl() {
            visit(vd)
        }
        if sctx.fss != nil {
            visit(sctx.fss)
        }
        var v = visitPval(sctx.expr()!)!
        if v.get() as! Bool {
            visit(sctx.block()!)
            if  fc!.toEndBlock() {break}
            visit(sctx.sss)
            v = visitPval(sctx.expr()!)!
        }
//    case let sctx as PinnParser.GuardStatementContext:
//        let v = visitPVal(sctx.expr()!)
//        if
        
    case let sctx as PinnParser.VarDeclContext:
        let str = sctx.ID()!.getText()
        let map = fc?.m ?? gm
        func doMap(_ m: inout [String: Pval]) {
            if m[str] != nil {
                fatalError(ErrRedeclare)
            }
            if sctx.CE() == nil {
                var k = visitKind(sctx.kind()!)
                m[str] = Pval(k, nil)
            } else {

                let e = visitPval(sctx.expr()!)!
                m[str] = e
            }
        }
        if fc != nil {
             doMap(&fc!.m)
        } else {
             doMap(&gm)
        }
        
    default: break
    }
    }

    
}







var aInput = ANTLRInputStream(myinput)
var lexer = PinnLexer(aInput)
var stream = CommonTokenStream(lexer)
var parser =  try! PinnParser(stream)

var tree =  try! parser.file()

var pv = Pvisitor()
pv.start(tree)
