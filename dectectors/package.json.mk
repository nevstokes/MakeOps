#######################################################################
# Containerised npm variable commands
#######################################################################

NPM_IMAGE ?= node:alpine
PWD_FILE ?= /tmp/passwd

# Variable commands, as per Makefile conventions

NPM_CMD := $(RUN) \
		--volume ~/.npm:/home/node \
		--env npm_config_cache=/home/node/cache \
		--volume $$PWD:/var/www \
		--workdir /var/www \
		\
		--user $$(id -u):$$(id -g) \
		--volume $(PWD_FILE):/etc/passwd:ro \
		\
		--env ENV \
		--network host \
		\
		$(NPM_IMAGE)

NPM := $(NPM_CMD) npm
NPX := $(NPM_CMD) npx

##@ NPM

.PHONY: npm-%

# https://lebenplusplus.de/2018/03/15/how-to-run-npm-install-as-non-root-from-a-docker-container/
$(PWD_FILE):
	echo "node:x:$$(id -u):$$(id -g)::/home/node:/bin/sh" > $@

node_modules: $(PWD_FILE) package.json
	$(call style,"Installing dependencies...",$(STYLE_success))
	$(NPM) \
		$(if $(findstring dev,$(ENV)),install,ci) \
		$(if $(PRODUCTION),--production) \
		--ignore-scripts

package-lock.json: node_modules
	grep --quiet --no-messages $< $(PROJECT_ROOT)/.gitignore || echo $< >> $(PROJECT_ROOT)/.gitignore

#######################################################################
# Semantic sugar
#######################################################################

npm-audit: ## Audit NPM dependencies for vulnerabilities
ifeq ($(ENV),dev)
	(grep -q "npm-audit-resolver" package.json && $(NPM) check-audit --registry=https://registry.npmjs.org) || $(NPM) audit --registry=https://registry.npmjs.org
else
	$(error Dependency vulnerabilities should only be resolved during development)
endif

npm-verify: ## Verify vulnerable NPM dependency resolution (CI)
	(grep -q "npm-audit-resolver" package.json && $(NPM) resolve-audit --registry=https://registry.npmjs.org) || $(NPM) audit --registry=https://registry.npmjs.org

npm-check: ## Check NPM dependencies for available updates
	$(NPX) npm-check --skip-unused || true

npm-update: ## Update NPM dependencies interactively
ifeq ($(ENV),dev)
	$(NPX) npm-check --no-emoji --update
else
	$(error Dependencies should only be updated during development)
endif

npm-clean: ## Remove NPM dependencies
	rm -rf node_modules

npm-deps: package-lock.json ## Install NPM dependencies

CHECKS += npm-check npm-verify
CLEAN += npm-clean
DEPENDENCIES += npm-deps
FIXES += npm-update
SAFE += npm-audit
