<p align="center">
<!---<img src="assets/logos/128x128.png">-->
 <h1 align="center">SUnit Extensions for VAST Platform (VA Smalltalk)</h1>
  <p align="center">
    VAST Extensions to SUnit
    <!---
    <br>
    <a href="docs/"><strong>Explore the docs »</strong></a>
    <br>
    -->
    <br>
    <a href="https://github.com/vast-community-hub/sunit-extensions-vast/issues/new?labels=Type%3A+Defect">Report a defect</a>
    |
    <a href="https://github.com/vast-community-hub/sunit-extensions-vast/issues/new?labels=Type%3A+Feature">Request feature</a>
  </p>
</p>

Pack of extensions to use with SUnit Testing. Currently it provides:
- *UI Eventing Framework* that allows users to also write SUnit Test for GUI components.
- *JUnitXML Renderer* that allows writing the SUnit results into the JUnit XML format that is widely used in CI (Continuous Integration) tools.

## License
- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).


## Installation

1. Install [VA Smalltalk 9.2.1 or newer](https://www.instantiations.com/products/vasmalltalk/download.html).
2. Install Tonel support in your development image following [this guide](https://github.com/vasmalltalk/tonel-vast#installation).
3. Clone this repository.
4. The easiest and recommended approach is to install it via a script:

```smalltalk
| loader path |
path := (CfsPath named: '<insert path to root sunit-extensions-vast local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended; "do not prompt and use all defaults"
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
```

Or you can load the Configuration Map `VastSUnitExtensions` from the context menu of the Configuration Maps Browser: `"Import"` -> `"Load Configuration Maps from Tonel repository..."` -> select path to root `sunit-extensions-vast` local repo. This will open a dialog and will use convenient defaults for the load. Refer to [its documentation](https://github.com/instantiations/tonel-vast#using-gui-menus) for more details.

5. Optionally run the SUnit tests included in the map `VastSUnitExtensions` to ensure correct installation. One easy way is to right-click on the `VastSUnitExtensions` map name in the Name pane (as opposed to version pane ) and then select `Test Loaded Applications`.

## UI Eventing Framework - Quick Start

This repository includes tests which also work as examples for users to get started. Check the application `VastSUnitExtensionsExamplesApp` and you will find examples such as `TestEtDictionaryInspector`, `TestEtTextComparisonBrowser`, `TestEtWorkspace`, etc.

<img alt="TestEtTextComparisonBrowser" src="assets/screenshots/testSelectedMethod.png">

Ultimately, all you need to do is to subclass `EtWindowsTestCase` or `UITestCase` and call their API from within your tests.


## JUnitXML Renderer - Quick Start

The best way to get started with the JUnitXML feature is by checking the application `JUnitXMLRendererModelTests` and its tests. There is also an example `RunTestSuiteAndReportResultAsJUnitXML` that is pretty close to what you would call from a CI:




## Acknowledgments

- [Juan Escalada](https://github.com/JuanEscalada) and [Mercap Software](https://github.com/Mercap) for their initial version of the JUnitXML Renderer.


## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)
