---
name: install-software
description: Add a new ansible playbook and associated data to the managed software installation framework at $XDG_DATA_HOME/ansible/playbooks/localhost. Use when the user wants to install or manage new software through ansible.
---

# Install Software

## Step 1 — Read the README

Read the "Software" section of `$XDG_DATA_HOME/ansible/playbooks/localhost/README.md` to understand the file structure, supported install types, and their corresponding templates before proceeding.

## Step 2 — Gather information

If the user does not specify an install type, determine the most appropriate type for the requested software. Look up the software's release page or public repo to check if the installation instructions can be mapped to an existing type, or whether a new type may be necessary. Always defer to downloading a pre-built binary if this option is available. If the software can only be obtained through a package manager, check the package repository of the currently installed operating system, e.g. for Ubuntu:

```bash
apt search --names-only <keyword>
```

Once an install type has been selected, look up the `data.yml` template for that type in `$XDG_DATA_HOME/ansible/playbooks/localhost/library/templates`. The template will list the variables required for the installation playbook. Search for other existing `data.yml` files of that type to see analogous configuration examples:

```bash
grep -rl "# type: <type>" $XDG_DATA_HOME/ansible/playbooks/localhost/software 

```

If uncertain about the value of any variable, consult the user.

## Step 3 — Create the subdirectory and files

Create `$XDG_DATA_HOME/ansible/playbooks/localhost/software/<name>/` with the four required files specified in the README, adhering to existing file structure conventions. Facilitate the installation using the tasks in the `$XDG_DATA_HOME/ansible/playbooks/localhost/library/tasks/` directory when possible. Defining new tasks inline within the `install.yml` file is fine for simple changes like editing configuration files, exporting environment variables, re-naming resources, etc. Examine other installation playbooks for the same install type for examples of how these cases can be handled. 

## Step 4 — Confirm

Show the user the contents of each created file and confirm the directory was created at the expected path.
