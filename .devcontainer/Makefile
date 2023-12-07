MAKEFILE_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
PARENT_DIR := $(realpath $(MAKEFILE_DIR)../)
DOTBOT_LINK := $(abspath $(PARENT_DIR)/.dotfiles)
ENV_FILE := $(realpath $(PARENT_DIR)/.env) 
USER := $(or $(USER),$(shell whoami))
DATE := $(shell TZ=America/New_York date '+%Y-%m-%d-%H.%M.%S')

# include .env if present
ifneq (,$(wildcard $(ENV_FILE)))
	include $(ENV_FILE)
	export
endif

ifdef ANSIBLE_PLAYBOOKS_URL
	AUTOMATIONS := automations
endif

DOTFILES_URL := $(or $(DOTFILES_URL),https://github.com/ilude/dotfiles.git)

.PHONY: dotfiles update-dotfiles echo ownership setup ssh
echo:
	@echo ENV_FILE: $(ENV_FILE)
	@echo PARENT_DIR: $(PARENT_DIR)
	@echo MAKEFILE_DIR: $(MAKEFILE_DIR)
	@echo VSCODE_DIR: $(VSCODE_DIR)
	@echo VSCODE_SETTINGS_FILE: $(VSCODE_SETTINGS_FILE)
	@echo DOTFILES_URL: $(DOTFILES_URL)
	@echo DOTBOT_LINK: $(DOTBOT_LINK)

setup: ownership $(ENV_FILE) ssh $(DOTBOT_LINK) $(AUTOMATIONS)
#@git config -l | grep -silent 'safe.directory=*' || git config --global --add safe.directory '*'
	@echo "Makefile Completed..."

ownership:	
	sudo chown -R $(USER):$(USER) $(PARENT_DIR)

$(ENV_FILE):
	@echo "Creating empty $@ file..."
	touch $@

ssh:
	@echo "Setting up ~/.ssh..."
	@sudo chown -R $(USER):$(USER) ~/.ssh
	@chmod 700 ~/.ssh
	@chmod 600 ~/.ssh/*
	@echo "Setting up ssh-agent..."
	@ssh-add
	@eval `ssh-agent`

automations: 
	@echo "Pulling latest $@ changes..."
	@cd $@ && git pull --quiet --rebase --autostash

automations/.git: | ~/.ssh/id_ed25519
	git clone $(ANSIBLE_PLAYBOOKS_URL) automations --recurse-submodules

$(DOTBOT_LINK): dotfiles
	@echo "Creating symlink to $(DOTBOT_LINK)..."
	@ln -s ~/.dotfiles $(DOTBOT_LINK) 

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

initialize: $(INITIALIZERS)

initialize-windows:
	@echo "Initializing Windows..."
	$(SHELL_COMMAND) -File .devcontainer/setup-ssh-agent.ps1

initialize-linux:
	@echo "Initializing Linux..."
