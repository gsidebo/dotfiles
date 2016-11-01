# Init zprezto (prompt/color/etc settings)
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Set path to dev directory where dotfiles directory should exist
export DEVPATH="$HOME/dev"

if [[ -s "$DEVPATH/dotfiles/.zshrc" ]]; then
  source "$DEVPATH/dotfiles/.zshrc"
fi
