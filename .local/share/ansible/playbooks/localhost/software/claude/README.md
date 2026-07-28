# claude

AI agent.

## Installation

1. Run playbook.

```
ansible-playbook install.yml
````

2. Run claude to finish setup

```
claude
```

## Reference


## Modifications

Claude has only partial XDG support, so a `.claude` hidden dir in the home directory is inevitable (for now). Tracked on https://github.com/anthropics/claude-code/issues/1455.

* Creates $HOME/.claude
* Creates $XDG_CONFIG_HOME/claude
* Creates $HOME/.local/bin/claude -> $HOME/.local/share/claude/versions/{current}
* Modifies $XDG_CONFIG_HOME/zsh/.zshrc
* Creates $CLAUDE_CONFIG_DIR environment variable

## Further Reading

https://github.com/anthropics/claude-code
https://code.claude.com/docs/en/quickstart


