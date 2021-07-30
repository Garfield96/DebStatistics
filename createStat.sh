#!/bin/bash

tmp_dir=ramdisk/tmp
mkdir $tmp_dir;

rm -f results*.txt;
rm -f pre_*_results*.txt;
rm -f post_*_results*.txt;
rm -f scanned_results*.txt;

function run() {
    local package_dir="ramdisk/tmp/"$(basename "$1");
    echo $1 1>>scanned_results$pindex.txt;
    echo "P${pindex}: $1 - $package_dir"
    dpkg-deb -R "$1" "${package_dir}" || return;
    find "${package_dir}/DEBIAN" -name "conffiles" -type f | xargs -I {} sh -c 'cat "$1" | xargs -I {} file -b $2{}' - {} ${package_dir} 1>>results$pindex.txt
    if [ -f "${package_dir}/DEBIAN/preinst" ]; then
        echo $1 1>>pre_inst_results$pindex.txt;
    fi
    if [ -f "${package_dir}/DEBIAN/postinst" ]; then
        echo $1 1>>post_inst_results$pindex.txt;
    fi
    if [ -f "${package_dir}/DEBIAN/prerm" ]; then
        echo $1 1>>pre_rm_results$pindex.txt;
    fi
    if [ -f "${package_dir}/DEBIAN/postrm" ]; then
        echo $1 1>>post_rm_results$pindex.txt;
    fi
    rm -rf "${package_dir}";
}

export -f run

find apt-mirror -name "*.deb" -type f | xargs -P24 -I {} --process-slot-var=pindex bash -c 'run "$1"' - {};

rm -rf $tmp_dir;

cat results*.txt | sed "s/, with very long lines//" | sed "s/, with \([a-zA-Z, ]*\) line terminators//" | sort | uniq -c>results.txt
