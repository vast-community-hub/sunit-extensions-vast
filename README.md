<p align="center">
<!---<img src="assets/logos/128x128.png">-->
 <h1 align="center">SUnit Extensions for VASmalltalk</h1>
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


 UI Eventing Framework to use for SUnit Testing. This allows users to also write SUnit Test for GUI components. 

## License
- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).


## Installation

1. Install [VA Smalltalk 9.2.1 or newer](https://www.instantiations.com/products/vasmalltalk/download.html).
2. Install Tonel support in your development image following [this guide](https://github.com/vasmalltalk/tonel-vast#installation).
3. Clone this repository.
4. Load the Configuration Map `VastSUnitExtensions` either from the context menu of the Configuration Maps Browser ("*Import*" -> "*Load Configuration Maps from Tonel repository...*" -> select path to root `sunit-extensions-vast` local repo) or via a script:

```smalltalk
| loader path |
path := (CfsPath named: '<insert path to root sunit-extensions-vast local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended.
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
```


## Quick Start

This repository includes tests which also work as examples for users to get started. Check the application `VastSUnitExtensionsExamplesApp` and you will find examples such as `TestEtDictionaryInspector`, `TestEtTextComparisonBrowser`, `TestEtWorkspace`, etc.

Ultimately, all you need to do is to subclass `EtWindowsTestCase` or `UITestCase` and call their API from within your tests.

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)
