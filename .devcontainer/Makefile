# include .env if present
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

SSH_AGENT_AVAIL := $(shell ssh-add -l > /dev/null 2>&1 | wc -l)

.PHONY: setup dotfiles
.ONESHELL: ${HOME}/.dotfiles/.git ${HOME}/.dotfiles_initialized

setup: dotfiles ${HISTFILE} 
	@ln -snf ~/.dotfiles ${APP}/.dotfiles

dotfiles: | ${HOME}/.dotfiles_initialized ${HOME}/.env

${HOME}/.dotfiles_initialized: | ${HOME}/.dotfiles/.git
	cd ${HOME}/.dotfiles/
	git pull --rebase --autostash
	~/.dotfiles/install
	date > $@

${HOME}/.dotfiles/.git: | ${HOME}/.ssh/used
	cd ${HOME}/.dotfiles/
	git clone ${DOTFILES_URL} . --recurse-submodules

${HOME}/.ssh/used:
ifdef SSH_AGENT_AVAIL
	echo ssh_agent > $@
else ifneq (,$(wildcard /mnt/.ssh/id_ed25519))
	cp /mnt/.ssh/id_ed25519 ${HOME}/.ssh/id_ed25519
	chmod 600 ${HOME}/.ssh/id_ed25519
	echo mnt-id_ed25519 > $@
else ifneq (,$(wildcard /mnt/.ssh/id_rsa))
	cp /mnt/.ssh/id_ed25519 ${HOME}/.ssh/id_rsa
	chmod 600 ${HOME}/.ssh/id_rsa
	echo mnt-id_rsa > $@
else ifdef DOPPLER_TOKEN
	doppler secrets get SSH_KEY_PRIV --plain > ${HOME}/.ssh/id_ed25519
	chmod 600 ${HOME}/.ssh/id_ed25519
	echo doppler > $@
else ifdef SSH_KEY_PRIV
	echo ${SSH_KEY_PRIV} > ${HOME}/.ssh/id_ed25519
	chmod 600 ${HOME}/.ssh/id_ed25519
	echo env > $@
else
	echo nothing_found > $@
endif
	

${HOME}/.env: | ${APP}/.devcontainer/.env
	@ln -snf ${APP}/.devcontainer/.env  $@

${HISTFILE}:
	touch $@

${APP}/.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
