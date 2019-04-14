# Standard configuration and definitions
include make/config.mk

# Required functional modules
include make/dotenv.mk

# Non-generic, project-specific targets go here

# Included last to include relevant module config automatically
include make/helpers.mk
