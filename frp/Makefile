# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/fatedier/frp/tags"
image_url:="https://registry.hub.docker.com/v1/repositories/fbigun/frps/tags"
target:="https://github.com/fatedier/frp/releases/download/@/frp_@_linux_amd64.tar.gz"

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

# Define a function that filters out the tags of the json string
filter_tag_json=$(shell echo -n $(1) | json_pp | grep name | awk -F '"' '{print $$4}')

# Convert tags to tags in github package format
convert_github_tag=$(patsubst $(1),docker.pkg.github.com/$(1)/versiontracker,$(1))

# Get unupdated tags
# Get the tag information on docker hub and GitHub respectively,
# and get the tag tags that need to be updated by comparison.
image_result:='$(shell curl -sL $(image_url))'
github_result:='$(shell curl -sL $(github_url))'

github_tags:=$(call filter_tag_json,$(github_result))
ifeq ($(image_result),'"Resource not found"')
	update_tags:=$(github_tags)
	StatusMessage:="Build and upload image to Docker Repository for the first time"
	StatusCode:="NoExit"
else ifeq ($(image_result),'"The Repository is Locked, access denied"')
	StatusMessage:="The Docker Repository is Locked, access denied"
	StatusCode:=1
else
	imagehub_tags:=$(call filter_tag_json,$(image_result))
	update_tags=$(filter-out $(imagehub_tags),$(github_tags))
	StatusMessage:="Build and upload image to Docker Repository"
	StatusCode:="NoExit"
endif

tags:=$(sort $(update_tags))
tags_offset:=$(tags) latest
docker_tags:=$(addprefix frps_,$(tags_offset)) $(addprefix frpc_,$(tags_offset))
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_tags))
docker_github_pkg_tags:=$(addprefix docker.pkg.github.com/$(DOCKER_USERNAME)/versiontracker/,$(docker_tags))
all_docker_repo:=$(docker_hub_tags) $(docker_github_pkg_tags)

ifeq ($(words $(tags)), 0)
	StatusMessage:="Project frp is not updated, no build job"
	StatusCode:=0
else
	latest:=$(word $(words $(tags)),$(tags))
endif

# All build process actions

PHONY += BuildPre Build Upload test $(tags) latest _test $(all_docker_repo)
Build:$(tags) latest
Upload:$(all_docker_repo)
_all:BuildPre Build Upload
test:BuildPre Build _test


BuildPre:
	@echo $(StatusMessage)
	@test $(StatusCode) != "NoExit" && exit $(StatusCode)

$(tags):
	curl -sSLO $(subst @,$@,$(target))
	tar xf frp_$@_linux_amd64.tar.gz
	chmod +x frp_$@_linux_amd64/frps
	chmod +x frp_$@_linux_amd64/frpc
	docker build --build-arg COMMAND_NAME=frps -t $(DOCKER_USERNAME)/frps:$@ frp_$@_linux_amd64
	docker build --build-arg COMMAND_NAME=frpc -t $(DOCKER_USERNAME)/frpc:$@ frp_$@_linux_amd64
	docker tag $(DOCKER_USERNAME)/frps:$@ $(call convert_github_tag,$(DOCKER_USERNAME))/frps:$@
	docker tag $(DOCKER_USERNAME)/frpc:$@ $(call convert_github_tag,$(DOCKER_USERNAME))/frpc:$@
	rm -rvf frp_$@_linux_amd64*

latest:
	docker tag $(DOCKER_USERNAME)/frps:$(latest) $(DOCKER_USERNAME)/frps:latest
	docker tag $(DOCKER_USERNAME)/frpc:$(latest) $(DOCKER_USERNAME)/frpc:latest
	docker tag $(DOCKER_USERNAME)/frps:latest $(call convert_github_tag,$(DOCKER_USERNAME))/frps:latest
	docker tag $(DOCKER_USERNAME)/frpc:latest $(call convert_github_tag,$(DOCKER_USERNAME))/frpc:latest

$(all_docker_repo):
	docker push $(subst _,:,$@)

_test:
	@echo $(subst _,:,$(all_docker_repo))

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
