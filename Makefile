

PLUGINS=df cpu if_ if_err_ load memory processes swap netstat uptime interrupts irqstats ntpdate plugindir_
#PLUGINS=cpu if_ if_err_ load memory processes netstat uptime interrupts irqstats

munin-node: plugins/* munin-node.conf
	@VERSION=$$(cat VERSION); \
	CONF=$$(grep -v '^#' munin-node.conf); \
	echo "Making munin-node for muninlite version $$VERSION"; \
	PLSTR=""; \
	for PLGIN in $(PLUGINS); \
	do \
	  echo "Adding plugin $$PLGIN"; \
	  PLSTR=$$(echo "$$PLSTR"; grep -v '^#' plugins/$$PLGIN); \
	done; \
	PLSTR=$$(echo "$$PLSTR" | sed -e 's/\\/\\\\/g' \
		      	            -e 's/\//\\\//g' \
				    -e 's/\$$/\\$$/g'); \
	perl -p -e \
	  "s/\@\@VERSION\@\@/$$VERSION/;s/\@\@CONF\@\@/$$CONF/;s/\@\@PLUGINS\@\@/$(PLUGINS)/;s/\@\@PLSTR\@\@/$$PLSTR/;" \
	  munin-node.in > munin-node
	@chmod +x munin-node

	
all: munin-node
     
clean-node:
	@echo "Removing munin-node"
	@rm -f munin-node

clean-tgz: 
	@echo "Old releases"
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
