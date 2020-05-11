Class {
	#name : 'EtWindowsTestCase',
	#superclass : 'UITestCase',
	#category : 'VastSUnitExtensionsExamplesApp'
}

{ #category : 'Vast-SUnit',
  #vaVisibility : 'private' }
EtWindowsTestCase class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self sunitName = #EtWindowsTestCase
]

{ #category : 'Utilities' }
EtWindowsTestCase >> closeEtWindow: anEtWindowInstance [
	"Open the EtWindow and wait for it to be realized"
	
	self
		uiDo: [anEtWindowInstance shell isDestroyed ifFalse: [anEtWindowInstance close]] delay: 10;
		uiUntil: [anEtWindowInstance shell isDestroyed] delay: 0
]

{ #category : 'Utilities' }
EtWindowsTestCase >> menuBarWidget: aMenuPath for: aWindow [
	"Answer the widget that is located at the menu path, or nil if not found.
	 The menu path is a simple string that uses '->' to signal the next level.
	 
	 For example, the menu path 'File->Add->New...'
	 should answer the New... push button located in the cascaded menu 'Add' which is
	 in the 'File' menu on the menu bar
	 
	 Answer:
		<SUnitMenuEntry>"
	
	| parts menuBar menuBarMenu current nextParts |

	parts := (aMenuPath subStrings: '->') asOrderedCollection.
	parts isEmpty ifTrue: [^nil].
	menuBar := aWindow menuBar.
	menuBar isNil ifTrue: [^nil].
	nextParts := self permuteAcceleratorMarkers: parts removeFirst.
	nextParts detect: [:p |
		menuBarMenu := menuBar menuAtTitle: p ifAbsent: [nil].
		menuBarMenu notNil].
	parts isEmpty ifTrue: [^menuBarMenu].
	current := menuBarMenu.
	[parts notEmpty] whileTrue: [| origCurrent |
		(current isKindOf: SUnitMenuEntry) ifTrue: [current := current menuEntry].
		(current isKindOf: CwMenuCascadeButton) ifTrue: [current := current subMenu].
		origCurrent := current.
		nextParts := self permuteAcceleratorMarkers: parts removeFirst.
		(origCurrent isKindOf: CwMenu)
			ifTrue: [
				nextParts
					detect: [:p |
						current := origCurrent entries detect: [:e | e label = p] ifNone: [nil].
						current notNil and: [
							current := SUnitMenuEntry on: current owner: origCurrent owner.
							true]]
					ifNone: [^nil]]].
	^current



]

{ #category : 'Browsers' }
EtWindowsTestCase >> newEtDictionaryInspector: shouldOpen on: aTargetObject [
	"Answer the new browser instance on @aTargetObject
	 Open it if @shouldOpen is true"

	| browser |

	browser :=
		(EtDictionaryInspector on: aTargetObject)
			owningImage: System image;
			yourself.
	shouldOpen ifTrue: [self openEtWindow: browser].
	^browser
]

{ #category : 'Browsers' }
EtWindowsTestCase >> newEtTextComparisonBrowser: shouldOpen on: string1 and: string2 [
	"Answer the new browser instance on 2 strings to be compared
	 Open it if @shouldOpen is true"

	| browser |

	browser :=
		(EtTextComparisonBrowser on: string1 and: string2)
			owningImage: System image;
			yourself.
	shouldOpen ifTrue: [self openEtWindow: browser].
	^browser
]

{ #category : 'Browsers' }
EtWindowsTestCase >> newEtWorkspace: shouldOpen [
	"Answer the new workspace instance
	 Open it if @shouldOpen is true"

	| browser |

	browser :=
		(EtWorkspace new)
			owningImage: System image;
			yourself.
	shouldOpen ifTrue: [self openEtWindow: browser].
	^browser
]

{ #category : 'Utilities' }
EtWindowsTestCase >> openEtWindow: anEtWindowInstance [
	"Open the EtWindow and wait for it to be realized"
	
	self
		uiDo: [anEtWindowInstance open] delay: 50;
		uiUntil: [anEtWindowInstance shell isRealized] delay: 10
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
EtWindowsTestCase >> permuteAcceleratorMarkers: aName [
	"Answer a sequenceable collection of names that contain all possible
	 positions of accelerator markers in aName.
	 If aName already contains the special accelerator marker character '~'
	 then just answer that specific version which will be a collection of aName.
	 This is because the user has made a specific choice about where the ~ should
	 be
	 
	 Answers:
		<SequenceableCollection>"

	| names |

	names := OrderedCollection new.
	aName isEmptyOrNil ifTrue: [^names].
	names add: aName.
	(aName includes: $~) ifTrue: [^names].
	aName doWithIndex: [:char :idx | | adjustedName |
		(char = $~ or: [char isSeparator])
			ifFalse: [
				adjustedName := String new writeStream.
				adjustedName
					nextPutAll: (aName copyFrom: 1 to: idx - 1);
					nextPut: $~;
					nextPutAll: (aName copyFrom: idx to: aName size).
				names add: adjustedName contents]].
	^names
]

{ #category : 'Utilities' }
EtWindowsTestCase >> trackEtWindowModsDuring: aBlock [
	"Track basic mods (i.e. opened/closed) made to EtWindows during @aBlock
	 Answer a keyed collection with #opened and #closed windows
	 
	 Answers:
		<KeyedCollection>"
	
	| before after |
	
	before := EtWindow allWindows.
	[aBlock value] ensure: [after := EtWindow allWindows].
	^LookupTable new
		at: #opened put: (after difference: before) asArray;
		at: #closed put: (before difference: after) asArray;
		yourself
]
