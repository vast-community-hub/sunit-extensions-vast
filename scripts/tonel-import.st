| loader path |
path := (CfsPath named: '<insert path to root sunit-extensions-vast local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended;
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
