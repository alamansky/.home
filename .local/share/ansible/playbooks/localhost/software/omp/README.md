# oh-my-posh

Prompt themeing engine.

## Installation

1. Run playbook.

```
ansible-playbook install.yml
````

2. Configure terminal to use Nerd Fonts. For Windows Terminal, copy the font downloaded by the install playbook from `~/.local/share/fonts/meslolgm-nerd-font` to `C:\WINDOWS\Fonts`. This needs to be done "manually" through the Windows control panel due to access restrictions. Then, open the `settings.json` file (accessible through the Windows Terminal settings UI) and set `profiles.defaults` equal to:

```
{
    "font":
    {
        "face": "MesloLGM Nerd Font"
    }
}
```

## Reference


## Modifications

* Installs unzip apt package (dependency)
* Creates $HOME/.local/bin/me/omp
* Modifies $XDG_CONFIG_HOME/zsh/.zshrc

## Further Reading

https://github.com/JanDeDobbeleer/oh-my-posh


