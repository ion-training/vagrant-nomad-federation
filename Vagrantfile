# -*- mode: ruby -*-
# vi: set ft=ruby :

# IP ranges

# syslog "192.168.56.51"

# vault "192.168.56.61"

# nomad server "192.168.56.71"
# nomad client "192.168.56.75"

# consul server "192.168.56.81"
# consul client "192.168.56.85"


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.define "emea" do |emea|
    emea.vm.hostname = "emea"
    emea.vm.provision "shell", path: "scripts/emea.sh"
    emea.vm.network "private_network", ip: "192.168.56.71"
  end

  config.vm.define "usa" do |usa|
    usa.vm.hostname = "usa"
    usa.vm.provision "shell", path: "scripts/usa.sh"
    usa.vm.network "private_network", ip: "192.168.56.72"
  end

end