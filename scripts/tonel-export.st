| writer path |
path := (CfsPath named: '<insert path to root sunit-extensions-vast local repo here>').
writer := TonelWriter new.
writer
	addLatestConfigurationMapNamed: 'VastSUnitExtensions';
	addApplicationsFromConfigurationMaps.
writer writeProjectInto: path.
