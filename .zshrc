# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="lambda"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    aliases             # als
    colored-man-pages
    cp                  # cpv
    git
    gitignore           # gi
    macos               # tab - open dir in new tab
                        # split_tab
                        # vsplit_tab
                        # ofd - open finder dir
                        # pfd - print finder dir
                        # pfs - print finder selection
                        # cdf - cd to finder dir
                        # pushdf - pushd finder dir
                        # quick-look
                        # man-preview
                        # showfiles
                        # hidefiles
                        # itunes
                        # music
                        # spotify
                        # rmdsstore
    urltools            # urlencode
    #vi-mode
    web-search          # google
                        # github
                        # wiki...

    fzf-tab
    zsh-autosuggestions
    fast-syntax-highlighting
)

# Load oh-my-zsh.
test -r $ZSH/oh-my-zsh.sh && . "$_"

# Load bash profile.
test -r ~/.bash_profile && . "$_"

# Configure completions.
# See https://zsh.sourceforge.io/Doc/Release/Completion-System.html

zstyle ':completion:*' list-prompt ''       # display all possibilities
zstyle ':completion:*' insert-tab false     # always complete
zstyle ':completion:*' squeeze-slashes true # dont treat // as /*/

# enable groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# for man completion
zstyle ':completion:*' insert-sections yes
zstyle ':completion:*' separate-sections yes

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false

# Configure fzf-tab

# change group-name format from above
zstyle ':completion:*:descriptions' format '[%d]'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# hide prefix-char
zstyle ':fzf-tab:*' prefix ' '

# set fzf colors
zstyle ':fzf-tab:*' default-color $'\e[30m'
zstyle ':fzf-tab:*' fzf-flags --color='hl+:bold:-1,hl:bold:-1,gutter:-1,pointer:bright-green,bg+:#dddddd'

# set fzf bindings
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-o:toggle-preview'

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Remove `input` because for `nvim ./` it populates the query string with "./"
zstyle ':fzf-tab:*' query-string prefix first
