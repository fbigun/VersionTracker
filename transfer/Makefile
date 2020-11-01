# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/Mikubill/transfer/tags"
image_url:="https://registry.hub.docker.com/v1/repositories/fbigun/transfer/tags"
target:="https://github.com/Mikubill/transfer/releases/download/v@/transfer_@_linux_amd64.tar.gz"

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

# Get unupdated tags
# Get the tag information on docker hub and GitHub respectively,
# and get the tag tags that need to be updated by comparison.
github_tags:=$(shell curl -sSL $(github_url) | jq -r '.[].name')
github_tags_latest:=$(word 1,$(github_tags))
dockerhub_tags:=$(shell curl -sSL $(image_url) | jq -r '.[].name' || echo "")
skip_update_tags:=
nobuild_tags:=$(dockerhub_tags) $(skip_update_tags)
update_tags:=$(patsubst v%,%,$(filter-out $(nobuild_tags),$(github_tags_latest)))

docker_image_tags:=$(if $(update_tags),transfer_v$(update_tags) transfer_latest)
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_image_tags))

# All build process actions
PHONY += Build Upload

_all:Build Upload

PHONY += $(update_tags)
Build:$(update_tags)

$(update_tags):
	curl -sSLO $(subst @,$@,$(target))
	tar xf transfer_$@_linux_amd64.tar.gz
	chmod +x transfer_$@_linux_amd64/transfer
	cp Dockerfile transfer_$@_linux_amd64/
	docker build -t $(DOCKER_USERNAME)/transfer:v$@ transfer_$@_linux_amd64
	docker tag $(DOCKER_USERNAME)/transfer:v$@ $(DOCKER_USERNAME)/transfer:latest
	rm -rvf transfer_$@_linux_amd64*

PHONY += $(docker_hub_tags)
Upload:$(docker_hub_tags)

$(docker_hub_tags):Build
	docker push $(subst _,:,$@)

PHONY += test debug
test:debug Build
	@echo Project 'transfer' has been tested

debug:
	@echo github_tags:=$(github_tags)
	@echo github_tags_latest:=$(github_tags_latest)
	@echo dockerhub_tags:=$(dockerhub_tags)
	@echo update_tags:=$(update_tags)
	@echo docker_image_tags:=$(docker_image_tags)
	@echo docker_hub_tags:=$(docker_hub_tags)


PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
