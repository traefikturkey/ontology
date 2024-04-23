# ontology
A .devcontainer based environment for using terraform, ansible, kubectl and helm

# prereqs
## windows
```
winget install -e --id GnuWin32.Make
winget install -e --id Docker.DockerDesktop
winget install -e --id Microsoft.VisualStudioCode
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
```

## optional overrides in .devcontainer/.env file
```
# a git repo for DotBot dotfiles
DOTFILES_URL=git@github.com:ilude/dotfiles.git
```

## optionally download playbook or other repos from .devcontainer/.playbook_repos
```
# copy this file to .playbook_repos and customize with your playbook repos
repos:
  - url: https://github.com/example/repo1.git
    name: repo1_directory
  - url: https://github.com/example/repo2.git
    # No 'name' specified, will use the default directory name (repo2)
  - url: https://github.com/example/repo3.git
    name: custom_repo3_directory
```