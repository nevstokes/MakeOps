#######################################################################
# Make variables for building container images
#
# (Exported where necessary for visibility to child processes.)
#######################################################################

# Default container image builder and reference file
BUILDER ?= $(shell command -v docker || command -v podman)
DOCKERFILE ?= Dockerfile

# Take advantage of speed and caching improvements
export DOCKER_BUILDKIT ?= 1

# Define a default unreachable registry to avoid accidental pushes to Docker Hub.
# Set an environment variable or use a command line value in a CI / CD contexts for configuration.
# Use the override directive before including the Make bootstrap to set a custom registry in code:
#
#  override IMAGE_REGISTRY = your.registry.address
#  include make/boostrap.mk

IMAGE_REGISTRY ?= registry.localhost

# Default upstream registry for base images
BASE_REGISTRY ?= $(IMAGE_REGISTRY)

# Declare build argument list
BUILD_ARGS = BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")"
BUILD_ARGS += VCS_REF="$(SOURCE_COMMIT)"

# Todo: check if set
BUILD_ARGS += VCS_URL="$(SOURCE_REPO)"

BUILD_ARGS += BASE_REGISTRY="$(BASE_REGISTRY)"

# Name of the container image to be built
IMAGE_REPO ?= $(BARE_PROJECT) # Defined in boilerplate/project

# Construct repository path, container image name and version tag
ECR_REPO_PATH = $(VENDOR)
IMAGE_PATH = $(IMAGE_REGISTRY) # Defined in config
IMAGE_PATH += $(VENDOR) # Defined in boilerplate/project

# Optionally defined at top level
ifdef NAMESPACE
IMAGE_PATH += $(NAMESPACE)
ECR_REPO_PATH += $(NAMESPACE)
endif

IMAGE_PATH += $(IMAGE_REPO)
ECR_REPO_PATH += $(IMAGE_REPO)

# Assemble the pieces
export ECR_REPOSITORY = $(subst $(eval) ,/,$(strip ${ECR_REPO_PATH}))
IMAGE_NAME = $(subst $(eval) ,/,$(strip ${IMAGE_PATH}))

# Define prefix on development images for lifecyle rules
ifneq ($(strip $(SOURCE_BRANCH)),$(PRODUCTION_BRANCH))
IMAGE_TAG_PREFIX = dev-
endif

# Tagging policy
# Todo: finish strategy.
# stable semver tags to maintain base images / unique with build id
IMAGE_TAGS = $(IMAGE_NAME):$(IMAGE_TAG_PREFIX)$(SOURCE_COMMIT)

# Add tag with build number if available
ifdef BUILD_NUMBER
$(foreach IMAGE_TAG,$(IMAGE_TAGS),$(eval IMAGE_TAGS += $(IMAGE_TAG)-$(BUILD_NUMBER)))
endif

##@ Container Images

.PHONY: image-%

# Check a Dockerfile with Hadolint (https://github.com/hadolint/hadolint)
image-lint: $(DOCKERFILE) ## Check Dockerfiles for best practice
	$(call style,"Checking $(DOCKERFILE)...",$(STYLE_success))
	$(RUN) \
		--init \
		--cap-drop all \
		--read-only \
		--security-opt=no-new-privileges \
		hadolint/hadolint < $<

image-build: $(DOCKERFILE) ## Build container image
	$(BUILDER) build $(foreach BUILD_ARG,$(BUILD_ARGS),--build-arg $(BUILD_ARG)) \
		--file $< $(foreach TAG,$(IMAGE_TAGS),--tag $(TAG)) .

image-push: ## Push image to registry
ifeq ($(origin IMAGE_REGISTRY),file)
	$(error Refusing to push to $(IMAGE_REGISTRY))
else
	echo pushing to $(IMAGE_REGISTRY)
endif

BUILD += image-build
CHECKS += image-lint
