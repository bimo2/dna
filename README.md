![Banner](.github/assets/banner.svg)

**DNA is a command line tool and CLI to streamline development tasks and reduce the learning curve for any project**. `_` can be configured with a pretty uncomplicated JSON config to:

- `install` dependencies and frameworks
- `start` servers and run `tests`
- `build` and `deploy` apps, or
- `anything`...

The `_` CLI and JSON DSL enable features like multi-step tasks, static error checking, command line documentation, environment variables and runtime arguments out of the box.

<!-- **The full documentation is available on the [official docs website](https://web.site).** -->

## Using DNA

**DNA currently supports the latest versions of MacOS only.** Releases for other platforms are coming soon.

### Install

You can download all pre-compiled binaries in the [GitHub Releases](https://github.com/bimo2/dna/releases) section. However, using the install script is recommended:

```sh
curl -sf https://raw.githubusercontent.com/bimo2/dna/main/install | sh
```

### TLDR

Start using DNA:

```sh
_
```

### Configure

You can configure DNA by creating a `dna.json` file in project's root directory. The configuration file contains a JSON object with the following schema:

```
{
  "_dna": number,
  "project": string,
  "dependencies": {
    key: string | [string]
  },
  "env": {
    key: string
  },
  "scripts": {
    key: {
      "?": string,
      "run": string | [string]
    }
  }
}
```

| Field           | Default    | Description                                                                                                                                                                                                               |
| --------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `_dna`          | `0`        | JSON spec (`dna` major version) used to parse the file                                                                                                                                                                    |
| `project`       | `$(SCOPE)` | Project and scope name                                                                                                                                                                                                    |
| `dependencies`  | `{}`       | [Dependency queries](#dependencies) required by the project &mdash; Queries can be commands (ex. `xcodebuild`) or absolute paths (ex. `/usr/local/lib/foundation.a`). Use an array to include multiple queries dependency |
| `env`           | `{}`       | Environment variables that can be used in [JSON DSL](#json-dsl)                                                                                                                                                           |
| `scripts`       | `{}`       | Object containing project scripts                                                                                                                                                                                         |
| `scripts.*.?`   | `null`     | Description of the script for documentation                                                                                                                                                                               |
| `scripts.*.run` | `null`     | [JSON DSL](#json-dsl) commands to run                                                                                                                                                                                     |

Here's an example configuration file for a stock exchange project:

```json
{
  "_dna": 0,
  "project": "nasdaq/exchange",
  "dependencies": {
    "NASDAQ SDK": "nasdaq"
  },
  "env": {
    "NETWORK": "com.nasdaq.1"
  },
  "scripts": {
    "quote": {
      "?": "Find a stock quote",
      "run": "nasdaq quote -n &NETWORK -dt #datetime -> latest# #stock!#"
    },
    "issue": {
      "?": "Issue a new stock on the exchange",
      "run": [
        "nasdaq file #symbol!# | nasdaq issue #shares?#",
        "nasdaq ipo -n &NETWORK #price!# \"USD\""
      ]
    },
    "fetch": {
      "?": "Fetch orders by filter",
      "run": "nasdaq fetch -n &NETWORK -q #query -> \":open :nasdaq\"# orders"
    }
  }
}
```

### Scopes

DNA uses project scopes to manage configuration files. A `dna.json` file applies to its entire directory tree. `_` finds the current scope by recursively searching the working and `..` directories for a configuration file or a `.git` directory. Scopes can be nested by defining additional `dna.json` files in the project tree.

### Dependencies

Projects that require third party dependencies can use the `dependencies` object and the `deps` command to check if the system has the required dependencies installed. DNA will resolve the dependency queries and check if commands are available to the project scope and absolute paths (file or directory) exist in the file system. Absolute paths can be useful to check if files, like C/C++ libraries, are installed.

```sh
_ deps
# ✓ NASDAQ SDK
# ✗ NASDAQ SDK: nasdaq
```

### JSON DSL

JSON DSL allows DNA to run dynamic scripts by passing environment variables and arguments to commands at runtime. Environment variables defined in the `env` object can be referenced in commands using the `&` prefix (ex. `env.VARIABLE` &rarr; `&VARIABLE`). Commands can accept and handle runtime arguments by adding argument identifiers between `#` marks (ex. `#name#`) in commands. Default values can be supplied for identifiers using the `->` syntax (ex. `#value -> default#`). You can assert identifiers without default values as optional using the `?` suffix (ex. `#optional?#`) or required using the `!` suffix (ex. `#required!#`). All identifiers with a default value or no optional assertion will default to optional.

### Runtime

DNA uses a lexer to parse scripts and a compiler to inject environment and runtime variables into script commands. The compiler will substitute environment variables before parsing arguments so using environment variables as default values is possible (ex. `#value -> &VARIABLE#`). DNA will tokenize argument identifiers in a script and produce a script signature. Script signatures are documented using the `list` command. At runtime, you need to provide values for all required arguments (`!`) in the script signature. Optional arguments (`?`) can be undefined unless they precede a required argument, where you can pass a `-` to explicitly skip it. Undefined optional arguments will be replaced with nothing at runtime (ex. `dsl #first?# command` &rarr; `dsl command`). DNA will execute compiled commands synchronously from the scope directory.

```sh
_ list
# - quote datetime? stock!
# ...
# - issue symbol! shares? price!
# ...
# - fetch query?
# ...

_ quote
# ERROR

_ quote "APR 19/21" SBUX
# nasdaq quote -n com.nasdaq.1 -dt "APR 19/21" SBUX

_ issue SBUX - 110.00
# nasdaq file SBUX | nasdaq issue
# nasdaq ipo -n com.nasdaq.1 110.00 USD

_ fetch
# nasdaq fetch -n com.nasdaq.1 -q ":open :nasdaq" orders
```

## Develop

**DNA is built in Objective-C.** Open the project in Xcode and build the "Debug" or "Release" configuration scheme using the play button. Builds can be found in Xcode's `DerivedData` path. Production "Release" builds should be built using Xcode's command line tools and renamed to `dna-$(PLATFORM)-$(VERSION)` (ex. `dna-macos-0.1.0`):

```sh
# Build the "Release" configuration scheme
xcodebuild -project DNA.xcodeproj -scheme DNA -configuration Release build

# Copy the production binary
mkdir -p build
cp /Users/$(USER)/Library/Developer/Xcode/DerivedData/DNA-$(HASH)/Build/Products/Release/DNA ./build/dna-$(PLATFORM)-$(VERSION)
```

#

<sub><sup>**MIT.** Copyright &copy; 2021 Bimal Bhagrath</sup></sub>
