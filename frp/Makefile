.PHONY: build success $(tags)

github_url:=https://api.github.com/repos/fatedier/frp/tags
image_url:=https://registry.hub.docker.com/v1/repositories/fbigun/frps/tags
target:=https://github.com/fatedier/frp/releases/download/vtag/frp_tag_linux_amd64.tar.gz


github_tags:=$(shell curl -sSL $(github_url) | grep name | awk -F '"' '{print $$4}')
result:='$(shell curl -sL $(image_url))'

ifeq ($(result),'"Resource not found"')
	update_tags:=$(github_tags)
else ifeq ($(result),'"The Repository is Locked, access denied"')
	success:=false
else
	imagehub_tags:=$(shell echo -n $(result) | json_pp | grep name | awk -F '"' '{print $$4}')
	update_tags=$(filter-out $(imagehub_tags),$(github_tags))
endif

tags+=$(foreach tag,$(update_tags),$(patsubst v%,%,$(tag)))

build:request $(tags)

request:
	@if [ "$(success)" = "false" ]; then\
		echo "The Repository is Locked, access denied"; \
		exit 1; \
	fi

$(tags):
	curl -sSLO $(subst tag,$@,$(target))
	tar xf $(subst tag,$@,frp_tag_linux_amd64.tar.gz)
	tar_dir = $(subst tag,$@,frp_tag_linux_amd64)
	chmod +x $(tar_dir)/frps
	chmod +x $(tar_dir)/frpc
	docker build -f server.Dockerfile -t fbigun/frps:$(patsubst %,v%,$@) $(tar_dir)/frps
	docker push fbigun/frps:$(patsubst %,v%,$@)
	docker build -f client.Dockerfile -t fbigun/frpc:$(patsubst %,v%,$@) $(tar_dir)/frpc
	docker push fbigun/frpc:$(patsubst %,v%,$@)
	rm -rf frp $(subst tag,$@,frp_tag_linux_amd64.tar.gz)
