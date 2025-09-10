# .home

Home directory management by symlinking the XDG base directories to counterparts
in a tracked git repository. 

## Assumptions

* The Linux distribution is Ubuntu 24.04 LTS or later. Other Debian based
distros may work but are untested.
* Ansible is installed per the directions in the Setup section.
* The login shell is zsh. This only matters if running an installation script
with a hardcoded reference to the `.zshrc` file.

## Methodology

The `~/.profile` file is read by every POSIX-compliant login shell, so
high-level system settings that need to be shell agnostic should be sourced
there. For organization, these settings are divided into 3 files:
* $XDG_CONFIG_HOME/env/vars.sh - new environment variables
* $XDG_CONFIG_HOME/env/path.sh - modifications to the `$PATH` environment
variable
* $XDG_CONFIG_HOME/env/alias.sh - shell aliases

Shell scripts intended to be executed by a specific shell should be included in
that shell's rc file, e.g. `$XDG_CONFIG_HOME/zsh/.zshrc`.

Ansible playbooks for downloading software are located in this directory:

``` $HOME/.local/share/ansible/playbooks/localhost/software ```

Each subdirectory contains an installation and uninstallation playbook. Any
required manual steps not performed by the playbooks are detailed in the
directory's README file. 

Software downloaded as a single binary or as a github repository will generally
be persisted to `/opt/managed`, with any executables symlinked to
`$HOME/.local/bin`. This obviates the need to add each one to the $PATH
environment variable individually. Software available through the default ubuntu
repositories listed in the `/etc/apt/sources.list.d/ubuntu.sources` file are
managed through the apt package manager.

The installation and uninstallation playbooks do not typically create or delete
config files since these are tracked by git. However, the playbooks will
sometimes add/remove lines from `.zshrc` or one of the .sh files sourced by
`~/.profile`. 

## Setup

1. Clone repository

```sh
    git clone git@github.com:alamansky/.home.git ~/.home
```

2. Symlink XDG base directories  

```sh
    ln -s ~/.home/{.cache,.config,.local} ~
```

3. Source env files in `~/.profile` so interactive login bash shell can run
ansible playbook  

```sh
    printf "source ~/.config/env/vars.sh\nsource ~/.config/env/path.sh" >> ~/.profile
    source ~/.profile
```

4. Install ansible-playbook.

```sh 
    #https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu
    # get latest package info from all sources
    sudo apt update
    # install repository abstraction tool for ppa management
    sudo apt install software-properties-common
    # add ansible ppa 
    sudo add-apt-repository --yes --update ppa:ansible/ansible 
    # install ansible 
    sudo apt install ansible 
```

5. Run ansible playbooks to install desired software, for example the zsh shell
(recommended)  

```sh
    ansible-playbook ~/.local/share/ansible/playbooks/localhost/software/zsh/install.yml
```

