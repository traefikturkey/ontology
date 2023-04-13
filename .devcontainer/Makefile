
.PHONY: setup

setup: ${HOME}/.dotfiles ${APP}/.devcontainer/.env
	@echo > /dev/null

${HOME}/.dotfiles:
	git clone ${DOTFILES_URL} ${HOME}/.dotfiles 
	~/.dotfiles/install

${APP}/.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
