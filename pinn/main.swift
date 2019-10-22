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
var myinput = """
func main()
{
        print (A);
        print (44);
}

"""





class Pvisitor {
    init() {}
    class PVal {
        
    }
    
    class PArray <V>: PVal {
        var ar: [V] = []
        func get(_ k: Int) -> V {
            return ar[k]
        }
        func set(_ k: Int, v: V) {
            ar[k] = v
        }
    }
    
    enum Gtype {
        case gScalar, gArray, gSlice, gMap
    }
    struct Kind {
        var vtype: Any.Type
        var gtype: Gtype
    }
    struct FKind {
        var k: Kind
        var s: String
    }
    struct Fc {
        var m = [String: PVal]()
        var rt: PVal?
    }
    
    var fc = Fc()
    
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
    
    func visitFunction(_ ctx:PinnParser.FunctionContext, _ s: [PVal], _ str: String) throws -> PVal? {
        let oldfc = fc
        fc = Fc()
        let fh = fkmap[str]!
        if s.count != fh.fkinds.count {
            throw ErrParamLength()
        }
        var index = 0
        for v in s {
            fc.m[fh.fkinds[index].s] = v
            index += 1
        }
        visit(ctx.block()!)
        let rt = fc.rt
        fc = oldfc
        return rt
    }
    
    
    func start(_ ctx: PinnParser.FileContext) throws {
        prc = ctx
        for child in ctx.function() {
            try! header(child)
        }
        let MAIN = "main"
        _ = try! visitFunction(fkmap[MAIN]!.fc, [PVal](), MAIN)
    }
    func visit(_ ctx: PinnParser.FuncExprContext) {
        
        switch ctx.getStart()!.getText()! {
        case "print":
            print(ctx.exprList()!.getText(), "gottext")
        default:
            break;
        }
    }
    func visitKind(_ sctx: PinnParser.KindContext) -> Kind {
        let strType = sctx.TYPES()!.getText()
        let vtype = litToType[strType]!
        let gtype: Gtype
        if sctx.MAP() != nil {
            gtype = .gMap
        } else if sctx.SLICE() != nil {
            gtype = .gSlice
        } else {
            gtype = .gScalar
        }
        return Kind(vtype: vtype, gtype: gtype)
    }
    func visitFKind(_ sctx: PinnParser.FvarDeclContext) -> FKind {
        let str = sctx.ID()!.getText()
        let k = visitKind(sctx.kind()!)
        return FKind(k: k, s: str)
    }
    
    func visit(_ ctx: ParserRuleContext)
    {
    switch ctx {
    case is PinnParser.StatementContext:
        visit(ctx.getChild(0) as! ParserRuleContext)
    case let sctx as PinnParser.BlockContext:
        for child in sctx.statement() {
            visit(child)
        }
        
    default: break
    }
    print("in f")
    }

    
}







var aInput = ANTLRInputStream(myinput)
var lexer = PinnLexer(aInput)
var stream = CommonTokenStream(lexer)
var parser = try! PinnParser(stream)

var tree = try! parser.file()

var pv = Pvisitor()
try! pv.start(tree)



protocol IVal {
    associatedtype Element
    associatedtype Key
    func get(_ a:Key) -> Element
    func set(_ a:Key, _ e:Element)
}
 

enum VType {
    case invalid, int, bool
}

class GVal {

}

