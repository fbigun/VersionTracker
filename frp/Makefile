# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/fatedier/frp/tags"
image_url:="https://registry.hub.docker.com/v1/repositories/fbigun/frps/tags"
target:="https://github.com/fatedier/frp/releases/download/v@/frp_@_linux_amd64.tar.gz"
releases:="https://api.github.com/repos/fatedier/frp/releases"

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

# Get unupdated tags
# Get the tag information on docker hub and GitHub respectively,
# and get the tag tags that need to be updated by comparison.
github_tags:=$(shell curl -sSL $(github_url) | jq -r '.[].name')
github_tags_latest:=$(word 1,$(github_tags))
dockerhub_tags:=$(shell curl -sSL $(image_url) | jq -r '.[].name?' 2>/dev/null || echo "")
skip_update_tags:=
nobuild_tags:=$(dockerhub_tags) $(skip_update_tags)
update_tags:=$(patsubst v%,%,$(filter-out $(nobuild_tags),$(github_tags_latest)))
ball:=$(shell curl -sSL $(releases)|jq -r '.[]|select(.tag_name=="v$(update_tags)")|.assets[]|select(.name|contains("linux"))|select(.name|contains("amd64"))|.browser_download_url?')
update_tags:=$(if $(ball),$(update_tags))
message:=$(if !$(update_tags), "print")

docker_image_tags:=$(if $(update_tags),frpc_v$(update_tags) frpc_latest)
docker_image_tags+=$(if $(update_tags),frps_v$(update_tags) frps_latest)
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_image_tags))

# All build process actions
PHONY += Build Upload

_all:Build Upload

PHONY += $(update_tags) $(message)
Build:$(update_tags) $(message)

$(message):
	@echo info:: No updates to the frp project

$(update_tags):
	curl -sSL $(subst @,$@,$(target)) | tar xz
	chmod +x frp_$@_linux_amd64/frps
	chmod +x frp_$@_linux_amd64/frpc
	cp Dockerfile frp_$@_linux_amd64/
	docker build --build-arg COMMAND=frps -t $(DOCKER_USERNAME)/frps:v$@ frp_$@_linux_amd64
	docker build --build-arg COMMAND=frpc -t $(DOCKER_USERNAME)/frpc:v$@ frp_$@_linux_amd64
	docker tag $(DOCKER_USERNAME)/frps:v$@ $(DOCKER_USERNAME)/frps:latest
	docker tag $(DOCKER_USERNAME)/frpc:v$@ $(DOCKER_USERNAME)/frpc:latest
	rm -rvf frp_$@_linux_amd64*

PHONY += $(docker_hub_tags)
Upload:$(docker_hub_tags)

$(docker_hub_tags):Build
	docker push $(subst _,:,$@)

PHONY += test debug
test:debug Build
	@echo Project 'frp' has been tested

debug:
	@echo github_tags:=$(github_tags)
	@echo github_tags_latest:=$(github_tags_latest)
	@echo dockerhub_tags:=$(dockerhub_tags)
	@echo update_tags:=$(update_tags)
	@echo docker_image_tags:=$(docker_image_tags)
	@echo docker_hub_tags:=$(docker_hub_tags)
	@echo ball:=$(ball)


PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
