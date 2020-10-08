# MuninLite

MuninLite is a standalone shell script implementing the Munin
protocol and containing a few basic plugins out of the box.

It can run as an inetd-based service over TCP or a simple
executable script communicating via stdin/stdout.  The latter
does not require root privileges.


# Project scope

MuninLite is supposed to be a minimal portable and shell-based
implementation of `munin-node`.  It provides a small set of
essential plugins suitable for basic monitoring of a host.
Additionally external plugins can be used.
Only essential tools (e.g. the ones provided by busybox) should
be required for MuninLite.


# Missing features (by design)

The following features of the official `munin-node` implementation
are not included (see "Project scope" above):

* no configuration per plugin
  (e.g. environment variables or reduced privileges)
* no host-based access control for incoming requests
  (may be configured via `/etc/hosts.allow` or firewall rules)
* no advanced plugin state tracking
  (e.g. killing a plugin process after a timeout)


# Installation

## Build requirements

* Make
* Perl


## Installation

Download source and unpack it.

Assemble the MuninLite shell script by running `make`:
```shell
$ make
```

You may assemble a reduced script by including only specific plugins:
```shell
$ make PLUGINS="cpu load uptime"
```

Run `make install` or simply copy `muninlite` to a suitable location.

```shell
make install
```

Two typical ways of using MuninLite as a `munin-node` replacement are:

* direct execution: suitable for remote hosts lacking root access (e.g. shared host)
* TCP service via inetd/xinetd: providing a service that is accessible via TCP (like `munin-node`)

Both approaches are detailed below.


### Installation for direct execution

Configure the `address` setting of the node in the master's configuration with
a suitable transport, e.g.:
```
[some.host.tld]
    address ssh://node-a.example.org/usr/local/bin/muninlite
```

The above example causes the master to connect to the node via ssh and to
execute the MuninLite script directly.  The running script responds to request
from standard input just like it would do as a TCP service via inetd/xinetd.


### Installation as a TCP service (inetd/xinetd)

Add munin port to `/etc/services` (in case it is missing):
```shell
echo "munin           4949/tcp        lrrd            # Munin" >>/etc/services
```

Configure inetd or xinetd to fork this script for request on the
munin port (4949).

Sample configuration for xinetd is located in `examples/xinetd.d/munin`:
```shell
cp examples/xinetd.d/munin /etc/xinetd.d
killall -HUP xinetd
```

Sample configuration for inetd is located in `examples/inetd.conf`:
```shell
cat examples/inetd.conf >> /etc/inetd.conf
killall -HUP inetd
```

Restrict access to munin port using hosts.allow and
hosts.deny or add a rule to your favorite firewall config.
Examples of hosts.allow/deny settings is provided in the examples
directory.

Iptables might be set with something like this:
```shell
iptables -A INPUT -p tcp --dport munin --source 10.42.42.25 -j ACCEPT
```

## Test

To test the script, just run it (`/usr/local/bin/muninlite`):
```shell
$ /usr/local/bin/muninlite
# munin node at localhost.localdomain
help
# Unknown command. Try list, nodes, config, fetch, version or quit
list
df cpu if_eth0 if_eth1 if_err_eth0 if_err_eth1 load memory
version
munins node on example.org version: 0.0.5 (muninlite)
quit
```

An (x)inetd setup can be tested via telnet or netcat:
```shell
# telnet localhost 4949
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
# munin node at localhost.localdomain
help
# Unknown command. Try list, nodes, config, fetch, version or quit
list
df cpu if_eth0 if_eth1 if_err_eth0 if_err_eth1 load memory
version
munins node on example.org version: 0.0.5 (muninlite)
quit
Connection closed by foreign host.
```


# Configuration

## Plugin configuration

MuninLite does not support explicit configurations per plugin
(as `munin-node` does).

But the file `/etc/munin/muninlite.conf` (if it exists) is sourced
as a shell script during the execution of MuninLite.

This optional configuration file allows a variety of customizations:

* override integrated plugins
  (by redefining their functions, e.g. `config_if` and `fetch_if`)
* disable integrated plugins (e.g. `PLUGINS=${PLUGINS/ wireless / }`)
* overwrite configuration variables for integrated plugins
  (e.g. `NTP_PEER` or `DF_IGNORE_FILESYSTEM_REGEX`)
* specify configuration settings required for external plugins
  (provided in `/etc/munin/plugins/`):
  `export FOO_SERVICE=http://localhost:7123`


## External plugins

MuninLite includes a set of integrated plugins.  In addition it is
possible to expose additional plugins (just like the official
`munin-node` implementation).  By default all executables files
(or symlinks) below the directory `/etc/munin/plugins` are treated
as plugins.


## Munin master configuration

Configure /etc/munin/munin.conf on you munin master as you would for a regular
`munin-node`. If you configured MuninLite as a TCP service (e.g. via
inetd/xinetd):

```
[some.host.tld]
    address 10.42.42.25
    use_node_name yes
```

In case of direct execution of MuninLite on the remote host (without a TCP
service), you need to configure a transport and execute the script directly:
```
[some.host.tld]
    address ssh://10.42.42.25/usr/local/bin/muninlite
    use_node_name yes
```

The ssh transport obviously requires the use of `authorized_keys` on
the host running MuninLite.


# License and copyright

MuninLite is released under GPLv2 (see LICENSE file).

* Copyright (C) 2007-2011 Rune Nordbøe Skillingstad <rune@skillingstad.no>
* Copyright (C) 2019-2020 Lars Kruse <devel@sumpfralle.de>
* Copyright (C) 2020 Kim B. Heino <b@bbbs.net>
