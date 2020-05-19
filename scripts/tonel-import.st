| loader path |
path := ((CfsPath named: CfsDirectoryDescriptor getcwd) append: '..\tonel-repos\sunit-extensions-vast').
loader := TonelLoader readFromPath: path.
loader
	beUnattended;
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
