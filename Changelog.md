# [2.1.2] - 2021-07-14

* handle tokens with leading hyphens carefully
* do not ignore `DF_IGNORE_FILESYSTEM_REGEX` during build


# [2.1.1] - 2020-10-19

* muninlite: do not hardcode accepted network interface names
* irqstats: fix irqstats on Raspberry Pi
* ntpdate: add missing "graph_category time" to config section
* processes, ntpdate: draw graphs with normal 1px lines


# [2.1.0] - 2020-10-08

* if_: handle "Unknown" emitted by ethtool
* if: include "Interface" to graph_title for better grouping
* muninlite: do not crash if empty line is received
* df: fix "config" vs "fetch" mismatches
* new plugin "wireless" (based on `iwinfo`, suitable for OpenWrt)
* add support for optional configuration file `/etc/munin/muninlite.conf`


# [2.0.1] - 2020-04-12

* network interface names: tolerate more than one hyphen
* fix category for uptime graph


# [2.0.0] - 2020-02-12

* change plugin path to `/etc/munin/plugins`
  (previously: `munin-node-plugin.d` next to the muninlite script)
* change name of standalone script from "munin-node" to "muninlite"
* various improvements of most plugins
* add checks for code style and spelling
* rework Makefile
* import patches from [Opennet Initiative](https://opennet-initiative.de/)
* import patches from [OpenWrt](https://openwrt.org/)
* move project hosting to the "munin" organization in github
  (https://github.com/munin-monitoring/muninlite)


# [1.0.4] - 2011-01-27

* `munin-node.conf`: Forget the previous change
* `munin-node.in`: Added ipsec to monitored interfaces - Thanks to Tamas TEVESZ
* Added VLANs to monitored interfaces - Patch from Christophe GUILLOUX
  (Closes: #3162054)
* `plugins/ntpdate`: Arrays is a bashismn
* `munin-node.conf`: $HOSTNAME seems to be a bashism
* `plugins/cpu`: Keith Taylor submitted a patch to support older kernels ID
  (Closes: #2716990)


# [1.0.3] - 2011-01-14

* Added patch from Jozsef Marton
* Makefile: Added `plugindir_` as a default plugin
* `plugins/plugindir_`: Build need this empty file
* `munin-node.in`: Accepted patch from Jozsef Marton. Plugins might now be
  added dynamically using the `plugindir_`


# [1.0.2] - 2009-03-17

* `munin-node.in`: Added support for `if_` and `if_err_` on ppp devices
* `plugins/df`: Closes 2080844
* `plugins/if_`: Closes 2078765
* `munin-node.conf`: Wrong hostname for NTP pool
* `plugins/netstat`: BUG: Line break


# [1.0.1] - 2007-11-30

* munin-node.conf, munin-node.in, plugins/ntpdate
* plugins/df: Nicer pipe (hint from janl)


# [1.0.0] - 2007-06-20

* `plugins/if_`: SF#1736919
* Changed type to DERIVE and added min values to 0
* Added check for ethtool to check if max value could be calculated
* Makefile: munin-node depends on plugins
* `doc/floppyfw.txt`: More fixes to the floppyfw howto
* `examples/post-muninlite.ini`: Added post-boot script for floppyfw
* `doc/floppyfw.txt`: Rewrote how to compile floppyfw with muninlite support
* `doc/floppyfw.txt`: Howto for floppyfw
* `doc/Working-distributions.txt`: Some Endian Firewall documentation
* Makefile: Fix
* import into a subversion repository


# [0.9.15] - 2007-06-10

* Some documentations added


# [0.9.14] - 2007-06-10

* Plugins as separate files
* Makefile (make smaller munin-node for systems with less plugins)


# [0.9.13] - 2007-06-10

* Fixed spikes (hopefully) in `if_` and `if_err_`
* Fixed missing output due to parsed $ in variables in multiple plugins


# [0.9.12] - 2007-06-08

* First Changelog
* Initial "release"
