# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  # tell vagrant whey my keys are located
  config.ssh.insert_key = false
  # do not generate a random one
  config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key", "~/.ssh/id_rsa", ]

  config.vm.post_up_message="*** Happy coding ***"
  config.vm.network "private_network", ip: "192.168.100.100"
  config.vm.hostname="devbox"

  # copy my private key to authorized_keys
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
  
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
  end

  config.vm.provision :shell do |s|
    s.path = '.vagrant/provision.sh'
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    echo "HELLO PROVISIONING SHELL"
  SHELL
end
