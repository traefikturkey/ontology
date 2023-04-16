# include .env if present
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

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

${HOME}/.dotfiles/.git: | ${HOME}/.ssh/id_ed25519
	cd ${HOME}/.dotfiles/
	git clone ${DOTFILES_URL} . --recurse-submodules

${HOME}/.ssh/id_ed25519:
ifdef DOPPLER_TOKEN
	doppler secrets get SSH_KEY_PRIV --plain > $@
	touch ${HOME}/.ssh/doppler_used
else ifdef SSH_KEY_PRIV
	echo "${SSH_KEY_PRIV}" > $@
	touch ${HOME}/.ssh/env_used
else
	cp /mnt/.ssh/id_ed25519 $@
	touch ${HOME}/.ssh/mnt_used
endif
	chmod 600 $@

${HOME}/.env: | ${APP}/.devcontainer/.env
	@ln -snf ${APP}/.devcontainer/.env  $@

${HISTFILE}:
	touch $@

${APP}/.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
