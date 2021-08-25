![Banner](.github/assets/banner.svg)

ALO is a developer automation tool and CLI. You can configue ALO to manage dependencies, run servers and tests, build and deploy projects... with an uncomplicated JSON config.

**The full documentation is available on the [official docs website](https://alo.sh).**

## Using ALO

ALO supports the following platforms:

| MacOS | Linux | Windows | Chrome OS |
| :---: | :---: | :-----: | :-------: |
| YES   | NO    | NO      | NO        |

### Install

You can download all pre-compiled binaries in the [GitHub Releases](https://github.com/bimo2/alo/releases) section. However, using the install script is recommended:

```sh
curl -sf https://alo.sh/download | sh
```

### Configure

Projects can be configured to use ALO by defining an `alo.json` file at the root directory. The project scope includes all subdirectories in the project (or git repository).

```sh
# Get project scope + CLI commands
alo

# Initialize alo.json in the current directory
alo init

# List available project scripts
alo list

# Run project script (ex. "build")
alo build
```

You can learn more about scopes and configuration options in the [JSON docs](https://alo.sh).

## Develop

ALO is built in Objective-C. Open the project in Xcode and build the "Debug" configuration scheme using the play button. "Release" builds can be built using the Xcode command line tools:

```sh
xcodebuild -project alo.xcodeproj -configuration Release build CONFIGURATION_BUILD_DIR=./build
```

#

<sub><sup>**MIT.** Copyright &copy; 2021 Bimal Bhagrath</sup></sub>
