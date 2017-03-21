#!/bin/bash

set -eof pipefail

export PATH=/usr/bin:/usr/sbin:/opt/puppetlabs/bin

# for the purpose of the video course we pin the agent and server
# packages to specific versions
#
# XXX if you run yum update you will receive a newer version
readonly AGENT_VERSION=1.8.3
readonly SERVER_VERSION=2.7.2

yum -y -q install git || exit 1

#
# install puppet packages
#

if ! rpm -qi --quiet puppetlabs-release-pc1; then
    rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi

yum install -y puppet-agent-${AGENT_VERSION}
yum install -y puppetserver-${SERVER_VERSION}

puppet resource package ntpdate ensure=installed
puppet resource package ntp ensure=installed

ntpdate 0.centos.pool.ntp.org

puppet resource service ntpd ensure=running enable=true

puppet resource host puppet ensure=present ip='127.0.0.1' host_aliases='puppet'

sed -i 's/JAVA_ARGS.*/JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=64m"/' /etc/sysconfig/puppetserver

# keep this until vagrant bug #8096 gets fixed
# https://github.com/mitchellh/vagrant/issues/8096
# ifup eth1 >/dev/null 2>&1
