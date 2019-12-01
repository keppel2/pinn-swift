// Generated from Pinn.g4 by ANTLR 4.7.2
import Antlr4

open class PinnLexer: Lexer {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = PinnLexer._ATN.getNumberOfDecisions()
          for i in 0..<length {
          	    decisionToDFA.append(DFA(PinnLexer._ATN.getDecisionState(i)!, i))
          }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	static let T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, 
            T__8=9, T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, 
            T__15=16, T__16=17, T__17=18, T__18=19, T__19=20, T__20=21, 
            T__21=22, T__22=23, T__23=24, T__24=25, T__25=26, T__26=27, 
            T__27=28, T__28=29, T__29=30, T__30=31, T__31=32, T__32=33, 
            T__33=34, TWODOTS=35, THREEDOT=36, LSQUARE=37, LPAREN=38, MAP=39, 
            SLICE=40, TYPES=41, DOUBLEOP=42, RANGE=43, COMMA=44, COLON=45, 
            CE=46, IOTA=47, BINOP=48, BOOL=49, ID=50, CHAR=51, INT=52, FLOAT=53, 
            WS=54, STRING=55

	public
	static let channelNames: [String] = [
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	]

	public
	static let modeNames: [String] = [
		"DEFAULT_MODE"
	]

	public
	static let ruleNames: [String] = [
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", "T__24", 
		"T__25", "T__26", "T__27", "T__28", "T__29", "T__30", "T__31", "T__32", 
		"T__33", "TWODOTS", "THREEDOT", "LSQUARE", "LPAREN", "MAP", "SLICE", "TYPES", 
		"DOUBLEOP", "RANGE", "COMMA", "COLON", "CE", "IOTA", "BINOP", "BOOL", 
		"ID", "CHAR", "INT", "FLOAT", "WS", "STRING", "DECIMAL_DIGIT", "DECIMAL_DIGITS", 
		"DECIMAL_EXPONENT", "HEX_DIGIT", "HEX_DIGITS", "HEX_MANTISSA", "HEX_EXPONENT", 
		"OCTAL_DIGIT", "BINARY_DIGIT"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'func'", "')'", "'{'", "'}'", "'var'", "']'", "'='", "'+'", "'-'", 
		"'^'", "'!'", "'=='", "'!='", "'>'", "'<'", "'>='", "'<='", "'&&'", "'||'", 
		"'?'", "'return'", "'if'", "'else'", "'guard'", "'while'", "'repeat'", 
		"'for'", "';'", "'when'", "'match'", "'default'", "'break'", "'continue'", 
		"'fallthrough'", "'@'", "'...'", "'['", "'('", "'map'", "'slice'", nil, 
		nil, "'range'", "','", "':'", "':='", "'iota'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, "TWODOTS", "THREEDOT", "LSQUARE", "LPAREN", 
		"MAP", "SLICE", "TYPES", "DOUBLEOP", "RANGE", "COMMA", "COLON", "CE", 
		"IOTA", "BINOP", "BOOL", "ID", "CHAR", "INT", "FLOAT", "WS", "STRING"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)


	override open
	func getVocabulary() -> Vocabulary {
		return PinnLexer.VOCABULARY
	}

	public
	required init(_ input: CharStream) {
	    RuntimeMetaData.checkVersion("4.7.2", RuntimeMetaData.VERSION)
		super.init(input)
		_interp = LexerATNSimulator(self, PinnLexer._ATN, PinnLexer._decisionToDFA, PinnLexer._sharedContextCache)
	}

	override open
	func getGrammarFileName() -> String { return "Pinn.g4" }

	override open
	func getRuleNames() -> [String] { return PinnLexer.ruleNames }

	override open
	func getSerializedATN() -> String { return PinnLexer._serializedATN }

	override open
	func getChannelNames() -> [String] { return PinnLexer.channelNames }

	override open
	func getModeNames() -> [String] { return PinnLexer.modeNames }

	override open
	func getATN() -> ATN { return PinnLexer._ATN }


	public
	static let _serializedATN: String = PinnLexerATN().jsonString

	public
	static let _ATN: ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}