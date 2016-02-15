# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  config.vm.box_check_update = true
  #config.vm.network "forwarded_port", guest: 8888, host: 9888
  #config.vm.network "forwarded_port", guest: 22, host: 9022

  config.vm.network "public_network", ip: "192.168.4.126", bridge: "enp2s0f0"
  config.vm.network "public_network", bridge: "wlp0s26u1u6"

  config.vm.synced_folder "../itorch_data", "/itorch_data"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "16384"
    vb.name = "iTorch"
    vb.cpus = "4"
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end
  
  
  $script = <<-SCRIPT
     sudo apt-get update
     sudo apt-get -y install git cmake libreadline-dev libzmq3-dev libssl-dev ntpdate
     sudo apt-get update
     sudo ntpdate ntp.ubuntu.com
     sudo apt-get -y install ipython3 ipython3-notebook python-zmq luarocks uuid lua-cjson 
     sudo luarocks install lbase64 
     sudo luarocks install luacrypto 
     sudo luarocks install luafilesystem 
     sudo luarocks install penlight

     sudo ln -s /usr/bin/ipython3 /usr/bin/ipython
     curl -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
     git clone https://github.com/torch/distro.git /home/vagrant/torch --recursive
     cd /home/vagrant/torch; sudo ./install.sh
     echo ". /home/vagrant/torch/install/bin/torch-activate" >> /home/vagrant/.bashrc
     source ~/.bashrc
     git clone https://github.com/facebook/iTorch.git /home/vagrant/iTorch
     cd /home/vagrant/iTorch; sudo luarocks make 
     sudo ufw disable
     ./home/vagrant/torch/install/bin/torch-activate 
     itorch notebook --no-browser --port=8889 --ip=192.168.4.126
     ipython notebook --no-browser --port=8888 --ip=192.168.4.126
     
   SCRIPT
   
  config.vm.provision "shell", inline: $script, privileged: false
  

  # Shell provisioning
  #config.vm.provider "shell" do |s|
  #  s.path = "provision/setup.sh"
  #end
end
