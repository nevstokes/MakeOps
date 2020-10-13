#######################################################################
# General configuration variables for Make
#######################################################################

# Make sure we're using bash
SHELL := /usr/bin/env bash

# https://explainshell.com/explain?cmd=set+-euo+pipefail
.SHELLFLAGS := -euo pipefail -O dotglob -c

# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html#Special-Targets
.DELETE_ON_ERROR:
.SUFFIXES:

# Disable all command echoing without requiring @ prefixes
# Can be overridden by setting the appropriate environment variable
ifndef VERBOSE
.SILENT:
endif

# Version check
MAKE_VERSION != $(MAKE) --version | head -1
MAKE_REQUIRED = GNU Make 4
ifneq ($(basename $(MAKE_VERSION)),$(MAKE_REQUIRED))
$(error $(MAKE_REQUIRED) or better required)
endif

# Unless otherwise stated, set interactive mode if stdin is a tty
INTERACTIVE ?= $(shell [ -t 0 ] && echo 1)

# Unless supplied, define how to run container commands
RUNNER ?= $(shell command -v docker || command -v podman)
RUN := $(RUNNER) run --rm
ifeq ($(INTERACTIVE),1)
RUN += --interactive
endif
