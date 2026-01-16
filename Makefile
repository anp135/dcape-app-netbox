## dcape-app-netbox Makefile
## This file extends Makefile.app from dcape
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= service-netbox

#- Docker image name
IMAGE              ?= docker.io/netboxcommunity/netbox

#- Docker image tag
IMAGE_VER          ?= v4.5.0-3.4.2

# Do not use Dcape common app service
USE_DCAPE_DC       = false

# If you need database, uncomment this var
USE_DB              = yes

# Default PGDATABASE
PGDATABASE         ?= service_netbox

# Default PGUSERNAME
PGUSER             ?= service_netbox

#- Netbox secret key
SECRET_KEY         ?= $(shell openssl rand -base64 64; echo)

#- Redis image name
REDIS_IMAGE        ?= docker.io/valkey/valkey

#- Redis image ver
REDIS_IMAGE_VER    ?= 8.1-alpine

#- Netbox email from
EMAIL_FROM         ?= netbox@${DCAPE_HOST}

#- Netbox email password
EMAIL_PASSWORD     ?= $(shell openssl rand -hex 16; echo)

#- Netbox email port
EMAIL_PORT         ?= 25

#- Netbox email server
EMAIL_SERVER       ?= localhost

#- Netbox email crt
EMAIL_SSL_CERTFILE ?= 

#- Netbox crt key
EMAIL_SSL_KEYFILE  ?= 

#- Netbox email timeout
EMAIL_TIMEOUT      ?= 5

#- Netbox email username
EMAIL_USERNAME     ?= netbox

#- Netbox use SSL with email
EMAIL_USE_SSL      ?= false

#- Netbox use TSL with email
EMAIL_USE_TLS      ?= false

#- Netbox use GraphQL
GRAPHQL_ENABLED    ?= true

#- Netbox media root
MEDIA_ROOT         ?= /opt/netbox/netbox/media

#- Netbox redis password
REDIS_PASSWORD           ?= $(shell openssl rand -hex 16; echo)

#- Netbox redis cache password
REDIS_CACHE_PASSWORD     ?= $(shell openssl rand -hex 16; echo)
# ------------------------------------------------------------------------------

# if exists - load old values
-include $(CFG_BAK)
export

-include $(CFG)
export

# This content will be added to .env
# define CONFIG_CUSTOM
# # ------------------------------------------------------------------------------
# # Sample config for .env
# #SOME_VAR=value
#
# endef

# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# ------------------------------------------------------------------------------

## create superuser
admin-add: CMD=exec app ./manage.py createsuperuser
admin-add: dc
