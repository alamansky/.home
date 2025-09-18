# symlink XDG base directories:  
ln -s ~/.home/{.cache,.config,.local} ~

# source env files in `~/.profile` so interactive login shells can run ansible playbooks  
printf "source ~/.config/env/vars.sh\nsource ~/.config/env/path.sh" >> ~/.profile
source ~/.profile

# get latest package info from all sources
sudo apt update

# install repository abstraction tool for ppa management
sudo apt install software-properties-common

# add ansible ppa
sudo add-apt-repository --yes --update ppa:ansible/ansible

# install ansible
sudo apt install ansible
