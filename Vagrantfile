Vagrant.configure("2") do |config|
  config.vm.box = "gutehall/ubuntu25-04"
  config.vm.box_version = "2024.11.20"

  #vm1
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end

  config.vm.network "private_network", type: "192.168.1.1"
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update && apt-get upgrade -y
  SHELL
end

#vm2
Vagrant.configure("2") do |config|
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "ubuntu/bionic64"
    vm2.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end

    vm2.vm.network "private_network", type: "192.168.1.2"
    vm2.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get upgrade -y
    SHELL
  end
end