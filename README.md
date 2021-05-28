# DebStatistics
Statistics for deb packages. Currently, the file types of config files are collected.

## Run
Adapt path in `apt-mirror.config`.

```sh
./setup.sh
./createStat.sh
```

## Troubleshooting
This script doesn't work on NTFS, because file names in various packages are not valid.
