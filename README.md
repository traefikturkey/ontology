# ontology (Neovim branch)

A .devcontainer based environment for using terraform, ansible, kubectl and helm

### Install Devcontainers CLI

`npm install -g @devcontainers/cli`

### Building the DevContainer

Change directory into the git repo and then run:

```bash
devcontainer build --workspace-folder .
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . <command>
```

<command> can be anything you might run on the shell, even a shell itself, like if you want to just shell into the container:

`devcontainer exec --workspace-folder . /bin/zsh`

Or if you want to run Neovim:

`devcontainer exec --workspace-folder . nvim`

### Recommendations

These commands are pretty long, so I recommend creating an alias for at least `devcontainer exec --workspace-folder .`

### Usage on Windows

```ps1
winget install -e --id GnuWin32.Make
winget install -e --id Docker.DockerDesktop
winget install -e --id Microsoft.VisualStudioCode
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
```

## optional overrides in .devcontainer/.env file

```ini
# a git repo for DotBot dotfiles
DOTFILES_URL=git@github.com:ilude/dotfiles.git
# Enable the starship shell prompt
STARSHIP_ENABLED=true
```

## optionally download playbook or other repos from .devcontainer/.playbook_repos

```yaml
# copy this file to .playbook_repos and customize with your playbook repos
repos:
  - url: https://github.com/example/repo1.git
    name: repo1_directory
  - url: https://github.com/example/repo2.git
    # No 'name' specified, will use the default directory name (repo2)
  - url: https://github.com/example/repo3.git
    name: custom_repo3_directory
```
