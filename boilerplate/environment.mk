#######################################################################
# Define contexts
#######################################################################

VALID_ENVS = ci dev prod

ifdef CI
ENV = ci
endif

# Fallback to dev by default
ENV ?= dev
PRODUCTION := $(if $(findstring prod,$(ENV)),1)

# Check for a known environment
ifeq ($(ENV),$(filter-out $(VALID_ENVS),$(ENV)))
$(error Unknown environment: "$(ENV)")
endif
