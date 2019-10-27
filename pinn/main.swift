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
// 0 tie, 1 player true, 2 player false
// 0 empty, 1 true, 2 false

func coord (x int, y int) int {
    return x * 3 + y;
}

func printBoard (board [9]int) {
    y int;
        for y = range 0:3 {
        print (board[coord(0, y)], board[coord(1, y)], board[coord(2, y)]);
        }
}

func winner (board [9]int) int {
    current int;
    x int;
    y int;
    for x = range 0:3 {
        current = board[coord(x, 0)];
        for y = range 1:3 {
            if board[coord(x, y)] != current {
                current = 0;
            }
        }
        if current != 0 {
            return current;
        }
    }
    for y = range 0:3 {
        current = board[coord(0, y)];
        for x = range 1:3 {
            if board[coord(x, y)] != current {
                current = 0;
            }
        }
        if current != 0 {
            return current;
        }
    }
    if board[coord(0, 0)] != 0 &&
        board[coord(0, 0)] == board[coord(1, 1)] &&
        board[coord(1, 1)] == board[coord(2, 2)] {
            return board[coord(1, 1)];
    }
    if board[coord(2, 0)] != 0 &&
        board[coord(2, 0)] == board[coord(1, 1)] &&
        board[coord(1, 1)] == board[coord(0, 2)] {
            return board[coord(1, 1)];
    }
    return 0;
}

func opposite (x int) int {
    if x == 1 { return 2;}
    return 1;
}

iters int;
            
func minimax (player int, board [9]int) int
{

    result int;
    best int = -1;
    result = winner(board);
    if result != 0 {
        return result;
    }
    x int;
    y int;
    for x = range 0:3 {
        for y = range 0:3 {
            if board[coord(x, y)] == 0 {
                if best == -1 {
                    best = opposite(player);
                }
                board[coord(x, y)] = player;
                result = minimax(opposite(player), board);
                if result == player {
                    return player;
                }
                if result == 0 {
                    best = 0;
                }
                board[coord(x, y)] = 0;
            }
        }
    }
    if best == -1 {
        best = 0;
    }
    return best;
}

func main ( )
{
    board [9]int;
    printBoard(board);
    board[3] = 0;
    result int = minimax (1, board);
    print (result);
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
        for (index, v) in s.enumerated() {
             fh.fkinds[index].k.equalsError(v.getKind())
            fc!.m[fh.fkinds[index].s] = v
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
    func visitListCase(_ sctx: PinnParser.ExprListContext, _ v: Pval) -> Bool {
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
    func doOp(_ lhs: Pval, _ rhs: Pval, _ str: String) -> Pval {
        let rt: Pval
        let lhsv = lhs.get() as! Int
        var rhsv = rhs.get() as! Int
                       switch str {
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
                       case "@":
                        rhsv += 1
                        fallthrough
                       case ":":
                        guard rhsv - lhsv >= 0 else {
                            fatalError(ErrRange)
                        }
                        rt = Pval(Kind(vtype: Int.self, gtype: .gArray, count: rhsv - lhsv), nil)
                        for x in lhsv..<rhsv {
                            rt.set(x - lhsv, x)
                        }
                        
                          default:
                           fatalError(ErrCase)
        }
        return rt
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
    func visitCase(_ sctx: PinnParser.CaseStatementContext, _ v: Pval) -> Bool {
        var rt = false
        if fc!.path == Path.pFallthrough || visitListCase(sctx.exprList()!, v) {
            rt = true
            if fc!.path == Path.pFallthrough {
                fc!.path = .pNormal
            }
            cloop: for (key, child) in sctx.statement().enumerated() {
                visit(child)
                switch fc!.path {
                case .pFallthrough:
                    if key != sctx.statement().count - 1 {
                        fatalError(ErrWrongStatement)
                    }
                    
                case .pBreak:
                    fc!.path = .pNormal
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
                    fatalError(ErrCase)
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
                    rt = Pval(lhs.equal(rhs))
                    break
                }
                if op == "!=" {
                    rt = Pval(!lhs.equal(rhs))
                    break
                }

                rt = doOp(lhs, rhs, op)
                break
               
            }
            if sctx.expr().count == 3 {
                let b = visitPval(sctx.expr(0)!)!.get() as! Bool
                if b {
                    rt = Pval(visitPval(sctx.expr(1)!)!)
                } else {
                    rt = Pval(visitPval(sctx.expr(2)!)!)
                }
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
                    fatalError(ErrCase)
                }
            
        case let sctx as PinnParser.SwitchStatementContext:
            let v = visitPval(sctx.expr()!)!
            var broken = false
            for child in sctx.caseStatement()
            {
                if visitCase(child, v) {
                    broken = true
                    if fc!.path == .pFallthrough {
                        broken = false
                        continue
                    }
                    break
                }
            }
            if !broken {
                if fc!.path == .pFallthrough {
                    fc!.path = .pNormal
                }
                loop:
                    for child in sctx.statement() {
                        visit(child)
                        switch fc!.path {
                            
                        case .pBreak: fc!.path = .pNormal
                            fallthrough
                        case .pContinue, .pExiting: break loop
                        default: break
                        }
                }
            }
        case let sctx as PinnParser.FuncExprContext:
                switch sctx.getStart()!.getText()! {
                case "len":
                    let str = sctx.ID()!.getText()
                    let v = getPv(str)
                    rt = Pval(v.getKind().count!)
                case "print":
                    let s = visitList(sctx.exprList()!)
                    var ar = [String]()
                    for e in s {
                        ar.append(e.string)
                    }
                        print(ar)
                case "printH":
                    let e = visitPval(sctx.expr()!)!.get() as! Int
                    print(String(e, radix: 16, uppercase: false))
                    case "printB":
                                       let e = visitPval(sctx.expr()!)!.get() as! Int
                                       print(String(e, radix: 2, uppercase: false))
                case "delete":
                    let e = visitPval(sctx.expr()!)!
                    let v = getPv(sctx.ID()!.getText())
                    v.set(e.get() as! String, nil)
                    
                default:
                    break
                }
        case let sctx as PinnParser.IndexExprContext:
            let v =  getPv(sctx.ID()!.getText())
            let e = visitPval(sctx.expr(0)!)!
            let x = e.get() as! Int
            let v2 = v.get(x)
            rt = Pval(v2)
            
        default:
//            let schild = ctx.getChild(0) as! ParserRuleContext
//            rt = visitPval(schild)
         fatalError(ErrCase)
        }
        return rt
    }
    func dbg() {
        print(fc!.m)
        
    }
    
    func visit(_ ctx: ParserRuleContext)
    {
    switch ctx {
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
            fc!.path = .pBreak
        case "continue":
            fc!.path = .pContinue
        case "fallthrough":
            fc!.path = .pFallthrough
        case "debug":
            dbg()
        case ";":
            break
        default:
            fatalError(ErrCase)
        }
        
    case let sctx as PinnParser.SimpleStatementContext:
        if let str = sctx.ID()?.getText() {
            let v = getPv(str)
            let rhsv: Int
            switch sctx.DOUBLEOP()!.getText() {
            case "++": rhsv = 1
            case "--": rhsv = -1
            default: fatalError(ErrCase)
            }
            
            if let e = sctx.expr() {
                let ev = visitPval(e)!.get() as! Int
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
        fc!.path = .pExiting
        if let e = sctx.expr() {
            fc!.rt = visitPval(e)
        }
    case let sctx as PinnParser.BlockContext:
        for child in sctx.statement() {
            visit(child)
            if fc!.path == .pFallthrough {
                fatalError(ErrWrongStatement)
            }
            if fc!.path != .pNormal {
                break
            }
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
                    if fc!.toEndBlock() {
                        break
                    }
                }
            case .gMap:
                let map = ranger.map!
                for (mkey, mvalue) in map {
                    key?.set(mkey)
                    value.set(mvalue)
                    visit(sctx.block()!)
                    if fc!.toEndBlock() {
                        break
                    }
                    
                    
                }
                break
            default:
                fatalError(ErrCase)
            }
            break
        }
        if let vd = sctx.varDecl() {
            visit(vd)
        }
        if sctx.fss != nil {
            visit(sctx.fss)
        }
        var v = visitPval(sctx.expr()!)!
        while v.get() as! Bool {
            visit(sctx.block()!)

            if  fc!.toEndBlock() {break}
            visit(sctx.sss)
            v = visitPval(sctx.expr()!)!

        }
    case let sctx as PinnParser.GuardStatementContext:
        let v = visitPval(sctx.expr()!)!
        if !(v.get() as! Bool) {
            visit(sctx.block()!)
            if fc!.path == .pNormal {
                fatalError(ErrWrongStatement)
            }
        }
        
    case let sctx as PinnParser.VarDeclContext:
        let str = sctx.ID()!.getText()
        let map = fc?.m ?? gm
        var newV: Pval
        if map[str] != nil {
            fatalError(ErrRedeclare)
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
                        fatalError(ErrParamLength)
                    }
                    newV.set(ai[0].get())
                case .gArray:
                    if k.count! != ai.count {
                        fatalError(ErrParamLength)
                    }
                    for (key, value) in ai.enumerated() {
                        newV.set(key, value.get())
                    }
                    
                    
                case .gMap:
                    if ai.count != 1 {
                        fatalError(ErrParamLength)
                    }
                    newV = ai[0]
                }
            } else {             newV = Pval(k, nil)
}
        }
        if fc != nil {
            fc!.m[str] = newV
        } else {
            gm[str] = newV
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
//main()
