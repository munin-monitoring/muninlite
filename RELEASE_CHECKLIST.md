# Release checklist

The following steps are required for a release:

1. update the `Changelog` file
2. execute the following commands:
```shell
new_version=2.0.0
echo "$new_version" >VERSION
git commit -m "Release $new_version" VERSION Changelog
git tag -s "$new_version" -m "$new_version"
make dist
```
