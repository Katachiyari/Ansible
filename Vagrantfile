Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http = "http://172.25.0.200:3142/"
    config.proxy.https = "http://172.25.0.200:3142/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.devops-afpa.fr"
  end

  # VM1
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "ubuntu/bionic64"
    vm1.vm.box_version = "20230607.0.5"
    vm1.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end
    vm1.vm.network "private_network", ip: "192.168.1.1"
    vm1.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get upgrade -y
    SHELL
  end

  # VM2
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "ubuntu/bionic64"
    vm2.vm.box_version = "20230607.0.5"
    vm2.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end
    vm2.vm.network "private_network", ip: "192.168.1.2"
    vm2.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get upgrade -y
    SHELL
  end
end
