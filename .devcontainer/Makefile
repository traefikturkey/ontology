# include .env if present
MAKEFILE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
ifneq (,$(wildcard $(MAKEFILE_DIR).env))
    include $(MAKEFILE_DIR).env
    export
endif

SSH_AGENT_AVAIL := $(shell ssh-add -l > /dev/null 2>&1 | wc -l)

ifdef ANSIBLE_PLAYBOOKS_URL
	AUTOMATIONS := automations
endif

.PHONY: setup automations dotfiles
.ONESHELL: setup ~/.dotfiles/.git 

setup: begin ~/.env dotfiles $(AUTOMATIONS) 
	@echo "Makefile Completed..."

begin:
	@echo "Running $(MAKEFILE_DIR)Makefile..."

automations: | automations/.git
	@echo "Pulling latest $@ changes..."
	@cd $@ && git pull --quiet --rebase --autostash

automations/.git: | ~/.ssh/id_ed25519
	git clone $(ANSIBLE_PLAYBOOKS_URL) automations --recurse-submodules

dotfiles: | ~/.dotfiles/.git
	@echo "Pulling latest ~/.dotfiles changes..."
	@cd ~/.dotfiles/ && git pull --quiet --rebase --autostash
	@echo "Running ~/.dotfiles/install..."
	~/.dotfiles/install
	@ln -snf ~/.dotfiles ${APP}/.dotfiles

~/.dotfiles/.git: | ~/.ssh/id_ed25519
	git clone $(DOTFILES_URL) .dotfiles --recurse-submodules

~/.ssh/id_ed25519:
ifeq ($(shell expr $(SSH_AGENT_AVAIL) \>= 1), 1) 
	echo ssh_agent > ~/.ssh/used
else ifneq (,$(wildcard /mnt/.ssh/id_ed25519))
	cp /mnt/.ssh/id_ed25519 $@
	chmod 600 $@
	echo mnt-id_ed25519 > ~/.ssh/used
else ifneq (,$(wildcard /mnt/.ssh/id_rsa))
	cp /mnt/.ssh/id_ed25519 ~/.ssh/id_rsa
	chmod 600 ~/.ssh/id_rsa
	echo mnt-id_rsa > ~/.ssh/used
else ifdef DOPPLER_TOKEN
	doppler secrets get SSH_KEY_PRIV --plain > $@
	chmod 600 $@
	echo doppler > ~/.ssh/used
else ifdef SSH_KEY_PRIV
	echo ${SSH_KEY_PRIV} > $@
	chmod 600 $@
	echo env > ~/.ssh/used
else
	echo nothing_found > $@
endif

~/.env: | ${APP}/.devcontainer/.env
	@ln -snf ${APP}/.devcontainer/.env  $@

${HISTFILE}:
	touch $@

${APP}/.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
