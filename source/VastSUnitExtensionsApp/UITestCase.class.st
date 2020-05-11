Class {
	#name : 'UITestCase',
	#superclass : 'TestCase',
	#category : 'VastSUnitExtensionsApp'
}

{ #category : 'Accessing' }
UITestCase class >> defaultPollDelay [

	^UIWorkQueueTestResource defaultPollDelay
]

{ #category : 'Accessing' }
UITestCase class >> defaultPollDelay: anObject [

	UIWorkQueueTestResource defaultPollDelay: anObject
]

{ #category : 'Accessing' }
UITestCase class >> defaultTimeout [

	^UIWorkQueueTestResource defaultTimeout
]

{ #category : 'Accessing' }
UITestCase class >> defaultTimeout: anObject [

	UIWorkQueueTestResource defaultTimeout: anObject
]

{ #category : 'SUnit' }
UITestCase class >> isAbstract [

	^self sunitName = #UITestCase
]

{ #category : 'SUnit' }
UITestCase class >> resources [
	
	^Array with: UIWorkQueueTestResource
]

{ #category : 'Accessing' }
UITestCase >> defaultPollDelay [

	^self class defaultPollDelay
]

{ #category : 'Accessing' }
UITestCase >> defaultTimeout [

	^self class defaultTimeout
]

{ #category : 'UI-Basic' }
UITestCase >> uiDo: aUIBlock [
	"Perform @aUIBlock once in a forked UI process."
	
	self uiDo: aUIBlock until: [true]
]

{ #category : 'UI-Basic' }
UITestCase >> uiDo: aUIBlock delay: aDelay [
	"Perform @aUIBlock once in a forked UI process.
	 After the operation, wait for @aDelay milliseconds
	 before returning from the forked UI Process"
	
	self uiDo: aUIBlock until: [true] delay: aDelay
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock until: aConditionBlock [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked"
	
	self uiDo: aUIBlock until: aConditionBlock delay: self defaultPollDelay
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock until: aConditionBlock delay: aDelay [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process"
	
	self uiDo: aUIBlock until: aConditionBlock delay: aDelay timeout: self defaultTimeout
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock until: aConditionBlock delay: aDelay timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process.
	 Return unconditionally once the timeout value @aTimeout has been reached"
	
	self uiDo: aUIBlock while: [aConditionBlock value not] delay: aDelay timeout: aTimeout
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock until: aConditionBlock timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 Return unconditionally once the timeout value @aTimeout has been reached"
	
	self uiDo: aUIBlock until: aConditionBlock delay: self defaultPollDelay timeout: aTimeout
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock while: aConditionBlock [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked"
	
	self uiDo: aUIBlock while: aConditionBlock delay: self defaultPollDelay
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock while: aConditionBlock delay: aDelay [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process"
	
	self uiDo: aUIBlock while: aConditionBlock delay: aDelay timeout: self defaultTimeout
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock while: aConditionBlock delay: aDelay timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process.
	 Return unconditionally once the timeout value @aTimeout has been reached"

	| workQueue limit |

	workQueue := UIWorkQueueTestResource current workQueue.
	limit := Time millisecondClockValue + aTimeout.
	[true] whileTrue: [
		workQueue queueAndWaitForBlock: [
			aUIBlock value.
			(Delay forMilliseconds: aDelay) wait].
		aConditionBlock value ifFalse: [^self].
		Time millisecondClockValue > limit
			ifTrue: [
				UITimeoutException
					sunitSignalWith: 'UI Timeout triggered.  Timeout Value: ' , aTimeout asString]].

	^self
]

{ #category : 'UI-Advanced' }
UITestCase >> uiDo: aUIBlock while: aConditionBlock timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 Return unconditionally once the timeout value @aTimeout has been reached"
	
	self uiDo: aUIBlock while: aConditionBlock delay: self defaultPollDelay timeout: aTimeout
]

{ #category : 'UI-Basic' }
UITestCase >> uiUntil: aConditionBlock [
	"Loop in forked UI process until @aConditionalBlock is true"
	
	self uiDo: [] until: aConditionBlock
]

{ #category : 'UI-Basic' }
UITestCase >> uiUntil: aConditionBlock delay: aDelay [
	"Loop in forked UI process until @aConditionalBlock is true.
	 Wait for @aDelay milliseconds before looping"
	
	self uiDo: [] until: aConditionBlock delay: aDelay
]

{ #category : 'UI-Basic' }
UITestCase >> uiWhile: aConditionBlock [
	"Loop in forked UI process while @aConditionalBlock is true"
	
	self uiDo: [] while: aConditionBlock
]

{ #category : 'UI-Basic' }
UITestCase >> uiWhile: aConditionBlock delay: aDelay [
	"Loop in forked UI process while @aConditionalBlock is true.
	 Wait for @aDelay milliseconds before looping"
	
	self uiDo: [] while: aConditionBlock delay: aDelay
]
