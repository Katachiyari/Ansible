Vagrant.configure("2") do |config|
  config.vbguest.auto_update = true
  #commentaire en francais
  if Vagrant.has_plugin?("vagrant-proxyconf") # Configuration du proxy 
    config.proxy.http = "http://172.25.0.200:3142/"
    config.proxy.https = "http://172.25.0.200:3142/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.devops-afpa.fr"
  end

  # cn / controller node / vm1
  config.vm.define "cn" do |cn| # Configuration de la première machine virtuelle
    cn.vm.box = "ubuntu/bionic64"
    cn.vm.box_version = "20230607.0.5"
    cn.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.customize ["modifyhd", :id, "--resize", 20480]
    end
    cn.vm.network "private_network", ip: "172.25.0.111"
    cn.vm.provision "shell", shell: "chmod +x /vagrant/ControllerNode/cn.sh"
    cn.vm.provision "shell", path: "./ControllerNode/cn.sh"
  end

  # mn / manager node / vm2
  config.vm.define "mn" do |mn| # Configuration de la deuxième machine virtuelle
    mn.vm.box = "ubuntu/bionic64"
    mn.vm.box_version = "20230607.0.5"
    mn.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.customize ["modifyhd", :id, "--resize", 20480] 
    end
    mn.vm.network "private_network", ip: "172.25.0.112"
    mn.vm.provision "shell", shell: "chmod +x /vagrant/ManagerNode/mn.sh'"
    mn.vm.provision "shell", path: "./ManagerNode/mn.sh"
  end
end
