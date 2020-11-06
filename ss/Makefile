# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# API interface
github_url:="https://api.github.com/repos/shadowsocks/shadowsocks-libev/tags"
image_url:="https://registry.hub.docker.com/v1/repositories/fbigun/ss/tags"

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
update_tags:=$(filter-out $(nobuild_tags),$(github_tags_latest))

docker_image_tags:=$(if $(update_tags),ss_$(update_tags) ss_latest)
docker_hub_tags:=$(addprefix $(DOCKER_USERNAME)/,$(docker_image_tags))
depend:=$(if $(update_tags),depend)

# All build process actions
PHONY += Build Upload

_all:Build Upload

PHONY += $(update_tags) $(depend)
Build:$(update_tags)

# Installation of basic build dependencies
$(depend):
	sudo apt-get update
	sudo apt-get install --no-install-recommends -y \
		gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto \
		libssl-dev libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev

$(update_tags):$(depend)
	git clone https://github.com/shadowsocks/shadowsocks-libev.git $@
	cd $@ && git checkout -b $@ $@ && git submodule update --init --recursive \
	&& ./autogen.sh && ./configure && make
	git clone https://github.com/shadowsocks/simple-obfs.git
	cd simple-obfs && git submodule update --init --recursive \
	&& ./autogen.sh && ./configure && make
	mkdir ss-bin && cp $@/src/ss-{local,server} simple-obfs/src/obfs-{local,server} ss-bin/
	docker build -t $(DOCKER_USERNAME)/ss:$@ ss-bin
	docker tag $(DOCKER_USERNAME)/ss:$@ $(DOCKER_USERNAME)/ss:latest
	rm -rvf simple-obfs ss-bin $@

PHONY += $(docker_hub_tags)
Upload:$(docker_hub_tags)

$(docker_hub_tags):Build
	docker push $(subst _,:,$@)

PHONY += test debug
test:debug Build
	@echo Project 'ss' has been tested

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
