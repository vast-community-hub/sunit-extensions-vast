Class {
	#name : 'TestPackagingRules',
	#superclass : 'TestCase',
	#instVars : [
		'packagingRuleMethod',
		'packagingRuleSource',
		'packagingRuleParseTree'
	],
	#category : 'VastSUnitExtensionsApp'
}

{ #category : 'SUnit' }
TestPackagingRules class >> isAbstract [

	^self sunitName = #TestPackagingRules
	
]

{ #category : 'Assertions' }
TestPackagingRules >> assertDoNotReduceAnySubApplications: anAppOrAppName [
	"The ability for this assertion to work depends on the common pattern seen in #packagingRulesFor:
	 Pattern Expected:   aRuleCollector doNotReduceSubApplicationNamed: #ApplicationName.
	 There is some detection in here to keep false positives from happening"

	| theApp |

	theApp :=
		anAppOrAppName isString
			ifTrue: [anAppOrAppName asGlobalKey asClass]
			ifFalse: [anAppOrAppName].
	self assertDoNotReduceSubApplication: theApp.
	theApp allSubApplications do: [:subApp | self assertDoNotReduceSubApplication: subApp].
	self assert: true
]

{ #category : 'Assertions' }
TestPackagingRules >> assertDoNotReduceClass: aClassOrClassName [
	"Check for #doNotReduceClassNamed: rule.  Use the defining application from the packagingRuleMethod compiledMethod
	 as the subapplication to use"
	
	self assertDoNotReduceClass: aClassOrClassName inSubApplication: self packagingRuleMethod methodClass primaryInstance
]

{ #category : 'Assertions' }
TestPackagingRules >> assertDoNotReduceClass: aClassOrClassName inSubApplication: anAppOrAppName [

	| className subAppName ruleCollector isTopLevel description |

	className :=
		(aClassOrClassName isString ifTrue: [aClassOrClassName] ifFalse: [aClassOrClassName name])
			asGlobalKey.
	subAppName :=
		(anAppOrAppName isString ifTrue: [aClassOrClassName] ifFalse: [anAppOrAppName name])
			asGlobalKey.
	isTopLevel := self packagingRuleMethod methodClass primaryInstance name asGlobalKey = subAppName.
	ruleCollector := self packagingRuleCollector.
	self packagingRuleParseTree allNodesDo: [:node |
		node isMessageExpression
			ifTrue: [
				(isTopLevel and: [node selector = #doNotReduceClassNamed:])
					ifTrue: [
						(node receiver isVariable and: [
							node receiver local == ruleCollector
								and: [node arguments first contents asGlobalKey = className]])
									ifTrue: [ "assertion passed" ^true]].
				(node selector = #doNotReduceClassNamed:inSubApplicationNamed:)
					ifTrue: [
						(node receiver isVariable and: [
							node receiver local == ruleCollector and: [
								node arguments first contents asGlobalKey = className
									and: [node arguments second contents asGlobalKey = subAppName]]])
										ifTrue: [ "assertion passed" ^true]]]].

	description :=
		isTopLevel
			ifTrue: [
				'Never found doNotReduceClassNamed: or doNotReduceClassNamed:inSubApplicationNamed: rule for ' ,
					className]
			ifFalse: ['Never found doNotReduceClassNamed: rule for ' , className].
	self assert: false description: description


]

{ #category : 'Assertions' }
TestPackagingRules >> assertDoNotReduceSubApplication: anAppOrAppName [
	"The ability for this assertion to work depends on the common pattern seen in #packagingRulesFor:
	 Pattern Expected:   aRuleCollector doNotReduceSubApplicationNamed: #ApplicationName.
	 There is some detection in here to keep false positives from happening"

	| subAppName ruleCollector selectorToFind |

	selectorToFind := #doNotReduceSubApplicationNamed:.
	subAppName :=
		(anAppOrAppName isString ifTrue: [anAppOrAppName] ifFalse: [anAppOrAppName name]) asGlobalKey.
	ruleCollector := self packagingRuleCollector.
	self packagingRuleParseTree allNodesDo: [:node |
		node isMessageExpression
			ifTrue: [
				(node selector = selectorToFind and: [
					node receiver isVariable and: [
						node receiver local == ruleCollector
							and: [node arguments first contents asGlobalKey = subAppName]]])
								ifTrue: [ "assertion passed" ^true]]].

	self assert: false description: 'Never found doNotReduceSubApplication rule for ' , subAppName


]

{ #category : 'Assertions' }
TestPackagingRules >> assertInitializeToNilClassVariable: aClassVariableName inClass: aClassOrClassName [
	"The ability for this assertion to work depends on the common pattern seen in #packagingRulesFor:
	 Pattern Expected:   aRuleCollector doNotReduceSubApplicationNamed: #ApplicationName.
	 There is some detection in here to keep false positives from happening"

	| className ruleCollector selectorToFind |

	selectorToFind := #initializeToNilClassVariable:inClassNamed:.
	className :=
		(aClassOrClassName isString ifTrue: [aClassOrClassName] ifFalse: [aClassOrClassName name])
			asGlobalKey.
	ruleCollector := self packagingRuleCollector.
	self packagingRuleParseTree allNodesDo: [:node |
		node isMessageExpression
			ifTrue: [
				(node selector = selectorToFind and: [
					node receiver isVariable and: [
						node receiver local == ruleCollector and: [
							node arguments first contents asReducedString = aClassVariableName
								and: [node arguments second contents asGlobalKey = className]]]])
									ifTrue: [ "assertion passed" ^true]]].

	self assert: false description: 'Never found initializeToNilClassVariable:inClassNamed: rule for ' , (aClassVariableName -> className) asString


]

{ #category : 'Accessing' }
TestPackagingRules >> packagingRuleCollector [
	"Answer the actual name <String> of the rule collector argument"

	| argIdx args |

	argIdx := self packagingRuleCollectorArgumentIndex.
	args := self packagingRuleParseTree arguments.
	args size < argIdx
		ifTrue: [
			self signalFailure:
				'Rule Collector argument location out of sync with packager method specification'].
	^args at: argIdx
]

{ #category : 'Accessing' }
TestPackagingRules >> packagingRuleCollectorArgumentIndex [
	"Assuming a layout like #packagingRulesFor:...then the default
	 is that the first argument is the rule collector"
	
	^1
]

{ #category : 'Accessing' }
TestPackagingRules >> packagingRuleMethod [

	^packagingRuleMethod
]

{ #category : 'Accessing' }
TestPackagingRules >> packagingRuleMethod: anObject [

	packagingRuleMethod := anObject
]

{ #category : 'Accessing' }
TestPackagingRules >> packagingRuleParseTree [

	packagingRuleParseTree isNil
		ifTrue: [
			packagingRuleParseTree :=
				EsParser
					parse: self packagingRuleSource
					class: self packagingRuleMethod methodClass
					scanComments: false
					errorHandler: nil
					ifFail: [nil]].
	^packagingRuleParseTree
]

{ #category : 'Accessing' }
TestPackagingRules >> packagingRuleSource [
	"Answer the source code of the packagingRuleMethod <CompiledMethod>"

	packagingRuleSource isNil
		ifTrue: [
			self packagingRuleMethod isNil
				ifTrue: [self signalFailure: 'packagingRuleMethod not set'].
			packagingRuleSource := self packagingRuleMethod sourceString].

	^packagingRuleSource
]

{ #category : 'Setup/Teardown',
  #vaVisibility : 'private' }
TestPackagingRules >> tearDown [
	"Remove method and cached source.
	 While this requires each test case to reconstitute this information, it keeps
	 us from having to deal with test cases that are accidently running other
	 test case packaging rule methods"
	
	packagingRuleMethod := nil.
	packagingRuleSource := nil.
	packagingRuleParseTree := nil
]
