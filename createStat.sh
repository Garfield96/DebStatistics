#!/bin/bash

mkdir /tmp/packages_tmp;

rm -f results*.txt;

function run() {
    local package_dir=/tmp/packages_tmp/$(basename "$1");
    echo "P${pindex}: $1"
    dpkg-deb -R "$1" "${package_dir}";
    find "${package_dir}" -name "conffiles" -type f | xargs -I {} sh -c 'cat "$1" | xargs -I {} file -b $2{}' - {} ${package_dir} 1>>results$pindex.txt
    rm -rf "${package_dir}";
}

export -f run

find apt-mirror -name "*.deb" -type f | xargs -P18 -I {} --process-slot-var=pindex bash -c 'run "$1"' - {};

rm -rf /tmp/packages_tmp;

cat results*.txt | sed "s/, with very long lines//" | sed "s/, with \([a-zA-Z, ]*\) line terminators//" | sort | uniq -c>results.txt
