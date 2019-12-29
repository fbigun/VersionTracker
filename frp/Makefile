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

# Get unupdated tags
# Get the tag information on docker hub and GitHub respectively,
# and get the tag tags that need to be updated by comparison.
image_result:='$(shell curl -sL $(image_url))'
github_result:='$(shell curl -sL $(github_url))'

github_tags:=$(call filter_tag_json,$(github_result))
ifeq ($(image_result),'"Resource not found"')
	update_tags:=$(call filter_tag_json,$(github_tags))
	failure:=yes
else ifeq ($(image_result),'"The Repository is Locked, access denied"')
	failure:=yes
else
	imagehub_tags:=$(call filter_tag_json,$(image_result))
	update_tags=$(filter-out $(imagehub_tags),$(github_tags))
endif

tags:=$(sort $(foreach tag,$(update_tags),$(patsubst v%,%,$(tag))))

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
	tar xf $(subst tag,$@,frp_tag_linux_amd64.tar.gz)
	chmod +x $(subst tag,$@,frp_tag_linux_amd64)/frps
	chmod +x $(subst tag,$@,frp_tag_linux_amd64)/frpc
	docker build -f server.Dockerfile -t fbigun/frps:$(patsubst %,v%,$@) \
		$(subst tag,$@,frp_tag_linux_amd64)
	docker push fbigun/frps:$(patsubst %,v%,$@)
	docker build -f client.Dockerfile -t fbigun/frpc:$(patsubst %,v%,$@) \
		$(subst tag,$@,frp_tag_linux_amd64)
	docker push fbigun/frpc:$(patsubst %,v%,$@)
	rm -rf frp $(subst tag,$@,frp_tag_linux_amd64.tar.gz)

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
