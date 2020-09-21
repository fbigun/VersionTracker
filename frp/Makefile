# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/fatedier/frp/tags"
image_url:="https://registry.hub.docker.com/v1/repositories/fbigun/frps/tags"
target:="https://github.com/fatedier/frp/releases/download/v@/frp_@_linux_amd64.tar.gz"

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

# Get unupdated tags
# Get the tag information on docker hub and GitHub respectively,
# and get the tag tags that need to be updated by comparison.
github_tags:=$(shell curl -sSL $(github_url) | jq -r '.[].name')
github_tags_latest:=$(word 1,$(github_tags))
dockerhub_tags:=$(shell curl -sSL $(image_url) | jq -r '.[].name' || echo "")
update_tags:=$(patsubst v%,%,$(filter-out $(dockerhub_tags),$(github_tags_latest)))

docker_image_tags:=$(if $(update_tags),frpc_v$(update_tags) frpc_latest)
docker_image_tags+=$(if $(update_tags),frps_v$(update_tags) frps_latest)
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_image_tags))

# All build process actions
PHONY += Build Upload test $(update_tags) $(docker_hub_tags)

_all:Build Upload


Build:$(update_tags)

$(update_tags):
	curl -sSLO $(subst @,$@,$(target))
	tar xf frp_$@_linux_amd64.tar.gz
	chmod +x frp_$@_linux_amd64/frps
	chmod +x frp_$@_linux_amd64/frpc
	cp Dockerfile frp_$@_linux_amd64/
	docker build --build-arg COMMAND_NAME=frps -t $(DOCKER_USERNAME)/frps:v$@ frp_$@_linux_amd64
	docker build --build-arg COMMAND_NAME=frpc -t $(DOCKER_USERNAME)/frpc:v$@ frp_$@_linux_amd64
	docker tag $(DOCKER_USERNAME)/frps:v$@ $(DOCKER_USERNAME)/frps:latest
	docker tag $(DOCKER_USERNAME)/frpc:v$@ $(DOCKER_USERNAME)/frpc:latest
	rm -rvf frp_$@_linux_amd64*

Upload:$(docker_hub_tags)

$(docker_hub_tags):Build
	docker push $(subst _,:,$@)

test:Build
	@echo github_result:=$(github_result)
	@echo github_tags_latest:=$(github_tags_latest)
	@echo dockerhub_tags:=$(dockerhub_tags)
	@echo update_tags:=$(update_tags)
	@echo docker_image_tags:=$(docker_image_tags)
	@echo docker_hub_tags:=$(docker_hub_tags)
	@echo Test task completed

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
