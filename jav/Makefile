# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

github_url:="https://api.github.com/repos/yoshiko2/AV_Data_Capture/tags"
dockerhub_url:="https://registry.hub.docker.com/v1/repositories/fbigun/jav/tags"

github_tags:=$(shell curl $(github_url) | jq -r '.[].name')
github_tags_latest:=$(word 1,$(github_tags))
dockerhub_tags:=$(shell curl $(image_url) | jq -r '.[].name' || echo "")
update_tags:=$(filter-out $(dockerhub_tags),v$(github_tags_latest))

docker_image_tags:=$(if $(update_tags),jav_v$(update_tags) jav_latest)
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_image_tags))


# All build process actions
PHONY += Build Upload $(update_tags) $(docker_hub_tags) test
_all:Build Upload

Build:$(update_tags)

$(update_tags):
	docker build --build-arg AV_Data_Capture_VERSION=$@ -t $(DOCKER_USERNAME)/jav:v$@ .
	docker tag $(DOCKER_USERNAME)/jav:v$@ $(DOCKER_USERNAME)/jav:latest

Upload:$(docker_hub_tags)

$(docker_hub_tags):Build
	docker push $(subst _,:,$@)

test:Build
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
