Extension {
	#name : 'TestSuite'
}

{ #category : '*VastSUnitExtensionsApp',
 #vaCategories : ['Vast-SUnit'] }
TestSuite >> randomRun: seed [
	"Run the tests in the test suite in a pseudo-random order
	 which can be reconstituted using the @seed <Number>"
	
	| result random |

	result := TestResult new.
	random := EsRandom seed: seed asFloat.
	[self randomRun: random result: result]
		sunitEnsure: [TestResource resetResources: self resources].
	^result
]

{ #category : '*VastSUnitExtensionsApp',
 #vaCategories : ['Vast-SUnit'] }
TestSuite >> randomRun: random result: aResult [
	"Run the tests in the test suite in a random order
	 using the @random RNG"

	| shuffledTests |

	shuffledTests := self tests asArray vaShuffleBy: random.
	shuffledTests do: [:each |
		self sunitChanged: each.
		each randomRun: random result: aResult]
]
