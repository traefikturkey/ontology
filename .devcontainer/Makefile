MAKEFILE_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
DEVCONTAINER_ENV := $(realpath $(MAKEFILE_DIR)/.env) 
PARENT_DIR := $(realpath $(MAKEFILE_DIR)../)
PARENT_ENV := $(realpath $(PARENT_DIR)/.env) 
DOTBOT_LINK := $(abspath $(PARENT_DIR)/.dotfiles)
USER := $(or $(USER),$(shell whoami))

# include .devcontainer/.env if present
ifneq (,$(wildcard $(DEVCONTAINER_ENV)))
	include $(DEVCONTAINER_ENV)
	export
endif

# include .env if present
ifneq (,$(wildcard $(PARENT_ENV)))
	include $(PARENT_ENV)
	export
endif

DOTFILES_URL := $(or $(DOTFILES_URL),https://github.com/ilude/dotfiles.git)

.PHONY: ansible dotfiles update-dotfiles echo ownership setup ssh
echo:
	@echo DEVCONTAINER_ENV: $(DEVCONTAINER_ENV)
	@echo PARENT_ENV: $(PARENT_ENV)
	@echo PARENT_DIR: $(PARENT_DIR)
	@echo MAKEFILE_DIR: $(MAKEFILE_DIR)
	@echo VSCODE_DIR: $(VSCODE_DIR)
	@echo VSCODE_SETTINGS_FILE: $(VSCODE_SETTINGS_FILE)
	@echo DOTFILES_URL: $(DOTFILES_URL)
	@echo DOTBOT_LINK: $(DOTBOT_LINK)

setup: ssh dotfiles playbook-repos
	sudo chown -R $(USER):$(USER) $(PARENT_DIR)
	@echo "Makefile Completed..."

ssh:
	ansible-playbook -i .devcontainer/ansible/inventory.yml .devcontainer/ansible/ssh.yml

dotfiles:
	ansible-playbook -i .devcontainer/ansible/inventory.yml .devcontainer/ansible/clone_dotfiles.yml

playbook-repos:
	ansible-playbook -i .devcontainer/ansible/inventory.yml .devcontainer/ansible/clone_playbook_repos.yml

ifeq ($(OS),Windows_NT)
  INITIALIZERS=initialize-windows
else
  INITIALIZERS=initialize-linux
endif

ifneq (, $(shell which pwsh))
	SHELL_COMMAND=pwsh
else ifneq (, $(shell which powershell))
	SHELL_COMMAND=powershell
endif

initialize: $(INITIALIZERS) $(DEVCONTAINER_ENV)

$(DEVCONTAINER_ENV):
	@echo "Creating empty $@ file..."
	touch $@

initialize-windows:
	@echo "Initializing Windows..."
	$(SHELL_COMMAND) -File .devcontainer/setup-ssh-agent.ps1

initialize-linux:
	@echo "Initializing Linux..."
