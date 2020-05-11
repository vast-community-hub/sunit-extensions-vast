Class {
	#name : 'UIWorkQueueTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'workQueue'
	],
	#classVars : [
		'DefaultTimeout',
		'DefaultPollDelay'
	],
	#category : 'VastSUnitExtensionsApp'
}

{ #category : 'Accessing' }
UIWorkQueueTestResource class >> defaultPollDelay [

	DefaultPollDelay isNil ifTrue: [DefaultPollDelay := 500].
	^DefaultPollDelay
]

{ #category : 'Accessing' }
UIWorkQueueTestResource class >> defaultPollDelay: anObject [

	DefaultPollDelay := anObject
]

{ #category : 'Accessing' }
UIWorkQueueTestResource class >> defaultTimeout [

	DefaultTimeout isNil ifTrue: [DefaultTimeout := 5000].
	^DefaultTimeout
]

{ #category : 'Accessing' }
UIWorkQueueTestResource class >> defaultTimeout: anObject [

	DefaultTimeout := anObject
]

{ #category : 'Accessing' }
UIWorkQueueTestResource >> defaultPollDelay [

	^self class defaultPollDelay
]

{ #category : 'Accessing' }
UIWorkQueueTestResource >> defaultTimeout [

	^self class defaultTimeout
]

{ #category : 'Setup/Teardown' }
UIWorkQueueTestResource >> setUp [
	
	workQueue := AbtWorkQueue start
]

{ #category : 'Setup/Teardown' }
UIWorkQueueTestResource >> tearDown [
	
	workQueue terminate
]

{ #category : 'UI-Basic' }
UIWorkQueueTestResource >> uiDo: aUIBlock [
	"Perform @aUIBlock once in a forked UI process."
	
	self uiDo: aUIBlock until: [true]
]

{ #category : 'UI-Basic' }
UIWorkQueueTestResource >> uiDo: aUIBlock delay: aDelay [
	"Perform @aUIBlock once in a forked UI process.
	 After the operation, wait for @aDelay milliseconds
	 before returning from the forked UI Process"
	
	self uiDo: aUIBlock until: [true] delay: aDelay
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock until: aConditionBlock [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked"
	
	self uiDo: aUIBlock until: aConditionBlock delay: self defaultPollDelay
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock until: aConditionBlock delay: aDelay [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process"
	
	self uiDo: aUIBlock until: aConditionBlock delay: aDelay timeout: self defaultTimeout
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock until: aConditionBlock delay: aDelay timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process.
	 Return unconditionally once the timeout value @aTimeout has been reached"
	
	self uiDo: aUIBlock while: [aConditionBlock value not] delay: aDelay timeout: aTimeout
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock until: aConditionBlock timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process until @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 Return unconditionally once the timeout value @aTimeout has been reached"
	
	self uiDo: aUIBlock until: aConditionBlock delay: self defaultPollDelay timeout: aTimeout
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock while: aConditionBlock [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked"
	
	self uiDo: aUIBlock while: aConditionBlock delay: self defaultPollDelay
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock while: aConditionBlock delay: aDelay [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process"
	
	self uiDo: aUIBlock while: aConditionBlock delay: aDelay timeout: self defaultTimeout
]

{ #category : 'UI-Advanced' }
UIWorkQueueTestResource >> uiDo: aUIBlock while: aConditionBlock delay: aDelay timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 After each evaluation of @aUIBlock, wait for @aDelay milliseconds
	 before returning from the forked UI Process.
	 Return unconditionally once the timeout value @aTimeout has been reached"

	| limit |

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
UIWorkQueueTestResource >> uiDo: aUIBlock while: aConditionBlock timeout: aTimeout [
	"Perform @aUIBlock in a forked UI process while @aConditionBlock is true.
	 @aUIBlock will be evaluated at least once before the condition is checked.
	 Return unconditionally once the timeout value @aTimeout has been reached"
	
	self uiDo: aUIBlock while: aConditionBlock delay: self defaultPollDelay timeout: aTimeout
]

{ #category : 'UI-Basic' }
UIWorkQueueTestResource >> uiUntil: aConditionBlock [
	"Loop in forked UI process until @aConditionalBlock is true"
	
	self uiDo: [] until: aConditionBlock
]

{ #category : 'UI-Basic' }
UIWorkQueueTestResource >> uiUntil: aConditionBlock delay: aDelay [
	"Loop in forked UI process until @aConditionalBlock is true.
	 Wait for @aDelay milliseconds before looping"
	
	self uiDo: [] until: aConditionBlock delay: aDelay
]

{ #category : 'UI-Basic' }
UIWorkQueueTestResource >> uiWhile: aConditionBlock [
	"Loop in forked UI process while @aConditionalBlock is true"
	
	self uiDo: [] while: aConditionBlock
]

{ #category : 'UI-Basic' }
UIWorkQueueTestResource >> uiWhile: aConditionBlock delay: aDelay [
	"Loop in forked UI process while @aConditionalBlock is true.
	 Wait for @aDelay milliseconds before looping"
	
	self uiDo: [] while: aConditionBlock delay: aDelay
]

{ #category : 'Setup/Teardown' }
UIWorkQueueTestResource >> workQueue [

	^workQueue
]
