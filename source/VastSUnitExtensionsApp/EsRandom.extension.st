Extension {
	#name : 'EsRandom'
}

{ #category : '*VastSUnitExtensionsApp',
 #vaCategories : ['Vast-SUnit'] }
EsRandom class >> seed: aFloat [
	"Use linear congruential generator, with a shuffling array.

	 Reference: Numerical Recipes in C, The Art of Scientific Computing
				Press et al., Cambridge University Press 1990, pp. 211, 212"

	| randomStream |
	randomStream := super new.
	randomStream
		seed2: aFloat;
		basicNext;
		shuffleArray: (Array new: randomStream shuffleSize).
	1 to: randomStream shuffleSize do: [ :index |
		randomStream shuffleArray at: index put: randomStream basicNext].

	randomStream seed1: randomStream seed2.

	^randomStream
]
