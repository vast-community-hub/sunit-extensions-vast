| writer path |
path := ((CfsPath named: CfsDirectoryDescriptor getcwd) append: '..\tonel-repos\sunit-extensions-vast').
writer := TonelWriter new.
writer
	addLatestConfigurationMapNamed: 'VastSUnitExtensions';
	addApplicationsFromConfigurationMaps.
writer writeProjectInto: path.
