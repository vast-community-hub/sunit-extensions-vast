Class {
	#name : 'TestEtTextComparisonBrowser',
	#superclass : 'EtWindowsTestCase',
	#category : 'VastSUnitExtensionsExamplesApp'
}

{ #category : 'Testing' }
TestEtTextComparisonBrowser >> testSelectedApplications [

	| browser |

	browser := self newEtTextComparisonBrowser: true on: 'string1' and: 'string2'.
	[
		self
			assert: browser selectedApplications notNil;
			assert: browser selectedApplications isEmpty]
				sunitEnsure: [self closeEtWindow: browser]
]

{ #category : 'Testing' }
TestEtTextComparisonBrowser >> testSelectedClass [

	| browser methodA methodB |

	methodA := OrderedCollection >> #add:.
	methodB := OrderedCollection >> #addAll:.
	browser :=
		self newEtTextComparisonBrowser: false on: methodA sourceString and: methodB sourceString.
	browser selectedMethod: methodA.
	self openEtWindow: browser.
	[
		self
			assert: browser selectedClass notNil;
			assert: browser selectedClass = OrderedCollection]
				sunitEnsure: [self closeEtWindow: browser]
]

{ #category : 'Testing' }
TestEtTextComparisonBrowser >> testSelectedClassNotSet [

	| browser methodA methodB |

	methodA := OrderedCollection >> #add:.
	methodB := OrderedCollection >> #addAll:.
	browser :=
		self newEtTextComparisonBrowser: true on: methodA sourceString and: methodB sourceString.
	[self assert: browser selectedClass isNil] sunitEnsure: [self closeEtWindow: browser]
]

{ #category : 'Testing' }
TestEtTextComparisonBrowser >> testSelectedMethod [

	| browser methodA methodB |

	methodA := OrderedCollection >> #add:.
	methodB := OrderedCollection >> #addAll:.
	browser := self newEtTextComparisonBrowser: false on: methodA sourceString and: methodB sourceString.
	browser selectedMethod: methodA.
	self openEtWindow: browser.
	[
		self
			assert: browser selectedMethod notNil;
			assert: browser selectedMethod = methodA]
				sunitEnsure: [self closeEtWindow: browser]
]

{ #category : 'Testing' }
TestEtTextComparisonBrowser >> testSelectedMethodNotSet [

	| browser methodA methodB |

	methodA := OrderedCollection >> #add:.
	methodB := OrderedCollection >> #addAll:.
	browser :=
		self newEtTextComparisonBrowser: true on: methodA sourceString and: methodB sourceString.
	[self assert: browser selectedMethod isNil] sunitEnsure: [self closeEtWindow: browser]
]

{ #category : 'Testing' }
TestEtTextComparisonBrowser >> testSelectedMethods [

	| browser |

	browser := self newEtTextComparisonBrowser: true on: 'string1' and: 'string2'.
	[
		self
			assert: browser selectedMethods notNil;
			assert: browser selectedMethods isEmpty]
				sunitEnsure: [self closeEtWindow: browser]
]
