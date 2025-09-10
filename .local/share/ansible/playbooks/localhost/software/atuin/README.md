# atuin

Shell history aggregator.

## Installation

1. Run playbook.

```sh
    ansible-playbook install.yml
````

## Reference

The up arrow key brings up a searchable shell history.

## Modifications

* Creates symlink `~/.local/bin/atuin` to binary in opt directory
* Creates $XDG_DATA_HOME/atuin
* Updates $XDG_CONFIG_HOME/zsh/.zshrc with initialization

## Further Reading

https://github.com/atuinsh/atuin
