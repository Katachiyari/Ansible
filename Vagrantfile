Vagrant.configure("2") do |config|
  config.vbguest.auto_update = true
  # vagrant plugin install vagrant-disksize
  config.disksize.size = '20GB'
  #commentaire en francais
  if Vagrant.has_plugin?("vagrant-proxyconf") # Configuration du proxy 
    config.proxy.http = "http://192.168.56.200:3142/"
    config.proxy.https = "http://192.168.56.200:3142/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.devops-afpa.fr"
  end

  # cn / controller node / vm111
  config.vm.define "cn" do |cn| # Configuration de la première machine virtuelle
    cn.vm.box = "ubuntu/bionic64"
    cn.vm.box_version = "20230607.0.5"
    cn.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    cn.vm.network "private_network", ip: "192.168.56.111"
  end

  # mn / manager node / vm112
  config.vm.define "mn" do |mn| # Configuration de la deuxième machine virtuelle
    mn.vm.box = "ubuntu/bionic64"
    mn.vm.box_version = "20230607.0.5"
    mn.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2 
    end
    mn.vm.network "private_network", ip: "192.168.56.112"
    mn.vm.provision "shell", inline: "chmod +x /vagrant/ManagerNode/mn.sh"
  end
end
