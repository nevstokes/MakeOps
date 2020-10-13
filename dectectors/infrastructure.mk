##@ Infrastructure

.PHONY: infra-%

infra-audit: ## Audit infrastructure dependencies for vulnerabilities
	$(info Auditing infrastructure)
	$(MAKE) --no-print-directory --directory=infrastructure --file=../Makefile --include-dir=.. npm-audit

infra-verify: ## Verify vulnerable infrastructure dependency resolution (CI)
	$(info Verifying infrastructure audit)
	$(MAKE) --no-print-directory --directory=infrastructure --file=../Makefile --include-dir=.. npm-verify

infra-check: ## Check infrastructure dependencies for available updates
	$(info Checking infrastructure dependencies)
	$(MAKE) --no-print-directory --directory=infrastructure --file=../Makefile --include-dir=.. npm-check

infra-update: ## Update NPM dependencies interactively
	$(info Updating infrastructure dependencies)
	$(MAKE) --no-print-directory --directory=infrastructure --file=../Makefile --include-dir=.. npm-update

infra-clean: ## Remove infrastructure dependencies
	$(info Cleaning infrastructure dependencies)
	$(MAKE) --no-print-directory --directory=infrastructure --file=../Makefile --include-dir=.. npm-clean

infra-deps: ## Install infrastructure dependencies
	$(info Installing infrastructure dependencies)
	$(MAKE) --no-print-directory --directory=infrastructure --file=../Makefile --include-dir=.. npm-deps

CHECKS += infra-check infra-verify
CLEAN += infra-clean
DEPENDENCIES += infra-deps
FIXES += infra-update
SAFE += infra-audit
