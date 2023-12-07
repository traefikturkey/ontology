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

ifdef ANSIBLE_PLAYBOOKS_URL
	AUTOMATIONS := automations
endif

ifneq (bash,$(TERMSHELL))
	SETUP_SHELL=setup_shell
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

ansible:
	ansible-playbook -i .devcontainer/ansible/inventory.yml .devcontainer/ansible/download_playbook_repos.yml

setup: ownership ssh ansible $(AUTOMATIONS) | $(DOTBOT_LINK)
	ansible-playbook -i .devcontainer/ansible/inventory.yml .devcontainer/ansible/download_playbook_repos.yml
	sudo chown -R $(USER):$(USER) $(PARENT_DIR)
	@echo "Makefile Completed..."

ssh:
	@echo "Setting up ~/.ssh..."
	@sudo chown -R $(USER):$(USER) ~/.ssh
	@chmod 700 ~/.ssh
	@chmod 600 ~/.ssh/*
	@echo "Setting up ssh-agent..."
	@ssh-add
	@eval `ssh-agent`

automations: automations/.git
	@echo "Pulling latest $@ changes..."
	@cd $@ && git pull --quiet --rebase --autostash

automations/.git:
	git clone $(ANSIBLE_PLAYBOOKS_URL) automations --recurse-submodules

$(DOTBOT_LINK): dotfiles
	@echo "Creating symlink to $@..."
	@rm -f $@
	@ln -s ~/.dotfiles $@ 

reload-dotfiles:
	symlinks -v ~ | grep .dotfiles | awk '{print $$2}' | xargs rm 
	rm -rf ~/.dotfiles
	ssh-keygen -f ~/.ssh/known_hosts -R github.com
	ssh-keyscan github.com >> ~/.ssh/known_hosts
	ssh-keyscan -H github.com >> ~/.ssh/known_hosts
	make dotfiles

dotfiles: ~/.dotfiles/.git
	@echo "Preparing to load/update ~/.dotfiles from $(DOTFILES_URL)..."
ifneq (,$(DOTFILES_URL))
	@echo "Pulling latest ~/.dotfiles changes..."
	@cd ~/.dotfiles/ && git pull --quiet --rebase --autostash
	@echo "Running ~/.dotfiles/install..."
	~/.dotfiles/install
endif

~/.dotfiles/.git: 
ifneq (,$(DOTFILES_URL))
	git clone $(DOTFILES_URL) ~/.dotfiles --recurse-submodules
else
	@echo "DOTFILES_URL has not been set!"
endif

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
