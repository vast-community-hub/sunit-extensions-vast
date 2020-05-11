Class {
	#name : 'TestEtWorkspace',
	#superclass : 'EtWindowsTestCase',
	#category : 'VastSUnitExtensionsExamplesApp'
}

{ #category : 'Testing' }
TestEtWorkspace >> testRevertMenuItemDisabled [

	| workspace |

	workspace := self newEtWorkspace: true.
	[| revertButton |
		revertButton := self menuBarWidget: 'File->Revert' for: workspace.
		self assert: revertButton notNil description: 'Could not find revert button'.
		self assert: workspace fileName isNil.
		self
			deny: revertButton menuEntry enable value
			description: 'Revert should be disabled when no fileName is set']
				sunitEnsure: [self closeEtWindow: workspace]
]
