# This file is the latest to be included; determine current directory as a base for subsequent includes
INCLUDE_PATH := $(dir $(lastword $(MAKEFILE_LIST)))
PROJECT_ROOT := $(realpath $(INCLUDE_PATH)..)

include $(INCLUDE_PATH)boilerplate/config.mk

include $(INCLUDE_PATH)boilerplate/ansi.mk
include $(INCLUDE_PATH)boilerplate/environment.mk
include $(INCLUDE_PATH)boilerplate/helpers.mk
include $(INCLUDE_PATH)boilerplate/project.mk

# Initialise empty aggregate targets
BUILD :=
CHECKS :=
CLEAN :=
DEPENDENCIES :=
FIXES :=
SAFE :=
TESTS :=

# Automatically include any detector that matches something in the current working directory
# Detectors may append their individual targets to the aggregate lists as required
# Make's $(wildcard) does not obey shell dotglob option, hence the explicit dotfile patterns
include $(foreach MATCH,$(filter $(basename $(notdir $(wildcard $(INCLUDE_PATH)detectors/.*.mk $(INCLUDE_PATH)detectors/*.mk))),$(wildcard .[^.]* *)),$(INCLUDE_PATH)detectors/$(MATCH).mk)

##@ Aggregate Targets

.PHONY: build checks clean dependencies fixes safe tests

build: ## Create build
ifeq ($(BUILD),)
	$(call style,"Nothing to build",$(STYLE_info))
else
	$(MAKE) --jobs --no-print-directory --output-sync $(BUILD)
endif

checks: ## Perform all checks
ifeq ($(CHECKS),)
	$(call style,"No checks to perform",$(STYLE_info))
else
	$(MAKE) --no-print-directory $(CHECKS)
endif

clean: ## Tidy everything up
ifeq ($(CLEAN),)
	$(call style,"Nothing to clean",$(STYLE_info))
else
	$(MAKE) --jobs --no-print-directory --output-sync $(CLEAN)
endif

dependencies: ## Install all dependencies
ifeq ($(DEPENDENCIES),)
	$(call style,"No dependencies to install",$(STYLE_info))
else
	$(MAKE) --jobs --no-print-directory --output-sync $(DEPENDENCIES)
endif

fixes: ## Apply automated fixes
ifeq ($(FIXES),)
	$(call style,"Nothing to fix",$(STYLE_info))
else
	$(MAKE) --no-print-directory $(FIXES)
endif

safe: ## Ensure secure practices
ifeq ($(SAFE),)
	$(call style,"No safety rules to run",$(STYLE_info))
else
	$(MAKE) --jobs --no-print-directory --output-sync $(SAFE)
endif

tests: ## Run all tests
ifeq ($(TESTS),)
	$(call style,"No tests to run",$(STYLE_info))
else
	$(MAKE) --jobs --no-print-directory --output-sync $(TESTS)
endif
