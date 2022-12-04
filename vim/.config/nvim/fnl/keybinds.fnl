(import-macros {: gset! : bind! : binds! : use! : feedkeys! : mode?
                : has? : selected-text!} :macros)

(gset!
 mapleader " "
 maplocalleader " ")

(bind!
 ;; Use jk to cycle through panes (counter-)clockwise and JK to swap them.
 "<C-w>j" n "<C-w>w"
 "<C-w>k" n "<C-w>W"
 "<C-w>J" n "mX<C-w>wmY'X<C-w>W'Y<C-w>w"
 "<C-w>K" n "mX<C-w>WmY'X<C-w>w'Y<C-w>W"

 ;; Like tmux's break-pane binding.
 "<C-w>!" n "<C-w>T"

 ;; Switch panes in terminal mode.
 "<C-w><C-w>" t "<C-\\><C-n><C-w><C-w>"
 "<C-w>j"     t "<C-\\><C-n><C-w>w"
 "<C-w>k"     t "<C-\\><C-n><C-w>W"

 ;; Move current line up and down.
 "<C-9>" n ":move .+1<CR>=="
 "<C-0>" n ":move .-2<CR>=="
 "<C-9>" i "<ESC>:move .+1<CR>==gi"
 "<C-0>" i "<ESC>:move .-2<CR>==gi"
 "<C-9>" x ":move '>+1<CR>gv=gv"
 "<C-0>" x ":move '<-2<CR>gv=gv"

 ;; Move through wrapped lines.
 "j" n "gj"
 "k" n "gk"
 "j" x "gj"
 "k" x "gk"

 ;; Paste and keep clipboard.
 "p" x "pgvy"

 ;; Start search with '(very) magic'.
 "/"   n! "/\\v"
 "?"   n! "?\\v"
 "%s/" c! "%sm//g<Left><Left>"

 ;; Don't exit visual mode on shifting.
 "<" x "<gv"
 ">" x ">gv"

 ;; Yank till the end of the line.
 "Y" n "y$"

 ;; Clear matches and redraw diff and syntax highlighting.
 "<C-l>" n ":nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>"

 ;; Same C-m (Return) as in insert mode.
 "<CR>" n "o<ESC>"

 ;; Same C-j as in Emacs.
 "<C-j>" n "i<CR><ESC>"

 ;; Start new change before Ctrl-U and Ctrl-W for undo.
 "<C-u>" i "<C-g>u<C-u>"
 "<C-w>" i "<C-g>u<C-w>"

 ;; Respect an already typed prefix when iterating through history.
 "<C-p>" ce! #(if (> (vim.fn.wildmenumode) 0) "<C-p>" "<Up>")
 "<C-n>" ce! #(if (> (vim.fn.wildmenumode) 0) "<C-n>" "<Down>")

 ;; Basic emacs bindings.
 "<C-b>"  ic!  "<Left>"
 "<C-f>"  ic!  "<Right>"
 "<C-d>"  c!   "<Del>"
 "<C-a>"  ie   #(.. "<ESC>" (if (> (vim.fn.col ".") 1) "0" "_") "i")
 "<C-a>"  c!   "<Home>"
 "<C-e>"  ie   #(if (> (vim.fn.pumvisible) 0) "<C-e>" "<End>")
 "<C-e>"  c!   "<End>"
 "<C-BS>" ict! "<C-w>"

 ;; Make original C-e accessible through S-C-y.
 "<S-C-y>" i "<C-e>"

 ;; <Leader> bindings and more.
 :desc "Lookup keyword"      "<C-k>"    nx #(if (_G.lsp? :hoverProvider)
                                                (vim.lsp.buf.hover)
                                                (feedkeys! "K" "m"))
 :desc "Show signature help" "<C-k>"    i  #(if (_G.lsp? :signatureHelpProvider)
                                                (vim.lsp.buf.signature_help)
                                                (print "No support within current buffer"))
 :desc "Open terminal"       "<C-z>"    n  ":FocusNuake<CR>"
 :desc "Open terminal"       "<C-z>"    i  "<C-o>:FocusNuake<CR>"
 :desc "Close terminal"      "<C-z>"    t  "<C-\\><C-n>:Nuake<CR><C-w>p"

 :desc "Show error"          "K"        n  (. vim.diagnostic :open_float)
 :desc "Previous error"      "[e"       n  (. vim.diagnostic :goto_prev)
 :desc "Next error"          "]e"       n  (. vim.diagnostic :goto_next)
 :desc "Previous change"     "[c"       ne "&diff ? '[c' : ':Gitsigns prev_hunk<CR>'"
 :desc "Next change"         "]c"       ne "&diff ? ']c' : ':Gitsigns next_hunk<CR>'"

 :desc "Set breakpoint"      "<F2>"     n  #((. (require :dap) :toggle_breakpoint))
 :desc "Terminate"           "<C-S-F2>" n  #((. (require :dap) :terminate))
 :desc "Step out"            "<S-F9>"   n  #((. (require :dap) :step_out))
 :desc "Step into"           "<F7>"     n  #((. (require :dap) :step_into))
 :desc "Step over"           "<F8>"     n  #((. (require :dap) :step_over))
 :desc "Run"                 "<F9>"     n  #((. (require :dap) :continue))

 (:prefix
  "<leader>" "SPC"
  :desc "Find file in project" "<leader>" n  #((. (require :telescope.builtin) :find_files) {:tiebreak (_G.oldfiles_tiebreak)})
  :desc "Find relative file"   "."        n  #((. (require :telescope.builtin) :find_files) {:tiebreak (_G.oldfiles_tiebreak) :cwd (vim.fn.expand "%:p:h")})
  :desc "Grep project"         "/"        n  #((. (require :telescope.builtin) :live_grep))
  :desc "Grep project"         "/"        x  #((. (require :telescope.builtin) :grep_string) {:search (selected-text!)})
  :desc "Grep relative files"  "\\"       n  #((. (require :telescope.builtin) :live_grep) {:cwd (vim.fn.expand "%:p:h")})
  :desc "Resume last search"   "\""       n  #((. (require :telescope.builtin) :resume))
  :desc "Show commands"        ":"        n  #((. (require :telescope.builtin) :commands))
  :desc "Show command history" "@:"       n  #((. (require :telescope.builtin) :command_history))
  :desc "Show search history"  "@/"       n  #((. (require :telescope.builtin) :search_history))

  (:prefix
   "b" "buffer"
   :desc "Switch buffer"   "b" n #((. (require :telescope.builtin) :buffers))
   :desc "Set filetype"    "f" n #((. (require :telescope.builtin) :filetypes))
   :desc "Next buffer"     "n" n ":bnext<CR>"
   :desc "Previous buffer" "p" n ":bprevious<CR>"
   :desc "Save buffer"     "s" n ":update<CR>")

  (:prefix
   "c" "code"
   :desc "Execute code action"        "a" n! #(if (_G.lsp? :codeActionProvider)
                                                  (vim.lsp.buf.code_action)
                                                  (print "No support within current buffer"))
   :desc "Jump to definition"         "d" n! #(if (_G.lsp? :definitionProvider) (vim.cmd ":TroubleToggle lsp_definitions")
                                                  (feedkeys! "gd" "m"))
   :desc "Jump to declaration"        "D" n! #(if (_G.lsp? :declarationProvider)
                                                  (vim.lsp.buf.declaration)
                                                  (feedkeys! "gD" "m"))
   :desc "Format buffer"              "f" n! #(if (_G.lsp? :documentFormattingProvider)
                                                  (vim.lsp.buf.format)
                                                  (print "No support within current buffer"))
   :desc "Format region"              "f" x! #(if (_G.lsp? :documentRangeFormattingProvider)
                                                  (vim.lsp.buf.format)
                                                  (print "No support within current buffer"))
   :desc "Find implementations"       "i" n! #(if (_G.lsp? :implementationProvider)
                                                  (vim.cmd ":TroubleToggle lsp_implementations")
                                                  (print "No support within current buffer"))
   :desc "Organize imports"           "o" n! #(if (_G.lsp-organize-imports?)
                                                  (_G.lsp-organize-imports!)
                                                  (print "No support within current buffer"))
   :desc "Rename"                     "r" n! #(if (_G.lsp? :renameProvider) (vim.lsp.buf.rename)
                                                  (print "No support within current buffer"))
   :desc "Find type definition"       "t" n! #(if (_G.lsp? :typeDefinitionProvider)
                                                  (vim.cmd ":TroubleToggle lsp_type_definitions")
                                                  (print "No support within current buffer"))
   :desc "Find usages"                "u" n! #(if (_G.lsp? :referencesProvider)
                                                  (vim.cmd ":TroubleToggle lsp_references")
                                                  (print "No support within current buffer"))
   :desc "Delete trailing whitespace" "w" n  ":StripTrailingWS<CR>"
   :desc "List errors"                "x" n  ":Trouble<CR>"
   :desc "List project todos"         "X" n! ":CtrlSF -R '(TODO|NOTE|HACK|OPTIMIZE|XXX)(\\([^)]+\\))?:' '<C-r>=getcwd()<CR>'"
   :desc "List incoming calls"        "y" n  ":Trouble lsp_incoming_calls<CR>"
   :desc "List outgoing calls"        "Y" n  ":Trouble lsp_outgoing_calls<CR>"

   (:prefix
    "l" "lsp"
    :desc "LSP Show capabilities" "c" n! ":lua =vim.lsp.get_active_clients()[1].server_capabilities<CR>"
    :desc "LSP Reload"            "r" n! #(do (vim.lsp.stop_client (vim.lsp.get_active_clients)) (vim.cmd "edit"))))

  (:prefix
   "f" "file"
   :desc "Recent files"              "r" n #((. (require :telescope.builtin) :oldfiles))
   :desc "Run file's tests"          "t" n ":TestFile<CR>"
   :desc "Run nearest test"          "T" n ":TestNearest<CR>"
   :desc "Yank file's path"          "y" n ":let @+='<C-r>=fnameescape(expand('%:p:~'))<CR>'<CR>"
   :desc "Yank file's relative path" "Y" n ":let @+='<C-r>=fnameescape(expand('%:~'))<CR>'<CR>")

  (:prefix
   "g" "git"
   :desc "Branches"             "b" n #((. (require :telescope.builtin) :git_branches))
   :desc "File-related commits" "c" n #((. (require :telescope.builtin) :git_bcommits))
   :desc "Commits"              "C" n #((. (require :telescope.builtin) :git_commits))
   :desc "Files"                "f" n #((. (require :telescope.builtin) :git_files))
   :desc "Status"               "g" n #((. (require :telescope.builtin) :git_status))
   :desc "Blame"                "m" n ":GitMessenger<CR>"
   :desc "Stash"                "s" n #((. (require :telescope.builtin) :git_stash)))

  (:prefix
   "i" "insert"
   :desc "Emoji"        "e" n #((. (require :telescope.builtin) :symbols) {:sources ["emoji"]})
   :desc "Filename"     "f" n "i<C-r>=expand('%:t')<CR><ESC>l"
   :desc "Gitmoji"      "g" n #((. (require :telescope.builtin) :symbols) {:sources ["gitmoji"]})
   :desc "Symbol"       "i" n #((. (require :telescope.builtin) :symbols) {:sources ["julia"]})
   :desc "LaTeX symbol" "l" n #((. (require :telescope.builtin) :symbols) {:sources ["latex"]})
   :desc "Filepath"     "p" n "i<C-r>=fnameescape(expand('%:p:~'))<CR><ESC>l"
   :desc "Snippet"      "s" n #((. (require :telescope) :extensions :luasnip :luasnip)))

  (:prefix
   "n" "number"
   :desc "Convert to binary"  "b" n "ciw<C-r>=printf('0b%b', <C-r>\")<CR><ESC>b"
   :desc "Convert to decimal" "d" n "ciw<C-r>=printf('%d', <C-r>\")<CR><ESC>b"
   :desc "Convert to hex"     "h" n "ciw<C-r>=printf('0x%x', <C-r>\")<CR><ESC>b"
   :desc "Convert to octal"   "o" n "ciw<C-r>=printf('0o%o', <C-r>\")<CR><ESC>b"
   :desc "Print radix"        "p" n ":echo printf('<%s> %d 0x%x 0o%o 0b%b', '<C-r><C-w>', <C-r><C-w>, <C-r><C-w>, <C-r><C-w>, <C-r><C-w>)<CR>")

  (:prefix
   "o" "open"
   :desc "Reveal file in Finder"        "o" ne #(if (has? "mac") ":exe 'silent !open -R <C-r>=fnameescape(expand('%:p'))<CR>'<CR>"
                                                    (has? "win32") ":exe 'silent !explorer /select,\"<C-r>=fnameescape(expand('%:p'))<CR>\"'<CR>")
   :desc "Reveal project in Finder"     "O" ne #(if (has? "mac") ":exe 'silent !open <C-r>=fnameescape(getcwd())<CR>'<CR>"
                                                    (has? "win32") ":exe 'silent !explorer <C-r>=fnameescape(getcwd())<CR>'<CR>")
   :desc "Project sidebar"              "p" n  ":NvimTreeFocus<CR>"
   :desc "Find file in project sidebar" "P" n  ":NvimTreeFindFile<CR>"
   :desc "Tagbar"                       "t" n  ":TagbarOpen 'fj'<CR>"
   :desc "Undotree"                     "u" n  ":UndotreeShow<CR>"
   :desc "Vinegar"                      "v" n  #((. (require "nvim-tree") :open_replacing_current_buffer)))

  (:prefix
   "p" "project"
   :desc "Add new project"      "a" n! ":!zoxide add <C-r>=fnameescape(getcwd())<CR>"
   :desc "Remove known project" "d" n! ":!zoxide remove <C-r>=fnameescape(getcwd())<CR>"
   :desc "Switch project"       "p" n  #((. (require :telescope) :extensions :project :project)))

  (:prefix
   "q" "quit"
   :desc "Quit"                "q" n ":qa<CR>"
   :desc "Quit without saving" "Q" n ":qa!<CR>")

  (:prefix
   "s" "search"
   :desc "Search and replace" "/" n! ": '<C-r>=fnameescape(fnamemodify(getcwd(), ':~:.'))<CR>'<Home>CtrlSF "
   :desc "Buffer"             "b" n  #((. (require :telescope.builtin) :current_buffer_fuzzy_find))
   :desc "All open buffers"   "B" n  #((. (require :telescope.builtin) :live_grep {:grep_open_files true}))
   :desc "Workspace symbols"  "i" n  #(if (_G.lsp? :workspaceSymbolProvider)
                                          (vim.lsp.buf.workspace_symbol)
                                          (print "No support within current buffer"))
   :desc "Jump list"          "j" n  #((. (require :telescope.builtin) :jumplist))
   :desc "Docset"             "k" n  #(_G.DashSearch {:query (vim.fn.expand "<cword>")})
   :desc "All docsets"        "K" n  #(_G.DashSearch {:query (vim.fn.expand "<cword>") :docsets "all"})
   :desc "Docset"             "k" x  #(_G.DashSearch {:query (selected-text!)})
   :desc "All docsets"        "K" x  #(_G.DashSearch {:query (selected-text!) :docsets "all"})
   :desc "Marks"              "r" n  #((. (require :telescope.builtin) :marks))
   :desc "Buffer symbols"     "s" n  #(if (_G.lsp? :documentSymbolProvider)
                                          (vim.lsp.buf.document_symbol)
                                          (print "No support within current buffer"))
   :desc "Tags"               "t" n  #((. (require :telescope.builtin) :tags))
   :desc "Buffer tags"        "T" n  #((. (require :telescope.builtin) :current_buffer_tags))
   :desc "Zoxide"             "z" n  #((. (require :telescope) :extensions :zoxide :list)))

  (:prefix
   "t" "toggle"
   :desc "Cursor column"         "c" n! ":set <C-r>=&cuc ? 'nocursorcolumn' : 'cursorcolumn'<CR><CR>"
   :desc "Colored column"        "C" n! ":set <C-r>=&cc ? 'colorcolumn=' : 'colorcolumn=80'<CR><CR>"
   :desc "Diff buffer"           "d" n  ":<C-r>=&diff ? 'diffoff' : 'diffthis'<CR><CR>"
   :desc "Cycle diff-algo"       "D" n  ":call CycleDiffAlgo()<CR>"
   :desc "Cycle folding"         "f" n  ":call CycleFolding()<CR>"
   :desc "Line numbers"          "l" n! ":set <C-r>=&nu ? 'nonumber' : 'number'<CR><CR>"
   :desc "Relative line numbers" "L" n! ":set <C-r>=&rnu ? 'norelativenumber' : 'relativenumber'<CR><CR>"
   :desc "Virtual editing"       "v" n! ":set <C-r>=&ve =~# 'all' ? 'virtualedit-=all' : 'virtualedit+=all'<CR><CR>"
   :desc "Soft line wrapping"    "w" n! ":set <C-r>=&wrap ? 'nowrap' : 'wrap'<CR><CR>"
   (:prefix
    "i" "indentation"
    :desc "Toggle expandtab"                "i" n! ":set <C-r>=&et ? 'noexpandtab' : 'expandtab'<CR><CR>"
    :desc "Increase indent"                 ">" n! ":set ts=<C-r>=&ts+2<CR>|set sw=<C-r>=&sw+2<CR><CR>"
    :desc "Decrease indent"                 "<" n! ":set ts=<C-r>=&ts-2<CR>|set sw=<C-r>=&sw-2<CR><CR>"
    :desc "Replace according to &expandtab" "r" nx ":<C-r>=&et ? 'Sp2Tb' : 'Tb2Sp'<CR><CR>"
    :desc "Replace with spaces"             "s" nx ":Tb2Sp<CR>"
    :desc "Replace with tabs"               "t" nx ":Sp2Tb<CR>"))

  (:prefix
   "w" "workspace"
   :desc "Add folder"    "a" n #(vim.lsp.buf.add_workspace_folder)
   :desc "Remove folder" "d" n #(vim.lsp.buf.remove_workspace_folder)
   :desc "List folders"  "l" n ":lua =vim.inspect(vim.lsp.buf.list_workspace_folders())\n"))

 (:prefix
  "<C-h>" "help"
  (:prefix
   "b" "bindings"
   :desc "List all" "b" n #((. (require :telescope.builtin) :keymaps)))
  (:prefix
   "h" "highlights"
   :desc "What's under cursor" "c" n ":TSHighlightCapturesUnderCursor<CR>"
   :desc "List all"            "l" n #((. (require :telescope.builtin) :highlights)))
  (:prefix
   "p" "packer"
   :desc "Compile"         "c" n! ":PackerCompile<CR>"
   :desc "Clean"           "C" n! ":PackerClean<CR>"
   :desc "Install"         "i" n! ":PackerInstall<CR>"
   :desc "List packages"   "l" n! ":PackerStatus<CR>"
   :desc "Browse packages" "p" n #((. (require :telescope) :extensions :packer :packer))
   :desc "Sync"            "s" n! ":PackerSync<CR>")
  (:prefix
   "r" "reload"
   :desc "Edit config"   "e" n  ":Editrc<CR>"
   :desc "Lua package"   "p" n  #((. (require :telescope.builtin) :reloader))
   :desc "Config"        "r" n! ":Reload<CR>"
   :desc "Edit Snippets" "s" n  #(_G.luasnip_edit_snippets)))

 (:prefix
  "<C-x>" "completion"
  :desc "Scroll window one line up"    "<C-e>" i "<C-x><C-e>"
  :desc "Scroll window one line down"  "<C-y>" i "<C-x><C-y>"
  :desc "Complete definition"          "<C-d>" i "<C-x><C-d>"
  :desc "Complete filename"            "<C-f>" i "<C-x><C-f>"
  :desc "Complete tag"                 "<C-]>" i "<C-x><C-]>"
  :desc "Complete keyword"             "<C-i>" i "<C-x><C-i>"
  :desc "Complete with thesaurus"      "<C-t>" i "<C-x><C-t>"
  :desc "Complete with dictionary"     "<C-k>" i "<C-x><C-k>"
  :desc "Complete keyword (forwards)"  "<C-n>" i "<C-x><C-n>"
  :desc "Complete keyword (backwards)" "<C-p>" i "<C-x><C-p>"
  :desc "Complete line"                "<C-l>" i "<C-x><C-l>"
  :desc "Complete with spell checking" "<C-s>" i "<C-x><C-s>"
  :desc "Complete with spell checking" "s"     i "<C-x>s"
  :desc "Omni completion"              "<C-o>" i "<C-x><C-o>"
  :desc "User defined completion"      "<C-u>" i "<C-x><C-u>"
  :desc "Complete vim command"         "<C-v>" i "<C-x><C-v>"))

(use!
 ;; See :help which-key.txt.
 {:config
  (fn []
    (let [{: setup : register} (require :which-key)]
      (setup {:show_help false
              :key_labels {:<space> "SPC"
                           :<cr> "RET"
                           :<tab> "TAB"}
              :icons {:breadcrumb "›"
                      :separator "➜"
                      :group ""}
              :spelling {:enabled true}
              :layout {:spacing 6}})

      (register {:<leader>   {:name "SPC"}
                 :<leader>b  {:name "buffer"}
                 :<leader>c  {:name "code"}
                 :<leader>cl {:name "lsp"}
                 :<leader>f  {:name "file"}
                 :<leader>g  {:name "git"}
                 :<leader>gc {:name "create"}
                 :<leader>gf {:name "find"}
                 :<leader>i  {:name "insert"}
                 :<leader>n  {:name "number"}
                 :<leader>o  {:name "open"}
                 :<leader>p  {:name "project"}
                 :<leader>q  {:name "quit"}
                 :<leader>s  {:name "search"}
                 :<leader>t  {:name "toggle"}
                 :<leader>ti {:name "indentation"}
                 :<leader>w  {:name "workspace"}
                 :<C-h>      {:name "help"}
                 :<C-h>b     {:name "bindings"}
                 :<C-h>h     {:name "highlights"}
                 :<C-h>p     {:name "packer"}
                 :<C-h>r     {:name "reload"}
                 :<C-x>      {:name "completion"}})))}
 :folke/which-key.nvim)
