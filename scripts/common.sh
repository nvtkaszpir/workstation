#!/bin/bash
# this file should be executed as sudo
export LANG=en_US.UTF-8
export > /var/tmp/export.txt

export DEBIAN_FRONTEND=noninteractive

# automatic switching to mirrors by geo-location by country
# notice this may not be the closest/fastest mirror by ping/transfer
sed -i -e 's|http://us.archive.ubuntu.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list

# packages needed for pyenv
apt-get update > /dev/null
apt-get install -y \
	build-essential \
	curl \
	expect \
	git \
	libbz2-dev \
	libffi-dev \
	liblzma-dev \
	libncurses5-dev \
	libncursesw5-dev \
	libreadline-dev \
	libsqlite3-dev \
	libssl-dev \
	llvm \
	make \
	python \
	python-dev \
	python-openssl \
	rsync \
	tk-dev \
	wget \
	xz-utils \
	zlib1g-dev \
	> /dev/null
