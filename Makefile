PLUGINS = df cpu if_ if_err_ load memory processes swap netstat uptime interrupts irqstats ntpdate plugindir_


munin-node: plugins/* munin-node.conf
	@export VERSION=$$(cat VERSION); \
	export CONF=$$(grep -v '^#' munin-node.conf); \
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
	  munin-node.in > munin-node
	@chmod +x munin-node

all: munin-node

clean-node:
	@echo "Removing munin-node"
	@rm -f munin-node

clean-tgz:
	@echo "Removing old releases"
	@rm -rf releases

clean: clean-node

clean-all: clean-node clean-tgz

tgz: clean-node
	@VERSION=$$(cat VERSION); \
 	echo "Building release/muninlite-$$VERSION.tar.gz"; \
	mkdir -p releases; \
	cp -ra . releases/muninlite-$$VERSION 2>/dev/null || true; \
	cd releases; \
	rm -rf muninlite-$$VERSION/releases; \
	rm -rf muninlite-$$VERSION/.svn; \
	tar zcvf muninlite-$$VERSION.tar.gz muninlite-$$VERSION >/dev/null; \
	rm -rf  muninlite-$$VERSION;
