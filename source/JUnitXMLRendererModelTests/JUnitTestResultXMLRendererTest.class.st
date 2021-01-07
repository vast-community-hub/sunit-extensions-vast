Class {
	#name : 'JUnitTestResultXMLRendererTest',
	#superclass : 'TestCase',
	#category : 'JUnitXMLRendererModelTests'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> assert: firstString equalsIgnoringSeparators: secondString [

	| firstStringSanitized secondStringSanitized |

	firstStringSanitized := firstString reject: [:aCharacter | aCharacter isSeparator].
	secondStringSanitized := secondString reject: [:aCharacter | aCharacter isSeparator].
	self assert: firstStringSanitized equals: secondStringSanitized
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> erroneousTestCase [

	^self class selector: #foo
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> exampleSuite [

	^(TestSuite named: 'Full Suite')
		addTest: self passingTestCase;
		addTest: self failingTestCase;
		addTest: self erroneousTestCase;
		addTest: self expectedErroneousTestCase;
		yourself
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> expectedErroneousTestCase [

	^self class selector: #expectedFoo
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> expectedFailures [

	^#(expectedFoo)
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> failingTestCase [

	^self class selector: #fail
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> failWithInvalidXMLCharacters [

	Error signal: '"''<>&'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRendererTest >> passingTestCase [

	^self class selector: #yourself
]

{ #category : 'Not categorized' }
JUnitTestResultXMLRendererTest >> testRenderingEscapesInvalidXMLCharacters [

	| xml testResult testSuite failingTest |

	testResult := TestResult new.
	testSuite := TestSuite named: '<Suite With Invalid ''XML" &Characters>'.
	failingTest := self class selector: #failWithInvalidXMLCharacters.
	testSuite addTest: failingTest.
	testSuite run: testResult.
	xml :=
		String streamContents: [:stream |
			JUnitTestResultXMLRenderer new renderResult: testResult ofSuite: testSuite on: stream].
	self
		assert: xml
		equalsIgnoringSeparators: (
			'<?xml version="1.0" encoding="UTF-8"?>
		<testsuite errors="1" failures="0" name="&lt;Suite With Invalid &apos;XML&quot; &amp;Characters&gt;" skipped="0" tests="1">
			<testcase className="JUnitTestResultXMLRendererTest" name="failWithInvalidXMLCharacters" time="0.0000">
				<error><![CDATA[N/A]]></error>
			</testcase>
		<system-out/>
		<system-err/>
	</testsuite>'
				bindWith: self class name)


]

{ #category : 'Not categorized' }
JUnitTestResultXMLRendererTest >> testRenderingTestResult [

	| xml testResult testSuite |

	testSuite := self exampleSuite.
	testResult := testSuite run.
	xml :=
		String streamContents: [:stream |
			JUnitTestResultXMLRenderer new renderResult: testResult ofSuite: testSuite on: stream].
	self
		assert: xml
		equalsIgnoringSeparators: (
			'<?xml version="1.0" encoding="UTF-8"?>
					<testsuite errors="1" failures="1" name="Full Suite" skipped="1" tests="4">
						<testcase className="%1" name="%2" time="0.0000"/>
						<testcase className="%1" name="%3" time="0.0000">
							<failure><![CDATA[N/A]]></failure>
						</testcase>
						<testcase className="%1" name="%4" time="0.0000">
							<error><![CDATA[N/A]]></error>
						</testcase>
						<testcase className="%1" name="%5" time="0.0000">
							<skipped/>
						</testcase>
						<system-out/>
						<system-err/>
					</testsuite>'
				bindWithArguments: (
					OrderedCollection new
						add: self class name asString;
						add: self passingTestCase selector asString;
						add: self failingTestCase selector asString;
						add: self erroneousTestCase selector asString;
						add: self expectedErroneousTestCase selector asString;
						asArray))
]
