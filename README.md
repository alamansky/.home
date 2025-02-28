# .home

~

## Instructions

1. Clone repository:  
```
git clone git@github.com:alamansky/.home.git ~/.home
```
2. Symlink XDG base directories:  
```
ln -s ~/.home/{.cache,.config,.local} ~
```
3. Source env files in `~/.profile` so interactive login bash shell can run ansible playbook  
```
echo "source $HOME/.config/env/{vars.sh,path.sh}" >> .profile
source ~/.profile
```
4. Install ansible

https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu

```
# get latest package info from all sources
sudo apt update
# install repository abstraction tool for ppa management
sudo apt install software-properties-common
# add ansible ppa
sudo add-apt-repository --yes --update ppa:ansible/ansible
# install ansible
sudo apt install ansible
```
