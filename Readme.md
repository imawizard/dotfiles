My dotfiles are stored in the iCloud and symlinked with stow.

```sh
# To unstow
pushd "$ICLOUD_DRIVE/dotfiles" # folder containing .stowrc
find . -type d -depth 1 -not -name '.*' -exec basename {} \; | xargs stow
popd
```

Included configs:
- [bash_aliases](bash/.bash_aliases)
- [tmux.conf](tmux/.tmux.conf)
- [vimrc](vim/.vimrc)
- [ideavimrc](vim/.ideavimrc)

### Software used/referenced

```sh
INSTALL_FORMULA() { HOMEBREW_NO_AUTO_UPDATE=1 command brew install --formula $@ }
INSTALL_CASK() { HOMEBREW_NO_AUTO_UPDATE=1 command brew install --cask $@ }

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
INSTALL_FORMULA ${FORMULAE[@]} || { echo "Formulae failed!" && exit 1; }
INSTALL_FORMULA --HEAD universal-ctags/universal-ctags/universal-ctags

CASKS=(
    opera
    qlstephen
)
INSTALL_CASK ${CASKS[@]} || { echo "Casks failed!" && exit 1; }

FONTS=(
    font-fira-code-nerd-font
)
brew tap homebrew/cask-fonts
INSTALL_CASK ${FONTS[@]} || { echo "Fonts failed!" && exit 1; }
```

