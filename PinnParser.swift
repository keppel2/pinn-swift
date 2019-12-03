// Generated from Pinn.g4 by ANTLR 4.7.2
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
                 T__32 = 33, T__33 = 34, T__34 = 35, TWODOTS = 36, THREEDOT = 37, 
                 LSQUARE = 38, LPAREN = 39, MAP = 40, SLICE = 41, TYPES = 42, 
                 DOUBLEOP = 43, RANGE = 44, NIL = 45, COMMA = 46, COLON = 47, 
                 CE = 48, IOTA = 49, BINOP = 50, AST = 51, BOOL = 52, ID = 53, 
                 CHAR = 54, INT = 55, FLOAT = 56, WS = 57, STRING = 58
	}

	public
	static let RULE_file = 0, RULE_function = 1, RULE_testRule = 2, RULE_block = 3, 
            RULE_fvarDecl = 4, RULE_varDecl = 5, RULE_kind = 6, RULE_simpleStatement = 7, 
            RULE_lExpr = 8, RULE_objectPair = 9, RULE_dummy = 10, RULE_expr = 11, 
            RULE_exprList = 12, RULE_kindList = 13, RULE_returnStatement = 14, 
            RULE_ifStatement = 15, RULE_guardStatement = 16, RULE_whStatement = 17, 
            RULE_repeatStatement = 18, RULE_foStatement = 19, RULE_caseStatement = 20, 
            RULE_switchStatement = 21, RULE_statement = 22

	public
	static let ruleNames: [String] = [
		"file", "function", "testRule", "block", "fvarDecl", "varDecl", "kind", 
		"simpleStatement", "lExpr", "objectPair", "dummy", "expr", "exprList", 
		"kindList", "returnStatement", "ifStatement", "guardStatement", "whStatement", 
		"repeatStatement", "foStatement", "caseStatement", "switchStatement", 
		"statement"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'func'", "')'", "'{'", "'}'", "'var'", "']'", "'='", "'+'", "'-'", 
		"'^'", "'$$$'", "'!'", "'=='", "'!='", "'>'", "'<'", "'>='", "'<='", "'&&'", 
		"'||'", "'?'", "'return'", "'if'", "'else'", "'guard'", "'while'", "'repeat'", 
		"'for'", "';'", "'when'", "'match'", "'default'", "'break'", "'continue'", 
		"'fallthrough'", "'@'", "'...'", "'['", "'('", "'map'", "'slice'", nil, 
		nil, "'range'", "'nil'", "','", "':'", "':='", "'iota'", nil, "'*'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, "TWODOTS", "THREEDOT", "LSQUARE", 
		"LPAREN", "MAP", "SLICE", "TYPES", "DOUBLEOP", "RANGE", "NIL", "COMMA", 
		"COLON", "CE", "IOTA", "BINOP", "AST", "BOOL", "ID", "CHAR", "INT", "FLOAT", 
		"WS", "STRING"
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
	    RuntimeMetaData.checkVersion("4.7.2", RuntimeMetaData.VERSION)
		try super.init(input)
		_interp = ParserATNSimulator(self,PinnParser._ATN,PinnParser._decisionToDFA, PinnParser._sharedContextCache)
	}


	public class FileContext: ParserRuleContext {
			open
			func EOF() -> TerminalNode? {
				return getToken(PinnParser.Tokens.EOF.rawValue, 0)
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
		 	setState(48) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(48)
		 		try _errHandler.sync(self)
		 		switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .T__0:
		 			setState(46)
		 			try function()

		 			break
		 		case .T__2:fallthrough
		 		case .T__4:fallthrough
		 		case .T__7:fallthrough
		 		case .T__8:fallthrough
		 		case .T__11:fallthrough
		 		case .T__21:fallthrough
		 		case .T__22:fallthrough
		 		case .T__24:fallthrough
		 		case .T__25:fallthrough
		 		case .T__26:fallthrough
		 		case .T__27:fallthrough
		 		case .T__28:fallthrough
		 		case .T__30:fallthrough
		 		case .T__32:fallthrough
		 		case .T__33:fallthrough
		 		case .T__34:fallthrough
		 		case .LSQUARE:fallthrough
		 		case .LPAREN:fallthrough
		 		case .NIL:fallthrough
		 		case .BOOL:fallthrough
		 		case .ID:fallthrough
		 		case .INT:fallthrough
		 		case .FLOAT:fallthrough
		 		case .STRING:
		 			setState(47)
		 			try statement()

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}

		 		setState(50); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__0.rawValue,PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__4.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.T__21.rawValue,PinnParser.Tokens.T__22.rawValue,PinnParser.Tokens.T__24.rawValue,PinnParser.Tokens.T__25.rawValue,PinnParser.Tokens.T__26.rawValue,PinnParser.Tokens.T__27.rawValue,PinnParser.Tokens.T__28.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__32.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }())
		 	setState(52)
		 	try match(PinnParser.Tokens.EOF.rawValue)

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
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_function
		}
	}
	@discardableResult
	 open func function() throws -> FunctionContext {
		var _localctx: FunctionContext = FunctionContext(_ctx, getState())
		try enterRule(_localctx, 2, PinnParser.RULE_function)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(54)
		 	try match(PinnParser.Tokens.T__0.rawValue)
		 	setState(55)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(56)
		 	try match(PinnParser.Tokens.LPAREN.rawValue)
		 	setState(65)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.ID.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(57)
		 		try fvarDecl()
		 		setState(62)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(58)
		 			try match(PinnParser.Tokens.COMMA.rawValue)
		 			setState(59)
		 			try fvarDecl()


		 			setState(64)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(67)
		 	try match(PinnParser.Tokens.T__1.rawValue)
		 	setState(69)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.TYPES.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(68)
		 		try kind()

		 	}

		 	setState(71)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TestRuleContext: ParserRuleContext {
		open var name: ExprContext!
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_testRule
		}
	}
	@discardableResult
	 open func testRule() throws -> TestRuleContext {
		var _localctx: TestRuleContext = TestRuleContext(_ctx, getState())
		try enterRule(_localctx, 4, PinnParser.RULE_testRule)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(73)
		 	try {
		 			let assignmentValue = try expr(0)
		 			_localctx.castdown(TestRuleContext.self).name = assignmentValue
		 	     }()


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
		 	setState(75)
		 	try match(PinnParser.Tokens.T__2.rawValue)
		 	setState(79)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__4.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.T__21.rawValue,PinnParser.Tokens.T__22.rawValue,PinnParser.Tokens.T__24.rawValue,PinnParser.Tokens.T__25.rawValue,PinnParser.Tokens.T__26.rawValue,PinnParser.Tokens.T__27.rawValue,PinnParser.Tokens.T__28.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__32.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(76)
		 		try statement()


		 		setState(81)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(82)
		 	try match(PinnParser.Tokens.T__3.rawValue)

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
			func ID() -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, 0)
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
		 	setState(84)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(86)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.THREEDOT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(85)
		 		try match(PinnParser.Tokens.THREEDOT.rawValue)

		 	}

		 	setState(88)
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
			func ID() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.ID.rawValue)
			}
			open
			func ID(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.ID.rawValue, i)
			}
			open
			func kind() -> KindContext? {
				return getRuleContext(KindContext.self, 0)
			}
			open
			func CE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.CE.rawValue, 0)
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
			func COMMA() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_varDecl
		}
	}
	@discardableResult
	 open func varDecl() throws -> VarDeclContext {
		var _localctx: VarDeclContext = VarDeclContext(_ctx, getState())
		try enterRule(_localctx, 10, PinnParser.RULE_varDecl)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(108)
		 	try _errHandler.sync(self)
		 	switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__4:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(90)
		 		try match(PinnParser.Tokens.T__4.rawValue)
		 		setState(91)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(92)
		 		try kind()

		 		break

		 	case .ID:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(93)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(94)
		 		try match(PinnParser.Tokens.CE.rawValue)
		 		setState(95)
		 		try expr(0)

		 		break

		 	case .LPAREN:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(96)
		 		try match(PinnParser.Tokens.LPAREN.rawValue)
		 		setState(97)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(102)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == PinnParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(98)
		 			try match(PinnParser.Tokens.COMMA.rawValue)
		 			setState(99)
		 			try match(PinnParser.Tokens.ID.rawValue)


		 			setState(104)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(105)
		 		try match(PinnParser.Tokens.T__1.rawValue)
		 		setState(106)
		 		try match(PinnParser.Tokens.CE.rawValue)
		 		setState(107)
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
			func TYPES() -> TerminalNode? {
				return getToken(PinnParser.Tokens.TYPES.rawValue, 0)
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
			func MAP() -> TerminalNode? {
				return getToken(PinnParser.Tokens.MAP.rawValue, 0)
			}
			open
			func SLICE() -> TerminalNode? {
				return getToken(PinnParser.Tokens.SLICE.rawValue, 0)
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
			func kindList() -> KindListContext? {
				return getRuleContext(KindListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_kind
		}
	}
	@discardableResult
	 open func kind() throws -> KindContext {
		var _localctx: KindContext = KindContext(_ctx, getState())
		try enterRule(_localctx, 12, PinnParser.RULE_kind)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(124)
		 	try _errHandler.sync(self)
		 	switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .TYPES:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(110)
		 		try match(PinnParser.Tokens.TYPES.rawValue)

		 		break

		 	case .LSQUARE:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(111)
		 		try match(PinnParser.Tokens.LSQUARE.rawValue)
		 		setState(115)
		 		try _errHandler.sync(self)
		 		switch (PinnParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .MAP:
		 			setState(112)
		 			try match(PinnParser.Tokens.MAP.rawValue)

		 			break

		 		case .SLICE:
		 			setState(113)
		 			try match(PinnParser.Tokens.SLICE.rawValue)

		 			break
		 		case .T__2:fallthrough
		 		case .T__7:fallthrough
		 		case .T__8:fallthrough
		 		case .T__11:fallthrough
		 		case .LSQUARE:fallthrough
		 		case .LPAREN:fallthrough
		 		case .NIL:fallthrough
		 		case .BOOL:fallthrough
		 		case .ID:fallthrough
		 		case .INT:fallthrough
		 		case .FLOAT:fallthrough
		 		case .STRING:
		 			setState(114)
		 			try expr(0)

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(117)
		 		try match(PinnParser.Tokens.T__5.rawValue)

		 		setState(119)
		 		try kind()

		 		break

		 	case .LPAREN:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(120)
		 		try match(PinnParser.Tokens.LPAREN.rawValue)
		 		setState(121)
		 		try kindList()
		 		setState(122)
		 		try match(PinnParser.Tokens.T__1.rawValue)

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
	 
		open
		func copyFrom(_ ctx: SimpleStatementContext) {
			super.copyFrom(ctx)
		}
	}
	public class SimpleSetContext: SimpleStatementContext {
			open
			func lExpr() -> LExprContext? {
				return getRuleContext(LExprContext.self, 0)
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
			func BINOP() -> TerminalNode? {
				return getToken(PinnParser.Tokens.BINOP.rawValue, 0)
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
			open
			func DOUBLEOP() -> TerminalNode? {
				return getToken(PinnParser.Tokens.DOUBLEOP.rawValue, 0)
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
		try enterRule(_localctx, 14, PinnParser.RULE_simpleStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(138)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,11, _ctx)) {
		 	case 1:
		 		_localctx =  SimpleSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(126)
		 		try lExpr()
		 		setState(127)
		 		try match(PinnParser.Tokens.T__6.rawValue)
		 		setState(128)
		 		try expr(0)

		 		break
		 	case 2:
		 		_localctx =  CompoundSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(130)
		 		try lExpr()
		 		setState(131)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__9.rawValue,PinnParser.Tokens.BINOP.rawValue]
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
		 		setState(132)
		 		try match(PinnParser.Tokens.T__6.rawValue)
		 		setState(133)
		 		try expr(0)

		 		break
		 	case 3:
		 		_localctx =  DoubleSetContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(135)
		 		try lExpr()
		 		setState(136)
		 		try match(PinnParser.Tokens.DOUBLEOP.rawValue)

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
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_lExpr
		}
	}
	@discardableResult
	 open func lExpr() throws -> LExprContext {
		var _localctx: LExprContext = LExprContext(_ctx, getState())
		try enterRule(_localctx, 16, PinnParser.RULE_lExpr)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(140)
		 	try match(PinnParser.Tokens.ID.rawValue)
		 	setState(147)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.LSQUARE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(141)
		 		try match(PinnParser.Tokens.LSQUARE.rawValue)
		 		setState(142)
		 		try expr(0)
		 		setState(143)
		 		try match(PinnParser.Tokens.T__5.rawValue)


		 		setState(149)
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

	public class ObjectPairContext: ParserRuleContext {
			open
			func STRING() -> TerminalNode? {
				return getToken(PinnParser.Tokens.STRING.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COLON.rawValue, 0)
			}
			open
			func expr() -> ExprContext? {
				return getRuleContext(ExprContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_objectPair
		}
	}
	@discardableResult
	 open func objectPair() throws -> ObjectPairContext {
		var _localctx: ObjectPairContext = ObjectPairContext(_ctx, getState())
		try enterRule(_localctx, 18, PinnParser.RULE_objectPair)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(150)
		 	try match(PinnParser.Tokens.STRING.rawValue)
		 	setState(151)
		 	try match(PinnParser.Tokens.COLON.rawValue)
		 	setState(152)
		 	try expr(0)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DummyContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_dummy
		}
	}
	@discardableResult
	 open func dummy() throws -> DummyContext {
		var _localctx: DummyContext = DummyContext(_ctx, getState())
		try enterRule(_localctx, 20, PinnParser.RULE_dummy)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(154)
		 	try match(PinnParser.Tokens.T__10.rawValue)

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
	 
		open
		func copyFrom(_ ctx: ExprContext) {
			super.copyFrom(ctx)
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
			func BINOP() -> TerminalNode? {
				return getToken(PinnParser.Tokens.BINOP.rawValue, 0)
			}

		public
		init(_ ctx: ExprContext) {
			super.init()
			copyFrom(ctx)
		}
	}
	public class ObjectLiteralContext: ExprContext {
			open
			func objectPair() -> [ObjectPairContext] {
				return getRuleContexts(ObjectPairContext.self)
			}
			open
			func objectPair(_ i: Int) -> ObjectPairContext? {
				return getRuleContext(ObjectPairContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.COMMA.rawValue, i)
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
			func TWODOTS() -> TerminalNode? {
				return getToken(PinnParser.Tokens.TWODOTS.rawValue, 0)
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
			func TWODOTS() -> TerminalNode? {
				return getToken(PinnParser.Tokens.TWODOTS.rawValue, 0)
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
		var _startState: Int = 22
		try enterRecursionRule(_localctx, 22, PinnParser.RULE_expr, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(189)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,15, _ctx)) {
			case 1:
				_localctx = ArrayLiteralContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(157)
				try match(PinnParser.Tokens.LSQUARE.rawValue)
				setState(158)
				try exprList()
				setState(159)
				try match(PinnParser.Tokens.T__5.rawValue)

				break
			case 2:
				_localctx = ObjectLiteralContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(161)
				try match(PinnParser.Tokens.T__2.rawValue)
				setState(162)
				try objectPair()
				setState(167)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				while (//closure
				 { () -> Bool in
				      let testSet: Bool = _la == PinnParser.Tokens.COMMA.rawValue
				      return testSet
				 }()) {
					setState(163)
					try match(PinnParser.Tokens.COMMA.rawValue)
					setState(164)
					try objectPair()


					setState(169)
					try _errHandler.sync(self)
					_la = try _input.LA(1)
				}
				setState(170)
				try match(PinnParser.Tokens.T__3.rawValue)

				break
			case 3:
				_localctx = UnaryExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(172)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue]
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
				setState(173)
				try expr(10)

				break
			case 4:
				_localctx = CallExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(174)
				try match(PinnParser.Tokens.ID.rawValue)
				setState(175)
				try match(PinnParser.Tokens.LPAREN.rawValue)
				setState(177)
				try _errHandler.sync(self)
				_la = try _input.LA(1)
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 0)
				}()
				      return testSet
				 }()) {
					setState(176)
					try exprList()

				}

				setState(179)
				try match(PinnParser.Tokens.T__1.rawValue)

				break
			case 5:
				_localctx = ParenExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(180)
				try match(PinnParser.Tokens.LPAREN.rawValue)
				setState(181)
				try expr(0)
				setState(182)
				try match(PinnParser.Tokens.T__1.rawValue)

				break
			case 6:
				_localctx = TupleExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(184)
				try match(PinnParser.Tokens.LPAREN.rawValue)
				setState(185)
				try exprList()
				setState(186)
				try match(PinnParser.Tokens.T__1.rawValue)

				break
			case 7:
				_localctx = LiteralExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(188)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
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

				break
			default: break
			}
			_ctx!.stop = try _input.LT(-1)
			setState(224)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,20,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(222)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,19, _ctx)) {
					case 1:
						_localctx = IntExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(191)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(192)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.BINOP.rawValue]
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
						setState(193)
						try expr(10)

						break
					case 2:
						_localctx = CompExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(194)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(195)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, PinnParser.Tokens.T__12.rawValue,PinnParser.Tokens.T__13.rawValue,PinnParser.Tokens.T__14.rawValue,PinnParser.Tokens.T__15.rawValue,PinnParser.Tokens.T__16.rawValue,PinnParser.Tokens.T__17.rawValue]
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
						setState(196)
						try expr(9)

						break
					case 3:
						_localctx = BoolExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(197)
						if (!(precpred(_ctx, 7))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 7)"))
						}
						setState(198)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == PinnParser.Tokens.T__18.rawValue || _la == PinnParser.Tokens.T__19.rawValue
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(199)
						try expr(8)

						break
					case 4:
						_localctx = RangeExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(200)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(201)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == PinnParser.Tokens.TWODOTS.rawValue || _la == PinnParser.Tokens.COLON.rawValue
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(202)
						try expr(4)

						break
					case 5:
						_localctx = ConditionalExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(203)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(204)
						try match(PinnParser.Tokens.T__20.rawValue)
						setState(205)
						try expr(0)
						setState(206)
						try match(PinnParser.Tokens.COLON.rawValue)
						setState(207)
						try expr(3)

						break
					case 6:
						_localctx = IndexExprContext(  ExprContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, PinnParser.RULE_expr)
						setState(209)
						if (!(precpred(_ctx, 13))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 13)"))
						}
						setState(210)
						try match(PinnParser.Tokens.LSQUARE.rawValue)
						setState(219)
						try _errHandler.sync(self)
						switch(try getInterpreter().adaptivePredict(_input,18, _ctx)) {
						case 1:
							setState(212)
							try _errHandler.sync(self)
							_la = try _input.LA(1)
							if (//closure
							 { () -> Bool in
							      let testSet: Bool = {  () -> Bool in
							   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
							    return  Utils.testBitLeftShiftArray(testArray, 0)
							}()
							      return testSet
							 }()) {
								setState(211)
								try {
										let assignmentValue = try expr(0)
										_localctx.castdown(IndexExprContext.self).first = assignmentValue
								     }()


							}

							setState(214)
							_la = try _input.LA(1)
							if (!(//closure
							 { () -> Bool in
							      let testSet: Bool = _la == PinnParser.Tokens.TWODOTS.rawValue || _la == PinnParser.Tokens.COLON.rawValue
							      return testSet
							 }())) {
							try _errHandler.recoverInline(self)
							}
							else {
								_errHandler.reportMatch(self)
								try consume()
							}
							setState(216)
							try _errHandler.sync(self)
							_la = try _input.LA(1)
							if (//closure
							 { () -> Bool in
							      let testSet: Bool = {  () -> Bool in
							   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
							    return  Utils.testBitLeftShiftArray(testArray, 0)
							}()
							      return testSet
							 }()) {
								setState(215)
								try {
										let assignmentValue = try expr(0)
										_localctx.castdown(IndexExprContext.self).second = assignmentValue
								     }()


							}


							break
						case 2:
							setState(218)
							try expr(0)

							break
						default: break
						}
						setState(221)
						try match(PinnParser.Tokens.T__5.rawValue)

						break
					default: break
					}
			 
				}
				setState(226)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,20,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
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
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_exprList
		}
	}
	@discardableResult
	 open func exprList() throws -> ExprListContext {
		var _localctx: ExprListContext = ExprListContext(_ctx, getState())
		try enterRule(_localctx, 24, PinnParser.RULE_exprList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(227)
		 	try expr(0)
		 	setState(232)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(228)
		 		try match(PinnParser.Tokens.COMMA.rawValue)
		 		setState(229)
		 		try expr(0)


		 		setState(234)
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
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(PinnParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(PinnParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return PinnParser.RULE_kindList
		}
	}
	@discardableResult
	 open func kindList() throws -> KindListContext {
		var _localctx: KindListContext = KindListContext(_ctx, getState())
		try enterRule(_localctx, 26, PinnParser.RULE_kindList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(235)
		 	try kind()
		 	setState(240)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(236)
		 		try match(PinnParser.Tokens.COMMA.rawValue)
		 		setState(237)
		 		try kind()


		 		setState(242)
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
		try enterRule(_localctx, 28, PinnParser.RULE_returnStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(243)
		 	try match(PinnParser.Tokens.T__21.rawValue)
		 	setState(245)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(244)
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
		try enterRule(_localctx, 30, PinnParser.RULE_ifStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(247)
		 	try match(PinnParser.Tokens.T__22.rawValue)
		 	setState(248)
		 	try expr(0)
		 	setState(249)
		 	try statement()
		 	setState(252)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,24,_ctx)) {
		 	case 1:
		 		setState(250)
		 		try match(PinnParser.Tokens.T__23.rawValue)
		 		setState(251)
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
		try enterRule(_localctx, 32, PinnParser.RULE_guardStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(254)
		 	try match(PinnParser.Tokens.T__24.rawValue)
		 	setState(255)
		 	try expr(0)
		 	setState(256)
		 	try match(PinnParser.Tokens.T__23.rawValue)
		 	setState(257)
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
		try enterRule(_localctx, 34, PinnParser.RULE_whStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(259)
		 	try match(PinnParser.Tokens.T__25.rawValue)
		 	setState(260)
		 	try expr(0)
		 	setState(261)
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
		try enterRule(_localctx, 36, PinnParser.RULE_repeatStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(263)
		 	try match(PinnParser.Tokens.T__26.rawValue)
		 	setState(264)
		 	try block()
		 	setState(265)
		 	try match(PinnParser.Tokens.T__25.rawValue)
		 	setState(266)
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
			func COMMA() -> TerminalNode? {
				return getToken(PinnParser.Tokens.COMMA.rawValue, 0)
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
		try enterRule(_localctx, 38, PinnParser.RULE_foStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(295)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,26, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(268)
		 		try match(PinnParser.Tokens.T__27.rawValue)
		 		setState(271)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,25,_ctx)) {
		 		case 1:
		 			setState(269)
		 			try varDecl()

		 			break
		 		case 2:
		 			setState(270)
		 			try {
		 					let assignmentValue = try simpleStatement()
		 					_localctx.castdown(FoStatementContext.self).fss = assignmentValue
		 			     }()


		 			break
		 		default: break
		 		}
		 		setState(273)
		 		try match(PinnParser.Tokens.T__28.rawValue)
		 		setState(274)
		 		try expr(0)
		 		setState(275)
		 		try match(PinnParser.Tokens.T__28.rawValue)
		 		setState(276)
		 		try {
		 				let assignmentValue = try simpleStatement()
		 				_localctx.castdown(FoStatementContext.self).sss = assignmentValue
		 		     }()

		 		setState(277)
		 		try block()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(279)
		 		try match(PinnParser.Tokens.T__27.rawValue)
		 		setState(280)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(281)
		 		try match(PinnParser.Tokens.COMMA.rawValue)
		 		setState(282)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(283)
		 		try match(PinnParser.Tokens.T__6.rawValue)
		 		setState(284)
		 		try match(PinnParser.Tokens.RANGE.rawValue)
		 		setState(285)
		 		try expr(0)
		 		setState(286)
		 		try block()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(288)
		 		try match(PinnParser.Tokens.T__27.rawValue)
		 		setState(289)
		 		try match(PinnParser.Tokens.ID.rawValue)
		 		setState(290)
		 		try match(PinnParser.Tokens.T__6.rawValue)
		 		setState(291)
		 		try match(PinnParser.Tokens.RANGE.rawValue)
		 		setState(292)
		 		try expr(0)
		 		setState(293)
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
		try enterRule(_localctx, 40, PinnParser.RULE_caseStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(297)
		 	try match(PinnParser.Tokens.T__29.rawValue)
		 	setState(298)
		 	try exprList()
		 	setState(299)
		 	try match(PinnParser.Tokens.COLON.rawValue)
		 	setState(303)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__4.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.T__21.rawValue,PinnParser.Tokens.T__22.rawValue,PinnParser.Tokens.T__24.rawValue,PinnParser.Tokens.T__25.rawValue,PinnParser.Tokens.T__26.rawValue,PinnParser.Tokens.T__27.rawValue,PinnParser.Tokens.T__28.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__32.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(300)
		 		try statement()


		 		setState(305)
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
		try enterRule(_localctx, 42, PinnParser.RULE_switchStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(306)
		 	try match(PinnParser.Tokens.T__30.rawValue)
		 	setState(307)
		 	try expr(0)
		 	setState(308)
		 	try match(PinnParser.Tokens.T__2.rawValue)
		 	setState(312)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__29.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(309)
		 		try caseStatement()


		 		setState(314)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(323)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == PinnParser.Tokens.T__31.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(315)
		 		try match(PinnParser.Tokens.T__31.rawValue)
		 		setState(316)
		 		try match(PinnParser.Tokens.COLON.rawValue)
		 		setState(320)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, PinnParser.Tokens.T__2.rawValue,PinnParser.Tokens.T__4.rawValue,PinnParser.Tokens.T__7.rawValue,PinnParser.Tokens.T__8.rawValue,PinnParser.Tokens.T__11.rawValue,PinnParser.Tokens.T__21.rawValue,PinnParser.Tokens.T__22.rawValue,PinnParser.Tokens.T__24.rawValue,PinnParser.Tokens.T__25.rawValue,PinnParser.Tokens.T__26.rawValue,PinnParser.Tokens.T__27.rawValue,PinnParser.Tokens.T__28.rawValue,PinnParser.Tokens.T__30.rawValue,PinnParser.Tokens.T__32.rawValue,PinnParser.Tokens.T__33.rawValue,PinnParser.Tokens.T__34.rawValue,PinnParser.Tokens.LSQUARE.rawValue,PinnParser.Tokens.LPAREN.rawValue,PinnParser.Tokens.NIL.rawValue,PinnParser.Tokens.BOOL.rawValue,PinnParser.Tokens.ID.rawValue,PinnParser.Tokens.INT.rawValue,PinnParser.Tokens.FLOAT.rawValue,PinnParser.Tokens.STRING.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(317)
		 			try statement()


		 			setState(322)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(325)
		 	try match(PinnParser.Tokens.T__3.rawValue)

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
		try enterRule(_localctx, 44, PinnParser.RULE_statement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(355)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,31, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(327)
		 		try expr(0)
		 		setState(328)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(330)
		 		try varDecl()
		 		setState(331)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(333)
		 		try simpleStatement()
		 		setState(334)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(336)
		 		try ifStatement()

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(337)
		 		try guardStatement()

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(338)
		 		try whStatement()

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(339)
		 		try repeatStatement()
		 		setState(340)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(342)
		 		try switchStatement()

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(343)
		 		try returnStatement()
		 		setState(344)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(346)
		 		try foStatement()

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(347)
		 		try block()

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(348)
		 		try match(PinnParser.Tokens.T__32.rawValue)
		 		setState(349)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 13:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(350)
		 		try match(PinnParser.Tokens.T__33.rawValue)
		 		setState(351)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 14:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(352)
		 		try match(PinnParser.Tokens.T__34.rawValue)
		 		setState(353)
		 		try match(PinnParser.Tokens.T__28.rawValue)

		 		break
		 	case 15:
		 		try enterOuterAlt(_localctx, 15)
		 		setState(354)
		 		try match(PinnParser.Tokens.T__28.rawValue)

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
		case  11:
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
		    case 5:return precpred(_ctx, 13)
		    default: return true
		}
	}


	public
	static let _serializedATN = PinnParserATN().jsonString

	public
	static let _ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}