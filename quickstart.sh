#!/bin/bash

set -eof pipefail

export PATH=/usr/bin:/usr/sbin:/opt/puppetlabs/bin

cat <<EOF
***********************************************************
*                                                         *
* This script gets you started quickly                    *
*                                                         *
* It                                                      *
*                                                         *
* 1) enables the puppetlabs yum repository                *
* 2) installs the puppetserver rpm                        *
* 3) enables time synchonization                          *
* 3) configures a puppet entry in /etc/hosts              *
* 4) configures puppetserver to use less memory           *
*                                                         *
***********************************************************
EOF

echo ''
echo '<Hit the any key to continue>'
read

# for the purpose of the video course we pin the agent and server
# packages to specific versions
#
# XXX if you run yum update you will receive a newer version
readonly AGENT_VERSION=1.9.3
readonly SERVER_VERSION=2.7.2

if ! rpm -qi --quiet puppetlabs-release-pc1; then
    rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi

yum install -y puppet-agent-${AGENT_VERSION}
yum install -y puppetserver-${SERVER_VERSION}

puppet resource package ntpdate ensure=installed
puppet resource package ntp ensure=installed

ntpdate 0.centos.pool.ntp.org

puppet resource service ntpd ensure=running enable=true

puppet resource host puppet ensure=present ip='192.168.42.42' host_aliases='puppet'

sed -i 's/JAVA_ARGS.*/JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=64m"/' /etc/sysconfig/puppetserver
