# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/fatedier/frp/tags"
image_url:="https://registry.hub.docker.com/v1/repositories/fbigun/frps/tags"
target:="https://github.com/fatedier/frp/releases/download/v@/frp_@_linux_amd64.tar.gz"

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
	failure:=yes
else ifeq ($(image_result),'"The Repository is Locked, access denied"')
	failure:=yes
else
	imagehub_tags:=$(call filter_tag_json,$(image_result))
	update_tags=$(filter-out $(imagehub_tags),$(github_tags))
endif

tags:=$(sort $(foreach tag,$(update_tags),$(patsubst v%,%,$(tag))))

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

# All build process actions

PHONY += request $(tags)

_all:request $(tags)


request:
	@if [ -n "$(failure)" ] && [ -z "$(tags)" ]; then\
		echo "The Docker Repository is Locked, access denied"; \
		exit 1; \
	elif [ -n "$(failure)" ] && [ -n "$(tags)" ]; then\
		echo "Build and upload image to Docker Repository for the first time"; \
	elif [ -z "$(tags)" ]; then\
		echo "Project frp is not updated, no build job"; \
		exit 0; \
	fi

$(tags):
	curl -sSLO $(subst @,$@,$(target))
	tar xf frp_$@_linux_amd64.tar.gz
	chmod +x frp_$@_linux_amd64/frps
	chmod +x frp_$@_linux_amd64/frpc
	docker build -f server.Dockerfile -t $(DOCKER_USERNAME)/frps:v$@ frp_$@_linux_amd64
	docker build -f client.Dockerfile -t $(DOCKER_USERNAME)/frpc:v$@ frp_$@_linux_amd64
	docker tag $(DOCKER_USERNAME)/frps:v$@ \
		$(call convert_github_tag,$(DOCKER_USERNAME))/frps:v$@
	docker tag $(DOCKER_USERNAME)/frpc:v$@ \
		$(call convert_github_tag,$(DOCKER_USERNAME))/frpc:v$@
	docker push $(DOCKER_USERNAME)/frps:v$@
	docker push $(call convert_github_tag,$(DOCKER_USERNAME))/frps:v$@
	docker push $(DOCKER_USERNAME)/frpc:v$@
	docker push $(call convert_github_tag,$(DOCKER_USERNAME))/frpc:v$@
	rm -rvf frp_$@_linux_amd64*

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
