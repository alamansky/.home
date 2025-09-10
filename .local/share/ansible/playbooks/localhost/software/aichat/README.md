# aichat

TUI wrapper for LLMs. The ansible playbook and this README assume Groq will be used with a pre-provisioned API key, which can be created through the free developer tier at https://console.groq.com/keys.

## Installation

1. Run playbook. Vault password is required to decrypt Groq API key.

```sh
    ansible-playbook --vault-password-file=~/.vault install.yml
```

2. Echo env var to confirm API key was decrypted.

```sh
    echo $GROQ_API_KEY
```

3. Run aichat. If no config file is detected, the following prompts are displayed to create one:

* Platform: (choose `groq`)
* API Key: (enter key value echoed above)

4. If the given platform does not have a default model (or if the default is out of date), add the model explicitly to the config at `$XDG_CONFIG_HOME/aichat/config.yaml`.

```sh
    model: groq:llama-3.3-70b-versatile
```

## Reference

## Modifications

* Creates symlink `~/.local/bin/aichat` to binary in opt directory
* Creates config file at `$XDG_CONFIG_HOME/aichat/config.yaml`
* Adds `$GROQ_API_KEY` env var to `$XDG_CONFIG_HOME/env/vars.sh`

## Further Reading

https://github.com/sigoden/aichat
