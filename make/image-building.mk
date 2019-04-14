.PHONY: dockerfile-lint image push shell

CHECKS += dockerfile-lint


##@ Building

# Don't build things that haven't been linted
image: dockerfile-lint ## Build the Docker image
	./hooks/build

# Check the Dockerfile conforms to best practice
dockerfile-lint: Dockerfile ## Check the Dockerfile for best practice
	$(call style,"Checking Dockerfile...",$(STYLE_success))
	$(RUN) hadolint/hadolint < $<

# Ensure we have a REGISTRY to guard against default pushes to docker.io
push: guard-REGISTRY check image image-test ## Push a clean build to a specified registry
	echo $(REGISTRY)/$(IMAGE_NAME)
	echo $(REGISTRY)/$(DOCKER_REPO):latest

shell: ## Open a terminal into a new container
	$(RUN) F--entrypoint=sh $(IMAGE_NAME)
