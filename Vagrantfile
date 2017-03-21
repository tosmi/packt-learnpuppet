# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">= 1.8.7"

ENV["LC_ALL"] = "en_US.UTF-8"

unless Vagrant.has_plugin?("vagrant-proxyconf")
  raise 'Plugin vagrant-proxyconf not installed! vagrant plugin install plugins/vagrant-proxyconf*.gem'
end

unless Vagrant.has_plugin?("vagrant-sshfs")
  raise 'Plugin vagrant-sshfs not installed! vagrant plugin install plugins/vagrant-sshfs*.gem'
end

Vagrant.configure("2") do |config|
  config.proxy.http     = ENV['http_proxy']  unless ENV['http_proxy'].nil?
  config.proxy.https    = ENV['https_proxy'] unless ENV['https_proxy'].nil?
  config.proxy.no_proxy = ENV['no_proxy']    unless ENV['no_proxy'].nil?

  config.ssh.forward_agent = true
  config.vm.box_check_update = false

  config.vm.provision "shell", path: "vagrant/packages.sh"
  config.vm.provision "shell", path: "vagrant/provision.sh"
  config.vm.provision "shell", inline: "echo 'Defaults secure_path = /sbin:/bin:/opt/puppetlabs/bin' > /etc/sudoers.d/puppet"
  # config.vm.provision "shell", inline: "ifup eth1 >/dev/null 2>&1"
  config.vm.provision "file",  source: "vagrant/bash_profile", destination: ".bash_profile"
  config.vm.provision "file",  source: "~/.gitconfig", destination: ".gitconfig" if File.exists?(File.expand_path('~/.gitconfig'))

  config.vm.synced_folder ".", "/vagrant", type: "sshfs"
  config.vm.box_version = '1611.01'
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "1024"
  end

  config.vm.provider "libvirt" do |libvirt|
    libvirt.memory = 1024
  end

  config.vm.define "vm1", primary: true do |pupdev|
    pupdev.vm.hostname = 'puppet-vm1'
    pupdev.vm.network "private_network", ip: "192.168.42.42"
  end

  # config.vm.define "vm2", autostart: false  do |pupdev|
  #   pupdev.vm.hostname = 'puppet-vm2'
  #   pupdev.vm.network "private_network", ip: "192.168.42.43"
  # end
end
