Extension {
	#name : 'TestResult'
}

{ #category : '*VastSUnitExtensionsApp',
 #vaCategories : ['Not categorized'] }
TestResult >> allExpectedTestsPassed [

	^(self hasUnexpectedErrors not and: [self hasUnexpectedFailures not])
		and: [self hasUnexpectedPasses not]
]
