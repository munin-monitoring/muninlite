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

## Downstream: OpenWrt

Update the
[release references](https://github.com/openwrt/packages/blob/master/admin/muninlite/Makefile)
in OpenWrt.
