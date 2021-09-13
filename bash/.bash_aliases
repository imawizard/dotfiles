alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

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
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: hex filename"
		return 1
	fi
	xxd -p $@ | tr -d "\n" && echo
}

# Like md5 for sha1.
sha1() {
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: sha1 filename"
		return 1
	fi
	shasum -a 1 $@
}

# Like md5 for sha256.
sha256() {
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: sha256 filename"
		return 1
	fi
	shasum -a 256 $@
}

# Like md5 for sha512.
sha512() {
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: sha512 filename"
		return 1
	fi
	shasum -a 512 $@
}

# Outputs random bytes.
rand() {
	local mode
	local showusage=false
	if [[ "$#" -gt 1 ]]; then
		case "$1" in
		hex|base64)
			mode="-$1"
			shift
			;;
		*)
			showusage=true
			;;
		esac
	fi
	if [[ ! "$1" =~ ^[0-9]+$ ]]; then
		showusage=true
	fi
	if $showusage; then
		echo "usage: rand [hex|base64] num"
		return 1
	fi
	openssl rand $mode $1
}

# Shuffle input.
shuf() {
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: shuf [-e] filename or input"
		return 1
	fi
	if [ "$1" == "-e" ]; then
		shift
		echo $@ | tr ' ' '\n' | sort -R
	else
		sort -R $@
	fi
}

# Recursively reset directory and file modes.
resetmod() {
	echo "Do you want to recursivly reset modes for '$(pwd)' (Y/n)?"
	read
	[[ "$REPLY" != "Y" ]] && return
	find . -type d -exec chmod 0755 {} \;
	find . -type f -exec chmod 0644 {} \;
}

# System .................................................................{{{1

# Disable standby.
up() {
	if [[ "$1" == "--help" ]]; then
		echo "usage: up [minutes]"
		return 1
	fi
	local mins=$(( 4 * 60 ))
	if [[ "$1" ]]; then
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
alias clamshell-sleep-off='sudo pmset -a disablesleep 1'
alias clamshell-sleep-on='sudo pmset -a disablesleep 0'

# Remove the red circle indicating there's an OS update.
hide-os-update() {
	defaults delete com.apple.preferences.softwareupdate LatestMajorOSSeenByUserBundleIdentifier
	softwareupdate --list
}

# Start an unthrottled TimeMachine backup.
do-timemachine-backup() {
	if [[ "$(sysctl debug.lowpri_throttle_enabled | grep ': 1')" ]]; then
		sudo sysctl debug.lowpri_throttle_enabled=0
	fi
	tmutil startbackup
}

# Look in current dir for iCloud files to download.
icloud-download() {
	find . -name '*.icloud' -exec brctl download {} \; -print
}

# Try to remove all local iCloud copies in current dir.
icloud-evict() {
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
	[[ -e prefs-new.txt ]] && mv -f prefs-new.txt prefs-old.txt
	defaults read > prefs-new.txt
	[[ -e prefs-old.txt ]] && diff prefs-old.txt prefs-new.txt
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

alias watch='watch --color'
alias archey='archey --color --offline'
alias build_runner='pub run build_runner watch --delete-conflicting-outputs || flutter packages pub run build_runner watch --delete-conflicting-outputs'

# Open Finder with z.
zz() {
	_z $@ && ofd && popd >/dev/null
}

# Read cht.sh.
cht() {
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: cht topic [-c] [query]"
		return 1
	fi
	local topic="$1"
	shift
	local opts='\?Q'
	if [[ "$1" == "-c" ]]; then
		opts=""
		shift
	fi
	local query="${*// /+}"
	[[ "$query" ]] && query="/$query"
	local out="$(echo cht.sh/$topic$query$opts | xargs curl 2>/dev/null)"
	if [[ -z "$out" ]]; then
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
	if [[ ! "$TMUX" ]]; then
		return
	fi
	if [[ "$1" == "--help" || "$#" -lt 1 ]]; then
		echo "usage: prog-name"
		return 1
	fi
	local id="$(tmux list-panes -a -F '#{pane_current_command} #{window_id} #{pane_id}' | awk '/^'$1' / {print $2" "$3; exit}')"
	local window_id="$id[(w)1]"
	local pane_id="$id[(w)2]"
	[[ "$pane_id" ]] && tmux select-window -t "$window_id" && tmux select-pane -t "$pane_id"
}

# Register a filetype with QLStephen.
ft2ql() {
	[[ "$1" == "--help" || "$#" == 0 || ! -f "$1" ]] && { echo "Usage: ft2ql filename.ext"; return 1; }
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

	echo " \033[30;1m[\033[35;1m•\033[30;1m]\033[32m brew\033[0m"
	upgrade-brew
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m oh-my-zsh\033[0m"
	upgrade-oh-my-zsh
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m tmux plugins\033[0m"
	upgrade-tmux
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m vim plugins\033[0m"
	upgrade-vim
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m doom emacs\033[0m"
	upgrade-doom
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m rust\033[0m"
	upgrade-rust
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m flutter\033[0m"
	upgrade-flutter
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m dart\033[0m"
	upgrade-dart

	local took=$(($(date +%s) - $t))
	if [[ "$took" -gt 59 ]]; then
		local mins=$(($took / 60))
		local secs=$(($took % 60))
		printf "Done, upgraded in %dm%02ds.\n" $mins $secs
	else
		echo "Done, upgraded in ${took}s."
	fi
}

# Update brew and software.
upgrade-brew() {
	if [[ $(sw_vers -productVersion) > "10.14" ]] || [[ $(sw_vers -productVersion) == "10.14" ]]; then
		brew update

		# Possibly filter progs not to update.
		brew outdated --formula | perl -alE 'say $F[0] unless /^prog-to-ignore/' | xargs brew upgrade
		brew outdated --cask | perl -alE 'say $F[0] unless /^prog-to-ignore/' | xargs brew upgrade

		brew cleanup -s
	else
		echo "Won't upgrade brew on High Sierra"
	fi
}

# Update oh my zsh.
upgrade-oh-my-zsh() {
	[[ $(command -v omz) ]] || return 1

	omz update --unattended
}

# Update tmux plugins.
upgrade-tmux() {
	[[ $(command -v tmux) ]] || return 1

	~/.tmux/plugins/tpm/bin/update_plugins all
}

# Update vim plugins.
upgrade-vim() {
	[[ $(command -v vim) ]] || return 1

	vim -c 'PlugUpgrade | PlugUpdate' +qa
}

# Update doom emacs.
upgrade-doom() {
	[[ $(command -v doom) ]] || return 1

	doom upgrade
	doom purge
}

# Update rust.
upgrade-rust() {
	[[ $(command -v rustup) ]] || return 1

	rustup update
}

# Update flutter and flutter docs.
upgrade-flutter() {
	[[ $(command -v flutter) ]] || return 1

	# update flutter
	flutter upgrade --force
	flutter config --no-analytics

	# update docset
	local download=false
	local docset=$(http --body --check-status https://master-api.flutter.dev/offline/flutter.xml 2>/dev/null)
	if [[ "$?" != 0 ]]; then
		echo "Couldn't download flutter.docset!"
		return 1
	fi
	local version=$(echo "$docset" | sed -n 's/\s*<version>\(.*\)<\/version>/\1/p' | xargs)
	url=$(echo "$docset" | sed -n 's/\s*<url>\(.*\)<\/url>/\1/p' | xargs)
	if [[ ! -e ~/flutter/flutter.docset ]]; then
		echo "Downloading flutter.docset..."
		download=true
	fi
	if [[ ! "$(cat ~/flutter/flutter.docset-version)" == "$version" ]]; then
		echo "Updating flutter.docset to $version..."
		download=true
	fi
	if $download; then
		wget -q -O ~/flutter/dl.tar.gz "$url"
		echo "Unpacking flutter.docset..."
		tar -xzf ~/flutter/dl.tar.gz -C ~/flutter/
		rm -f ~/flutter/dl.tar.gz
		printf "$version" > ~/flutter/flutter.docset-version
	fi

	# remove icons to save some space
	rm -rf ~/flutter/flutter.docset/Contents/Resources/Documents/doc/flutter/material/Icons
}

upgrade-dart() {
	[[ $(command -v dart) && $(command -v pub) ]] || return 1

	pub global list | cut -d' ' -f1 | xargs -n 1 pub global activate
	dart --disable-analytics
}

# Clean various temporary files.
cleansys() {
	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m trash\033[0m"
	cleansys_rmdir ~/.Trash/ ~/iCloud\ Drive/.Trash/

	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m local tm snapshots\033[0m"
	tmutil deletelocalsnapshots /

	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m docker\033[0m"
	docker system prune -f

	#~/Library/Developer/Xcode/Archives
	#~/Library/Developer/Xcode/iOS DeviceSupport
	#~/Library/Developer/CoreSimulator
	#~/Library/Caches/com.apple.dt.Xcode
	#~/Library/Application Support/MobileSync/Backup
	#~/Library/Containers/com.apple.mail/Data/Library/Mail Downloads

	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m xcode\033[0m"
	cleansys_rmdir ~/Library/Developer/Xcode/DerivedData

	if [[ $((10 * 1024 * 1024)) -lt $(stat -f '%z' ~/Library/Caches/com.apple.dt.Xcode/fsCachedData 2>/dev/null) ]]; then
		echo "manually check ~/Library/Caches/com.apple.dt.Xcode/fsCachedData"
	fi
	if [[ $((10 * 1024 * 1024)) -lt $(stat -f '%z' /Library/Developer/CoreSimulator/Profiles/Runtimes 2>/dev/null) ]]; then
		echo "manually check /Library/Developer/CoreSimulator/Profiles/Runtimes"
	fi
	xcrun simctl erase all && echo "Simulators erased"

	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m gradle\033[0m"
	cleansys_rmdir ~/.gradle/caches

	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m vim\033[0m"
	find ~/.vim/swap -type f -mtime +7 -print -delete
	find ~/.vim/undo -type f -mtime +7 -print -delete

	echo "\n \033[30;1m[\033[35;1m•\033[30;1m]\033[32m brew\033[0m"
	brew autoremove -v
	rm -rf ~/Library/Caches/Homebrew
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

