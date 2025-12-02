# .home

Home directory management system for my portable personal computing environment. 

## Overview

This repository uses the XDG Base Directory specification to organize files for the automated installation and configuration of software. Installation is performed through ansible playbooks found in the subdirectories at `~/.local/share/ansible/playbooks/localhost/software`. Each subdirectory is named for the software that is managed by the files therein, and is expected to contain the following:

* install.yml - playbook for installing the software
* uninstall.yml - playbook for uninstalling the software
* data.yml - required variables
* README.md - general information about the software, including any manual steps not covered by automation.

Software that is distributed as a single binary or a git repo will usually be downloaded to `/opt/managed/$name/$version`, and the executable will be symlinked to `~/.local/bin`. Software downloaded using a package manger should not be modified to follow this convention and should stay in that package manager ecosystem.  

Language compilers/interpreters are considered a special class of software and are implemented through the subdirectories at `~/.local/share/ansible/playbooks/localhost/languages`, where the ansible playbooks leverage the asdf runtime version manager (which is a required dependency).

Configuration files are located in the `~/.config` directory and are not generally created or destroyed by running a playbook, since they are tracked by git. Some playbooks will write additional lines to existing files (e.g. `.zshrc` for init logic). When these operations occur, they should be detailed in the READMEs. 

The `~/.config/env` directory contains shell files for configuring the environment itself:

* secrets.sh - export statements for sensitive environment variables
* vars.sh - export statements for regular environment variables
* path.sh - additions to the $PATH variable, e.g. `PATH="$HOME/.local/bin:$PATH"`
* functions.sh - shell functions

These files should be sourced in `~/.profile` so they can be made available to any login shell.  

## Requirements

* Debian-based Linux distribution (recommended: Ubuntu 24.04) with the apt package manager.
* Ansible
* Z Shell

Steps for installing Ansible are included in the Instructions section of this document, which can then be used to install Z Shell.

## Instructions

### Configuring Github Access

If a brand new environment is being provisioned, the environment's SSH client will require a private RSA key to authenticate with Github so this repo can be cloned.

1. If re-using an existing key, simply copy key into `~/.ssh`. Or, if creating a new key, generate a new keypair by following the prompts output from the `ssh-keygen` command, and then upload the resulting public key to Github through their web interface.

2. Ensure permissions are set correctly on the private key, replacing `$key_name` with the file name:  

```
chmod 600 ~/.ssh/$key_name
```

3. Create a config file specifying that the key should be used when connecting to the github domain:  

```
touch ~/.ssh/config
printf "Host github.com\n   AddKeysToAgent yes\n   User git\n   IdentityFile ~/.ssh/$key_name" >> ~/.ssh/config
```

### Setting up Home Directory

1. Clone the repository:  

```
git clone git@github.com:alamansky/.home.git ~/.home
```

2. Symlink XDG base directories:  

```
ln -s ~/.home/{.cache,.config,.local} ~
```

3. Source env files in `~/.profile` so interactive login shells can run ansible playbooks  

```
printf ". ~/.config/env/secrets.sh\n. ~/.config/env/vars.sh\n. ~/.config/env/path.sh\n. ~/.config/env/functions.sh\n" >> ~/.profile
source ~/.profile
```

4. Install ansible

```
# https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu
# get latest package info from all sources
sudo apt update
# install repository abstraction tool for ppa management
sudo apt install software-properties-common
# add ansible ppa
sudo add-apt-repository --yes --update ppa:ansible/ansible
# install ansible
sudo apt install ansible
```

5. Install Z shell  

```
ansible-playbook ~/.local/share/ansible/playbooks/localhost/software/zsh/install.yaml
```

6. Install other software/languages as desired.
