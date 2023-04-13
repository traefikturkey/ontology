
.PHONY: setup

setup:${HOME}/.dotfiles/.git ${HOME}/.dotfiles_initialized ${APP}/.devcontainer/.env ${HISTFILE}
	@echo > /dev/null

${HOME}/.dotfiles/.git:
	cd ${HOME}/.dotfiles/ && git clone ${DOTFILES_URL} . --recurse-submodules

${HOME}/.dotfiles_initialized:
	cd ${HOME}/.dotfiles/ && git pull --rebase --autostash
	~/.dotfiles/install
	date > $@

${HISTFILE}:
	touch $@

${APP}/.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
