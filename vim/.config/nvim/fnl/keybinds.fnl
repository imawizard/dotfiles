(import-macros {: gset! : bind! : binds! : use! : feedkeys! : mode?} :macros)

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
 "<C-p>" ce! `(if (> (vim.fn.wildmenumode) 0) "<C-p>" "<Up>")
 "<C-n>" ce! `(if (> (vim.fn.wildmenumode) 0) "<C-n>" "<Down>")

 ;; Basic emacs bindings.
 "<C-b>"  ic!  "<Left>"
 "<C-f>"  ic!  "<Right>"
 "<C-d>"  c!   "<Del>"
 "<C-a>"  ie   `(.. "<ESC>" (if (> (vim.fn.col ".") 1) "0" "_") "i")
 "<C-a>"  c!   "<Home>"
 "<C-e>"  ie   `(if (> (vim.fn.pumvisible) 0) "<C-e>" "<End>")
 "<C-e>"  c!   "<End>"
 "<C-BS>" ict! "<C-w>"

 :desc "Open terminal"  "<C-z>" n ":FocusNuake<CR>"
 :desc "Open terminal"  "<C-z>" i "<C-o>:FocusNuake<CR>"
 :desc "Close terminal" "<C-z>" t "<C-\\><C-n>:Nuake<CR><C-w>p")

(fn _G.lsp? [capability]
  (var found false)
  (let [clients (vim.lsp.get_active_clients {:bufnr (vim.fn.bufnr)})]
    (each [_ client (ipairs clients)
           &until (not= found false)]
      (let [caps client.server_capabilities]
        (if (not= (. caps capability) nil)
            (set found true))))
    found))

(fn _G.ts? [module]
  (let [m (require module)]
    ((not= m nil))))

(fn _G.ts! [module func]
  (let [m (require module)
        f (?. m func)]
    (if (not= f nil) (f))))

(use!
 ;; See :help which-key.txt
 {:config
  (fn []
    (let [{: setup : register} (require :which-key)]
      (setup
       {:show_help false
        :key_labels {:<space> "SPC"
                     :<cr> "RET"
                     :<tab> "TAB"}
        :icons {:breadcrumb "›"
                :separator "➜"
                :group ""}
        :spelling {:enabled true}
        :layout {:spacing 6}})

      (register
       (binds!
        :desc "Lookup keyword" "<C-k>"    nxi `(if (not (mode? "i"))
                                                   (if (_G.lsp? :hoverProvider)
                                                       (vim.lsp.buf.hover)
                                                       (feedkeys! "K" "m"))
                                                   (if (_G.lsp? :signatureHelpProvider)
                                                       (vim.lsp.buf.signature_help)
                                                       (print "No support within current buffer")))
        :desc "Show error"     "K"        n   (. vim.diagnostic :open_float)
        :desc "Previous error" "[e"       n   (. vim.diagnostic :goto_prev)
        :desc "Next error"     "]e"       n   (. vim.diagnostic :goto_next)
        :desc "Set breakpoint" "<F2>"     n   `((. (require :dap) :toggle_breakpoint))
        :desc "Terminate"      "<C-S-F2>" n   `((. (require :dap) :terminate))
        :desc "Step out"       "<S-F9>"   n   `((. (require :dap) :step_out))
        :desc "Step into"      "<F7>"     n   `((. (require :dap) :step_into))
        :desc "Step over"      "<F8>"     n   `((. (require :dap) :step_over))
        :desc "Run"            "<F9>"     n   `((. (require :dap) :continue))

        (:prefix
         "<leader>" "SPC"
         :desc "Find file in project" "<leader>" n  `((. (require :telescope.builtin) :find_files))
         :desc "Find file"            "."        n! ":Files <C-r>=fnameescape(fnamemodify(getcwd(), ':~:.'))<CR>/"
         :desc "Show commands"        ":"        n  `((. (require :telescope.builtin) :commands))
         :desc "Show command history" "@:"       n  `((. (require :telescope.builtin) :command_history))
         (:prefix
          "b" "buffer"
          :desc "Switch buffer"   "b" n `((. (require :telescope.builtin) :buffers))
          :desc "Set filetype"    "f" n `((. (require :telescope.builtin) :filetypes))
          :desc "Next buffer"     "n" n ":bnext<CR>"
          :desc "Previous buffer" "p" n ":bprevious<CR>"
          :desc "Save buffer"     "s" n ":update<CR>")

         (:prefix
          "c" "code"
          :desc "Execute code action"        "a" n!  `(if (_G.lsp? :codeActionProvider)
                                                          (vim.lsp.buf.code_action)
                                                          (print "No support within current buffer"))
          :desc "Jump to definition"         "d" n!  `(if (_G.lsp? :definitionProvider) (vim.lsp.buf.definition)
                                                          (_G.ts? "nvim-treesitter-refactor.navigation") (_G.ts! :nvim-treesitter-refactor.navigation :goto_definition)
                                                          (feedkeys! "gd" "m"))
          :desc "Jump to declaration"        "D" n!  `(if (_G.lsp? :declarationProvider)
                                                          (vim.lsp.buf.declaration)
                                                          (feedkeys! "gD" "m"))
          :desc "Format buffer/region"       "f" nx! `(if (mode? "n")
                                                          (if (_G.lsp? :documentFormattingProvider)
                                                              (vim.lsp.buf.format)
                                                              (print "No support within current buffer"))
                                                          (if (_G.lsp? :documentRangeFormattingProvider)
                                                              (vim.lsp.buf.format)
                                                              (print "No support within current buffer")))
          :desc "Find implementations"       "i" n!  `(if (_G.lsp? :implementationProvider)
                                                          (vim.lsp.buf.implementation)
                                                          (print "No support within current buffer"))
          :desc "Organize imports"           "o" n!  `(print "No support within current buffer")
          :desc "Rename"                     "r" n!  `(if (_G.lsp? :renameProvider) (vim.lsp.buf.rename)
                                                          (_G.ts? "nvim-treesitter-refactor.smart_rename") (_G.ts! "nvim-treesitter-refactor.smart_rename" :smart_rename)
                                                          (print "No support within current buffer"))
          :desc "Find type definition"       "t" n!  `(if (_G.lsp? :typeDefinitionProvider)
                                                          (vim.lsp.buf.type_definition)
                                                          (print "No support within current buffer"))
          :desc "Find usages"                "u" n!  `(if (_G.lsp? :referencesProvider)
                                                          (vim.lsp.buf.references)
                                                          (print "No support within current buffer"))
          :desc "Delete trailing whitespace" "w" n   ":StripTrailingWS<CR>"
          :desc "List errors"                "x" n   ":Trouble<CR>"
          :desc "List errors in quickfix"    "X" n   (. vim.diagnostic :setqflist)
          (:prefix
           "l" "lsp"
           :desc "LSP Show capabilities" "i" n! ":lua =vim.lsp.get_active_clients()[1].server_capabilities"
           :desc "LSP Reload"            "r" n! `(do (vim.lsp.stop_client (vim.lsp.get_active_clients))
                                                     (vim.cmd "edit"))))

         (:prefix
          "e" "eval")

         (:prefix
          "f" "file"
          :desc "Browse private config"     "P" n ":Editrc<CR>"
          :desc "Recent files"              "r" n `((. (require :telescope.builtin) :oldfiles))
          :desc "Run file's tests"          "t" n ":TestFile<CR>"
          :desc "Run nearest test"          "T" n ":TestNearest<CR>"
          :desc "Yank file's path"          "y" n ":let @+='<C-r>=fnameescape(expand('%:~:p'))<CR>'<CR>"
          :desc "Yank file's relative path" "Y" n ":let @+='<C-r>=fnameescape(expand('%:~'))<CR>'<CR>")

         (:prefix
          "g" "git"
          :desc "Switch branch" "b" n ":Git branch<CR>"
          :desc "Blame"         "B" n ":Git blame<CR>"
          :desc "Show status"   "g" n ":Git<CR>"
          :desc "Stage file"    "S" n ":Gdiffsplit<CR>"
          (:prefix
           "c" "create"
           :desc "Initialize repo" "r" n ":Git init")
          (:prefix
           "f" "find"
           :desc "Find file commit" "c" n ":BCommits<CR>"
           :desc "Find commit"      "C" n ":Commits<CR>"))

         (:prefix
          "i" "insert"
          :desc "Insert file's name"    "f" n "i<C-r>=expand('%:t')<CR><ESC>l"
          :desc "Insert file's path"    "F" n "i<C-r>=fnameescape(expand('%:~'))<CR><ESC>l"
          :desc "Insert snippet"        "s" n `((. (require :telescope.builtin) :snippets))
          :desc "Insert from yank list" "y" n `((. (require :telescope.builtin) :yanks)))

         (:prefix
          "n" "number"
          :desc "Convert number to binary"  "b" n "ciw<C-r>=printf('0b%b', <C-r>\")<CR><ESC>"
          :desc "Convert number to decimal" "d" n "ciw<C-r>=printf('%d', <C-r>\")<CR><ESC>"
          :desc "Convert number to octal"   "o" n "ciw<C-r>=printf('0o%o', <C-r>\")<CR><ESC>"
          :desc "Print number"              "p" n ":echo printf('<%s> %d 0x%x 0o%o 0b%b', '<C-r><C-w>', <C-r><C-w>, <C-r><C-w>, <C-r><C-w>, <C-r><C-w>)<CR>"
          :desc "Convert number to hex"     "x" n "ciw<C-r>=printf('0x%x', <C-r>\")<CR><ESC>")

         (:prefix
          "o" "open"
          :desc "Reveal file in Finder"        "o" n ":exe '!open -R <C-r>=fnameescape(expand('%:p'))<CR>'<CR>"
          :desc "Reveal project in Finder"     "O" n ":exe '!open <C-r>=fnameescape(getcwd())<CR>'<CR>"
          :desc "Open file"                    "f" n ":Fern <C-r>=fnameescape(expand('%:p:h'))<CR> -reveal=<C-r>=fnameescape(expand('%:p'))<CR><CR>"
          :desc "Project sidebar"              "p" n ":NERDTreeFocus<CR>"
          :desc "Find file in project sidebar" "P" n ":NERDTreeFind<CR>"
          :desc "Toggle terminal popup"        "t" n ":terminal<CR>")

         (:prefix
          "p" "project"
          :desc "Add new project"      "a" n ":NERDTree<CR>:EditBookmarks<CR>"
          :desc "Remove known project" "d" n ":NERDTree<CR>:EditBookmarks<CR>"
          :desc "Switch project"       "p" n ":NERDTreeFromBookmark <C-z>"
          :desc "List project todos"   "t" n ":CtrlSF -R '(TODO|NOTE|HACK|OPTIMIZE|XXX)(\\([^)]+\\))?:' '<C-r>=getcwd()<CR>'"
          :desc "Test project"         "T" n ":TestSuite<CR>")

         (:prefix
          "q" "quit"
          :desc "Quit"                "q" n ":qa<CR>"
          :desc "Quit without saving" "Q" n ":qa!<CR>")

         (:prefix
          "s" "search"
          :desc "Search buffer"            "b" n  `((. (require :telescope.builtin) :lines))
          :desc "Search all open buffers"  "B" n  `((. (require :telescope.builtin) :all_lines))
          :desc "Search current directory" "d" n  `((. (require :telescope.builtin) :live_grep))
          :desc "Search other directory"   "D" n! ": '<C-r>=fnameescape(fnamemodify(getcwd(), ':~:.'))<CR>'<Home>CtrlSF "
          :desc "Locate file"              "f" n  ":Locate "
          :desc "Search workspace symbols" "i" n  `(if (_G.lsp? :workspaceSymbolProvider)
                                                       (print "lsp") ; vim.lsp.buf.workspace_symbol
                                                       (print "kein lsp"))
          :desc "Search jump list"         "j" n  ":Jumplist<CR>"
          :desc "Look up in local docsets" "k" n  "<Plug>DashSearch"
          :desc "Jump to mark"             "r" n  `((. (require :telescope.builtin) :marks))
          :desc "Search buffer symbols"    "s" n  `(if (_G.lsp? :documentSymbolProvider)
                                                       (print "lsp") ; vim.lsp.buf.document_symbol
                                                       (print "kein lsp"))
          :desc "Search tags"              "t" n  `((. (require :telescope.builtin) :tags))
          :desc "Search buffer tags"       "T" n  `((. (require :telescope.builtin) :buffer_tags)))

         (:prefix
          "t" "toggle"
          :desc "Colored column"        "c" n  ":set <C-r>=&cc ? 'colorcolumn=' : 'colorcolumn=80'<CR><CR>"
          :desc "Cursor column"         "C" n  ":set cursorcolumn!<CR>"
          :desc "Diff buffer"           "d" n  ":<C-r>=&diff ? 'diffoff' : 'diffthis'<CR><CR>"
          :desc "Cycle folding"         "f" n  ":call CycleFolding()<CR>"
          :desc "Line numbers"          "l" n! ":set number!<CR>"
          :desc "Relative line numbers" "L" n! ":set relativenumber!<CR>"
          :desc "Virtual editing"       "v" n! ":set <C-r>=&ve =~# 'all' ? 'virtualedit-=all' : 'virtualedit+=all'<CR><CR>"
          :desc "Soft line wrapping"    "w" n! ":set wrap!<CR>"
          (:prefix
           "D" "diffing"
           :desc "Cycle diff-algo"               "a" n ":call CycleDiffAlgo()<CR>"
           :desc "Turn off diff for all buffers" "o" n ":diffoff!<CR>")
          (:prefix
           "i" "indentation"
           :desc "Toggle indent"                   "i" n! ":set expandtab!<CR>"
           :desc "Increase indent"                 ">" n  ":set ts=<C-r>=&ts+2<CR>|set sw=<C-r>=&sw+2<CR><CR>"
           :desc "Decrease indent"                 "<" n  ":set ts=<C-r>=&ts-2<CR>|set sw=<C-r>=&sw-2<CR><CR>"
           :desc "Replace according to &expandtab" "R" n  ":<C-r>=&et ? 'Tb2Sp' : 'Sp2Tb'<CR><CR>"
           :desc "Replace according to &expandtab" "r" x  ":set <C-r>=&et ? 'Sp2Tb' : 'Tb2Sp'<CR><CR>"
           :desc "Replace with spaces"             "s" x  ":Tb2Sp<CR>"
           :desc "Replace with tabs"               "t" x  ":Sp2Tb<CR>"))

         (:prefix
          "w" "workspace"
          :desc "Add workspace folder"    "a" n `(vim.lsp.buf.add_workspace_folder)
          :desc "Remove workspace folder" "d" n `(vim.lsp.buf.remove_workspace_folder)
          :desc "List workspace folders"  "l" n ":lua =vim.inspect(vim.lsp.buf.list_workspace_folders())\n"))

        (:prefix
         "<C-h>" "help"
         :desc "Show syntax highlight group"                  "s" n ":call ShowSyntaxGroups()<CR>"
         :desc "Show syntax highlight groups with treesitter" "t" n ":TSHighlightCapturesUnderCursor<CR>"
         (:prefix
          "b" "bindings"
          :desc "Show all" "b" n ":Maps<CR>")
         (:prefix
          "p" "packer"
          :desc "Clean"       "c" n! ":PackerClean<CR>"
          :desc "Install"     "i" n! ":PackerInstall<CR>"
          :desc "Status"      "s" n! ":PackerStatus<CR>"
          :desc "Update/Sync" "u" n! ":PackerSync<CR>")
         (:prefix
          "r" "reload"
          :desc ".vimrc" "r" n! ":Reload<CR>"))

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
         :desc "Complete vim command"         "<C-v>" i "<C-x><C-v>")))))}
 :folke/which-key.nvim)
