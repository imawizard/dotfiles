#!/bin/bash
#shellcheck disable=SC2155,SC2317,SC1090,SC2015

set -euo pipefail

# On Silicon add brew to PATH first.
test -x /opt/homebrew/bin/brew && eval $($_ shellenv)

# Ask for super user permissions.
sudo -v

# Keep the sudo session alive for the duration of this script.
while true; do sudo -n true; sleep 60; kill -0 $$ || exit; done 2>/dev/null &

# Check for Homebrew, install if we don't have it.
if [[ ! $(command -v brew) ]]; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Turn off analytics.
    brew analytics off
fi

# Check for oh-my-zsh, install if we don't have it.
if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing oh-my-zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif [[ $(command -v omz) ]]; then
    omz update --unattended
fi

# Keep the computer awake for the duration of this script.
[[ $(command -v caffeinate) ]] && caffeinate -dusw $$ &

# Set up vars.
export MODEL_NAME=$(system_profiler SPHardwareDataType -detailLevel mini | grep "Model Name:" | sed -E 's/^.*:[[:space:]]+//')
export SILICON_CHIP=$(system_profiler SPHardwareDataType -detailLevel mini | grep "Chip:" | grep -oE 'M\d+')
export MACOS_VERSION=$(sw_vers -productVersion)
export ICLOUD_DRIVE=$(test -d ~/Library/Mobile\ Documents/com~apple~CloudDocs && echo "$_")

MACOS_MOJAVE="10.14"
MACOS_CATALINA="10.15"
MACOS_SONOMA="14"

# Disable macOS update notifications.
test -d /Library/Bundles/OSXNotification.bundle && mv "$_" "$_.ignored"

# Install keyboard layout.
keylayout=Amalgamation.keylayout
keylayout_dir=$(dirname "$0")/$keylayout
{ test ! -e "$keylayout_dir" &&
    git clone https://github.com/imawizard/$keylayout "$_" ||
    git -C "$_" pull --rebase
} && test -f "$keylayout_dir/$keylayout" &&
    sudo cp "$_" "/Library/Keyboard Layouts/" &&
    echo "Copied keyboard layout"

# Pull Chrome extensions.
test ! -e "$(dirname "$0")/chrome-extensions" &&
    git clone https://github.com/imawizard/chrome-extensions "$_" ||
    git -C "$_" pull --rebase

# Abort if brew isn't installed.
command -v brew >/dev/null || exit 1

# Create iCloud shortcut.
[[ $ICLOUD_DRIVE ]] &&
    test ! -L ~/iCloud\ Drive &&
    test ! -e "$_" &&
    ln -s "$ICLOUD_DRIVE" "$_" &&
    chflags -h hidden "$_"

# Create workspace folder.
test ! -e ~/Developer && mkdir "$_"

# Create ssh folder.
test ! -d ~/.ssh && mkdir "$_"; chmod 700 "$_"
[[ "$(ls -A ~/.ssh)" ]] && chmod -R 600 ~/.ssh/*
test ! -f ~/.ssh/authorized_keys && touch "$_"; chmod 644 "$_"
test ! -f ~/.ssh/known_hosts && touch "$_"; chmod 644 "$_"

# Kick off iCloud download for config directory.
find "$ICLOUD_DRIVE/.config" -name '*.icloud' -exec brctl download {} \;
secrets() { test -x "$ICLOUD_DRIVE/.config/secrets.sh" && "$_" "$1" || exit 1; }
secrets pre

# Configuring macOS ......................................................{{{1

# Close System Preferences so nothing gets overwritten again.
osascript -e 'tell application "System Preferences" to quit' >/dev/null 2>&1

# System
sudo pmset -b tcpkeepalive 0                                                                          # Disable TCP keep alives when asleep (like from Find My Mac)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool false # Disable automatic update downloads
if [[ "$MODEL_NAME" == *"MacBook"* ]]; then
    defaults write com.apple.bird optimize-storage -bool true                                         # Delete unused local files downloaded from the cloud to save space
elif [[ "$MODEL_NAME" == *"iMac"* ]]; then
    defaults write com.apple.bird optimize-storage -bool false
fi
#sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName                # Display IP address, hostname or OS version when pressing the login's clock (doesn't work)
#sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true              # Show language in menu at login
#sudo nvram SystemAudioVolume=" "                                                                     # Disable boot sound

# General
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false                                    # Enable repeating when holding a key down.
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"                             # Hide thicker column lines and show scrollbars only when scrolling
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true                                 # Ask whether changes should be kept
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true                                     # Restore a program's opened tabs on its next launch

# Dock
defaults write com.apple.dock magnification -bool true                                                # Magnify dock on hover
defaults write com.apple.dock tilesize -int 45                                                        # Regular size
defaults write com.apple.dock largesize -int 70                                                       # Magnification size
#defaults write com.apple.dock launchanim -bool false                                                 # Don’t animate opening apps
defaults write com.apple.dock minimize-to-application -bool true                                      # Minimize apps to their dock icon
defaults write com.apple.dock show-process-indicators -bool true                                      # Show little dots under dock icons
defaults write com.apple.dock show-recents -bool false                                                # Don't show recent apps
defaults write com.apple.dock autohide -bool true                                                     # Automatically hide dock
#defaults write com.apple.dock autohide-delay -float 0                                                # Adjust autohide reaction delay
#defaults write com.apple.dock autohide-time-modifier -float 0                                        # Adjust autohide delay
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"                                 # Always open documents in tabs

# Desktop
if [[ ! "v$MACOS_VERSION" < "v$MACOS_SONOMA" ]]; then
    defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
fi

# Mission Control
defaults write com.apple.dock mru-spaces -bool false                                                  # Don't automatically rearrange spaces based on most recent use
#defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false                                # Don't switch to a space with open windows for the application when switching to an application
defaults write com.apple.dock expose-group-apps -bool true                                            # Group windows by app
if [[ "v$MACOS_VERSION" < "v$MACOS_CATALINA" ]]; then
    defaults write com.apple.dashboard mcx-disabled -bool true                                        # Disable dashboard completely
fi

# Keyboard
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true                                   # Enable using f-keys directly
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2                                              # Enable Tab in system dialogs

# Trackpad
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5                                   # Change pointer speed, requires logging out!
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true                                  # Enable tapping for clicking
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true                 # ^
defaults write com.apple.dock showAppExposeGestureEnabled -bool true                                  # Enable App-Exposé

# Mouse
sudo defaults write com.apple.universalaccess mouseDriverCursorSize -float 1.25                       # Change cursor size, requires logging out!
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.6                                      # Change pointer speed
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"                     # Enable right-click

# Sound
#defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -bool false                            # Disable system sounds

# Menu
if [[ "v$MACOS_VERSION" < "v$MACOS_CATALINA" ]]; then
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"                              # Show battery percentage
    defaults write com.apple.menuextra.textinput ModeNameVisible -bool false                          # Don't show input-layout
elif [[ "v$MACOS_VERSION" < "v$MACOS_SONOMA" ]]; then
    defaults write com.apple.TextInputMenu visible -bool false                                        # Don't show input-layout
else
    defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true                # Show bluetooth in menu bar
    defaults write com.apple.controlcenter "NSStatusItem Visible Item-0" -bool false                  # Don't show spotlight in menu bar
fi

# Finder
defaults write com.apple.finder QuitMenuItem -bool true                                               # Make it closable
defaults write com.apple.finder NewWindowTarget -string "PfHm"                                        # Set the default location for new windows
                                                                                                      # PfCm for Computer
                                                                                                      # PfVo for HDD
                                                                                                      # PfHm for Home
                                                                                                      # PfDe for Desktop
                                                                                                      # PfLo for Custom
#defaults write com.apple.finder NewWindowTargetPath -string "file:///fullpath/"                      # ^ when PfLo
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"                                   # Change view in all windows by default
                                                                                                      # icnv for icon view
                                                                                                      # Nlsv for list view
                                                                                                      # clmv for column view
                                                                                                      # Flwv for gallery view
defaults write com.apple.finder ShowPathbar -bool true                                                # Show path breadcrumbs by default
defaults write com.apple.finder ShowStatusBar -bool true                                              # Show status at bottom by default
#defaults write com.apple.finder AppleShowAllFiles -bool true                                         # Show hidden files by default (Cmd-Shift-period)

if [[ "v$MACOS_VERSION" < "v$MACOS_MOJAVE" ]]; then
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true                                # Display full POSIX path as window title
fi
defaults write com.apple.finder QLEnableTextSelection -bool true                                      # Allow text selection in Quick Look/Preview by default (doesn't work anymore)

defaults write NSGlobalDomain AppleShowAllExtensions -bool true                                       # Show all filename extensions by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false                            # Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false                      # Disable the warning when removing from iCloud
defaults write com.apple.finder WarnOnEmptyTrash -bool false                                          # Disable the warning when emptying the thrash
defaults write com.apple.finder FXRemoveOldTrashItems -bool true                                      # Delete files in trash after 30 days
defaults write com.apple.finder _FXSortFoldersFirst -bool true                                        # Pin folders when sorting by name
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"                                   # Search the current folder by default
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true                           # Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true                          # ^
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true                              # Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true                             # ^
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false                           # Save to disk (not to iCloud) by default

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist # Enable snap-to-grid for icons on the desktop
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true                          # Avoid creation of .DS_Store files on network volumes
#defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true                             # Avoid creation of .DS_Store files on removable media
#chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library                                # Show the ~/Library folder
sudo chflags nohidden /Volumes                                                                        # Show the /Volumes folder

# Mail
defaults domains | grep -qi com.apple.mail || defaults write "$_" '{}'
defaults write com.apple.mail AutoFetch -bool true
defaults write com.apple.mail polltime -string "-1"                                                   # Automatically fetch new mails
defaults write com.apple.mail CalendarInviteRuleEnabled -bool true                                    # Automatically add invites to calender
defaults write com.apple.mail SuppressDeliveryFailure -bool true                                      # Retry sending later
defaults write com.apple.mail IndexJunk -bool true                                                    # Also search in spam
defaults write com.apple.mail ExpandPrivateAliases -bool true                                         # Show a group's members
defaults write com.apple.mail ColumnLayoutMessageList -bool true                                      # View mails in columns
defaults write com.apple.mail HighlightClosedThreads -bool true                                       # Highlight conversations
defaults write com.apple.mail ShowBccHeader -bool true                                                # Show extra fields when writing a mail
defaults write com.apple.mail ShowCcHeader -bool true                                                 # ^
defaults write com.apple.mail ShowReplyToHeader -bool true                                            # ^
defaults write com.apple.mail BccSelf -bool true                                                      # Send copy to oneself

# iBooks
if [[ "v$MACOS_VERSION" < "v$MACOS_CATALINA" ]]; then
    defaults domains | grep -qi com.apple.iBooksX || defaults write "$_" '{}'
    defaults write com.apple.iBooksX BKPreventScreenDimmingPreferenceKey -bool true                   # Delay dimming while reading
    defaults write com.apple.iBooksX BKJustificationPreferenceKey -int 0                              # Naturally justify lines
    defaults write com.apple.iBooksX BKBookshelfViewControllerShowLabels -bool true                   # Show title and author
    defaults write com.apple.iBooksX BKBookshelfViewControllerSortAction -int 2                       # Sort by title instead of last time read
fi

# iCal
defaults write com.apple.iCal "Show Week Numbers" -bool true                                          # Show week numbers
defaults write com.apple.iCal "scroll by weeks in week view" -int 2                                   # Stop at today in week view
defaults write com.apple.iCal "Show heat map in Year View" -bool true                                 # Show dates in year view
defaults write com.apple.iCal CalendarSidebarShown -bool true                                         # Show sidebar
defaults write com.apple.iCal SharedCalendarNotificationsDisabled -bool false                         # Show notifications for shared calenders
defaults write com.apple.iCal "TimeZone support enabled" -bool true                                   # Show time zones

# Terminal
defaults write com.apple.terminal StringEncodings -array 4                                            # Enable UTF-8 ONLY
#defaults write com.apple.terminal "Default Window Settings" -string "Pro"                            # Select the Pro theme by default
#defaults write com.apple.terminal "Startup Window Settings" -string "Pro"                            # ^
#defaults write com.apple.terminal SecureKeyboardEntry -bool true                                     # Enable Secure Keyboard Entry, see: https://security.stackexchange.com/a/47786/8918

# Restart Apps to apply changes
killall Finder
killall Dock
killall -q Mail || true

# .........................................................................}}}

# Set up hotkeys .........................................................{{{1

domains=()
existing=$(defaults domains)
old=$IFS
IFS=$'\n'
for line in $(
    perl -nlE "say if (/^# --Hotkeys/.../^# --/) && !/^# --/" "$0"
); do
    if [[ $line =~ ^\-\  ]]; then
        domain="${line##*- }"
        domains+=("$domain")
        defaults read "$domain" 2>/dev/null | grep -q 'NSUserKeyEquivalents' &&
            defaults delete "$domain" NSUserKeyEquivalents
    elif [[ ! $line =~ ^\ *\# ]] && [[ $line =~ " " ]]; then
        name=$(echo "${line% *}" | xargs)
        key="${line##* }"
        echo "$existing" | grep -qi "$domain" || defaults write "$domain" '{}'
        defaults write "$domain" NSUserKeyEquivalents -dict-add "$name" "$key"
    fi
done
IFS=$old

sudo defaults write com.apple.universalaccess com.apple.custommenu.apps -array \
    "${domains[@]}"

defaults write pbs NSServicesStatus -dict-add '"(null) - Bearbeite in helix - runWorkflowAsService"'                    '{ "key_equivalent" = "@^$\Uf704"; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Neuer iTerm2 Tab - runWorkflowAsService"'                      '{ "key_equivalent" = "@^$\Uf705"; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Bearbeite in VSCode - runWorkflowAsService"'                   '{ "key_equivalent" = "@^$\Uf706"; }'
defaults write pbs NSServicesStatus -dict-add '"com.aone.keka - Keka/Send to Keka - serviceHandle"'                     '{ "key_equivalent" = "@^$\Uf707"; }'
defaults write pbs NSServicesStatus -dict-add '"com.apple.TextEdit - Open Selected File in TextEdit - openFile"'        '{ "key_equivalent" = "@^$\Uf708"; }'
defaults write pbs NSServicesStatus -dict-add '"co.gitup.mac - Open in GitUp - openRepository"'                         '{ "key_equivalent" = "@^$\Uf709"; }'

defaults write pbs NSServicesStatus -dict-add '"(null) - Neues Textdokument - runWorkflowAsService"'                    '{ "key_equivalent" = "@~n"; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Verstecke alle Fenster - runWorkflowAsService"'                '{}'

defaults write pbs NSServicesStatus -dict-add '"(null) - Unique lines - runWorkflowAsService"'                          '{ "key_equivalent" = "@$\Uf70b"; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Sort lines (asc) - runWorkflowAsService"'                      '{ "key_equivalent" = "@$\Uf70c"; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Sort lines (desc) - runWorkflowAsService"'                     '{ "key_equivalent" = "@$\Uf70d"; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Shuffle lines - runWorkflowAsService"'                         '{ "key_equivalent" = "@$\Uf70e"; }'

defaults write pbs NSServicesStatus -dict-add '"(null) - Bearbeite in vim (iTerm2 Tab) - runWorkflowAsService"'         '{ "enabled_context_menu" = 0; "enabled_services_menu" = 0; "presentation_modes" = { ContextMenu = 0; ServicesMenu = 0; }; }'
defaults write pbs NSServicesStatus -dict-add '"(null) - Bearbeite in Vimr - runWorkflowAsService"'                     '{ "enabled_context_menu" = 0; "enabled_services_menu" = 0; "presentation_modes" = { ContextMenu = 0; ServicesMenu = 0; }; }'

defaults write pbs NSServicesStatus -dict-add '"com.apple.Terminal - New Terminal Tab at Folder - newTerminalAtFolder"' '{ "enabled_context_menu" = 0; "enabled_services_menu" = 0; "presentation_modes" = { ContextMenu = 0; ServicesMenu = 0; }; }'
defaults write pbs NSServicesStatus -dict-add '"com.apple.Terminal - New Terminal at Folder - newTerminalAtFolder"'     '{ "enabled_context_menu" = 0; "enabled_services_menu" = 0; "presentation_modes" = { ContextMenu = 0; ServicesMenu = 0; }; }'
defaults write pbs NSServicesStatus -dict-add '"com.googlecode.iterm2 - New iTerm2 Tab Here - openTab"'                 '{ "enabled_context_menu" = 0; "enabled_services_menu" = 0; "presentation_modes" = { ContextMenu = 0; ServicesMenu = 0; }; }'
defaults write pbs NSServicesStatus -dict-add '"com.googlecode.iterm2 - New iTerm2 Window Here - openWindow"'           '{ "enabled_context_menu" = 0; "enabled_services_menu" = 0; "presentation_modes" = { ContextMenu = 0; ServicesMenu = 0; }; }'

# .........................................................................}}}

# Install software and tools .............................................{{{1

latest() { echo "${3:-%2}" | sed -e "s|%1|$1|" -e "s|%2|$( \
    git ls-remote --tags --refs --sort="version:refname" "https://$1" \
    | cut -f2 \
    | cut -d/ -f3 \
    | grep -E "^v?${2:-}" \
    | tail -n1)|"; }
cargo_latest() { latest "$1" "${2:-}" '--git https://%1 --tag %2'; }
go_clone_install() {
    local pkg="$1"
    local bin="${2:-.}"

    local name=${pkg%%@*}
    local version=$(latest "$name")
    local dir="$GOPATH/git/$name"

    test -e "$dir" || git clone "https://$name" "$_"
    cd "$dir" || return 1

    git fetch
    git checkout "refs/tags/$version"
    if ! go install "$bin" 2>/dev/null; then
        go generate ./...
        go install "$bin"
    fi
}

# Install formulae and casks.
brew update
Brewfile=$(perl -nlE 'say if (/^# --Brewfile/.../^# --/) && !/^# --/' "$0"; secrets brewfile)
echo "$Brewfile" | brew bundle install --file=-
echo "$Brewfile" | brew bundle cleanup --file=- --force --zap
brew cleanup

# Install rustup and rust toolchain.
if [[ ! $(command -v rustup) ]]; then
    if [[ $(command -v rustup-init) ]]; then
        rustup-init --default-toolchain stable --no-modify-path -y
    else
        curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- --default-toolchain stable --no-modify-path -y
    fi
else
    if [[ ! $(command -v cargo) ]]; then
        rustup default stable
    else
        rustup update
    fi
fi

# Install mise.
if [[ ! $(command -v mise) ]]; then
    cargo install --locked mise
    command -v mise >/dev/null || { echo "mise wasn't found in PATH"; exit 1; }
else
    mise self-update -y
    mise upgrade
fi

# Install zsh plugins.
for repo in \
    github.com/Aloxaf/fzf-tab \
    github.com/zdharma-continuum/fast-syntax-highlighting \
    github.com/zsh-users/zsh-autosuggestions \
    github.com/zsh-users/zsh-syntax-highlighting \
; do
    test ! -e "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/${repo##*/}" &&
        git clone "https://$repo" "$_" ||
        git -C "$_" pull --rebase
done

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
        #shellcheck disable=SC2086
        $cmd $line
    fi
done

# Install plug.vim and vim plugins.
if [[ $(command -v vim) ]]; then
    test ! -e ~/.vim/swap && mkdir "$_"
    test ! -e ~/.vim/undo && mkdir "$_"
    test ! -e ~/.vim/autoload/plug.vim &&
        curl -fLo "$_" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qa
    vim -c 'PlugUpgrade | PlugUpdate' +qa
fi

# Install packer, hotpot and neovim plugins.
if [[ $(command -v nvim) ]]; then
    test ! -e ~/.vim/swap && mkdir "$_"
    test ! -e ~/.vim/undo && mkdir "$_"
    test ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim &&
        git clone https://github.com/wbthomason/packer.nvim "$_" ||
        git -C "$_" pull --rebase
    test ! -e ~/.local/share/nvim/site/pack/packer/start/hotpot.nvim &&
        git clone https://github.com/rktjmp/hotpot.nvim "$_" ||
        git -C "$_" pull --rebase
    nvim --headless -c 'TSUpdateSync' +qa
    nvim --headless -c 'TSInstallSync all' +qa
    nvim --headless -c 'autocmd User PackerComplete qa' +PackerSync
fi

# Install tpm and tmux plugins.
if [[ $(command -v tmux) ]]; then
    test ! -e ~/.tmux/plugins/tpm &&
        git clone https://github.com/tmux-plugins/tpm "$_" ||
        git -C "$_" pull --rebase
    test -x ~/.tmux/plugins/tpm/bin/install_plugins && "$_"
    test -x ~/.tmux/plugins/tpm/bin/update_plugins && "$_" all
fi

# Link helix' runtime.
if ! test -e ~/.config/helix/runtime || test -L "$_"; then
    test -L "$_" && rm "$_"
    #shellcheck disable=SC2012
    ln -s "$(ls -d -1 -t ~/.cargo/git/checkouts/helix-????????????????/* | head -n 1)/runtime" "$_"
fi

if [[ $(command -v dart) ]]; then
    dart --disable-analytics
fi
if [[ $(command -v flutter) ]]; then
    flutter upgrade --force
    flutter config --no-analytics

    download=false
    docset=$(curl -fsSL https://master-api.flutter.dev/offline/flutter.xml)
    if [[ $? != 0 ]]; then
        echo "Couldn't download flutter.docset!"
        return 1
    fi
    version=$(echo "$docset" | sed -n 's/\s*<version>\(.*\)<\/version>/\1/p' | xargs)
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
fi


# Possibly add missing tmux-256color.
test ! -f ~/.terminfo/*/tmux-256color &&
    tee <<HERE "$(basename "$_").terminfo" >/dev/null && tic "$_" && rm -f "$_"
tmux-256color|screen with 256 colors and italic,
  sitm=\E[3m, ritm=\E[23m,
  use=screen-256color,
HERE

# Install quicklook extensions (backed up to iCloud).
find "$ICLOUD_DRIVE/.config/Apps/Quicklook" -name '*.qlgenerator' -maxdepth 1 -exec cp -a -n {} "$HOME/Library/Quicklook/" \;

# .........................................................................}}}

secrets post

echo
echo "Done"
exit

#shellcheck disable=all
{

# --Brewfile .............................................................{{{1

tap "homebrew/bundle"
tap "homebrew/services"

tap "aws/tap"
tap "clojure-lsp/brew"
tap "koekeishiya/formulae"

# Core
    brew "telnet"
    brew "tmux"
    brew "watch"
    brew "wget"
    #brew "bash"                     # newer version
    #brew "cowsay"
    #brew "curl"                     # newer version
    #brew "diffutils"                # newer version
    #brew "fortune"
    #brew "gdb"                      # gdb needs to be signed
    #brew "neovim"
    #brew "rsync"                    # newer version
    #brew "screen"                   # newer version
    #brew "ssh-copy-id"              # newer version
    #brew "stow"
    #brew "tree"
    #brew "valgrind"                 # only compatible with macOS<10.13
    #brew "vim"                      # newer version
    #brew "zsh"                      # newer version

# Libraries
    brew "bison"
    brew "libiconv"
    brew "libzip"
    brew "meson"
    brew "re2c"

# Utilities
    brew "entr"                      # or fswatch
    brew "exercism"
    brew "fdupes"
    brew "jq"                        # or fx
    brew "ncdu"
    brew "trash"
    brew "universal-ctags"
    #brew "archey"                   # deprecated, or screenfetch or neofetch
    #brew "byobu"
    #brew "cgdb"                     # needs gdb to be signed
    #brew "ctags"                    # use universal-ctags
    #brew "figlet"
    #brew "fzf"                      # or fzy or peco
    #brew "lynx"
    #brew "mas"
    #brew "micro"
    #brew "nnn"                      # or ranger or lf
    #brew "rename"
    #brew "snappy"

# Compilers
    brew "discount"                  # or peg-markdown
    brew "rustup"

# Package managers and build systems
    #brew "asdf"
    #brew "carthage"                 # alternative to cocoapods
    #brew "cpanminus"                # run instmodsh for installs
    #brew "pnpm"                     # or yarn

# Linters and formatters
    brew "clojure-lsp/brew/clojure-lsp-native"

# Security
    #brew "git-crypt"
    #brew "radare2"
    #brew "nmap"

# Storage
    #brew "hub"
    #brew "mariadb"
    #brew "memcached"
    #brew "mercurial"
    #brew "mongodb/brew/mongodb-community"
    #brew "postgresql"
    #brew "rabbitmq"
    #brew "sqlite"                   # newer version, keg-only

# DevOps
    brew "podman"
    #brew "aws-shell"
    #brew "aws/tap/aws-sam-cli"
    #brew "docker"
    #brew "docker-machine"
    #brew "docker-swarm"
    #brew "podman-compose"

# Conversion
    brew "ffmpeg"
    brew "graphviz"
    #brew "gifsicle"
    #brew "imagemagick"

# Cask Essentials
    cask "iterm2"                    # or kitty or alacritty
    cask "karabiner-elements"
    cask "keka"
    cask "kekaexternalhelper"        # previously kekadefaultapp
    cask "opera"
    cask "sloth"
    #cask "alfred"                   # or raycast
    #cask "obsidian"
    #cask "onedrive"
    #cask "onyx"
    #cask "ukelele"
    #cask "vanilla"                  # or dozer
    #cask "virtualbox"
    #cask "virtualbox-extension-pack"

# Window Tools
    cask "amethyst"                  # or yabai
    cask "hammerspoon"
    cask "hazeover"
    cask "spaceid"
    #cask "alt-tab"
    #cask "fluid"
    #cask "spectacle"                # or rectangle
    #cask "ubersicht"                # desktop widgets
    #cask "whichspace"

# QuickLook
    cask "qlmarkdown"
    cask "qlmobi"
    cask "qlstephen"
    cask "quicklook-json"
    #cask "hetimazipql"              # removed because website is down
    #cask "qlcolorcode"
    #cask "quicklook-csv"

# Security
    cask "macpass"
    cask "tunnelblick"
    #cask "gpg-suite"                # GPG Mail is paid
    #cask "lulu"
    #cask "oversight"
    #cask "whatsyoursign"

# Development
    cask "android-studio"
    cask "boop"
    cask "hex-fiend"
    cask "meld"
    cask "podman-desktop"
    cask "visual-studio-code"
    #cask "clion"
    #cask "cocoapods"                # bundled app with editor
    #cask "dash"
    #cask "docker"
    #cask "goland"
    #cask "jd-gui"
    #cask "phpstorm"
    #cask "rancher"
    #cask "temurin"                  # or java, keg-only
    #cask "vagrant"
    #cask "vimr"
    #cask "xammp"

# Storage
    cask "db-browser-for-sqlite"
    cask "gitup"                     # or sourcetree or gitx or fork
    cask "robo-3t"                   # or mongotron or nosqlclient
    cask "sequel-ace"
    #cask "another-redis-desktop-manager"
    #cask "handbrake-nightly"
    #cask "postico"                  # paid
    #cask "redis"
    #cask "sequel-pro-nightly"       # outdated, use sequel-ace

# Reversing
    #cask "bit-slicer"
    #cask "cutter"
    #cask "ghidra"
    #cask "idafree"

# Writing & Notes
    cask "anki"
    #cask "basictex"
    #cask "bibdesk"
    #cask "notion"
    #cask "skim"

# Multimedia
    cask "drawio"
    cask "iina"                      # or vlc
    cask "kap"
    cask "sf-symbols"
    #cask "caption"
    #cask "cfxr"                     # 32bit only
    #cask "freac"
    #cask "inkscape"
    #cask "macsvg"
    #cask "moonlight"
    #cask "spotify"
    #cask "transmission-nightly"

# Communication
    #cask "colloquy"
    #cask "discord"
    #cask "mumble"
    #cask "skype"
    #cask "slack"
    #cask "teamspeak-client"
    #cask "teamviewer"
    #cask "whatsapp"

# osxfuse
    cask "macfuse"
    #cask "osxfuse"                  # deprecated
    #brew "sshfs"                    # deprecated
    #brew "gocryptfs"                # brew says it needs libfuse

# Fonts
    cask "font-clear-sans"
    cask "font-fira-code-nerd-font"
    cask "font-hack-nerd-font"
    cask "font-inconsolata"
    cask "font-metropolis"
    cask "font-monoid"
    cask "font-roboto"
    cask "font-roboto-condensed"
    cask "font-source-code-pro"
    cask "font-ubuntu"
    cask "font-work-sans"

# .........................................................................}}}

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
    usage-cli  # --git https://github.com/jdx/usage
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
    cocoapods
    iStats
    terminal-notifier
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
    github.com/int128/kubelogin@latest
    github.com/jesseduffield/lazydocker@latest
    github.com/jesseduffield/lazygit@latest
    github.com/mattn/efm-langserver@latest
    github.com/mgechev/revive@latest
    github.com/mikefarah/yq/v4@latest
    github.com/rclone/rclone@latest
    github.com/segmentio/golines@latest
    github.com/sqls-server/sqls@master # latest tag has old go.mod
    github.com/stern/stern@latest
    github.com/terraform-docs/terraform-docs@latest
    github.com/terraform-linters/tflint@latest
    golang.org/x/tools/gopls@latest
    helm.sh/helm/v3/cmd/helm@latest
    honnef.co/go/tools/cmd/staticcheck@latest
    mvdan.cc/gofumpt@latest
    mvdan.cc/sh/v3/cmd/shfmt@latest
    sigs.k8s.io/kind@latest
    #github.com/caddyserver/caddy@latest
    #github.com/josharian/impl@latest
    #github.com/magefile/mage@latest
    #github.com/rclone/rclone@latest
    #github.com/restic/restic@latest
    #github.com/technosophos/dashing@latest
    #github.com/x-motemen/ghq@latest

$ go_clone_install
    github.com/candid82/joker@latest
    github.com/carapace-sh/carapace-bin@latest ./cmd/carapace
    github.com/eksctl-io/eksctl@latest ./cmd/eksctl
    github.com/gruntwork-io/terragrunt@latest
    github.com/hashicorp/terraform@latest
    github.com/junegunn/fzf@latest
    github.com/kubernetes/kubernetes@latest ./cmd/kubectl
    github.com/kubernetes/minikube@latest ./cmd/minikube
    github.com/opentofu/opentofu@latest ./cmd/tofu
    #github.com/k3s-io/k3s@latest ./cmd/k3s

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

$ python3 -m pip install --upgrade
    pip
    asciinema
    azure-cli
    cookiecutter
    hy
    podman-compose
    pre-commit
    pynvim
    vim-vint
    yamllint
    youtube-dl
    git+https://github.com/aws/aws-cli.git@v2 pyopenssl
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

# --Hotkeys ..............................................................{{{1

# Special keys:
#  ^ = Ctrl
#  @ = Cmd
#  $ = Shift
#  ~ = Option

- com.apple.finder
    Bring All to Front              ~\\Uf70e
    Alle nach vorne bringen         ~\\Uf70e
    Print                           @~r
    Drucken                         @~r
    New Finder Window               @~^n
    Neues Fenster                   @~^n
    Tags...                         ^t
    Tags ...                        ^t
    Forward                         @'
    Vorw\\U00e4rts                  @'
    Back                            @;
    Zur\\U00fcck                    @;
    Recents                         @\$y
    Zuletzt benutzt                 @\$y
    Documents                       @\$s
    Dokumente                       @\$s
    Desktop                         @\$h
    Schreibtisch                    @\$h
    Downloads                       @~p
    Home                            @\$j
    Benutzerordner                  @\$j
    Library                         @\$p
    Computer                        @\$i
    AirDrop                         @\$o
    Network                         @\$v
    Netzwerk                        @\$v
    iCloud Drive                    @\$f
    Applications                    @\$a
    Programme                       @\$a
    Utilities                       @\$g
    Dienstprogramme                 @\$g
    Go to Folder                    @\$u
    Gehe zum Ordner ...             @\$u

- com.apple.Notes
    Strikethrough                   @\$u
    Durchgestrichen                 @\$u

- com.apple.Preview
    Export as PDF...                ~\$o
    Als PDF exportieren ...         ~\$o
    Export As...                    @~s
    Exportieren ...                 @~s
    Adjust Size...                  @~g
    Gr\\U00f6\\U00dfenkorrektur ... @~g
    Save As...                      @\$s
    Sichern unter ...               @\$s

- com.operasoftware.Opera
    Developer Tools                 @\$i
    Entwicklerwerkzeuge             @\$i
    Close Window                    @~w
    Fenster schlie\\U00dfen         @~w

- com.apple.mail
    Date                            @k
    Datum                           @k
    From                            @\$k
    Von                             @\$k
    Remove Style                    @\$b
    Stil entfernen                  @\$b

- com.apple.ActivityMonitor
    All Processes, Hierarchically   @1
    Alle Prozesse, hierarchisch     @1
    Windowed Processes              @2
    Prozesse mit Fenstern           @2

# .........................................................................}}}

}
