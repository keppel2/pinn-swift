//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4


main()

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

    
    static func newElement(_ vtype: Any.Type) throws -> Any {
        var rt: Any
        switch vtype {
        case is Int.Type:
            rt = Int(0)
        case is Bool.Type:
            rt = Bool(false)
        default:
            throw ErrCase()
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
        mutating func toEndBlock() throws -> Bool {
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
                throw ErrCase()
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

    
    func header(_ ctx:PinnParser.FunctionContext ) throws {
            prc = ctx
        
        if fkmap[ctx.ID()!.getText()] != nil {
            throw ErrRedeclare()
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
    
    func visitFunction(_ ctx:PinnParser.FunctionContext, _ s: [Pval], _ str: String) throws -> Pval? {
        let oldfc = fc
        fc = Fc()
        let fh = fkmap[str]!
        if s.count != fh.fkinds.count {
            throw ErrParamLength()
        }
        var index = 0
        for v in s {
            try! fh.fkinds[index].k.equalsError(v.getKind())
            fc!.m[fh.fkinds[index].s] = v
            index += 1
        }
        visit(ctx.block()!)
        
        if fc!.rt == nil && fh.kind == nil
        {
            
        }
        else {
            try! fc!.rt!.getKind().equalsError(fh.kind!)
        }
        let rt = fc!.rt
        fc = oldfc
        return rt
    }
    
    
    func start(_ ctx: PinnParser.FileContext) throws {
        prc = ctx
        for child in ctx.function() {
            try! header(child)
        }
        for child in ctx.varDecl() {
            visit(child)
        }
        let MAIN = "main"
        _ = try! visitFunction(fkmap[MAIN]!.fc, [Pval](), MAIN)
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
            let v = visitPVal(e)!
            let x = (v as! Pscalar<Int>).get()
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
            let v = visitPVal(child)!
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
    
    func getPv(_ s: String) throws -> Pval  {
        for m in [fc?.m, gm] {
            if m == nil {
                continue
            }
            if let v = m![s] {
                return v
            }
        }
        throw ErrUndeclare()
    }
    func putPv(_ s: String, _ pv: Pval) {
        if fc?.m[s] != nil {
            let pvOld = fc!.m.updateValue(pv, forKey: s)!
            try! pvOld.getKind().equalsError(pv.getKind())
        } else {
            let pvOld = gm.updateValue(pv, forKey: s)!
            try! pvOld.getKind().equalsError(pv.getKind())
        }
    }
    func visitPVal(_ ctx: ParserRuleContext) -> Pval? {
        var rt: Pval?
        switch ctx {
        case let sctx as PinnParser.ExprContext:
            if sctx.getChildCount() == 1 {
                let child = sctx.getChild(0)!
                
                if let cchild = child as? ParserRuleContext {
                    rt = visitPVal(cchild)
                    break
                }
                switch Self.childToToken(child) {
                case .INT:
                    let str = sctx.INT()!.getText()
                    let x = Int(str)!
                    let pv = Pscalar(x)
                    rt = pv
                case .BOOL:
                    let str = sctx.BOOL()!.getText()
                    let x = Bool(str)!
                    let pv = Pscalar(x)
                    rt = pv
                case .ID:
                    let str = sctx.ID()!.getText()
                    rt = try! getPv(str)
                default:
                    break
                }
            }
            if sctx.expr().count == 2 {
                let op = Self.childToText(sctx.getChild(1)!)
                let lhs = visitPVal(sctx.expr(0)!)!
                let lhsv: Int = pvAs(lhs)
                let rhs = visitPVal(sctx.expr(1)!)!
                let rhsv: Int = pvAs(rhs)
                
                
                
                
                switch op {
                   case "+":
                           rt = Pscalar(lhsv + rhsv)
                   case "-":
                           rt = Pscalar(lhsv - rhsv)
                   case "*":
                           rt = Pscalar(lhsv * rhsv)
                   case "/":
                           rt = Pscalar(lhsv / rhsv)
                   case "%":
                           rt = Pscalar(lhsv % rhsv)
                   case "&":
                           rt = Pscalar(lhsv & rhsv)
                   case "|":
                           rt = Pscalar(lhsv | rhsv)
                   case "^":
                           rt = Pscalar(lhsv ^ rhsv)
                   case "<<":
                           rt = Pscalar(lhsv << rhsv)
                   case ">>":
                           rt = Pscalar(lhsv >> rhsv)
                   case "<":
                           rt = Pscalar(lhsv < rhsv)
                   case "<=":
                           rt = Pscalar(lhsv <= rhsv)
                   case ">":
                           rt = Pscalar(lhsv > rhsv)
                   case ">=":
                           rt = Pscalar(lhsv >= rhsv)
                   default:
                    break
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
            let v = try! getPv(sctx.ID()!.getText())
            let e = visitPVal(sctx.expr(0)!)!
            let x: Int = pvAs(e)
            let v2 = (v as! Parray).getMe(0)
            
        default: break
        }
        return rt
    }
    func visit(_ ctx: ParserRuleContext)
    {
    switch ctx {
    
    case let sctx as PinnParser.StatementContext:
        if let e = sctx.expr() {
            _ = visitPVal(e)
        } else {
        visit(sctx.getChild(0) as! ParserRuleContext)
        }
    case let sctx as PinnParser.SimpleStatementContext:
        visit(sctx.getChild(0) as! ParserRuleContext)
    case let sctx as PinnParser.ReturnStatementContext:
        fc!.path = .pExiting
        if let e = sctx.expr() {
            fc!.rt = visitPVal(e)
        }
    case let sctx as PinnParser.BlockContext:
        for child in sctx.statement() {
            visit(child)
        }
    case let sctx as PinnParser.SimpleSetContext:
        let str = sctx.ID()!.getText()
        let e = visitPVal(sctx.expr(0)!)!
        putPv(str, e)
    case let sctx as PinnParser.IfStatementContext:
        let v = visitPVal(sctx.expr()!)
        if (v as! Pscalar<Bool>).get() {
            visit(sctx.statement(0)!)
        } else if let s2 = sctx.statement(1) {
            visit(s2)
        }
    case let sctx as PinnParser.RepeatStatementContext:
        var b = true
        while b {
            visit(sctx.block()!)
            if try! fc!.toEndBlock() {
                break
            }
            let v = visitPVal(sctx.expr()!)
            b = (v as! Pscalar<Bool>).get()
        }
    case let sctx as PinnParser.WhStatementContext:
        var v = visitPVal(sctx.expr()!)
        while (v as! Pscalar<Bool>).get() {
            visit(sctx.block()!)
            if try! fc!.toEndBlock() {break}
            v = visitPVal(sctx.expr()!)
        }
    case let sctx as PinnParser.FoStatementContext:
        if let vd = sctx.varDecl() {
            visit(vd)
        }
        if sctx.fss != nil {
            visit(sctx.fss)
        }
        var v = visitPVal(sctx.expr()!)
        if (v as! Pscalar<Bool>).get() {
            visit(sctx.block()!)
            if try! fc!.toEndBlock() {break}
            visit(sctx.sss)
            v = visitPVal(sctx.expr()!)
        }
//    case let sctx as PinnParser.GuardStatementContext:
//        let v = visitPVal(sctx.expr()!)
//        if
        
    case let sctx as PinnParser.VarDeclContext:
        let str = sctx.ID()!.getText()
        let map = fc?.m ?? gm
        func doMap(_ m: inout [String: Pval]) throws {
            if m[str] != nil {
                throw ErrRedeclare()
            }
            if sctx.CE() == nil {
                var k = visitKind(sctx.kind()!)
                m[str] = k.new()
            } else {

                let e = visitPVal(sctx.expr()!)!
                m[str] = e
            }
        }
        if fc != nil {
            try! doMap(&fc!.m)
        } else {
            try! doMap(&gm)
        }
        
    default: break
    }
    }

    
}







var aInput = ANTLRInputStream(myinput)
var lexer = PinnLexer(aInput)
var stream = CommonTokenStream(lexer)
var parser = try! PinnParser(stream)

var tree = try! parser.file()

var pv = Pvisitor()
//try! pv.start(tree)
