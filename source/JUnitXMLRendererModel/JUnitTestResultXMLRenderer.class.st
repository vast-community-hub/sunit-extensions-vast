Class {
	#name : 'JUnitTestResultXMLRenderer',
	#superclass : 'Object',
	#category : 'JUnitXMLRendererModel'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> attributesForResult: aTestResult ofCase: aTestCase [

	^(Dictionary new)
		at: 'className' put: aTestCase class name;
		at: 'name' put: aTestCase selector;
		at: 'time' put: (self executionTimeStringFor: aTestCase on: aTestResult);
		yourself
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> attributesForResult: aTestResult ofSuite: aTestSuite [

	^(Dictionary new)
		at: 'name' put: aTestSuite name;
		at: 'tests' put: aTestResult runCount;
		at: 'errors' put: aTestResult unexpectedErrorCount;
		at: 'failures' put: aTestResult unexpectedFailureCount;
		at: 'skipped' put: aTestResult expectedDefectCount;
		yourself
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> descriptionFor: aTestCase on: aTestResult [

	^'N/A'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> executionTimeStringFor: aTestCase on: aTestResult [

	^'0.0000'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> output: aString utf8EncodedOn: aStream [

	aStream nextPutAll: (
		EsAbstractCodePageConverter current
			convert: aString
			fromCodePage: EsAbstractCodePageConverter currentCodePage
			toCodePage: EsAbstractCodePageConverter current class utf8CodePage)


]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderAttributes: aDictionary on: aStream [

	aDictionary keys sorted do: [:anAttribute |
		aStream
			space;
			nextPutAll: anAttribute;
			nextPut: $=;
			nextPut: $";
			nextPutAll: (self sanitize: (aDictionary at: anAttribute) asString);
			nextPut: $"]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderBodyFor: aTestSuite withResultsIn: aTestResult on: aStream [

	self
		renderTag: 'testsuite'
		attributes: (self attributesForResult: aTestResult ofSuite: aTestSuite)
		during: [
			self renderPassedTestsOf: aTestResult on: aStream.
			self renderFaliledTestsOf: aTestResult on: aStream.
			self renderErroredTestsOf: aTestResult on: aStream.
			self renderExpectedFailuresOf: aTestResult on: aStream.
			self renderEmptyTag: 'system-out' attributes: Dictionary new on: aStream.
			self renderEmptyTag: 'system-err' attributes: Dictionary new on: aStream]
		on: aStream
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderCharacterData: aString on: aStream [

	aStream
		nextPutAll: '<![CDATA[';
		nextPutAll: aString;
		nextPutAll: ']]>'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderEmptyTag: aTagName attributes: aDictionary on: aStream [

	aStream
		nextPut: $<;
		nextPutAll: aTagName.
	self renderAttributes: aDictionary on: aStream.
	aStream
		nextPut: $/;
		nextPut: $>
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderErroredTestsOf: aTestResult on: aStream [

	self
		sort: aTestResult unexpectedErrors
		thenDo: [:aTestCase |
			self
				renderTag: 'testcase'
				attributes: (self attributesForResult: aTestResult ofCase: aTestCase)
				during: [
					self
						renderTag: 'error'
						withCData: (self descriptionFor: aTestCase on: aTestResult)
						on: aStream]
				on: aStream]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderExpectedFailuresOf: aTestResult on: aStream [

	self
		sort: aTestResult expectedDefects
		thenDo: [:aTestCase |
			self
				renderTag: 'testcase'
				attributes: (self attributesForResult: aTestResult ofCase: aTestCase)
				during: [self renderEmptyTag: 'skipped' attributes: Dictionary new on: aStream]
				on: aStream]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderFaliledTestsOf: aTestResult on: aStream [

	self
		sort: aTestResult unexpectedFailures
		thenDo: [:aTestCase |
			self
				renderTag: 'testcase'
				attributes: (self attributesForResult: aTestResult ofCase: aTestCase)
				during: [
					self
						renderTag: 'failure'
						withCData: (self descriptionFor: aTestCase on: aTestResult)
						on: aStream]
				on: aStream]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderPassedTestsOf: aTestResult on: aStream [

	self
		sort: aTestResult passed
		thenDo: [:aTestCase |
			self
				renderEmptyTag: 'testcase'
				attributes: (self attributesForResult: aTestResult ofCase: aTestCase)
				on: aStream]
]

{ #category : 'Not categorized' }
JUnitTestResultXMLRenderer >> renderResult: aTestResult ofSuite: aTestSuite on: aStream [

	self
		output: (
			String streamContents: [:stream |
				self renderXMLHeaderOn: stream.
				self renderBodyFor: aTestSuite withResultsIn: aTestResult on: stream])
		utf8EncodedOn: aStream
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderTag: aTagName attributes: aDictionary during: aBlock on: aStream [

	aStream
		nextPut: $<;
		nextPutAll: aTagName.
	self renderAttributes: aDictionary on: aStream.
	aStream nextPut: $>.
	aBlock value.
	aStream
		nextPut: $<;
		nextPut: $/;
		nextPutAll: aTagName;
		nextPut: $>
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderTag: aTagName withCData: aString on: aStream [

	self
		renderTag: aTagName
		attributes: Dictionary new
		during: [self renderCharacterData: aString on: aStream]
		on: aStream
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> renderXMLHeaderOn: aStream [

	aStream
		nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>';
		cr
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> sanitize: aString [

	| sanitized |

	sanitized := aString copyReplaceAll: $& asString with: '&amp;'.
	sanitized := sanitized copyReplaceAll: $' asString with: '&apos;'.
	sanitized := sanitized copyReplaceAll: $" asString with: '&quot;'.
	sanitized := sanitized copyReplaceAll: $> asString with: '&gt;'.
	^sanitized copyReplaceAll: $< asString with: '&lt;'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
JUnitTestResultXMLRenderer >> sort: aCollection thenDo: aBlock [

	(aCollection asArray sorted: [:a :b | a asString < b asString]) do: aBlock
]
