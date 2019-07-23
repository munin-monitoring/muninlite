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
	  munin-node.in >"$(TARGET_FILE)"
	@chmod +x "$(TARGET_FILE)"

all: $(TARGET_FILE)

clean-node:
	@echo "Removing $(TARGET_FILE)"
	@rm -f "$(TARGET_FILE)"

clean-tgz:
	@echo "Removing old releases"
	@rm -rf "$(DIST_DIR)"

clean: clean-node

clean-all: clean-node clean-tgz

tgz: $(TGZ_FILE)

$(TGZ_FILE):
	@VERSION="$(VERSION)"; \
	echo "Building "$(DIST_DIR)"/muninlite-$$VERSION.tar.gz"; \
	mkdir -p "$(DIST_DIR)"; \
	cp -ra . "$(DIST_DIR)"/muninlite-$$VERSION 2>/dev/null || true; \
	cd "$(DIST_DIR)"; \
	rm -rf muninlite-$$VERSION/"$(DIST_DIR)"; \
	rm -rf muninlite-$$VERSION/.svn; \
	tar zcvf muninlite-$$VERSION.tar.gz muninlite-$$VERSION >/dev/null; \
	rm -rf  muninlite-$$VERSION;
