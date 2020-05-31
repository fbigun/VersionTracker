# SPDX-License-Identifier: MIT


# That's our default target when none is given on the command line
PHONY := _all
_all:

# Define a function that filters out the tags of the json string
# Compilable project (including makefile)
compilable=$(patsubst %/Makefile,%,$(wildcard $(1)/Makefile))

DIRS:=$(shell ls -l |grep "^d" |awk '{print $$9}')
PROJECT:=$(foreach dir,$(DIRS),$(call compilable,$(dir)))

TEST_PROJECT:=$(addprefix test,$(PROJECT))


# All build process actions

PHONY += $(PROJECT) $(TEST_PROJECT) test
_all: $(PROJECT)
test: $(TEST_PROJECT)

$(PROJECT):
	$(MAKE) -C $@ M=$(shell pwd)

$(TEST_PROJECT):
	$(MAKE) -C $(subst test,,$@) M=$(shell pwd) test

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
