.PHONY: composer-outdated

CHECKS += composer-outdated


##@ Composer

~/.composer:
	mkdir -p $@

~/.composer/vendor/hirak/prestissimo: | ~/.composer # order-only prerequisite; ignore directory timestamp
	$(COMPOSER) \
		global require \
			--no-progress \
			--prefer-dist \
		hirak/prestissimo

vendor: ~/.composer/vendor/hirak/prestissimo composer.json
	$(COMPOSER) $(if $(wildcard $@/.),update,install) \
		--classmap-authoritative \
		--ignore-platform-reqs \
		--no-scripts \
		--no-suggest \
		--no-progress \
		--prefer-dist \
		$(if $(ANSI),--ansi,--no-ansi) \
		$(if $(PRODUCTION),--no-dev)

composer.lock: vendor

composer-outdated: | composer.lock ## Audit Composer packages
	$(COMPOSER) outdated \
		$(if $(ANSI),--ansi,--no-ansi)
