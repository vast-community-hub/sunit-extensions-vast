Class {
	#name : 'RunTestSuiteAndReportResultAsJUnitXML',
	#superclass : 'Object',
	#instVars : [
		'suites'
	],
	#category : 'JUnitXMLRendererModelTests'
}

{ #category : 'Not categorized' }
RunTestSuiteAndReportResultAsJUnitXML class >> for: testSuite [

	^self forAll: (Array with: testSuite)
]

{ #category : 'Not categorized' }
RunTestSuiteAndReportResultAsJUnitXML class >> forAll: testSuites [

	^self new initializeForAll: testSuites
]

{ #category : 'Not categorized' }
RunTestSuiteAndReportResultAsJUnitXML >> execute [

	suites do: [:suite | | result |

		result := self runSuite: suite.
		self
			writeFileNamed: (
				'%1.xml'
					bindWith: (suite name asString select: [:character | character isAlphaNumeric]))
			during: [:stream |
				JUnitTestResultXMLRenderer new renderResult: result ofSuite: suite on: stream]]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
RunTestSuiteAndReportResultAsJUnitXML >> initializeForAll: testSuites [

	suites := testSuites
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
RunTestSuiteAndReportResultAsJUnitXML >> logAndExit: stream [

	System errorLog
		cr;
		nextPutAll:
			('%1 Unexpected Error: %2' bindWith: DateAndTime now printString with: stream message);
		flush.
	
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
RunTestSuiteAndReportResultAsJUnitXML >> runSuite: suite [

	| result |

	result := TestResult new.
	[suite run: result] sunitEnsure: [TestResource resetResources: suite resources].
	^result
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
RunTestSuiteAndReportResultAsJUnitXML >> writeFileNamed: aFileName during: aBlock [

	| stream |
	
	"flags explanation
	OWRONLY: Write only.
	OCREAT : Create if does not exist.
	OTRUNC : Truncate instead of append -jmaestri"

	stream := CfsFileStream open: aFileName oflag: (CfsConstants::OWRONLY bitOr: (CfsConstants::OCREAT bitOr: CfsConstants::OTRUNC)).
	stream isCfsError ifTrue: [self logAndExit: stream].
	
	^[aBlock value: stream] ensure: [stream close]
	
]
