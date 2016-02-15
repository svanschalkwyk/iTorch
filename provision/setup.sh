sudo apt-get -y install git libreadline-dev libzmq3-dev ipython3-notebook
curl -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; ./install.sh
source ~/.bashrc
cd ~
git clone https://github.com/facebook/iTorch.git
cd iTorch
luarocks make 
source ~/.bashrc

