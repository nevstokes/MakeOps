# Name and port of default service
APP ?= app
PORT ?= 80

# Define docker-compose filename
_DC := docker-compose.yml
DC ?= $(_DC)

# Define appropriate docker-compose command
COMPOSE := docker-compose
ifneq ($(DC),$(_DC))
COMPOSE += -f $(DC)
endif

# How to tidy up docker-compose images
_RMI := all local
RMI_FLAG = $(if $(filter $(RMI),$(_RMI)),$(RMI),$(lastword $(_RMI)))
