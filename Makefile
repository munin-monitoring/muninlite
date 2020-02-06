PLUGINS = df cpu if_ if_err_ load memory processes swap netstat uptime interrupts irqstats ntpdate plugindir_
CONFIGURATION_FILE ?= munin-node.conf
INPUT_FILE ?= munin-node.in
TARGET_FILE ?= munin-node
PLUGIN_DIRECTORY ?= plugins
PLUGIN_FILES = $(patsubst %,$(PLUGIN_DIRECTORY)/%,$(PLUGINS))
VERSION ?= $(shell cat VERSION)
DIST_DIR = releases
TGZ_FILE ?= $(DIST_DIR)/muninlite-$(VERSION).tar.gz


$(TARGET_FILE): $(INPUT_FILE) $(PLUGIN_FILES) $(CONFIGURATION_FILE)
	@echo "Making munin-node for muninlite version $$VERSION"
	@for plugin_filename in $(PLUGIN_FILES); do \
		echo "Adding plugin $$(basename "$$plugin_filename")"; done
	@export VERSION="$(VERSION)"; \
	export CONF=$$(grep -v '^#' "$(CONFIGURATION_FILE)"); \
	export "PLUGINS=$(PLUGINS)"; \
	export PLSTR="$$(grep -vh '^#' $(PLUGIN_FILES))"; \
	perl -p -e '\
	    s/\@\@VERSION\@\@/$$ENV{"VERSION"}/; \
	    s/\@\@CONF\@\@/$$ENV{"CONF"}/; \
	    s/\@\@PLUGINS\@\@/$$ENV{"PLUGINS"}/; \
	    s/\@\@PLSTR\@\@/$$ENV{"PLSTR"}/;' \
	  "$(INPUT_FILE)" >"$(TARGET_FILE).tmp"
	@chmod +x "$(TARGET_FILE).tmp"
	@mv "$(TARGET_FILE).tmp" "$(TARGET_FILE)"

.PHONY: help
help:
	@$(info Available targets:)
	@$(info   all         - assemble 'TARGET_FILE' ($(TARGET_FILE)))
	@$(info   clean       - remove assembled 'TARGET_FILE' ($(TARGET_FILE)))
	@$(info   clean-all   - remove old releases from 'DIST_DIR' ($(DIST_DIR)))
	@$(info   help        - show this overview)
	@$(info   lint        - code style checks)
	@$(info   spelling    - check spelling)
	@$(info   test        - run tests)
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

.PHONY: lint
lint:
	shellcheck -s dash --exclude=SC2230 $(PLUGIN_FILES) "$(INPUT_FILE)"

.PHONY: spelling
spelling:
	find -name .git -prune -or -name $(DIST_DIR) -prune -or -type f | xargs codespell

.PHONY: test
test: $(TARGET_FILE)
	@# verify that the assembled shell script can be interpreted by the local shell
	@if echo "list" | "$(abspath $(TARGET_FILE))" | grep -qw "uptime"; then \
		echo "Test OK"; else echo "Test FAILED"; false; fi
