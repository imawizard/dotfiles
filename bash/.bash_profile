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

# Set Chrome for flutter.
export CHROME_EXECUTABLE=/Applications/Opera.app/Contents/MacOS/Opera

# Load up z.
. /usr/local/etc/profile.d/z.sh

# Motivation reminder
printf "There are \u001b[1m%d\u001b[0m weeks left this year. %s\n"       \
	$(( ($(date -v 12m -v 31d -v 23H +%s) - $(date +%s)) / 86400 / 7 ))  \
	"What will you do?"

