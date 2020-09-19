# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

github_url:="https://api.github.com/repos/yoshiko2/AV_Data_Capture/tags"
dockerhub_url:="https://registry.hub.docker.com/v1/repositories/fbigun/jav/tags"

github_tags:=$(shell curl $(github_url) | jq -r '.[].name')
dockerhub_tags:=$(shell curl $(image_url) | jq -r '.[].name' || echo "")
update_tags:=$(filter-out $(dockerhub_tags),$(github_tags))
latest:=$(if $(update_tags),$(word $(words $(update_tags)),$(update_tags)))

docker_image_tags:=$(addprefix jav_v,$(update_tags))
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_image_tags)) latest


# All build process actions
PHONY += Build Upload $(tags) $(latest) $(docker_hub_tags) test
_all:Build Upload

Build:$(tags) $(latest)

$(update_tags):
	docker build --build-arg AV_Data_Capture_VERSION=$@ -t $(DOCKER_USERNAME)/jav:v$@ .

$(latest):$(update_tags)
	docker tag $(DOCKER_USERNAME)/jav:v$(latest) $(DOCKER_USERNAME)/jav:latest
	docker tag $(DOCKER_USERNAME)/jav:v$(latest) $(DOCKER_USERNAME)/jav:latest

Upload:$(docker_hub_tags)

$(docker_hub_tags):Build
	docker push $(subst _,:,$@)

test:Build

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
