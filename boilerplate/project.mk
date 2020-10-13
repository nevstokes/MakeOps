#######################################################################
# Automatically determine project-related variables
#######################################################################

# Take ownership
VENDOR ?= $(shell whoami)

# Default variable names
# Use if not previously set from a CI environment
SOURCE_REPO ?= SOURCE_REPO
SOURCE_BRANCH ?= SOURCE_BRANCH
SOURCE_COMMIT ?= SOURCE_COMMIT

# Version control information
$(SOURCE_REPO) ?= $(shell git config --get remote.origin.url)

# $(SOURCE_REPO_HTTP) ?= $(subst git@,https://,$(basename $(subst :,/,$(SOURCE_REPO))))
# $(SOURCE_REPO_SSH) ?= $(subst /,:,$(subst https://,git@,$(SOURCE_REPO_HTTP))).git

$(SOURCE_BRANCH) ?= $(shell git rev-parse --abbrev-ref HEAD)
$(SOURCE_COMMIT) ?= $(shell git rev-parse --short HEAD)

# Production branch
PRODUCTION_BRANCH ?= main

# Derive project name from source repository
# (Don't rely on local directory name)
PROJECT_NAME := $(notdir $(SOURCE_REPO_HTTP))

# If no origin, fallback to directory
ifeq ($(PROJECT_NAME),)
PROJECT_NAME := $(notdir $(PROJECT_ROOT))
endif

# Construct separated project prefix where defined
ifdef PROJECT_PREFIX
PROJECT_PREFIX_DELIM ?= -
PROJECT_PREFIX := $(PROJECT_PREFIX)$(PROJECT_PREFIX_DELIM)
endif

# Remove any source repository prefix
BARE_PROJECT := $(subst $(PROJECT_PREFIX),,$(PROJECT_NAME))
