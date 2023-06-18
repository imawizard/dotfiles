#!/bin/bash
#shellcheck disable=SC2091,SC2155,SC2215,SC2288,SC2317

set -euo pipefail

# Check for oh-my-zsh, install if we don't have it.
if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing oh-my-zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install software and tools .............................................{{{1

latest() { echo "${3:-%2}" | sed -e "s|%1|$1|" -e "s|%2|$( \
    git ls-remote --tags --refs --sort="version:refname" "https://$1" \
    | cut -f2 \
    | cut -d/ -f3 \
    | grep -E "^v?${2:-}" \
    | tail -n1)|"; }
cargo_latest() { latest "$1" "${2:-}" '--git https://%1 --tag %2'; }

# Install rustup and rust toolchain.
if [[ ! $(command -v rustup) ]]; then
    if [[ $(command -v rustup-init) ]]; then
        rustup-init --default-toolchain stable --no-modify-path -y
    else
        curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- --default-toolchain stable --no-modify-path -y
    fi
fi

# Install mise.
cargo install --locked mise
command -v mise >/dev/null || { echo "mise wasn't found in PATH"; exit 1; }

# Install zsh plugins.
for repo in \
    github.com/Aloxaf/fzf-tab \
    github.com/zdharma-continuum/fast-syntax-highlighting \
    github.com/zsh-users/zsh-autosuggestions \
    github.com/zsh-users/zsh-syntax-highlighting \
; do
    test ! -e ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${repo##*/} && \
        git clone https://$repo "$_" || \
        git -C "$_" pull --rebase
done

# Install carapace.
if [[ ! $(command -v carapace) ]]; then
    kern="$(uname -s)"
    arch="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')"
    wget https://github.com/rsteube/carapace-bin/releases/download/v0.28.3/carapace-bin_${kern}_${arch}.tar.gz -O ~/dl.tar.gz && \
        tar -xzf "$_" && \
        rm -f "$_" && \
        mv carapace ~/.go/bin/ && \
        rm -f README.md LICENSE
fi

# Install various tools and packages and everything in ~/.tool-versions.
cmd="echo"; can=true
perl -nlE 'say if (/^# --Tools/.../^# --/) && !/^# --/' "$0" \
| while read -r line; do
    if [[ $line =~ ^\$\  ]]; then
        cmd="${line##*$ }"
        can=$(command -v "$(echo "$cmd" | cut -d' ' -f1)" || true)
    elif [[ $can ]]; then
        line=$(eval "echo $line")
        [[ $line ]] || continue
        echo -e "\033[7m\$ $cmd $line\033[0m"
        $cmd $line
    fi
done

# Install plug.vim and vim plugins.
if [[ $(command -v vim) ]]; then
    test ! -e ~/.vim/swap && mkdir "$_"
    test ! -e ~/.vim/undo && mkdir "$_"
    test ! -e ~/.vim/autoload/plug.vim && \
        curl -fLo "$_" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qa
fi

# Install packer, hotpot and neovim plugins.
if [[ $(command -v nvim) ]]; then
    test ! -e ~/.vim/swap && mkdir "$_"
    test ! -e ~/.vim/undo && mkdir "$_"
    test ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim && \
        git clone https://github.com/wbthomason/packer.nvim "$_" || \
        git -C "$_" pull --rebase
    test ! -e ~/.local/share/nvim/site/pack/packer/start/hotpot.nvim && \
        git clone https://github.com/rktjmp/hotpot.nvim "$_" || \
        git -C "$_" pull --rebase
    nvim --headless -c 'TSUpdateSync' +qa
    nvim --headless -c 'TSInstallSync all' +qa
    nvim --headless -c 'autocmd User PackerComplete qa' +PackerSync
fi

# Install tpm and tmux plugins.
if [[ $(command -v tmux) ]]; then
    test ! -e ~/.tmux/plugins/tpm && \
        git clone https://github.com/tmux-plugins/tpm "$_" || \
        git -C "$_" pull --rebase
    test -x ~/.tmux/plugins/tpm/bin/install_plugins && "$_"
fi

# Link helix' runtime.
if ! test -e ~/.config/helix/runtime || test -L "$_"; then
    test -L "$_" && rm "$_"
    ln -s "$(ls -d -1 -t ~/.cargo/git/checkouts/helix-????????????????/* | head -n 1)/runtime" "$_"
fi

# .........................................................................}}}

echo
echo "Done"
exit

# --Tools ................................................................{{{1

$ mise
    install -y

$ eval
    $(mise env)

$ cargo install --locked
    $(cargo_latest github.com/Shopify/shadowenv 2.1)
    --git https://github.com/helix-editor/helix helix-term
    $(cargo_latest github.com/latex-lsp/texlab 5.12) # texlab on crates.io is outdated
    amber      # --git https://github.com/dalance/amber
    bat        # --git https://github.com/sharkdp/bat
    broot      # --git https://github.com/Canop/broot
    du-dust    # --git https://github.com/bootandy/dust
    evcxr_repl # --git https://github.com/evcxr/evcxr evcxr_repl
    eza        # --git https://github.com/eza-community/eza
    git-delta  # --git https://github.com/dandavison/delta
    hyperfine  # --git https://github.com/sharkdp/hyperfine
    macchina   # --git https://github.com/Macchina-CLI/macchina
    ripgrep    # --git https://github.com/BurntSushi/ripgrep
    stylua     # --git https://github.com/JohnnyMorganz/StyLua
    tokei      # --git https://github.com/XAMPPRocky/tokei tokei
    zoxide     # --git https://github.com/ajeetdsouza/zoxide
    #exa       # --git https://github.com/ogham/exa
    #fd-find   # --git https://github.com/sharkdp/fd
    #mcfly     # --git https://github.com/cantino/mcfly
    #ren-find  # --git https://github.com/robenkleene/ren-find
    #rep-grep  # --git https://github.com/robenkleene/rep-grep
    #starship  # --git https://github.com/starship/starship
    #cargo-audit
    #cargo-c
    #cargo-docset
    #cargo-duplicates
    #cargo-edit
    #cargo-expand
    #cargo-make
    #cargo-outdated
    #cargo-watch
    #simple-http-server

$ composer global require
    #friendsofphp/php-cs-fixer
    #phpactor/phpactor
    #phploc/phploc
    #phpmd/phpmd
    #phpstan/phpstan
    #sebastian/phpcpd
    #squizlabs/php_codesniffer

$ cpanm
    Perl::Critic
    Perl::Tidy
    PLS
    --notest Neovim::Ext
    #Perl::LanguageServer

$ dart pub global activate
    webdev
    #dart_ctags

$ gem install
    asciidoctor
    #bundler
    #filewatcher
    #neovim-ruby-host
    #xcpretty

$ go install
    github.com/antonmedv/fx@latest
    github.com/charmbracelet/glow@latest
    github.com/cweill/gotests/gotests@latest
    github.com/derailed/k9s@latest
    github.com/editorconfig-checker/editorconfig-checker/v2/cmd/editorconfig-checker@latest
    github.com/fatih/gomodifytags@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    github.com/hashicorp/terraform-ls@latest
    github.com/jesseduffield/lazydocker@latest
    github.com/jesseduffield/lazygit@latest
    github.com/mattn/efm-langserver@latest
    github.com/mgechev/revive@latest
    github.com/rclone/rclone@latest
    github.com/segmentio/golines@latest
    github.com/sqls-server/sqls@master # latest tag has old go.mod
    github.com/stern/stern@latest
    github.com/terraform-docs/terraform-docs@latest
    github.com/terraform-linters/tflint@latest
    golang.org/x/tools/gopls@latest
    honnef.co/go/tools/cmd/staticcheck@latest
    mvdan.cc/gofumpt@latest
    mvdan.cc/sh/v3/cmd/shfmt@latest
    #github.com/caddyserver/caddy@latest
    #github.com/candid82/joker@latest # needs go generate
    #github.com/josharian/impl@latest
    #github.com/junegunn/fzf@latest # install with mise
    #github.com/magefile/mage@latest
    #github.com/rclone/rclone@latest
    #github.com/restic/restic@latest
    #github.com/rsteube/carapace-bin@latest # doesn't work because of replace-directive
    #github.com/technosophos/dashing@latest
    #github.com/x-motemen/ghq@latest

$ luarocks --local install
    fennel
    luacheck

$ npm install --global
    npm
    bash-language-server
    dot-language-server
    fixjson
    neovim
    perlnavigator-server
    sql-formatter
    sql-language-server
    vim-language-server
    vscode-langservers-extracted
    yaml-language-server
    #cloc
    #marked

$ python -m pip install --upgrade
    pip
    #ipython
    #pygments                        # for ccat
    #six                             # for lldb
    #virtualenv
    #virtualenvwrapper

$ python3 -m pip install --upgrade
    pip
    asciinema
    cookiecutter
    hy
    pre-commit
    pynvim
    vim-vint
    yamllint
    youtube-dl
    #httpie
    #markdown
    #neovim-remote
    #virtualenv
    #virtualenvwrapper

$ rustup component add
    clippy
    rust-analyzer
    rust-src
    #llvm-tools-preview

# .........................................................................}}}
