#!/bin/bash

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='exa -l'
alias la='exa -la'
alias cat='bat'
alias watch='watch --color'
alias archey='archey --color --offline'

# Commands ...............................................................{{{1

# Display size of folders and files.
ds() {
    du -sh $1
}

# Display apparent size of folders and files.
das() {
    local dir=${1:-.}
    find "$dir" -type f -exec ls -lnq {} \+ | awk '
        function pp(v) {
            n = split("B K M G T P E", unit, " ");
            for (i = 1; i < n-1; i++) {
                if (v < 1024) {
                    break;
                }
                v /= 1024;
            }
            printf("%.3f%s\t'$dir'\n", v, unit[i]);
        }

        BEGIN { sum = 0 }
        { sum += $5 }
        END { pp(sum) }'
}

# Like base64 for hex.
hex() {
    if [[ $1 == "--help" ]]; then
        echo "usages:"
        echo "  hex filename"
        echo "  echo \"abc\" | hex"
        return 1
    fi
    xxd -p $@ | tr -d "\n" && echo
}

# Like md5 for sha1.
sha1() {
    if [[ $1 == "--help" ]]; then
        echo "usages:"
        echo "  sha1 filename"
        echo "  echo \"abc\" | sha1"
        return 1
    fi
    shasum -a 1 $@
}

# Like md5 for sha256.
sha256() {
    if [[ $1 == "--help" ]]; then
        echo "usages:"
        echo "  sha256 filename"
        echo "  echo \"abc\" | sha256"
        return 1
    fi
    shasum -a 256 $@
}

# Like md5 for sha512.
sha512() {
    if [[ $1 == "--help" ]]; then
        echo "usages:"
        echo "  sha512 filename"
        echo "  echo \"abc\" | sha512"
        return 1
    fi
    shasum -a 512 $@
}

# Outputs random bytes.
rand() {
    local mode
    local showusage=false
    if [[ $# -gt 1 ]]; then
        case $1 in
        hex|base64)
            mode="-$1"
            shift
            ;;
        *)
            showusage=true
            ;;
        esac
    fi
    if [[ ! $1 =~ ^[0-9]+$ ]]; then
        showusage=true
    fi
    if $showusage; then
        echo "usage: rand [hex|base64] num"
        return 1
    fi
    openssl rand $mode $1
}

# Recursively reset directory and file modes.
resetmod() {
    echo "Do you want to recursivly reset modes for '$(pwd)' (y/N)?"
    read
    [[ $REPLY != "y" && $REPLY != "Y" ]] && return
    find . -type d -exec chmod 0755 {} \;
    find . -type f -exec chmod 0644 {} \;
}

# lazygit macro
lg() {
    export LAZYGIT_NEW_DIR_FILE=$XDG_CONFIG_HOME/lazygit/newdir

    lazygit "$@"

    if [[ -r $LAZYGIT_NEW_DIR_FILE ]]; then
        cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
        rm -f "$LAZYGIT_NEW_DIR_FILE" >/dev/null
    fi
}

# Use rg interactively in fzf
if [[ $(fzf --version) < 0.30 ]]; then
    rfv() {
        RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
        INITIAL_QUERY="${*:-}"
        IFS=: read -ra selected < <(
        FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")"                                    \
        fzf --ansi                                                                                        \
            --color "hl:-1:underline,hl+:-1:underline:reverse"                                            \
            --disabled --query "$INITIAL_QUERY"                                                           \
            --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true"                                      \
            --bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf> )+enable-search+clear-query" \
            --prompt '1. ripgrep> '                                                                       \
            --delimiter :                                                                                 \
            --preview 'bat --color=always {1} --highlight-line {2}'                                       \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
        )
        [[ ${selected[0]} ]] && $EDITOR "${selected[0]}" "+${selected[1]}"
    }
elif [[ $(fzf --version) < 0.38 ]]; then
    rfv() {
        rm -f /tmp/rg-fzf-{r,f}
        RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
        INITIAL_QUERY="${*:-}"
        IFS=: read -ra selected < <(
            FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")"                                                                                                                                  \
            fzf --ansi                                                                                                                                                                                      \
                --color "hl:-1:underline,hl+:-1:underline:reverse"                                                                                                                                          \
                --disabled --query "$INITIAL_QUERY"                                                                                                                                                         \
                --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true"                                                                                                                                    \
                --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)"                                     \
                --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
                --bind "start:unbind(ctrl-r)"                                                                                                                                                               \
                --prompt '1. ripgrep> '                                                                                                                                                                     \
                --delimiter :                                                                                                                                                                               \
                --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱'                                                                                                                                    \
                --preview 'bat --color=always {1} --highlight-line {2}'                                                                                                                                     \
                --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
        )
        [[ ${selected[0]} ]] && $EDITOR "${selected[0]}" "+${selected[1]}"
    }
else
    rfv() {
        rm -f /tmp/rg-fzf-{r,f}
        RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
        INITIAL_QUERY="${*:-}"
        FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")"                                                                                                                                  \
        fzf --ansi                                                                                                                                                                                      \
            --color "hl:-1:underline,hl+:-1:underline:reverse"                                                                                                                                          \
            --disabled --query "$INITIAL_QUERY"                                                                                                                                                         \
            --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true"                                                                                                                                    \
            --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)"                                     \
            --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
            --bind "start:unbind(ctrl-r)"                                                                                                                                                               \
            --prompt '1. ripgrep> '                                                                                                                                                                     \
            --delimiter :                                                                                                                                                                               \
            --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱'                                                                                                                                    \
            --preview 'bat --color=always {1} --highlight-line {2}'                                                                                                                                     \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'                                                                                                                                         \
            --bind 'enter:become($EDITOR {1} +{2})'
    }
fi

# System .................................................................{{{1

# Disable standby.
up() {
    if [[ $1 == "--help" ]]; then
        echo "usage: up [minutes]"
        return 1
    fi
    local mins=$(( 4 * 60 ))
    if [[ $1 ]]; then
        mins=$(( $1 ))
    fi
    local secs=$(( mins * 60 ))
    if ! pgrep -x "caffeinate" >/dev/null; then
        nohup caffeinate -du -t $secs >/dev/null 2>&1 &
        echo "Staying awake..."
    else
        echo "Already staying awake."
    fi
}

# Enable it again.
down() {
    if pgrep -x "caffeinate" >/dev/null; then
        killall caffeinate
        echo "Able to sleep again."
    else
        echo "Already able to sleep."
    fi
}

# Disable sleep when closing the lid.
alias clamshell_sleep_off='sudo pmset -a disablesleep 1'
alias clamshell_sleep_on='sudo pmset -a disablesleep 0'

# Remove the red circle indicating there's an OS update.
hide_os_update() {
    defaults delete com.apple.preferences.softwareupdate LatestMajorOSSeenByUserBundleIdentifier
    softwareupdate --list
}

# Start an unthrottled TimeMachine backup.
do_timemachine_backup() {
    if [[ $(sysctl debug.lowpri_throttle_enabled | grep ': 1') ]]; then
        sudo sysctl debug.lowpri_throttle_enabled=0
    fi
    tmutil startbackup
}

# Look in current dir for iCloud files to download.
icloud_download() {
    find . -name '*.icloud' -exec brctl download {} \; -print
}

# Try to remove all local iCloud copies in current dir.
icloud_evict() {
    find . -not -name '*.icloud' -exec brctl evict {} \; -print
}

# Restart iCloud Drive daemon.
killicloud() {
    local force_full_resync=false
    killall bird
    if $force_full_resync; then
        trash "~/Library/Application Support/CloudDocs"
    fi
}

# Kill FaceTime's popup-window (or try 'Do Not Disturb').
killft() {
    killall FaceTimeNotificationCenterService
}

# Compare system preferences.
diffprefs() {
    test -e prefs-new.txt && mv -f "$_" prefs-old.txt
    defaults read >prefs-new.txt
    test -e prefs-old.txt && diff "$_" prefs-new.txt
}

# List all registered UTI handlers.
listutis() {
    local filepath="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
    local utis=$($filepath -dump | grep '^uti:' | awk '{ print $2 }' | sort | uniq)
    if [[ $(command -v duti) ]]; then
        while read -r uti; do
            local hndlr=$(duti -d $uti 2>/dev/null)
            [[ $hndlr ]] && echo "$uti -> $hndlr"
        done <<< "$utis"
    else
        echo "$utis"
    fi
}

# List all extensions with handlers.
listexts() {
    local filepath="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
    local exts=$($filepath -dump | grep '^bindings:' | perl -nle 'print s/^\.|,$//gr for grep /^\./, split " "' | sort | uniq)
    if [[ $(command -v duti) ]]; then
        while read -r ext; do
            local hndlr=$(duti -x $ext 2>/dev/null | perl -ne 'print if /^\//')
            [[ $hndlr ]] && echo "$ext -> $hndlr"
        done <<< "$exts"
    else
        echo "$exts"
    fi
}

# Prog-macros ............................................................{{{1

# Open Finder with z.
zz() {
    _z $@ && ofd && popd >/dev/null
}

# Read cht.sh.
cht() {
    if [[ $1 == "--help" || $# -lt 1 ]]; then
        echo "usage: cht topic [-c] [query]"
        return 1
    fi
    local topic="$1"
    shift
    local opts='\?Q'
    if [[ $1 == "-c" ]]; then
        opts=""
        shift
    fi
    local query="${*// /+}"
    [[ $query ]] && query="/$query"
    local out="$(echo cht.sh/$topic$query$opts | xargs curl 2>/dev/null)"
    if [[ ! $out ]]; then
        echo cht.sh/$topic$query | xargs curl
    else
        echo $out
    fi
}

# Download videos from youtube.
ytdl() {
    local id
    for id in $*[@]; do
        youtube-dl -x --audio-quality 0 --audio-format mp3 --embed-thumbnail --metadata-from-title "(?P<artist>.+?) - (?P<title>[^\(]+)" "$id"
    done
}

# Focus a pane running a specified command.
tmux_focus() {
    if [[ ! $TMUX ]]; then
        return
    fi
    if [[ $1 == "--help" || $# -lt 1 ]]; then
        echo "usage: tmux_focus prog-name"
        return 1
    fi
    local id="$(tmux list-panes -a -F '#{pane_current_command} #{window_id} #{pane_id}' | awk '/^'$1' / {print $2" "$3; exit}')"
    local window_id="$id[(w)1]"
    local pane_id="$id[(w)2]"
    [[ $pane_id ]] && tmux select-window -t "$window_id" && tmux select-pane -t "$pane_id"
}

# Register a filetype with QLStephen.
ft2ql() {
    [[ $1 == "--help" || $# == 0 || ! -f $1 ]] && { echo "Usage: ft2ql filename.ext"; return 1; }
    local ft=$(mdls -name kMDItemContentType $1 | sed -n 's/^kMDItemContentType = \"\(.*\)\"$/\1/p')
    local plist=~/Library/QuickLook/QLStephen.qlgenerator/Contents/Info.plist
    if [[ ! $(cat $plist | grep $ft) ]]; then
        plutil -insert CFBundleDocumentTypes.0.LSItemContentTypes.0 -string $ft $plist
        qlmanage -r
        echo "Added filetype '$ft' to QLStephen."
    fi
}

# Show all brew formulae with their dependencies.
brewdeps() {
    brew list | while read form; do
        echo -n "$form ->"
        brew deps $form | awk '{ printf(" %s ", $0) }'
        echo ""
    done
}

# Maintenance ............................................................{{{1

# Update system.
upgrade() {
    local t=$(date +%s)

    echo " \e[30;1m[\e[35;1m•\e[30;1m]\e[32m brew\e[0m"
    upgrade_brew
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m oh-my-zsh\e[0m"
    upgrade_oh_my_zsh
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m tmux plugins\e[0m"
    upgrade_tmux
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m vim plugins\e[0m"
    upgrade_vim
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m nvim plugins\e[0m"
    upgrade_nvim
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m doom emacs\e[0m"
    upgrade_doom
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m rust\e[0m"
    upgrade_rust
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m flutter\e[0m"
    upgrade_flutter
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m dart\e[0m"
    upgrade_dart

    local took=$(($(date +%s) - $t))
    if [[ $took -gt 59 ]]; then
        local mins=$(($took / 60))
        local secs=$(($took % 60))
        printf "Done, upgraded in %dm%02ds.\n" $mins $secs
    else
        echo "Done, upgraded in ${took}s."
    fi
}

# Update brew and software.
upgrade_brew() {
    brew update

    # Possibly filter progs not to update.
    brew outdated --formula | perl -alE 'say $F[0] unless /^(sshfs|gocryptfs)/' | xargs brew upgrade
    brew outdated --cask | perl -alE 'say $F[0] unless /^prog-to-ignore/' | xargs brew upgrade --cask

    brew cleanup -s
}

# Update oh my zsh.
upgrade_oh_my_zsh() {
    [[ $(command -v omz) ]] || return 1

    omz update --unattended
}

# Update tmux plugins.
upgrade_tmux() {
    [[ $(command -v tmux) ]] || return 1

    test -x ~/.tmux/plugins/tpm/bin/update_plugins && "$_" all
}

# Update vim plugins.
upgrade_vim() {
    [[ $(command -v vim) ]] || return 1

    vim -c 'PlugUpgrade | PlugUpdate' +qa
}

# Update nvim plugins.
upgrade_nvim() {
    [[ $(command -v nvim) ]] || return 1

    nvim --headless -c 'autocmd User PackerComplete qa' +PackerSync
}

# Update doom emacs.
upgrade_doom() {
    [[ $(command -v doom) ]] || return 1

    doom upgrade
    doom purge
}

# Update rust.
upgrade_rust() {
    [[ $(command -v rustup) ]] || return 1

    rustup update
}

# Update flutter and flutter docs.
upgrade_flutter() {
    [[ $(command -v flutter) ]] || return 1

    # update flutter
    flutter upgrade --force
    flutter config --no-analytics

    # update docset
    local download=false
    local docset=$(http --body --check-status https://master-api.flutter.dev/offline/flutter.xml 2>/dev/null)
    if [[ $? != 0 ]]; then
        echo "Couldn't download flutter.docset!"
        return 1
    fi
    local version=$(echo "$docset" | sed -n 's/\s*<version>\(.*\)<\/version>/\1/p' | xargs)
    url=$(echo "$docset" | sed -n 's/\s*<url>\(.*\)<\/url>/\1/p' | xargs)
    if [[ ! -e ~/flutter/flutter.docset ]]; then
        echo "Downloading flutter.docset..."
        download=true
    fi
    if [[ ! $(cat ~/flutter/flutter.docset-version) == "$version" ]]; then
        echo "Updating flutter.docset to $version..."
        download=true
    fi
    if $download; then
        wget -q -O ~/flutter/dl.tar.gz "$url"
        echo "Unpacking flutter.docset..."
        tar -xzf ~/flutter/dl.tar.gz -C ~/flutter/
        rm -f ~/flutter/dl.tar.gz
        printf %s "$version" >~/flutter/flutter.docset-version
    fi

    # remove icons and localizations to save some space
    rm -rf ~/flutter/flutter.docset/Contents/Resources/Documents/doc/flutter/cupertino/CupertinoIcons
    rm -rf ~/flutter/flutter.docset/Contents/Resources/Documents/doc/flutter/material/Icons
    rm -rf ~/flutter/flutter.docset/Contents/Resources/Documents/doc/flutter/flutter_localizations
}

upgrade_dart() {
    [[ $(command -v dart) ]] || return 1

    dart pub global list | cut -d' ' -f1 | xargs -n 1 dart pub global activate
    dart --disable-analytics
}

# Clean various temporary files.
cleansys() {
    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m trash\e[0m"
    cleansys_rmdir ~/.Trash/ ~/iCloud\ Drive/.Trash/

    #echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m local tm snapshots\e[0m"
    #tmutil deletelocalsnapshots /

    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m docker\e[0m"
    docker system prune -f

    #~/Library/Developer/Xcode/Archives
    #~/Library/Developer/Xcode/iOS DeviceSupport
    #~/Library/Developer/CoreSimulator
    #~/Library/Caches/com.apple.dt.Xcode
    #~/Library/Application Support/MobileSync/Backup
    #~/Library/Containers/com.apple.mail/Data/Library/Mail Downloads

    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m xcode\e[0m"
    cleansys_rmdir ~/Library/Developer/Xcode/DerivedData

    if [[ $((10 * 1024 * 1024)) -lt $(stat -f '%z' ~/Library/Caches/com.apple.dt.Xcode/fsCachedData 2>/dev/null) ]]; then
        echo "manually check ~/Library/Caches/com.apple.dt.Xcode/fsCachedData"
    fi
    if [[ $((10 * 1024 * 1024)) -lt $(stat -f '%z' /Library/Developer/CoreSimulator/Profiles/Runtimes 2>/dev/null) ]]; then
        echo "manually check /Library/Developer/CoreSimulator/Profiles/Runtimes"
    fi
    xcrun simctl erase all && echo "Simulators erased"

    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m gradle\e[0m"
    cleansys_rmdir ~/.gradle/caches

    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m vim\e[0m"
    find ~/.vim/swap -type f -mtime +7 -print -delete
    find ~/.vim/undo -type f -mtime +7 -print -delete

    echo "\n \e[30;1m[\e[35;1m•\e[30;1m]\e[32m brew\e[0m"
    brew autoremove -v
    cleansys_rmdir ~/Library/Caches/Homebrew
}

cleansys_rmdir() {
    local size=$(du -shc $@ 2>/dev/null | grep total | cut -f1)
    for dir in $*[@]; do
        if [[ $(ls -A "$dir" 2>/dev/null) ]]; then
            rm -rf "$dir"
        fi
    done
    echo "...freed $size"
}

test -f "$HOME/iCloud Drive/.config/.bash_aliases" && . "$_"
