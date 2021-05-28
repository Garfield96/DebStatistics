#!/bin/bash
set -ex

sudo apt-get install apt-mirror

apt-mirror ./apt-mirror.config

