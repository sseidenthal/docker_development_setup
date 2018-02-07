# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.post_up_message="*** Happy coding ***"
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.100.100"
  config.vm.hostname="devbox"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "2048"
  end

  config.vm.provision :shell do |s|
    s.path = '.vagrant/provision.sh'
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    echo "HELLO PROVISIONING SHELL"
  SHELL
end
