ifndef COMPOSER
COMPOSER ?= $(shell command -v composer)
endif

ifeq ($(COMPOSER),)
COMPOSER_IMAGE ?= composer
COMPOSER := $(RUN) \
	--volume $$PWD:/app \
	\
	--env COMPOSER_HOME=/.composer \
	--volume ~/.composer:/.composer \
	\
	--user $$(id -u):$$(id -g) \
	--volume /etc/passwd:/etc/passwd:ro \
	--volume /etc/group:/etc/group:ro \
	\
	--volume $$SSH_AUTH_SOCK:/ssh-auth.sock \
	--env SSH_AUTH_SOCK=/ssh-auth.sock \
	\
	$(COMPOSER_IMAGE)
endif
