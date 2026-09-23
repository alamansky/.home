This directory contains ansible playbooks for managing the installation/uninstallation of languages and software.

## languages

Language runtimes are managed by the [asdf](https://github.com/asdf-vm/asdf) virtual machine.

Each subdirectory under `./languages` contains the playbooks for the language described by the subdirectory name. The language name should match the asdf plugin name for that language (e.g. "golang" instead of "go"). Each subdirectory should contain the following files:

* `data.yml`
  ```yaml
  language: "<asdf-plugin-name>"
  version: "<version>"
  plugin: "<asdf-plugin-url>"
  ```
* `install.yml`
  ```yaml
  - name: install <language>
    hosts: localhost
    vars_files:
      - data.yml
    tasks:
      - name: install language
        include_tasks:
          file: ../../library/tasks/install_language.yml
  ```
* `uninstall.yml`
  ```yaml
  - name: uninstall <language>
    hosts: localhost
    vars_files:
      - data.yml
    tasks:
      - name: uninstall language
        include_tasks:
          file: ../../library/tasks/uninstall_language.yml
  ```

## software

The following software installation types are supported:

* [Downloading an archived binary](./library/tasks/download_archived_binary.yml)
* [Downloading an unarchived binary](./library/tasks/download_binary.yml)
* [Running an install script](./library/tasks/run_install_script.yml)
* [Cloning a git repo](./library/tasks/clone_git_repo.yml)
* [Installing an apt package](./library/tasks/install_apt_package.yml)
* [Installing a deb package](./library/tasks/install_deb_package.yml)

Each subdirectory under `./software` contains the playbooks for the software described by the subdirectory name. Each subdirectory should contain the following files:

* `data.yml`
  ```yaml
  # type: <archived binary|unarchived binary|git repo|apt package|deb package|install script>
  name: "<name>"
  # ... remaining fields vary by type
  ```
* `install.yml`
  ```yaml
  - name: install <software>
    hosts: localhost
    vars_files:
      - data.yml
    tasks:
      - name: <task-name>
        include_tasks:
          file: ../../library/tasks/<task-file>.yml
      # ... remaining tasks            
  ```
* `uninstall.yml`
  ```yaml
  - name: uninstall <software>
    hosts: localhost
    vars_files:
      - data.yml
    tasks:
      - name: <task-name>
        include_tasks:
          file: ../../library/tasks/<task-file>.yml
      # ... remaining tasks
  ```
* `README.md`
  ```markdown
  # <software>

  <description>

  ## Installation

  1. Run playbook.

  ```sh
  ansible-playbook install.yml
  ```

  ## Reference

  ## Modifications

  ## Further Reading
  ```

Executables should be persisted to `/opt/managed/{name}/{version}/{binary}` whenever possible, and symlinked to `$/HOME/.local/bin/{binary}`. This obviates the need to add each one to the $PATH environment variable individually. Software available through the default ubuntu repositories listed in the `/etc/apt/sources.list.d/ubuntu.sources` file are managed through the apt package manager.

Playbooks should not typically create or delete configuration files since these are tracked by git. However, playbooks will sometimes add/remove lines from `zshrc` or one of the shell scripts sourced by `~/.profile`.
