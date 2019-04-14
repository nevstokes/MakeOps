BUILDER ?= $(shell command -v docker || command -v buildah)

export DOCKER_REPO := $(VENDOR)/$(PROJECT)
export IMAGE_NAME = $(DOCKER_REPO):$(SOURCE_COMMIT)
