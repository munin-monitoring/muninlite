# Release checklist

The following steps are required for a release:

1. update the `Changelog.md` file
2. execute the following commands:
```shell
new_version=2.0.0
echo "$new_version" >VERSION
git commit -m "Release $new_version" VERSION Changelog.md
git tag -s "$new_version" -m "$new_version"
make dist
```
3. push the commits (and the tag) to github:
```shell
git push
git push --tags
```
4. attach the locally generated release archive and the signature to the
   [new release](https://github.com/munin-monitoring/muninlite/releases/)


# Downstream notifications

## OpenWrt

The following minimal set of changes is applicable only, if no incompatible changes
(e.g. new filenames) are introduced in this release.

1. update the
   [release references](https://github.com/openwrt/packages/blob/master/admin/muninlite/Makefile)
   in OpenWrt:
    * `PKG_VERSION`: the new muninlite version
    * `PKG_HASH`: `sha256sum` of the release archive (`.tar.gz`)
    * see [example](https://github.com/openwrt/packages/pull/13717/commits/0f4db441b82a257252b775b1fee6de1737295bdc)
2. create a pull request:
    * the commit needs to contain a `Signed-off-by: NAME <MAIL_ADDRESS>` line (`git commit --signoff`)
    * see [example](https://github.com/openwrt/packages/pull/13717)
