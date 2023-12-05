# ontology
A .devcontainer based environment for using terraform, ansible, kubectl and helm

# prereqs
## windows
```
# install chocolatey
Set-ExecutionPolicy remotesigned -force  
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))  

choco install -y docker-desktop
choco pin add -n docker-desktop
choco install -y vscode
choco pin add -n vscode
choco install vscode-remote-development
choco pin add -n vscode-remote-development
```
