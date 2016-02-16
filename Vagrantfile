# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  config.vm.box_check_update = false
  #config.vm.network "forwarded_port", guest: 8888, host: 9888
  #config.vm.network "forwarded_port", guest: 22, host: 9022

  config.vm.network "public_network", ip: "192.168.4.112", bridge: "enp5s0f1"
  config.vm.network "public_network", bridge: "wlxc83a35cc825f"

  config.vm.synced_folder "../itorch_data", "/home/vagrant/itorch_data"

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

  $startipy= <<-SPYEOF
     cat > /home/vagrant/startup-scripts/run-ipython-notebook.sh << 'EOF'
export PATH=/home/vagrant/torch/install/bin:$PATH
ipython notebook --no-browser --port=8888 --ip=192.168.4.112 --notebook-dir=/home/vagrant/ipy --profile=nbserver > /tmp/ipynb.log 2>&1 &
EOF
chmod +x run-ipython-notebook.sh
mkdir /home/vagrant/ipy
  SPYEOF

  $startit= <<-STIEOF
    cat > /home/vagrant/startup-scripts/run-itorch-notebook.sh << 'EOF'
export PATH=/home/vagrant/torch/install/bin:$PATH
itorch notebook --no-browser --port=8889 --ip=192.168.4.112 --notebook-dir=/home/vagrant/it > /tmp/itnb.log 2>&1 &
EOF
chmod +x run-itorch-notebook.sh
mkdir /home/vagrant/it
  STIEOF

 $rclocal= <<-RCLEOF
     sudo -u root cat > /etc/rc.local << 'EOF'
#!/bin/sh -e
sudo -u vagrant /home/vagrant/startup-scripts/run-itorch-notebook.sh
sudo -u vagrant /home/vagrant/startup-scripts/run-ipython-notebook.sh
exit 0
EOF
  RCLEOF

  config.vm.provision "shell", inline: 'mkdir /home/vagrant/startup-scripts', privileged: false
  config.vm.provision "shell", inline: $startipy, privileged: false
  config.vm.provision "shell", inline: $startit, privileged: false
  config.vm.provision "shell", inline: $rclocal, privileged: true


  $sysinstall= <<-DLOAD
     sudo apt-get update
     sudo apt-get -y install git cmake libreadline-dev libssl-dev ntpdate
     sudo apt-get -y install ipython3 ipython3-notebook python-zmq luarocks lua-cjson 
     # add some decoders for iTorch audio and video
     sudo apt-get install gstreamer1.0-libav -y
     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master lbase64 
     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master env
#     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master lzmq ZMQ_DIR=/usr/local
     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master luacrypto 
     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master luafilesystem 
     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master penlight
     sudo luarocks install --server=https://raw.githubusercontent.com/torch/rocks/master uuid
     sudo luarocks --server=https://raw.githubusercontent.com/torch/rocks/master install image
  DLOAD

  $script= <<-SCRIPT
     sudo ntpdate ntp.ubuntu.com
     sudo ln -s /usr/bin/ipython3 /usr/bin/ipython

     cd /home/vagrant
     curl -sk http://download.zeromq.org/zeromq-4.0.5.tar.gz | tar xzv
     cd zeromq-4.0.5
     ./configure
     make
     sudo make install
     cd ..
     
     curl -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash

     git clone https://github.com/torch/distro.git /home/vagrant/torch --recursive
     cd /home/vagrant/torch
     ./install.sh
     #sudo chown vagrant:vagrant /home/vagrant/ -R
     echo '. /home/vagrant/torch/install/bin/torch-activate' >> /home/vagrant/.bashrc
     source ~/.bashrc
     
     git clone https://github.com/facebook/iTorch.git /home/vagrant/iTorch --recursive
     #sudo chown vagrant:vagrant /home/vagrant -R
     cd /home/vagrant/iTorch
     env "PATH=$PATH" luarocks make 
     sudo chown -R $USER $(dirname $(ipython locate profile))
     
     sudo ufw disable
   SCRIPT
   
  config.vm.provision "shell", inline: $sysinstall, privileged: true
  config.vm.provision "shell", inline: $script, privileged: false
    

  # Shell provisioning
  #config.vm.provider "shell" do |s|
  #  s.path = "provision/setup.sh"
  #end
end
