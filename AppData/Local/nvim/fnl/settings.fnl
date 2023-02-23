(import-macros {: gset! : oset! : has?} :macros)

(gset!
 (:when (has? "mac")
   perl_host_prog    "/usr/local/bin/perl"
   python3_host_prog "/usr/local/bin/python3"
   node_host_prog    "/usr/local/bin/node"
   ruby_host_prog    "/usr/bin/ruby"
   ctags_host_prog   "/usr/local/bin/ctags")

 (:when (has? "win32")
   perl_host_prog    (.. vim.env.HOME "/scoop/apps/perl/current/perl/bin/perl.exe")
   python3_host_prog (.. vim.env.HOME "/scoop/apps/python/current/python.exe")
   node_host_prog    (.. vim.env.HOME "/scoop/apps/nodejs/current/bin/neovim-node-host.cmd")
   ruby_host_prog    (.. vim.env.HOME "/scoop/apps/ruby/current/gems/bin/nvim-ruby-host.bat")
   ctags_host_prog   (.. vim.env.HOME "/scoop/apps/universal-ctags/current/ctags.exe")))

(oset!
 grepprg    "rg --vimgrep --smart-case --hidden -g \"!.git/\""
 grepformat "%f:%l:%c:%m,%f:%l:%m"
 lispwords  (:remove "if" "do")

 background "light"
 guicursor  ["a:block-blinkwait1000-blinkon500-blinkoff500"
             "i-ci:hor15"]

 (:when (has? "mac")
   guifont "Fira Code Light Nerd Font Complete Mono:h12")
 (:when (has? "win32")
   guifont      "FiraCode NFM:h10"
   ;; For pwsh as shell, see github.com/akinsho/toggleterm.nvim/wiki/Tips-and-Tricks.
   shell        "pwsh"
   shellcmdflag "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
   shellredir   "-RedirectStandardOutput %s -NoNewWindow -Wait"
   shellpipe    "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
   shellquote   ""
   shellxquote  "")

 (:when (has? "termguicolors")
   termguicolors true)                       ; Use guifg and guibg.
 (:when (string.match vim.o.term "256color")
   t_Co 256                                  ; Indicate number of colors.
   t_ut "")                                  ; Disable Background Color Erase.

 mouse        "a"                            ; Enable mouse-support.
 virtualedit  (:append "all")                ; Enable putting the cursor anywhere.
 timeoutlen   750                            ; Time out on mappings.
 ttimeout     true                           ; Time out on Escape after...
 ttimeoutlen  150                            ; ...waiting this many ms for a special key.
 clipboard    (if (has? "unnamedplus")       ; Share yanks etc. with system's clipboard.
                  "unnamedplus"
                  "unnamed")
 autowriteall true                           ; Autosave when navigating between buffers.
 hidden       true                           ; Enable unwritten buffers in background.
 confirm      true                           ; Show dialog when closing with unwritten buffers.
 switchbuf    (:append "uselast"             ; Use same window when opening quickfix results.
                       "useopen")            ; Or windows having the file already opened.
 swapfile     true                           ; Don't directly write to files.
 directory    (.. vim.env.HOME               ; Save swap files in a folder.
                  "/.vim/swap//")
 updatetime   250                            ; Write swap file after this time (effects signcolumn).
 undofile     true                           ; Enable persistent undos.
 undodir      (.. vim.env.HOME               ; Save undos in a folder.
                  "/.vim/undo")
 undolevels   2000                           ; Increase possible undos.
 sessionoptions (:remove "tabpages")         ; Only save the current tab in sessions.
 shada          (:append "rterm://"          ; Don't save marks for terminal buffers.
                         "'150")             ; Increase limit of v:oldfiles.
 fileformats  ["unix" "dos" "mac"]           ; Use Unix as the standard file type.

 completeopt  (:remove "menuone")            ; Don't show if only one match.
 completeopt  (:append "noselect"            ; No automatic selection.
                       "noinsert"            ; Only insert on confirmation.
                       "preview")            ; Show extra information in preview window.
 pumblend     5                              ; Transparency for popup menus.
 winblend     5                              ; Transparency for floating windows.
 diffopt      (:append "algorithm:histogram" ; Use a different diff-algo.
                       "iwhite"              ; Ignore amount of whitespace.
                       "hiddenoff")          ; Turn off diffing when hidden.

 (:when (has? "nvim-0.3.2")                  ; See https://github.com/agude/dotfiles/issues/2#issuecomment-843639956
   diffopt (:append "indent-heuristic"))
 ignorecase     true                         ; Ignore case when searching...
 smartcase      true                         ; ...unless we type a capital.
 infercase      false                        ; Don't adjust case of auto-completed matches.
 wildignorecase true                         ; Ignore case when completing filenames.
 inccommand     "nosplit"                    ; Match whilst typing when substituting.
 jumpoptions    (:append "stack")            ; When jumping discard any later entries.

 redrawtime     1500                         ; Max time highlighting search results can take.
 colorcolumn    (:append "80")               ; List of highlighted columns.
 cursorline     true                         ; Highlight current line.
 lazyredraw     false                        ; Redraw whilst executing macros.
 matchtime      2                            ; Duration for showing matching pairs after typing.
 pumheight      12                           ; Maximum number of items in popup menu.
 number         false                        ; Show no absolute line numbers.
 relativenumber false                        ; And no relative numbers.
 shortmess      (:append "c")                ; Don't show completion messages.
 shortmess      (:remove "l")                ; Use ;lines, bytes; instead of ;L, B;.
 showmatch      true                         ; Highlight matching [{()}].
 showtabline    2                            ; Always show tabs.
 signcolumn     "yes"                        ; Show sign-column.
 splitbelow     true                         ; HSplit to the bottom.
 splitright     true                         ; VSplit to the right.
 (:when (has? "nvim-0.7")
   laststatus 3)                             ; Only show one statusline.

 foldenable     true
 foldlevelstart 1                            ; Automatically open only the first level of folds.
 foldmethod     "marker"
 list           true                         ; Show tabs, spaces, etc.
 listchars      (:append (..                 ; Use these for hidden characters.
                             ",tab:| ,space:·"
                             ",trail: ,nbsp:␣"
                             ",extends:↷,precedes:↶"))
 wrap           false                        ; Don't fit lines to the window's width.
 linebreak      true                         ; If wrapping, break at specific chars.
 showbreak      "↪"                          ; Start wrapped lines with this.
 scrolloff      10                           ; Begin scrolling up and down earlier.
 sidescrolloff  6                            ; Begin scrolling sideways earlier.
 wrapmargin     0                            ; Wrap in chars-to-the-right if textwidth is 0.

 breakindent    true                         ; Continue wrapped lines' indentation.
 breakindentopt (:append "sbr")              ; Enable using showbreak's value.
 copyindent     true                         ; Continue with same indentation.
 fillchars      (:append (..                 ; Use these characters for special areas.
                             ",fold: ,vert:│"
                             ",stl: ,stlnc: ,diff:⣿"))
 preserveindent false                        ; Reconstruct indentation upon changing.
 smartindent    true                         ; Indent C-like languages.

 expandtab      true                         ; Use spaces instead of tab.
 smarttab       false                        ; Don't mix tabs with spaces.
 shiftwidth     4                            ; Use indents of 4 spaces.
 softtabstop    4                            ; Let backspace delete indent.
 tabstop        4                            ; A tab counts for so many spaces.

 wildcharm      <C-z>                        ; Used to trigger auto completion in macros.
 wildignore     (:append                     ; Ignore these for auto completion.
                         "*.DS_Store"
                         "*.swp"
                         "*.zip"
                         "*.png,*.jpg,*.gif"
                         ".git/*"
                         ".svn/*"
                         ".hg/*"
                         "CVS/*"
                         "*/tmp/*"
                         "node_modules/*"
                         "*~"
                         "*.so"
                         "*.o"
                         "*.obj"
                         "*.exe"
                         "*.class"
                         "*.pyc"))

(vim.cmd "colorscheme monochromatic")

(vim.diagnostic.config {:severity_sort true})

(vim.fn.sign_define "DiagnosticSignError" {:text "E" :texthl "DiagnosticSignError" :numhl "DiagnosticSignError"})
(vim.fn.sign_define "DiagnosticSignWarn"  {:text "W" :texthl "DiagnosticSignWarn"  :numhl "DiagnosticSignWarn"})
(vim.fn.sign_define "DiagnosticSignInfo"  {:text "I" :texthl "DiagnosticSignInfo"  :numhl "DiagnosticSignInfo"})
(vim.fn.sign_define "DiagnosticSignHint"  {:text "H" :texthl "DiagnosticSignHint"  :numhl "DiagnosticSignHint"})
