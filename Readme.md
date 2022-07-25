# Dotfiles
Residing in the iCloud ⛅ and symlinked with stow 📦

## Installation
To clone and apply them non-destructively (only if the destination doesn't exist
a symlink is created) run these commands:

```sh
cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs"
git clone https://github.com/imawizard/dotfiles iaw-dotfiles
cd iaw-dotfiles
find . -type d -depth 1 -not -name ".*" -and -not -name "*.nostow" -exec basename {} \; | xargs stow
```

## Required tools
To install the software used by within the configs or is otherwise necessary,
you can run this shell script:

```sh
FORMULAE=(
    archey
    bat
    fd
    fzf
    git
    go
    httpie
    lua
    node
    nvim
    perl
    python
    ripgrep
    rustup-init
    stow
    tmux
    trash
    tree
    watch
    wget
    youtube-dl
    z
)

CASKS=(
    opera
    qlstephen
)

FONTS=(
    font-fira-code-nerd-font
)

brew tap homebrew/cask-versions # for nightly
brew tap homebrew/cask-fonts

INSTALL_FORMULA() { HOMEBREW_NO_AUTO_UPDATE=1 command brew install --formula $@ }
INSTALL_FORMULA ${FORMULAE[@]} || { echo "Formulae failed!" && exit 1; }
INSTALL_FORMULA --HEAD universal-ctags/universal-ctags/universal-ctags
INSTALL_FORMULA railwaycat/emacsmacport/emacs-mac --with-emacs-big-sur-icon #--with-mac-metal

INSTALL_CASK() { HOMEBREW_NO_AUTO_UPDATE=1 command brew install --cask $@ }
INSTALL_CASK ${CASKS[@]} || { echo "Casks failed!" && exit 1; }
INSTALL_CASK ${FONTS[@]} || { echo "Fonts failed!" && exit 1; }

# oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
	RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# flutter
if [[ ! -e ~/flutter ]]; then
	wget -O ~/dl.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.2.3-stable.zip
	unzip -d ~ ~/dl.zip >/dev/null
	rm -f ~/dl.zip
fi

[[ -f ~/flutter/bin/flutter ]] && ~/flutter/bin/flutter config --no-analytics
[[ -f ~/flutter/bin/dart ]] && ~/flutter/bin/dart --disable-analytics

# vim
if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
[[ ! -e ~/.vim/swap ]] && mkdir ~/.vim/swap
[[ ! -e ~/.vim/undo ]] && mkdir ~/.vim/undo
vim -c 'PlugInstall' +qa

# tmux
if [[ $(brew ls --versions tmux) ]]; then
	if [[ ! -e ~/.tmux/plugins/tpm ]]; then
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	fi
	~/.tmux/plugins/tpm/bin/install_plugins
fi

# Doom emacs
if [[ $(brew ls --versions emacs-mac) ]]; then
	if [[ ! -e ~/.emacs.d ]]; then
		git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
		~/.emacs.d/bin/doom install
	else
		~/.emacs.d/bin/doom sync
	fi
	if [[ ! -e /Applications/Emacs.app ]]; then
		ln -s /usr/local/opt/emacs-mac/Emacs.app /Applications
	fi
fi
```

## Resources
### Dotfiles
- [disrupted / Salomon Popp](https://github.com/disrupted/dotfiles)
- [endocrimes / Danielle](https://github.com/endocrimes/dotfiles)
- [fasterthanlime / Amos Wenger](https://github.com/fasterthanlime/dotfiles)
- [FooSoft / Alexei Yatskov](https://github.com/FooSoft/dotvim)
- [jonhoo / Jon Gjengset](https://github.com/jonhoo/configs)
- [kalkayan / Manish Sahani](https://github.com/kalkayan/dotfiles)
- [koekeishiya / Åsmund Vikane](https://github.com/koekeishiya/dotfiles)
- [L3MON4D3](https://github.com/L3MON4D3/Dotfiles)
- [Lukas Reineke](https://github.com/lukas-reineke/dotfiles)
- [simnalamburt / Hyeon Kim](https://github.com/simnalamburt/.dotfiles)
- [thoughtbot, inc.](https://github.com/thoughtbot/dotfiles)
- [Tim Untersberger](https://github.com/TimUntersberger/dotfiles)
- [VonHeikemen / Heiker](https://github.com/VonHeikemen/dotfiles)
- [Wil Thomason](https://github.com/wbthomason/dotfiles)
### Neovim config
- [fannheyward / Heyward Fann](https://github.com/fannheyward/init.vim)
- [glepnir / Raphael](https://github.com/glepnir/nvim)
- [Joel Palmer](https://gist.github.com/joelpalmer/9db3f1cdfd463daa6d7c614ae1618fa6)
- [kyazdani42 / Kiyan](https://github.com/kyazdani42/nvim-config)
- [lervag / Karl Yngve Lervåg](https://github.com/lervag/dotvim)
- [Tim Untersberger](https://github.com/TimUntersberger/neovim.config)
### Emacs config
- [Will Crichton](https://github.com/willcrichton/dotfiles)
### Using stow
- [Managing Dotfiles with GNU Stow (2016) - Hacker News](https://news.ycombinator.com/item?id=27137172)
- [Using GNU Stow to manage your dotfiles (2012) - Hacker News](https://news.ycombinator.com/item?id=25549462)
- [Managing dotfiles with GNU Stow - Hacker News](https://news.ycombinator.com/item?id=11515222)
