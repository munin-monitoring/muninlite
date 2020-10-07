PLUGINS ?= df cpu if_ if_err_ load memory processes swap netstat uptime interrupts irqstats ntpdate wireless plugindir_
CONFIGURATION_FILE ?= muninlite.conf
INPUT_FILE ?= muninlite.in
TARGET_FILE ?= muninlite
PLUGIN_DIRECTORY ?= plugins
PLUGIN_FILES = $(patsubst %,$(PLUGIN_DIRECTORY)/%,$(PLUGINS))
VERSION ?= $(shell cat VERSION)
DIST_DIR = releases
DESTDIR ?= /usr/local/bin
TGZ_FILE ?= $(DIST_DIR)/muninlite-$(VERSION).tar.gz
TGZ_FILE_SIGNATURE ?= $(TGZ_FILE).asc
SIGN_KEY_NAME ?= $(shell git show --no-patch --format=%ae)


$(TARGET_FILE): $(INPUT_FILE) $(PLUGIN_FILES) $(CONFIGURATION_FILE)
	@echo "Making muninlite version $$VERSION"
	@for plugin_filename in $(PLUGIN_FILES); do \
		echo "Adding plugin $$(basename "$$plugin_filename")"; done
	@export VERSION="$(VERSION)"; \
		export "PLUGINS=$(PLUGINS)"; \
		export CONF=$$(grep -v '^#' "$(CONFIGURATION_FILE)"); \
		export PLSTR="$$(grep -vh '^[ \t]*#' $(PLUGIN_FILES))"; \
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
	@$(info   dist        - create release archive)
	@$(info   install     - install the standalone shell script)
	@$(info   help        - show this overview)
	@$(info   lint        - code style checks)
	@$(info   spelling    - check spelling)
	@$(info   test        - run tests)

.PHONY: all
all: $(TARGET_FILE)

.PHONY: clean-node
clean-node:
	@echo "Removing $(TARGET_FILE)"
	@rm -f "$(TARGET_FILE)"

.PHONY: clean-dist
clean-dist:
	@echo "Removing old releases"
	@rm -rf "$(DIST_DIR)"

.PHONY: clean
clean: clean-node

.PHONY: clean-all
clean-all: clean-node clean-dist

$(TGZ_FILE):
	@echo "Building $@ ..."
	@mkdir -p "$(dir $(@))"
	git archive --prefix=muninlite-$(VERSION)/ --format=tar.gz --output "$@.tmp" HEAD
	mv "$@.tmp" "$@"

$(TGZ_FILE_SIGNATURE): $(TGZ_FILE)
	gpg --armor --detach-sign --sign --local-user="$(SIGN_KEY_NAME)" "$<"

.PHONY: dist
dist: $(TGZ_FILE_SIGNATURE)

.PHONY: install
install: $(TARGET_FILE)
	mkdir -p "$(dir $(DESTDIR))"
	cp "$(TARGET_FILE)" "$(DESTDIR)/"


.PHONY: lint
lint:
	shellcheck -s dash --exclude=SC2230 $(PLUGIN_FILES) "$(INPUT_FILE)"

.PHONY: spelling
spelling:
	@find -name .git -prune -or -name $(DIST_DIR) -prune -or -type f -print | xargs codespell

.PHONY: test
test: $(TARGET_FILE)
	@# verify that the assembled shell script can be interpreted by the local shell
	@if echo "list" | "$(abspath $(TARGET_FILE))" | grep -qw "uptime"; then \
		echo "Test OK"; else echo "Test FAILED"; false; fi
