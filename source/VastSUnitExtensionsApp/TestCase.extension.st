Extension {
	#name : 'TestCase'
}

{ #category : '*VastSUnitExtensionsApp',
 #vaCategories : ['Not categorized'] }
TestCase >> <= aTestCase [

	"used to sort Ctest output"

	^(self  class name, self selector) <= (aTestCase class name, aTestCase selector).
]

{ #category : '*VastSUnitExtensionsApp',
 #vaCategories : ['Not categorized'] }
TestCase >> randomRun: random result: aResult [
	"Run normally"
	
	aResult runCase: self
]
