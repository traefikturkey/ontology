
.PHONY: setup

setup: .devcontainer/.env ${HOME}/.dotfiles
	@echo > /dev/null

${HOME}/.dotfiles:
	@git clone ${DOTFILES_URL} ~/.dotfiles --recurse-submodules
	@~/.dotfiles/install
	ln -s ~/.dotfiles .dotfiles
	ln -s ~/ .home

.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
