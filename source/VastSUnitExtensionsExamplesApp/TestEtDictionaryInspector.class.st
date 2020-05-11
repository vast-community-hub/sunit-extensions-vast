Class {
	#name : 'TestEtDictionaryInspector',
	#superclass : 'EtWindowsTestCase',
	#category : 'VastSUnitExtensionsExamplesApp'
}

{ #category : 'Testing' }
TestEtDictionaryInspector >> testCreation [
	"Test the creation of this inspector on a target dictionary"

	| inspector target |

	target := Dictionary new.
	1 to: 10000 do: [:i | target at: i asString put: i].
	inspector := self newEtDictionaryInspector: true on: target.
	[
		self
			assert: inspector target == target;
			assert: inspector variableRanges size equals: 100;
			assert: (inspector instVarNamed: 'variables') size equals: 10000;
			assert: (inspector instVarNamed: 'variableNames') size equals: 10000]
				sunitEnsure: [self closeEtWindow: inspector]
]
