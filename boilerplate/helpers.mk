#######################################################################
# Generic utility targets
#######################################################################

.DEFAULT_GOAL := help

##@ Project

.PHONY: help guard-%

# Inspired by https://suva.sh/posts/well-documented-makefiles/
help: ## Display this help
	awk 'BEGIN { \
		FS = ":.*##"; \
		printf "\nUsage:\n  make $(STYLE_cyan)<target>$(STYLE_reset)\n"} \
		/^[a-zA-Z_-%]+:.*?##/ { \
			printf "  $(STYLE_cyan)%-20s$(STYLE_reset) %s\n", $$1, $$2 \
		} \
		/^##@/ { \
			printf "\n$(STYLE_bold)%s$(STYLE_reset)\n", substr($$0, 5) \
		}' \
		$(MAKEFILE_LIST)

# https://stackoverflow.com/questions/4728810/makefile-variable-as-prerequisite
guard-%:
	$(if $(value $*),,$(error $* not set))
