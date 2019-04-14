# Make it so

A set of reusable generic and modular make targets.

## Requirements

Gnu Make > 4.0

## Usage

These make modules are self-documenting; calling `make` with no target will display a list of what is available.

See the example `Makefile` in this repository.

## Modules

### dotenv

This module will create dotenv files from template versions that can be safely committed to source control (i.e. contains no passwords or api keys).

Only new keys that exist in the template will be added to the dotenv. Values will be prompted for with any defined defaults presented for confirmation or updating. Exising environment variables in the defaults will be expanded.

Keys that already exist in the dotenv will be maintained, even if modified or removed from the template.

The extension used for scm-safe can be set using the `DIST` environment variable.

## Utility targets

There are two make variables to which modules can append their targets (i.e. using `+=`). The final combined list of these targets will be run together using a submake.

### `CHECKS`

Intended for `.PHONY` targets such as linting, static analysis and package auditing.

    make checks

### `TESTS`

Add targets to run different types of tests (e.g. unit, integration, functional) or individual test suites in parallel.

    make tests

## Options

### Ansi output

Setting the `ANSI` environment variable controls if escape codes are defined and used for formatted output. If this is unavailable for the device then this value will be set to `0` automatically.

    ANSI=0 make

### Interactivity

Some targets may prompt for user input. If this is undesired, set the `INTERACTIVE` environment variable. If `stdin` isn't a `tty` then this value is set to `0` automatically.

    INTERACTIVE=0 make .env

### Verbosity

By default, these make targets will operate quietly; that is, they will not display each command as it is run. This can be changed by setting the `VERBOSE` environment variable. Note that simple output commands (e.g. `echo`) are prefixed with an `@` in order to still be silent as displaying them give no real value.

    VERBOSE=1 make checks

## Profiling

While it's possible to use [`remake`](http://bashdb.sourceforge.net/remake/) as a drop-in replacement to get deeper profiling, if all that is needed is a quick overview of how long things take then it's possible to specify a proxy script that will operate in place of the normal shell and collect timing information automatically. Output will be sent to one logfile per command, named with the respective process id.

    PROFILER=profile make checks

## Conventions & Considerations

Make modules should be named by to what they relate and use `.mk` file extension.

As far as practical, make modules should be able to be used on their own and only consist of target rules. Configuration should be able to be overriden where sensible and extracted to a separate `.config.mk` file which get included automatically.

Other than having a relatively new version of `make` available, no assumptions should be made as to the environment on which they will operate. Use containerised solutions as a fall-back.
