ifndef NPM
NPM := $(shell command -v npm)
endif

ifeq ($(NPM),)
NPM_IMAGE ?= node:alpine
NPM := $(RUN) \
		--volume $$PWD:/var/www \
		--workdir /var/www \
		\
		--user $$(id -u):$$(id -g) \
		--volume ~/.npm/passwd:/etc/passwd \
		\
    	--volume ~/.npm:/home/node \
		-env npm_config_cache /home/node/cache \
    	\
		$(NPM_IMAGE) \
		\
		npm
endif
