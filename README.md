# DebStatistics
Statistics for deb packages. Currently, the file types of config files and packages using maintainer scripts are collected.

## Run
Adapt path in `apt-mirror.config`.

```sh
./setup.sh
mkdir ramdisk
sudo mount -t tmpfs -o size=8192m tmpfs ramdisk
./createStat.sh
```

## Troubleshooting
This script doesn't work on NTFS, because file names in various packages are not valid.
