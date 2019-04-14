.PHONY: guard-% check-tree checks help ignores tests
.DEFAULT_GOAL := help

# Don't check these files for a respetive config
NOCONFIGS = Makefile make/config.mk make/ansi.mk make/helpers.mk

# Automatically include any configuration for specified modules
include $(filter $(wildcard make/*.config.mk),$(subst .mk,.config.mk,$(filter-out $(NOCONFIGS),$(MAKEFILE_LIST))))


##@ Checking

checks: ## Run all checks
	$(if $(CHECKS),$(MAKE) --keep-going --no-print-directory --output-sync --jobs $(CHECKS),$(call style,"No checks",$(STYLE_error)))

tests: ## Run all tests
	$(if $(TESTS),$(MAKE) --keep-going --no-print-directory --output-sync --jobs $(TESTS),$(call style,"No tests",$(STYLE_error)))


##@ Helpers

# https://stackoverflow.com/questions/4728810/makefile-variable-as-prerequisite
guard-%:
	$(if $(value $*),,$(error $* not set))

# Make sure working tree is clean
check-tree: ## Check working tree status
	git diff --quiet || $(error Working tree is dirty. Please commit your work.)

# https://gist.github.com/nevstokes/282ca190de58a3ff032bcdfb8e692185
ignores: $(IGNORE) ## Generate ignore files for the project
	$(MAKE) --keep-going --no-print-directory --output-sync --jobs $(shell sed -nE 's/^([a-z]+):/\1/p' $< | xargs printf '.%signore\n')

# Generate individual ignore files
.%ignore: $(IGNORE)
	sed -nE '/^$*:/,/^[^\s-]+:/p' $< | sed -nE 's/^\s*-\s*//p' > $@

# https://suva.sh/posts/well-documented-makefiles/
help: ## Display this help
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make $(STYLE_cyan)<target>$(STYLE_reset)\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(STYLE_cyan)%-15s$(STYLE_reset) %s\n", $$1, $$2 } /^##@/ { printf "\n$(STYLE_bold)%s$(STYLE_reset)\n", substr($$0, 5) }' $(MAKEFILE_LIST)


# This should be the last thing done so as to not profile any config commands
ifdef PROFILER
# Run commands through a profiler script if one is supplied
override SHELL := /usr/bin/env $(PROFILER)
endif
