.PHONY: npm-audit

CHECKS += npm-audit


##@ npm

~/.npm:
	@mkdir -p $@

# https://lebenplusplus.de/2018/03/15/how-to-run-npm-install-as-non-root-from-a-docker-container/
~/.npm/passwd: | ~/.npm # order-only prerequisite; ignore directory timestamp
	@echo "node:x:$$(id -u):$$(id -g)::/home/node:/bin/sh" > $@

node_modules: package.json
	$(NPM) $(if $(findstring dev,$(ENV)),install,ci) \
		--ignore-scripts \
		$(if $(ANSI),--ansi,--no-ansi) \
		$(if $(PRODUCTION),--production)

package-lock.json: node_modules

npm-audit: | package-lock.json ## Audit npm dependencies
	$(NPM) audit \
		$(if $(ANSI),--ansi,--no-ansi)
