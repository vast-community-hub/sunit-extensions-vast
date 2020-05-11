Class {
	#name : 'SUnitMenuEntry',
	#superclass : 'Object',
	#instVars : [
		'owner',
		'menuEntry'
	],
	#category : 'VastSUnitExtensionsExamplesApp'
}

{ #category : 'Creation' }
SUnitMenuEntry class >> on: aCwMenuEntry owner: anOwner [
	"Answer a new instance of the menu entry wrapper
	 
	 Answers:
		<SUnitMenuEntry>"
	
	^self basicNew initializeOn: aCwMenuEntry owner: anOwner
]

{ #category : 'Initialize',
  #vaVisibility : 'private' }
SUnitMenuEntry >> initializeOn: aCwMenuEntry owner: anOwner [
	
	menuEntry := aCwMenuEntry.
	owner := anOwner
]

{ #category : 'API' }
SUnitMenuEntry >> isCascadeButton [

	^menuEntry isCascadeButton
]

{ #category : 'API' }
SUnitMenuEntry >> isPushButton [

	^menuEntry isPushButton
]

{ #category : 'API' }
SUnitMenuEntry >> menuEntry [

	^menuEntry	
]

{ #category : 'API' }
SUnitMenuEntry >> push [
	"Perform a programatic push of the button"
	
	(menuEntry isKindOf: CwMenuPushButton) ifFalse: [^false].
	menuEntry dispatchTo: owner
]
