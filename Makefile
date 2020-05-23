# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# Define a function that filters out the tags of the json string
# Compilable project (including makefile)
compilable=$(patsubst %/Makefile,%,$(wildcard $(1)/Makefile))

DIRS:=$(shell ls -l |grep "^d" |awk '{print $$9}')
PROJECT:=$(filter-out test,$(foreach dir,$(DIRS),$(call compilable,$(dir))))

_PROJECT:=$(PROJECT)


# All build process actions

PHONY += $(PROJECT) $(_PROJECT) test
_all: $(PROJECT)
test: $(_PROJECT)

$(PROJECT):
	$(MAKE) -C $@ M=$(shell pwd)

$(_PROJECT):
	$(MAKE) -C $@ M=$(shell pwd) -n test

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
