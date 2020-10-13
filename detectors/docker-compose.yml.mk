.PHONY: $(APP) up down up-% down-%


##@ Running

$(APP): $(DC)
	$(call style,"Starting containers...",$(STYLE_success))
	$(COMPOSE) up -d --no-recreate $@

up: $(APP) ## Start local development environment
	printf "\033[0;32mStarted on port \033[1;32m%d\033[0m\n" $(shell $(COMPOSE) port webserver $(PORT) | cut -f 2 -d :)

down: $(DC) ## Stop local development environment
	$(call style,"Stopping containers and tidying up...",$(STYLE_success))
	$(COMPOSE) down -v --rmi $(RMI_FLAG) --remove-orphans

up-%: docker-compose.%.yml ## Start named environment
	$(MAKE) --no-print-directory up DC=$< ENV=$*

down-%: docker-compose.%.yml ## Stop named environment
	$(MAKE) --no-print-directory down DC=$< ENV=$*
