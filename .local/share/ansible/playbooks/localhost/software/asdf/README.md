# asdf

Extensible language version manager.

## Installation

1. Run playbook.

```sh
    ansible-playbook install.yml
````

## Reference

```
# list installed plugins
asdf list

# add new plugin
asdf plugin add <repo>

# remove plugin
asdf plugin remove <name>

# install version from plugin
asdf install <name> <version>

# set active version in current directory
asdf set <name> <version>

# set active version globally
asdf set -u <name> <version>

# uninstall version
asdf uninstall <name> <version>

# reshim executables
asdf reshim <name> <version>
```

## Modifications

* Creates symlink `~/.local/bin/asdf` to binary in opt directory
* Creates shims in `$XDG_DATA_HOME/asdf/shims`
* Creates `$HOME/.local/share/asdf`
* Updates `$XDG_CONFIG_HOME/env/vars.sh` to add shims directory to `$PATH`

## Further Reading

https://github.com/asdf-vm/asdf
