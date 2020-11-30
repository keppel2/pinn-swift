// Generated from Pinn.g4 by ANTLR 4.8
import Antlr4

open class PinnParser: Parser {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = PinnParser._ATN.getNumberOfDecisions()
          for i in 0..<length {
            decisionToDFA.append(DFA(PinnParser._ATN.getDecisionState(i)!, i))
           }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	enum Tokens: Int {
		case EOF = -1, T__0 = 1, T__1 = 2, T__2 = 3, T__3 = 4, T__4 = 5, T__5 = 6, 
                 T__6 = 7, T__7 = 8, T__8 = 9, T__9 = 10, T__10 = 11, T__11 = 12, 
                 T__12 = 13, T__13 = 14, T__14 = 15, T__15 = 16, T__16 = 17, 
                 T__17 = 18, T__18 = 19, T__19 = 20, T__20 = 21, T__21 = 22, 
                 T__22 = 23, T__23 = 24, T__24 = 25, T__25 = 26, T__26 = 27, 
                 T__27 = 28, T__28 = 29, T__29 = 30, T__30 = 31, T__31 = 32, 
                 T__32 = 33, T__33 = 34, T__34 = 35, T__35 = 36, T__36 = 37, 
                 T__37 = 38, T__38 = 39, T__39 = 40, T__40 = 41, T__41 = 42, 
                 T__42 = 43, T__43 = 44, T__44 = 45, BOOL = 46, MAP = 47, 
                 LSQUARE = 48, RSQUARE = 49, LPAREN = 50, RPAREN = 51, NIL = 52, 
                 COLON = 53, CE = 54, RANGE = 55, AST = 56, THREEDOT = 57, 
                 AT = 58, CARET = 59, CONST = 60, ID = 61, INT = 62, FLOAT = 63, 
                 WS = 64, STRING = 65
	}

	public
	static let RULE_file = 0, RULE_defines = 1, RULE_function = 2, RULE_block = 3, 
            RULE_fvarDecl = 4, RULE_typeDecl = 5, RULE_varDecl = 6, RULE_kind = 7, 
            RULE_simpleStatement = 8, RULE_lExpr = 9, RULE_structurePair = 10, 
            RULE_objectPair = 11, RULE_expr = 12, RULE_idList = 13, RULE_exprList = 14, 
            RULE_lExprList = 15, RULE_kindList = 16, RULE_returnStatement = 17, 
            RULE_ifStatement = 18, RULE_guardStatement = 19, RULE_whStatement = 20, 
            RULE_loopStatement = 21, RULE_repeatStatement = 22, RULE_foStatement = 23, 
            RULE_caseStatement = 24, RULE_switchStatement = 25, RULE_statement = 26

	public
	static let ruleNames: [String] = [
		"file", "defines", "function", "block", "fvarDecl", "typeDecl", "varDecl", 
		"kind", "simpleStatement", "lExpr", "structurePair", "objectPair", "expr", 
		"idList", "exprList", "lExprList", "kindList", "returnStatement", "ifStatement", 
		"guardStatement", "whStatement", "loopStatement", "repeatStatement", "foStatement", 
		"caseStatement", "switchStatement", "statement"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'#define'", "'func'", "','", "'{'", "'}'", "'type'", "'var'", "'='", 
		"'+'", "'-'", "'/'", "'%'", "'++'", "'--'", "'.'", "'!'", "'<<'", "'>>'", 
		"'&'", "'|'", "'in'", "'=='", "'!='", "'>'", "'<'", "'>='", "'<='", "'&&'", 
		"'||'", "'?'", "'return'", "'if'", "'else'", "'guard'", "'while'", "'loop'", 
		"'repeat'", "'for'", "';'", "'when'", "'match'", "'default'", "'break'", 
		"'continue'", "'fallthrough'", nil, "'map'", "'['", "']'", "'('", "')'", 
		"'nil'", "':'", "':='", "'range'", "'*'", "'...'", "'@'", "'^'", "'const'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, "BOOL", "MAP", "LSQUARE", "RSQUARE", "LPAREN", "RPAREN", 
		"NIL", "COLON", "CE", "RANGE", "AST", "THREEDOT", "AT", "CARET", "CONST", 
		"ID", "INT", "FLOAT", "WS", "STRING"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

	override open
	func getGrammarFileName() -> String { return "Pinn.g4" }

	override open
	func getRuleNames() -> [String] { return PinnParser.ruleNames }

	override open
	func getSerializedATN() -> String { return PinnParser._serializedATN }

	override open
	func getATN() -> ATN { return PinnParser._ATN }


	override open
	func getVocabulary() -> Vocabulary {
	    return PinnParser.VOCABULARY
	}

	override public
	init(_ input:TokenStream) throws {
	    RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION)
		try super.init(input)
		_interp = ParserATNSimulator(self,PinnParser._ATN,PinnParser._decisionToDFA, PinnParser._sharedContextCache)
	}


	public class FileContext: ParserRuleContext {
			open
			func EOF() -> TerminalNode? {
				return getToken(PinnParser.Tokens.EOF.rawValue, 0)
			}
			open
			func defines() -> [DefinesContext] {
				return getRuleContexts(DefinesContext.self)
			}
			open
			func defines(_ i: Int) -> DefinesContext? {
				return getRuleContext(DefinesContext.self, i)
			}
			open
			func function() -> [FunctionContext] {
				return getRuleContexts(FunctionContext.self)
			}
			open
			func function(_ i: Int) -> FunctionContext? {
				return getRuleContext(FunctionContext.self, i)
			}
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_file
		}
	}
	@discardableResult
	 open func file() throws -> FileContext {
		var _localctx: FileContext = FileContext(_ctx, getState())
		try enterRule(_localctx, 0, PinnParser.RULE_file)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(57)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__0.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(54)
		 		try defines()


		 		setState(59)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(62) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(62)
		 		try _errHandler.sync(self)
		 		switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .T__1:
		 			setState(60)
		 			try function()

		 			break
		 		case .T__3:fallthrough
		 		case .T__5:fallthrough
		 		case .T__6:fallthrough
		 		case .T__8:fallthrough
		 		case .T__9:fallthrough
		 		case .T__15:fallthrough
		 		case .T__30:fallthrough
		 		case .T__31:fallthrough
		 		case .T__33:fallthrough
		 		case .T__34:fallthrough
		 		case .T__35:fallthrough
		 		case .T__36:fallthrough
		 		case .T__37:fallthrough
		 		case .T__38:fallthrough
		 		case .T__40:fallthrough
		 		case .T__42:fallthrough
		 		case .T__43:fallthrough
		 		case .T__44:fallthrough
		 		case .BOOL:fallthrough
		 		case .LSQUARE:fallthrough
		 		case .LPAREN:fallthrough
		 		case .NIL:fallthrough
		 		case .AST:fallthrough
		 		case .THREEDOT:fallthrough
		 		case .CARET:fallthrough
		 		case .CONST:fallthrough
		 		case .ID:fallthrough
		 		case .INT:fallthrough
		 		case .FLOAT:fallthrough
		 		case .STRING:
		 			setState(61)
		 			try statement()

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}

		 		setState(64); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__1.rawValue,PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__5.rawValue,PinnParser.Tokens.T__6.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__31.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.T__35.rawValue,PinnParser.Tokens.T__36.rawValue,PinnParser.Tokens.T__37.rawValue,PinnParser.Tokens.T__38.rawValue,PinnParser.Tokens.T__40.rawValue,PinnParser.Tokens.T__42.rawValue,PinnParser.Tokens.T__43.rawValue,PinnParser.Tokens.T__44.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.CONST.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 2)
		 	}()
		 	      return testSet
		 	 }())
		 	setState(66)
		 	try match(PinnParser.Tokens.EOF.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DefinesContext: ParserRuleContext {
			open
			func ID() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.ID.rawValue)
			}
			open
			func ID(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_defines
		}
	}
	@discardableResult
	 open func defines() throws -> DefinesContext {
		var _localctx: DefinesContext = DefinesContext(_ctx, getState())
		try enterRule(_localctx, 2, PinnParser.RULE_defines)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(68)
		 	try match(PinnParser.Tokens.T__0.rawValue)
		 	setState(69)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(70)
		 	try match(PinnParser.Tokens.ID.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
			open
			func fvarDecl() -> [FvarDeclContext] {
				return getRuleContexts(FvarDeclContext.self)
			}
			open
			func fvarDecl(_ i: Int) -> FvarDeclContext? {
				return getRuleContext(FvarDeclContext.self, i)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_function
		}
	}
	@discardableResult
	 open func function() throws -> FunctionContext {
		var _localctx: FunctionContext = FunctionContext(_ctx, getState())
		try enterRule(_localctx, 4, PinnParser.RULE_function)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(72)
		 	try match(PinnParser.Tokens.T__1.rawValue)
		 	setState(73)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(74)
		 	try match(PinnParser.Tokens.LPAREN.rawValue)
		 	setState(83)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.ID.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(75)
		 		try fvarDecl()
		 		setState(80)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(76)
		 			try match(PinnParser.Tokens.T__2.rawValue)
		 			setState(77)
		 			try fvarDecl()


		 			setState(82)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(85)
		 	try match(PinnParser.Tokens.RPAREN.rawValue)
		 	setState(87)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,5,_ctx)) {
		 	case 1:
		 		setState(86)
		 		try kind()

		 		break
		 	default: break
		 	}
		 	setState(89)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BlockContext: ParserRuleContext {
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_block
		}
	}
	@discardableResult
	 open func block() throws -> BlockContext {
		var _localctx: BlockContext = BlockContext(_ctx, getState())
		try enterRule(_localctx, 6, PinnParser.RULE_block)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(91)
		 	try match(PinnParser.Tokens.T__3.rawValue)
		 	setState(95)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__5.rawValue,PinnParser.Tokens.T__6.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__31.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.T__35.rawValue,PinnParser.Tokens.T__36.rawValue,PinnParser.Tokens.T__37.rawValue,PinnParser.Tokens.T__38.rawValue,PinnParser.Tokens.T__40.rawValue,PinnParser.Tokens.T__42.rawValue,PinnParser.Tokens.T__43.rawValue,PinnParser.Tokens.T__44.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.CONST.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 4)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(92)
		 		try statement()


		 		setState(97)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(98)
		 	try match(PinnParser.Tokens.T__4.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FvarDeclContext: ParserRuleContext {
			open
			func idList() -> IdListContext? {
				return getRuleContext(IdListContext.self, 0)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
			open
			func THREEDOT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.THREEDOT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_fvarDecl
		}
	}
	@discardableResult
	 open func fvarDecl() throws -> FvarDeclContext {
		var _localctx: FvarDeclContext = FvarDeclContext(_ctx, getState())
		try enterRule(_localctx, 8, PinnParser.RULE_fvarDecl)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(100)
		 	try idList()
		 	setState(102)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.THREEDOT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(101)
		 		try match(PinnParser.Tokens.THREEDOT.rawValue)

		 	}

		 	setState(104)
		 	try kind()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeDeclContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_typeDecl
		}
	}
	@discardableResult
	 open func typeDecl() throws -> TypeDeclContext {
		var _localctx: TypeDeclContext = TypeDeclContext(_ctx, getState())
		try enterRule(_localctx, 10, PinnParser.RULE_typeDecl)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(106)
		 	try match(PinnParser.Tokens.T__5.rawValue)
		 	setState(107)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(108)
		 	try kind()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VarDeclContext: ParserRuleContext {
			open
			func idList() -> IdListContext? {
				return getRuleContext(IdListContext.self, 0)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
			open
			func CONST() -> TerminalNode? {
				return getToken(PinnParser.Tokens.CONST.rawValue, 0)
			}
			open
			func ID() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.ID.rawValue)
			}
			open
			func ID(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, i)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func CE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.CE.rawValue, 0)
			}
			open
			func exprList() -> ExprListContext? {
				return getRuleContext(ExprListContext.self, 0)
			}
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_varDecl
		}
	}
	@discardableResult
	 open func varDecl() throws -> VarDeclContext {
		var _localctx: VarDeclContext = VarDeclContext(_ctx, getState())
		try enterRule(_localctx, 12, PinnParser.RULE_varDecl)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(140)
		 	try _errHandler.sync(self)
		 	switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__6:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(110)
		 		try match(PinnParser.Tokens.T__6.rawValue)
		 		setState(111)
		 		try idList()
		 		setState(112)
		 		try kind()

		 		break

		 	case .CONST:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(114)
		 		try match(PinnParser.Tokens.CONST.rawValue)
		 		setState(115)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(116)
		 		try match(PinnParser.Tokens.T__7.rawValue)
		 		setState(117)
		 		try expr(0)

		 		break

		 	case .ID:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(118)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(123)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(119)
		 			try match(PinnParser.Tokens.T__2.rawValue)
		 			setState(120)
		 			try match(PinnParser.Tokens.ID.rawValue)


		 			setState(125)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(126)
		 		try match(PinnParser.Tokens.CE.rawValue)
		 		setState(127)
		 		try exprList()

		 		break

		 	case .LPAREN:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(128)
		 		try match(PinnParser.Tokens.LPAREN.rawValue)
		 		setState(129)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(134)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(130)
		 			try match(PinnParser.Tokens.T__2.rawValue)
		 			setState(131)
		 			try match(PinnParser.Tokens.ID.rawValue)


		 			setState(136)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(137)
		 		try match(PinnParser.Tokens.RPAREN.rawValue)
		 		setState(138)
		 		try match(PinnParser.Tokens.CE.rawValue)
		 		setState(139)
		 		try expr(0)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class KindContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
			open
			func LSQUARE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LSQUARE.rawValue, 0)
			}
			open
			func RSQUARE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RSQUARE.rawValue, 0)
			}
			open
			func MAP() -> TerminalNode? {
				return getToken(PinnParser.Tokens.MAP.rawValue, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}
			open
			func AST() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AST.rawValue, 0)
			}
			open
			func kindList() -> KindListContext? {
				return getRuleContext(KindListContext.self, 0)
			}
			open
			func structurePair() -> [StructurePairContext] {
				return getRuleContexts(StructurePairContext.self)
			}
			open
			func structurePair(_ i: Int) -> StructurePairContext? {
				return getRuleContext(StructurePairContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_kind
		}
	}
	@discardableResult
	 open func kind() throws -> KindContext {
		var _localctx: KindContext = KindContext(_ctx, getState())
		try enterRule(_localctx, 14, PinnParser.RULE_kind)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(170)
		 	try _errHandler.sync(self)
		 	switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .ID:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(142)
		 		try match(PinnParser.Tokens.ID.rawValue)

		 		break

		 	case .LSQUARE:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(143)
		 		try match(PinnParser.Tokens.LSQUARE.rawValue)
		 		setState(146)
		 		try _errHandler.sync(self)
		 		switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .MAP:
		 		 	setState(144)
		 		 	try match(PinnParser.Tokens.MAP.rawValue)

		 			break
		 		case .T__3:fallthrough
		 		case .T__8:fallthrough
		 		case .T__9:fallthrough
		 		case .T__15:fallthrough
		 		case .BOOL:fallthrough
		 		case .LSQUARE:fallthrough
		 		case .LPAREN:fallthrough
		 		case .NIL:fallthrough
		 		case .AST:fallthrough
		 		case .THREEDOT:fallthrough
		 		case .CARET:fallthrough
		 		case .ID:fallthrough
		 		case .INT:fallthrough
		 		case .FLOAT:fallthrough
		 		case .STRING:
		 		 	setState(145)
		 		 	try expr(0)

		 			break

		 		case .RSQUARE:
		 			break
		 		default:
		 			break
		 		}
		 		setState(148)
		 		try match(PinnParser.Tokens.RSQUARE.rawValue)

		 		setState(150)
		 		try kind()

		 		break
		 	case .LPAREN:fallthrough
		 	case .AST:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(152)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.AST.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(151)
		 			try match(PinnParser.Tokens.AST.rawValue)

		 		}

		 		setState(154)
		 		try match(PinnParser.Tokens.LPAREN.rawValue)
		 		setState(156)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.ID.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(155)
		 			try kindList()

		 		}

		 		setState(158)
		 		try match(PinnParser.Tokens.RPAREN.rawValue)

		 		break

		 	case .T__3:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(159)
		 		try match(PinnParser.Tokens.T__3.rawValue)
		 		setState(160)
		 		try structurePair()
		 		setState(165)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(161)
		 			try match(PinnParser.Tokens.T__2.rawValue)
		 			setState(162)
		 			try structurePair()


		 			setState(167)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(168)
		 		try match(PinnParser.Tokens.T__4.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SimpleStatementContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_simpleStatement
		}
	}
	public class SimpleSetContext: SimpleStatementContext {
			open
			func lExprList() -> LExprListContext? {
				return getRuleContext(LExprListContext.self, 0)
			}
			open
			func exprList() -> ExprListContext? {
				return getRuleContext(ExprListContext.self, 0)
			}

		public
		init(_ ctx: SimpleStatementContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class CompoundSetContext: SimpleStatementContext {
			open
			func lExpr() -> LExprContext? {
				return getRuleContext(LExprContext.self, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func AST() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AST.rawValue, 0)
			}

		public
		init(_ ctx: SimpleStatementContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class DestructureSetContext: SimpleStatementContext {
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func lExprList() -> LExprListContext? {
				return getRuleContext(LExprListContext.self, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}

		public
		init(_ ctx: SimpleStatementContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class DoubleSetContext: SimpleStatementContext {
			open
			func lExpr() -> LExprContext? {
				return getRuleContext(LExprContext.self, 0)
			}

		public
		init(_ ctx: SimpleStatementContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	@discardableResult
	 open func simpleStatement() throws -> SimpleStatementContext {
		var _localctx: SimpleStatementContext = SimpleStatementContext(_ctx, getState())
		try enterRule(_localctx, 16, PinnParser.RULE_simpleStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(190)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,16, _ctx)) {
		 	case 1:
		 		_localctx =  SimpleSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(172)
		 		try lExprList()
		 		setState(173)
		 		try match(PinnParser.Tokens.T__7.rawValue)
		 		setState(174)
		 		try exprList()

		 		break
		 	case 2:
		 		_localctx =  DestructureSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(176)
		 		try match(PinnParser.Tokens.LPAREN.rawValue)
		 		setState(177)
		 		try lExprList()
		 		setState(178)
		 		try match(PinnParser.Tokens.RPAREN.rawValue)
		 		setState(179)
		 		try match(PinnParser.Tokens.T__7.rawValue)
		 		setState(180)
		 		try expr(0)

		 		break
		 	case 3:
		 		_localctx =  CompoundSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(182)
		 		try lExpr()
		 		setState(183)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__10.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.AST.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }())) {
		 		try _errHandler.recoverInline(self)
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}
		 		setState(184)
		 		try match(PinnParser.Tokens.T__7.rawValue)
		 		setState(185)
		 		try expr(0)

		 		break
		 	case 4:
		 		_localctx =  DoubleSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(187)
		 		try lExpr()
		 		setState(188)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.T__12.rawValue || _la == PinnParser.Tokens.T__13.rawValue
		 		      return testSet
		 		 }())) {
		 		try _errHandler.recoverInline(self)
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LExprContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func LSQUARE() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.LSQUARE.rawValue)
			}
			open
			func LSQUARE(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.LSQUARE.rawValue, i)
			}
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}
			open
			func RSQUARE() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.RSQUARE.rawValue)
			}
			open
			func RSQUARE(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.RSQUARE.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_lExpr
		}
	}
	@discardableResult
	 open func lExpr() throws -> LExprContext {
		var _localctx: LExprContext = LExprContext(_ctx, getState())
		try enterRule(_localctx, 18, PinnParser.RULE_lExpr)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(192)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(199)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.LSQUARE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(193)
		 		try match(PinnParser.Tokens.LSQUARE.rawValue)
		 		setState(194)
		 		try expr(0)
		 		setState(195)
		 		try match(PinnParser.Tokens.RSQUARE.rawValue)


		 		setState(201)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StructurePairContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_structurePair
		}
	}
	@discardableResult
	 open func structurePair() throws -> StructurePairContext {
		var _localctx: StructurePairContext = StructurePairContext(_ctx, getState())
		try enterRule(_localctx, 20, PinnParser.RULE_structurePair)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(202)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(203)
		 	try match(PinnParser.Tokens.COLON.rawValue)
		 	setState(204)
		 	try kind()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ObjectPairContext: ParserRuleContext {
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func STRING() -> TerminalNode? {
				return getToken(PinnParser.Tokens.STRING.rawValue, 0)
			}
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_objectPair
		}
	}
	@discardableResult
	 open func objectPair() throws -> ObjectPairContext {
		var _localctx: ObjectPairContext = ObjectPairContext(_ctx, getState())
		try enterRule(_localctx, 22, PinnParser.RULE_objectPair)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(206)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.ID.rawValue || _la == PinnParser.Tokens.STRING.rawValue
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}
		 	setState(207)
		 	try match(PinnParser.Tokens.COLON.rawValue)
		 	setState(208)
		 	try expr(0)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	public class ExprContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_expr
		}
	}
	public class DotIndexExprContext: ExprContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func INT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.INT.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class IntExprContext: ExprContext {
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}
			open
			func AST() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AST.rawValue, 0)
			}
			open
			func CARET() -> TerminalNode? {
				return getToken(PinnParser.Tokens.CARET.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class ObjectLiteralContext: ExprContext {
			open
			func AST() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AST.rawValue, 0)
			}
			open
			func objectPair() -> [ObjectPairContext] {
				return getRuleContexts(ObjectPairContext.self)
			}
			open
			func objectPair(_ i: Int) -> ObjectPairContext? {
				return getRuleContext(ObjectPairContext.self, i)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class ArrayLiteralContext: ExprContext {
			open
			func LSQUARE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LSQUARE.rawValue, 0)
			}
			open
			func RSQUARE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RSQUARE.rawValue, 0)
			}
			open
			func THREEDOT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.THREEDOT.rawValue, 0)
			}
			open
			func exprList() -> ExprListContext? {
				return getRuleContext(ExprListContext.self, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class ParenExprContext: ExprContext {
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class IndexExprContext: ExprContext {
		public var first: ExprContext!
		public var second: ExprContext!
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}
			open
			func LSQUARE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LSQUARE.rawValue, 0)
			}
			open
			func RSQUARE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RSQUARE.rawValue, 0)
			}
			open
			func AT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AT.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class UnaryExprContext: ExprContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class LiteralExprContext: ExprContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func FLOAT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.FLOAT.rawValue, 0)
			}
			open
			func INT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.INT.rawValue, 0)
			}
			open
			func BOOL() -> TerminalNode? {
				return getToken(PinnParser.Tokens.BOOL.rawValue, 0)
			}
			open
			func STRING() -> TerminalNode? {
				return getToken(PinnParser.Tokens.STRING.rawValue, 0)
			}
			open
			func NIL() -> TerminalNode? {
				return getToken(PinnParser.Tokens.NIL.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class CompExprContext: ExprContext {
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class CallExprContext: ExprContext {
			open
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
			}
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}
			open
			func exprList() -> ExprListContext? {
				return getRuleContext(ExprListContext.self, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class TupleExprContext: ExprContext {
			open
			func LPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.LPAREN.rawValue, 0)
			}
			open
			func RPAREN() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RPAREN.rawValue, 0)
			}
			open
			func CARET() -> TerminalNode? {
				return getToken(PinnParser.Tokens.CARET.rawValue, 0)
			}
			open
			func AST() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AST.rawValue, 0)
			}
			open
			func exprList() -> ExprListContext? {
				return getRuleContext(ExprListContext.self, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class BoolExprContext: ExprContext {
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class RangeExprContext: ExprContext {
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}
			open
			func AT() -> TerminalNode? {
				return getToken(PinnParser.Tokens.AT.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class ConditionalExprContext: ExprContext {
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}

	 public final  func expr( ) throws -> ExprContext   {
		return try expr(0)
	}
	@discardableResult
	private func expr(_ _p: Int) throws -> ExprContext   {
		let _parentctx: ParserRuleContext? = _ctx
		var _parentState: Int = getState()
		var _localctx: ExprContext = ExprContext(_ctx, _parentState)
		var  _prevctx: ExprContext = _localctx
		var _startState: Int = 24
		try enterRecursionRule(_localctx, 24, PinnParser.RULE_expr, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(258)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,27, _ctx)) {
			case 1:
				_localctx = ArrayLiteralContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(212)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = _la == PinnParser.Tokens.THREEDOT.rawValue
				      return testSet
				 }()) {
					setState(211)
					try match(PinnParser.Tokens.THREEDOT.rawValue)

				}

				setState(214)
				try match(PinnParser.Tokens.LSQUARE.rawValue)
				setState(216)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 4)
				}()
				      return testSet
				 }()) {
					setState(215)
					try exprList()

				}

				setState(218)
				try match(PinnParser.Tokens.RSQUARE.rawValue)

				break
			case 2:
				_localctx = ObjectLiteralContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(220)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = _la == PinnParser.Tokens.AST.rawValue
				      return testSet
				 }()) {
					setState(219)
					try match(PinnParser.Tokens.AST.rawValue)

				}

				setState(222)
				try match(PinnParser.Tokens.T__3.rawValue)
				setState(231)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = _la == PinnParser.Tokens.ID.rawValue || _la == PinnParser.Tokens.STRING.rawValue
				      return testSet
				 }()) {
					setState(223)
					try objectPair()
					setState(228)
					try _errHandler.sync(self)
					_la = try _input.LA(1)
					while (//closure
					 { () -> Bool in
					      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
					      return testSet
					 }()) {
						setState(224)
						try match(PinnParser.Tokens.T__2.rawValue)
						setState(225)
						try objectPair()


						setState(230)
						try _errHandler.sync(self)
						_la = try _input.LA(1)
					}

				}

				setState(233)
				try match(PinnParser.Tokens.T__4.rawValue)

				break
			case 3:
				_localctx = UnaryExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(234)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 0)
				}()
				      return testSet
				 }())) {
				try _errHandler.recoverInline(self)
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}
				setState(235)
				try expr(10)

				break
			case 4:
				_localctx = CallExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(236)
				try match(PinnParser.Tokens.ID.rawValue)
				setState(237)
				try match(PinnParser.Tokens.LPAREN.rawValue)
				setState(239)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 4)
				}()
				      return testSet
				 }()) {
					setState(238)
					try exprList()

				}

				setState(241)
				try match(PinnParser.Tokens.RPAREN.rawValue)

				break
			case 5:
				_localctx = ParenExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(242)
				try match(PinnParser.Tokens.LPAREN.rawValue)
				setState(243)
				try expr(0)
				setState(244)
				try match(PinnParser.Tokens.RPAREN.rawValue)

				break
			case 6:
				_localctx = TupleExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(247)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = _la == PinnParser.Tokens.CARET.rawValue
				      return testSet
				 }()) {
					setState(246)
					try match(PinnParser.Tokens.CARET.rawValue)

				}

				setState(250)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = _la == PinnParser.Tokens.AST.rawValue
				      return testSet
				 }()) {
					setState(249)
					try match(PinnParser.Tokens.AST.rawValue)

				}

				setState(252)
				try match(PinnParser.Tokens.LPAREN.rawValue)
				setState(254)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 4)
				}()
				      return testSet
				 }()) {
					setState(253)
					try exprList()

				}

				setState(256)
				try match(PinnParser.Tokens.RPAREN.rawValue)

				break
			case 7:
				_localctx = LiteralExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(257)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 46)
				}()
				      return testSet
				 }())) {
				try _errHandler.recoverInline(self)
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}

				break
			default: break
			}
			_ctx!.stop = try _input.LT(-1)
			setState(296)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,32,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(294)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,31, _ctx)) {
					case 1:
						_localctx = IntExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(260)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(261)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__10.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.T__16.rawValue,PinnParser.Tokens.T__17.rawValue,PinnParser.Tokens.T__18.rawValue,PinnParser.Tokens.T__19.rawValue,PinnParser.Tokens.T__20.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.CARET.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(262)
						try expr(10)

						break
					case 2:
						_localctx = CompExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(263)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(264)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, PinnParser.Tokens.T__21.rawValue,PinnParser.Tokens.T__22.rawValue,PinnParser.Tokens.T__23.rawValue,PinnParser.Tokens.T__24.rawValue,PinnParser.Tokens.T__25.rawValue,PinnParser.Tokens.T__26.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(265)
						try expr(9)

						break
					case 3:
						_localctx = BoolExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(266)
						if (!(precpred(_ctx, 7))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 7)"))
						}
						setState(267)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == PinnParser.Tokens.T__27.rawValue || _la == PinnParser.Tokens.T__28.rawValue
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(268)
						try expr(8)

						break
					case 4:
						_localctx = RangeExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(269)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(270)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == PinnParser.Tokens.COLON.rawValue || _la == PinnParser.Tokens.AT.rawValue
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(271)
						try expr(4)

						break
					case 5:
						_localctx = ConditionalExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(272)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(273)
						try match(PinnParser.Tokens.T__29.rawValue)
						setState(274)
						try expr(0)
						setState(275)
						try match(PinnParser.Tokens.COLON.rawValue)
						setState(276)
						try expr(3)

						break
					case 6:
						_localctx = IndexExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(278)
						if (!(precpred(_ctx, 14))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 14)"))
						}
						setState(279)
						try match(PinnParser.Tokens.LSQUARE.rawValue)
						setState(288)
						try _errHandler.sync(self)
						switch(try getInterpreter().adaptivePredict(_input,30, _ctx)) {
						case 1:
							setState(281)
							try _errHandler.sync(self)
							_la = try _input.LA(1)
							if (//closure
							 { () -> Bool in
							      let testSet: Bool = {  () -> Bool in
							   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
							    return  Utils.testBitLeftShiftArray(testArray, 4)
							}()
							      return testSet
							 }()) {
								setState(280)
								try {
										let assignmentValue = try expr(0)
										_localctx.castdown(IndexExprContext.self).first = assignmentValue
								     }()


							}

							setState(283)
							_la = try _input.LA(1)
							if (!(//closure
							 { () -> Bool in
							      let testSet: Bool = _la == PinnParser.Tokens.COLON.rawValue || _la == PinnParser.Tokens.AT.rawValue
							      return testSet
							 }())) {
							try _errHandler.recoverInline(self)
							}
							else {
								_errHandler.reportMatch(self)
								try consume()
							}
							setState(285)
							try _errHandler.sync(self)
							_la = try _input.LA(1)
							if (//closure
							 { () -> Bool in
							      let testSet: Bool = {  () -> Bool in
							   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
							    return  Utils.testBitLeftShiftArray(testArray, 4)
							}()
							      return testSet
							 }()) {
								setState(284)
								try {
										let assignmentValue = try expr(0)
										_localctx.castdown(IndexExprContext.self).second = assignmentValue
								     }()


							}


							break
						case 2:
							setState(287)
							try expr(0)

							break
						default: break
						}
						setState(290)
						try match(PinnParser.Tokens.RSQUARE.rawValue)

						break
					case 7:
						_localctx = DotIndexExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(291)
						if (!(precpred(_ctx, 13))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 13)"))
						}
						setState(292)
						try match(PinnParser.Tokens.T__14.rawValue)
						setState(293)
						try match(PinnParser.Tokens.INT.rawValue)

						break
					default: break
					}
			 
				}
				setState(298)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,32,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class IdListContext: ParserRuleContext {
			open
			func ID() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.ID.rawValue)
			}
			open
			func ID(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_idList
		}
	}
	@discardableResult
	 open func idList() throws -> IdListContext {
		var _localctx: IdListContext = IdListContext(_ctx, getState())
		try enterRule(_localctx, 26, PinnParser.RULE_idList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(299)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(304)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(300)
		 		try match(PinnParser.Tokens.T__2.rawValue)
		 		setState(301)
		 		try match(PinnParser.Tokens.ID.rawValue)


		 		setState(306)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExprListContext: ParserRuleContext {
			open
			func expr() -> [ExprContext] {
				return getRuleContexts(ExprContext.self)
			}
			open
			func expr(_ i: Int) -> ExprContext? {
				return getRuleContext(ExprContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_exprList
		}
	}
	@discardableResult
	 open func exprList() throws -> ExprListContext {
		var _localctx: ExprListContext = ExprListContext(_ctx, getState())
		try enterRule(_localctx, 28, PinnParser.RULE_exprList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(307)
		 	try expr(0)
		 	setState(312)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(308)
		 		try match(PinnParser.Tokens.T__2.rawValue)
		 		setState(309)
		 		try expr(0)


		 		setState(314)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LExprListContext: ParserRuleContext {
			open
			func lExpr() -> [LExprContext] {
				return getRuleContexts(LExprContext.self)
			}
			open
			func lExpr(_ i: Int) -> LExprContext? {
				return getRuleContext(LExprContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_lExprList
		}
	}
	@discardableResult
	 open func lExprList() throws -> LExprListContext {
		var _localctx: LExprListContext = LExprListContext(_ctx, getState())
		try enterRule(_localctx, 30, PinnParser.RULE_lExprList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(315)
		 	try lExpr()
		 	setState(320)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(316)
		 		try match(PinnParser.Tokens.T__2.rawValue)
		 		setState(317)
		 		try lExpr()


		 		setState(322)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class KindListContext: ParserRuleContext {
			open
			func kind() -> [KindContext] {
				return getRuleContexts(KindContext.self)
			}
			open
			func kind(_ i: Int) -> KindContext? {
				return getRuleContext(KindContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_kindList
		}
	}
	@discardableResult
	 open func kindList() throws -> KindListContext {
		var _localctx: KindListContext = KindListContext(_ctx, getState())
		try enterRule(_localctx, 32, PinnParser.RULE_kindList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(323)
		 	try kind()
		 	setState(328)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__2.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(324)
		 		try match(PinnParser.Tokens.T__2.rawValue)
		 		setState(325)
		 		try kind()


		 		setState(330)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ReturnStatementContext: ParserRuleContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_returnStatement
		}
	}
	@discardableResult
	 open func returnStatement() throws -> ReturnStatementContext {
		var _localctx: ReturnStatementContext = ReturnStatementContext(_ctx, getState())
		try enterRule(_localctx, 34, PinnParser.RULE_returnStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(331)
		 	try match(PinnParser.Tokens.T__30.rawValue)
		 	setState(333)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 4)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(332)
		 		try expr(0)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IfStatementContext: ParserRuleContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_ifStatement
		}
	}
	@discardableResult
	 open func ifStatement() throws -> IfStatementContext {
		var _localctx: IfStatementContext = IfStatementContext(_ctx, getState())
		try enterRule(_localctx, 36, PinnParser.RULE_ifStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(335)
		 	try match(PinnParser.Tokens.T__31.rawValue)
		 	setState(336)
		 	try expr(0)
		 	setState(337)
		 	try statement()
		 	setState(340)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,38,_ctx)) {
		 	case 1:
		 		setState(338)
		 		try match(PinnParser.Tokens.T__32.rawValue)
		 		setState(339)
		 		try statement()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class GuardStatementContext: ParserRuleContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_guardStatement
		}
	}
	@discardableResult
	 open func guardStatement() throws -> GuardStatementContext {
		var _localctx: GuardStatementContext = GuardStatementContext(_ctx, getState())
		try enterRule(_localctx, 38, PinnParser.RULE_guardStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(342)
		 	try match(PinnParser.Tokens.T__33.rawValue)
		 	setState(343)
		 	try expr(0)
		 	setState(344)
		 	try match(PinnParser.Tokens.T__32.rawValue)
		 	setState(345)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class WhStatementContext: ParserRuleContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_whStatement
		}
	}
	@discardableResult
	 open func whStatement() throws -> WhStatementContext {
		var _localctx: WhStatementContext = WhStatementContext(_ctx, getState())
		try enterRule(_localctx, 40, PinnParser.RULE_whStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(347)
		 	try match(PinnParser.Tokens.T__34.rawValue)
		 	setState(348)
		 	try expr(0)
		 	setState(349)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LoopStatementContext: ParserRuleContext {
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_loopStatement
		}
	}
	@discardableResult
	 open func loopStatement() throws -> LoopStatementContext {
		var _localctx: LoopStatementContext = LoopStatementContext(_ctx, getState())
		try enterRule(_localctx, 42, PinnParser.RULE_loopStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(351)
		 	try match(PinnParser.Tokens.T__35.rawValue)
		 	setState(352)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class RepeatStatementContext: ParserRuleContext {
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_repeatStatement
		}
	}
	@discardableResult
	 open func repeatStatement() throws -> RepeatStatementContext {
		var _localctx: RepeatStatementContext = RepeatStatementContext(_ctx, getState())
		try enterRule(_localctx, 44, PinnParser.RULE_repeatStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(354)
		 	try match(PinnParser.Tokens.T__36.rawValue)
		 	setState(355)
		 	try block()
		 	setState(356)
		 	try match(PinnParser.Tokens.T__34.rawValue)
		 	setState(357)
		 	try expr(0)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FoStatementContext: ParserRuleContext {
		open var fss: SimpleStatementContext!
		open var sss: SimpleStatementContext!
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
			open
			func simpleStatement() -> [SimpleStatementContext] {
				return getRuleContexts(SimpleStatementContext.self)
			}
			open
			func simpleStatement(_ i: Int) -> SimpleStatementContext? {
				return getRuleContext(SimpleStatementContext.self, i)
			}
			open
			func varDecl() -> VarDeclContext? {
				return getRuleContext(VarDeclContext.self, 0)
			}
			open
			func ID() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.ID.rawValue)
			}
			open
			func ID(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, i)
			}
			open
			func RANGE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.RANGE.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_foStatement
		}
	}
	@discardableResult
	 open func foStatement() throws -> FoStatementContext {
		var _localctx: FoStatementContext = FoStatementContext(_ctx, getState())
		try enterRule(_localctx, 46, PinnParser.RULE_foStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(386)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,40, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(359)
		 		try match(PinnParser.Tokens.T__37.rawValue)
		 		setState(362)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,39,_ctx)) {
		 		case 1:
		 			setState(360)
		 			try varDecl()

		 			break
		 		case 2:
		 			setState(361)
		 			try {
		 					let assignmentValue = try simpleStatement()
		 					_localctx.castdown(FoStatementContext.self).fss = assignmentValue
		 			     }()


		 			break
		 		default: break
		 		}
		 		setState(364)
		 		try match(PinnParser.Tokens.T__38.rawValue)
		 		setState(365)
		 		try expr(0)
		 		setState(366)
		 		try match(PinnParser.Tokens.T__38.rawValue)
		 		setState(367)
		 		try {
		 				let assignmentValue = try simpleStatement()
		 				_localctx.castdown(FoStatementContext.self).sss = assignmentValue
		 		     }()

		 		setState(368)
		 		try block()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(370)
		 		try match(PinnParser.Tokens.T__37.rawValue)
		 		setState(371)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(372)
		 		try match(PinnParser.Tokens.T__2.rawValue)
		 		setState(373)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(374)
		 		try match(PinnParser.Tokens.T__7.rawValue)
		 		setState(375)
		 		try match(PinnParser.Tokens.RANGE.rawValue)
		 		setState(376)
		 		try expr(0)
		 		setState(377)
		 		try block()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(379)
		 		try match(PinnParser.Tokens.T__37.rawValue)
		 		setState(380)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(381)
		 		try match(PinnParser.Tokens.T__7.rawValue)
		 		setState(382)
		 		try match(PinnParser.Tokens.RANGE.rawValue)
		 		setState(383)
		 		try expr(0)
		 		setState(384)
		 		try block()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CaseStatementContext: ParserRuleContext {
			open
			func exprList() -> ExprListContext? {
				return getRuleContext(ExprListContext.self, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_caseStatement
		}
	}
	@discardableResult
	 open func caseStatement() throws -> CaseStatementContext {
		var _localctx: CaseStatementContext = CaseStatementContext(_ctx, getState())
		try enterRule(_localctx, 48, PinnParser.RULE_caseStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(388)
		 	try match(PinnParser.Tokens.T__39.rawValue)
		 	setState(389)
		 	try exprList()
		 	setState(390)
		 	try match(PinnParser.Tokens.COLON.rawValue)
		 	setState(394)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__5.rawValue,PinnParser.Tokens.T__6.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__31.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.T__35.rawValue,PinnParser.Tokens.T__36.rawValue,PinnParser.Tokens.T__37.rawValue,PinnParser.Tokens.T__38.rawValue,PinnParser.Tokens.T__40.rawValue,PinnParser.Tokens.T__42.rawValue,PinnParser.Tokens.T__43.rawValue,PinnParser.Tokens.T__44.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.CONST.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 4)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(391)
		 		try statement()


		 		setState(396)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SwitchStatementContext: ParserRuleContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func caseStatement() -> [CaseStatementContext] {
				return getRuleContexts(CaseStatementContext.self)
			}
			open
			func caseStatement(_ i: Int) -> CaseStatementContext? {
				return getRuleContext(CaseStatementContext.self, i)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_switchStatement
		}
	}
	@discardableResult
	 open func switchStatement() throws -> SwitchStatementContext {
		var _localctx: SwitchStatementContext = SwitchStatementContext(_ctx, getState())
		try enterRule(_localctx, 50, PinnParser.RULE_switchStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(397)
		 	try match(PinnParser.Tokens.T__40.rawValue)
		 	setState(398)
		 	try expr(0)
		 	setState(399)
		 	try match(PinnParser.Tokens.T__3.rawValue)
		 	setState(403)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__39.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(400)
		 		try caseStatement()


		 		setState(405)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(414)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__41.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(406)
		 		try match(PinnParser.Tokens.T__41.rawValue)
		 		setState(407)
		 		try match(PinnParser.Tokens.COLON.rawValue)
		 		setState(411)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, PinnParser.Tokens.T__3.rawValue,PinnParser.Tokens.T__5.rawValue,PinnParser.Tokens.T__6.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__31.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.T__35.rawValue,PinnParser.Tokens.T__36.rawValue,PinnParser.Tokens.T__37.rawValue,PinnParser.Tokens.T__38.rawValue,PinnParser.Tokens.T__40.rawValue,PinnParser.Tokens.T__42.rawValue,PinnParser.Tokens.T__43.rawValue,PinnParser.Tokens.T__44.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.AST.rawValue,PinnParser.Tokens.THREEDOT.rawValue,PinnParser.Tokens.CARET.rawValue,PinnParser.Tokens.CONST.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 4)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(408)
		 			try statement()


		 			setState(413)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(416)
		 	try match(PinnParser.Tokens.T__4.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StatementContext: ParserRuleContext {
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
			open
			func typeDecl() -> TypeDeclContext? {
				return getRuleContext(TypeDeclContext.self, 0)
			}
			open
			func varDecl() -> VarDeclContext? {
				return getRuleContext(VarDeclContext.self, 0)
			}
			open
			func simpleStatement() -> SimpleStatementContext? {
				return getRuleContext(SimpleStatementContext.self, 0)
			}
			open
			func ifStatement() -> IfStatementContext? {
				return getRuleContext(IfStatementContext.self, 0)
			}
			open
			func guardStatement() -> GuardStatementContext? {
				return getRuleContext(GuardStatementContext.self, 0)
			}
			open
			func whStatement() -> WhStatementContext? {
				return getRuleContext(WhStatementContext.self, 0)
			}
			open
			func repeatStatement() -> RepeatStatementContext? {
				return getRuleContext(RepeatStatementContext.self, 0)
			}
			open
			func loopStatement() -> LoopStatementContext? {
				return getRuleContext(LoopStatementContext.self, 0)
			}
			open
			func switchStatement() -> SwitchStatementContext? {
				return getRuleContext(SwitchStatementContext.self, 0)
			}
			open
			func returnStatement() -> ReturnStatementContext? {
				return getRuleContext(ReturnStatementContext.self, 0)
			}
			open
			func foStatement() -> FoStatementContext? {
				return getRuleContext(FoStatementContext.self, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_statement
		}
	}
	@discardableResult
	 open func statement() throws -> StatementContext {
		var _localctx: StatementContext = StatementContext(_ctx, getState())
		try enterRule(_localctx, 52, PinnParser.RULE_statement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(450)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,45, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(418)
		 		try expr(0)
		 		setState(419)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(421)
		 		try typeDecl()
		 		setState(422)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(424)
		 		try varDecl()
		 		setState(425)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(427)
		 		try simpleStatement()
		 		setState(428)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(430)
		 		try ifStatement()

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(431)
		 		try guardStatement()

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(432)
		 		try whStatement()

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(433)
		 		try repeatStatement()
		 		setState(434)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(436)
		 		try loopStatement()

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(437)
		 		try switchStatement()

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(438)
		 		try returnStatement()
		 		setState(439)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(441)
		 		try foStatement()

		 		break
		 	case 13:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(442)
		 		try block()

		 		break
		 	case 14:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(443)
		 		try match(PinnParser.Tokens.T__42.rawValue)
		 		setState(444)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 15:
		 		try enterOuterAlt(_localctx, 15)
		 		setState(445)
		 		try match(PinnParser.Tokens.T__43.rawValue)
		 		setState(446)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 16:
		 		try enterOuterAlt(_localctx, 16)
		 		setState(447)
		 		try match(PinnParser.Tokens.T__44.rawValue)
		 		setState(448)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	case 17:
		 		try enterOuterAlt(_localctx, 17)
		 		setState(449)
		 		try match(PinnParser.Tokens.T__38.rawValue)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	override open
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  12:
			return try expr_sempred(_localctx?.castdown(ExprContext.self), predIndex)
	    default: return true
		}
	}
	private func expr_sempred(_ _localctx: ExprContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 9)
		    case 1:return precpred(_ctx, 8)
		    case 2:return precpred(_ctx, 7)
		    case 3:return precpred(_ctx, 3)
		    case 4:return precpred(_ctx, 2)
		    case 5:return precpred(_ctx, 14)
		    case 6:return precpred(_ctx, 13)
		    default: return true
		}
	}


	public
	static let _serializedATN = PinnParserATN().jsonString

	public
	static let _ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}