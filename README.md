![Banner](.github/assets/banner.svg)

ALO is a developer automation tool designed to automate command line tasks. You can configure ALO to manage dependencies and frameworks, run servers and tests, build and deploy apps... with an uncomplicated JSON config. ALO's CLI and JSON DSL enable features like static error checking, command line documentation, environment variables and runtime arguments out of the box.

**The full documentation is available on the [official docs website](https://alo.sh).**

## Using ALO

**ALO currently supports MacOS only.** Support for other platforms including Linux and Chrome OS are coming soon. 

### Install

You can download all pre-compiled binaries in the [GitHub Releases](https://github.com/bimo2/alo/releases) section. However, using the install script is recommended:

```sh
curl -sf https://alo.sh/install | sh
```

### Configure

Projects can use and configure ALO by defining an `alo.json` file in the root directory. The project scope includes all subdirectories in the project (or git repository).

```sh
# Get project scope + CLI commands
alo

# Initialize `alo.json` in the current directory
alo init

# List available project scripts
alo list

# Run project script (ex. "build")
alo build
```

You can learn more about scopes and configuration options in the [JSON docs](https://alo.sh/<ADD_URL_HERE>).

## Develop

ALO is built in Objective-C. Open the project in Xcode and build the "Debug" configuration scheme using the play button. You can test the debug build from Xcode's `DerivedData` path. "Release" builds should be built using the Xcode command line tools:

```sh
xcodebuild -project alo.xcodeproj -configuration Release build CONFIGURATION_BUILD_DIR=./build
```

#

<sub><sup>**MIT.** Copyright &copy; 2021 Bimal Bhagrath</sup></sub>
