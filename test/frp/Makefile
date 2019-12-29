# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/fatedier/frp/tags"
target:="https://github.com/fatedier/frp/releases/download/v@/frp_@_linux_amd64.tar.gz"


# Define a function that filters out the tags of the json string
filter_tag_json=$(shell echo -n $(1) | json_pp | grep name | awk -F '"' '{print $$4}')

# Convert tags to tags in github package format
convert_github_tag=$(patsubst $(1),docker.pkg.github.com/$(1)/versiontracker,$(1))

# Get the tag information
github_result:='$(shell curl -sL $(github_url))'
github_tags:=$(call filter_tag_json,$(github_result))
tags:=$(sort $(foreach tag,$(github_tags),$(patsubst v%,%,$(tag))))

old_tag:=$(firstword $(tags))
last_tag:=$(lastword $(tags))

objects:=$(old_tag) $(last_tag)

# Value obtained from the shell environment
DOCKER_USERNAME:=$(DOCKER_USERNAME)

# All build process actions

PHONY += $(objects)

_all:$(objects)

$(objects):
	curl -sSLO $(subst @,$@,$(target))
	tar xf $(subst tag,$@,frp_tag_linux_amd64.tar.gz)
	chmod +x $(subst tag,$@,frp_tag_linux_amd64)/frps
	chmod +x $(subst tag,$@,frp_tag_linux_amd64)/frpc
	docker build -f ../../frp/server.Dockerfile -t $(DOCKER_USERNAME)/frps:$(patsubst %,v%,$@) \
		$(subst tag,$@,frp_tag_linux_amd64)
	docker build -f ../../frp/client.Dockerfile -t $(DOCKER_USERNAME)/frpc:$(patsubst %,v%,$@) \
		$(subst tag,$@,frp_tag_linux_amd64)
	docker tag $(DOCKER_USERNAME)/frps:$(patsubst %,v%,$@) \
		$(call convert_github_tag,$(DOCKER_USERNAME))/frps:$(patsubst %,v%,$@)
	docker tag $(DOCKER_USERNAME)/frpc:$(patsubst %,v%,$@) \
		$(call convert_github_tag,$(DOCKER_USERNAME))/frpc:$(patsubst %,v%,$@)
	rm -rf $(wildcard frp_$@_*)

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
