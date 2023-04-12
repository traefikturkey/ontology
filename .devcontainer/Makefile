
.PHONY: setup

setup: .devcontainer/.env ${HOME}/.dotfiles
	@echo > /dev/null

${HOME}/.dotfiles:
	@git clone ${DOTFILES_URL} ~/.dotfiles
	@if [ ! -z "$DOTFILES_OVERRIDE_URL" ]; then \
		cd ~/.dotfiles/ && git remote set-url origin $DOTFILES_OVERRIDE_URL; \
	fi
	@rm ~/.gitconfig 
	@~/.dotfiles/install

.devcontainer/.env:
	@echo "$@ is being created..."
	@touch $@
