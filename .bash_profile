# Add perl's bin to path.
export PATH=$PATH:/usr/local/opt/perl/bin

# Add rust to path.
export PATH=$PATH:$HOME/.cargo/bin

# Add flutter, dart and pub to path.
export PATH=$PATH:$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin

# Add composer's bin to path.
export PATH=$PATH:$HOME/.composer/vendor/bin

# Set GOPATH and add its bin to path.
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Explicitly set config dir (e.g. for lazygit).
export XDG_CONFIG_HOME=$HOME/.config

# Preferred editor for local and remote sessions
if [[ $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='hx'
fi

# Set Chrome for flutter.
export CHROME_EXECUTABLE=/Applications/Opera.app/Contents/MacOS/Opera

# Homebrew settings
export HOMEBREW_AUTOREMOVE=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=90
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=14
export HOMEBREW_DISPLAY_INSTALL_TIMES=1
export HOMEBREW_NO_ANALYTICS=1

# Skip this e.g. if sourced from zshrc.
if [[ $SHELL =~ bash ]]; then

    # Load up zoxide.
    command -v zoxide >/dev/null && . <("$_" init bash)

    # Load up broot.
    command -v broot >/dev/null && . <("$_" --print-shell-function bash)

    # Load up shadowenv.
    command -v shadowenv >/dev/null && . <("$_" init bash)

    # Load fzf extensions.
    test -r /usr/share/doc/fzf/examples/key-bindings.bash && . "$_"
    test -r /usr/share/doc/fzf/examples/completion.bash && . "$_"

    # Load bashrc for interactive login-shells.
    test -r ~/.bashrc && . "$_"

fi

# Load everything in .bashrc.d.
for file in ~/.bashrc.d/**/*; do
    [[ $(dirname $file) =~ \.bak$ ]] && continue
    test -r "$file" && . "$_"
done

# Motivation reminder
printf "There are \e[1m%d\e[0m weeks left this year. %s\n"              \
    $(( ($(date -v 12m -v 31d -v 23H +%s) - $(date +%s)) / 86400 / 7 )) \
    "What will you do?"
