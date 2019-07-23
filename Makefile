PLUGINS = df cpu if_ if_err_ load memory processes swap netstat uptime interrupts irqstats ntpdate plugindir_
CONFIGURATION_FILE ?= munin-node.conf
TARGET_FILE ?= munin-node
VERSION ?= $(shell cat VERSION)
DIST_DIR = releases
TGZ_FILE ?= $(DIST_DIR)/muninlite-$(VERSION).tar.gz


$(TARGET_FILE): plugins/* $(CONFIGURATION_FILE)
	@export VERSION="$(VERSION)"; \
	export CONF=$$(grep -v '^#' "$(CONFIGURATION_FILE)"); \
	export "PLUGINS=$(PLUGINS)"; \
	echo "Making munin-node for muninlite version $$VERSION"; \
	export PLSTR=""; \
	for PLGIN in $$PLUGINS; \
	do \
	  echo "Adding plugin $$PLGIN"; \
	  PLSTR=$$(printf "%s\n" "$$PLSTR"; grep -v '^#' plugins/$$PLGIN); \
	done; \
	perl -p -e '\
	    s/\@\@VERSION\@\@/$$ENV{"VERSION"}/; \
	    s/\@\@CONF\@\@/$$ENV{"CONF"}/; \
	    s/\@\@PLUGINS\@\@/$$ENV{"PLUGINS"}/; \
	    s/\@\@PLSTR\@\@/$$ENV{"PLSTR"}/;' \
	  munin-node.in >"$(TARGET_FILE).tmp"
	@chmod +x "$(TARGET_FILE).tmp"
	@mv "$(TARGET_FILE).tmp" "$(TARGET_FILE)"

.PHONY: help
help:
	@$(info Available targets:)
	@$(info   all         - assemble 'TARGET_FILE' ($(TARGET_FILE)))
	@$(info   clean       - remove assembled 'TARGET_FILE' ($(TARGET_FILE)))
	@$(info   clean-all   - remove old releases from 'DIST_DIR' ($(DIST_DIR)))
	@$(info   help        - show this overview)
	@$(info   tgz         - create release archive)

.PHONY: all
all: $(TARGET_FILE)

.PHONY: clean-node
clean-node:
	@echo "Removing $(TARGET_FILE)"
	@rm -f "$(TARGET_FILE)"

.PHONY: clean-tgz
clean-tgz:
	@echo "Removing old releases"
	@rm -rf "$(DIST_DIR)"

.PHONY: clean
clean: clean-node

.PHONY: clean-all
clean-all: clean-node clean-tgz

.PHONY: tgz
tgz: $(TGZ_FILE)

$(TGZ_FILE):
	@echo "Building $@ ..."
	@mkdir -p "$(dir $(@))"
	git archive --prefix=muninlite-$(VERSION)/ --format=tar --output "$@.tmp" HEAD
	mv "$@.tmp" "$@"
