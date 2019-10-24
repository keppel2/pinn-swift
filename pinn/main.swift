//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
import Antlr4



struct ErrParamLength: Error {}
struct ErrWrongType: Error {}
struct ErrRedeclare: Error {}
struct ErrUndeclare: Error {}
var myinput = """
func main()
{
a int;
a = 5;
print(a);
}
"""

protocol Pval {
    var string: String {get}
    func getKind() -> Pvisitor.Kind
    func clone() -> Pval
    func equal(_ p:Pval) -> Bool
}

class aclas {}


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
//    class Pslice <V>: Pval {
//        class inner {
//            var v: V
//            init(_ x: V) {
//                v = x
//            }
//        }
//            var ar: [inner] = []
//            func get(_ k: Int) -> V {
//                return ar[k].v
//            }
//            func set(_ k: Int, v: V) {
//                ar[k].v =
//            }
//            func toString() -> String {
//                return String(describing: ar)
//            }
//            func getKind() -> Kind {
//                return Kind(vtype: V.self, gtype: .gArray, count: ar.count)
//            }
//    }
    
    
    

    //    class Parray <V>: Pval {
    //        var ar: [V?]
    //        func get(_ k: Int) -> V {
    //            return ar[k]!
    //        }
    //        func set(_ k: Int, v: V) {
    //            ar[k] = v
    //        }
    //        func toString() -> String {
    //            return String(describing: ar)
    //        }
    //        func getKind() -> Kind {
    //            return Kind(vtype: V.self, gtype: .gArray, count: ar.count)
    //        }
    //        init(_ x: Int) {
    //            ar = [V?].init(repeating: nil, count: x)
    //        }
    //        func clone() -> Pval<V> {
    //            var rt = Parray<V>(getKind().count!)
    //            return rt
    //        }
    //
    //    }
    
    
    
    
    
    
    class Pscalar <V: Equatable>: Pval {
        //convert to ==
        func equal(_ p:Pval) -> Bool {
            guard let p2 = p as? Self else {
                return false
            }
            return sc == p2.sc
        }
        var sc: V
        init(_ v: V) {
            sc = v
        }

        func get() -> V {
            return sc
        }
        var string: String { return String(describing: sc) }
        func getKind() -> Kind {
            return Kind(vtype: V.self, gtype: .gScalar, count: 1)
        }
        func clone() -> Pval {
            return Pscalar<V>(sc)
        }
    }
    

    
    
    enum Gtype {
        case gScalar, gArray, gSlice, gMap
    }
    struct Kind {

        var vtype: Any.Type
        var gtype: Gtype
        var count: Int?
        func new() -> Pval {
            if vtype == Int.self {
                return Pscalar(0)
            }
            if vtype == Bool.self {
                return Pscalar(false)
            }
            return Pscalar(0)
        }
        func equals(_ k: Kind) -> Bool {
            return vtype == k.vtype && gtype == k.gtype && count == k.count
        }
        func equalsError(_ k2: Kind) throws {
            switch gtype {
            case .gArray, .gScalar:
                if !self.equals(k2) {
                    throw ErrWrongType()
                }
            case .gSlice, .gMap:
                if gtype != k2.gtype || vtype != k2.vtype {
                    throw ErrWrongType()
                }
                
            }
        }
    }
    struct FKind {
        var k: Kind
        var s: String
    }
    struct Fc {
        var m = [String: Pval]()
        var rt: Pval?
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
    func pvAs <V: Equatable> (_ p: Pval) -> V {
        let ps = p as! Pscalar<V>
        return ps.sc
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
//            fh.fkinds[index].k.equalsError()
            fc!.m[fh.fkinds[index].s] = v
            index += 1
        }
        visit(ctx.block()!)
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
        } else if sctx.SLICE() != nil {
            rt = Kind(vtype: vtype, gtype: .gSlice, count: 0)
            
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
    //case let sctx as PinnParser.WhStatementContext:
    case let sctx as PinnParser.VarDeclContext:
        
        let str = sctx.ID()!.getText()
        let map = fc?.m ?? gm
        func doMap(_ m: inout [String: Pval]) throws {
            if m[str] != nil {
                throw ErrRedeclare()
            }
            if sctx.CE() != nil {
                let e = visitPVal(sctx.expr()!)!
                m[str] = e
                return
            }
            let k = visitKind(sctx.kind()!)
            m[str] = k.new()
            
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
try! pv.start(tree)
