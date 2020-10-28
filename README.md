# MakeOps

## tl;dr

Template your orchestration with automatic containerised buildchains.

## Requirements

- Gnu Make > 4.0
- OCI container runtime (e.g. `docker` or `podman`)
- `git`

## Installation

It is recommended to add this repository to other projects with a `git` subtree merge.

In the project in which you want to use MakeOps:

    git remote add -f make https://github.com/nevstokes/MakeOps
    git merge -s ours --squash --no-commit --allow-unrelated-histories make/main
    git read-tree --prefix=make/ -u make/main
    git commit -m "MakeOps subtree merged"

Once done, this subtree can be updated to get the latest changes using the built-in target:

    make self-update

## Usage

These modules are opinionated and self-documenting; calling `make` with no target will display a list of what is available.

## Detectors

- CDK
- Composer
- Cypress
- Dockerfile
- Docker Compose
- ESLint
- NPM
- Jenkinsfile
- Jest
- Pip
- Poetry
- Prettier

### Directory conventions

- infrastructure

## Aggregate targets

### `CHECKS`

### `TESTS`

## Use in CI

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

## Conventions & Considerations

Make modules should be named by to what they relate and use `.mk` file extension.

Other than the requirements outlined here, no assumptions should be made as to the environment on which this project will operate; use containerised solutions.
