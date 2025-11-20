(import-macros {: bind! : use! : mode? : has?} :macros)

(bind!
 (:prefix
  "<Space>" "SPC"
  :desc "Find file in project" "f"  n  #(FzfLua.files)
  ;;;;;;;;;;;; :desc "Find relative file"   "."  n  #((. (require :telescope.builtin) :find_files) {:tiebreak (_G.oldfiles_tiebreak) :cwd (vim.fn.expand "%:p:h")})
  :desc "Grep project"         "/"  n  #(FzfLua.live_grep_native)
  :desc "Grep project"         "/"  x  #(FzfLua.live_grep_native {:search (table.concat (_G.selected-text) "\n")})
  ;;;;;;;;;;;; :desc "Grep relative files"  "\\" n  #((. (require :telescope.builtin) :live_grep) {:cwd (vim.fn.expand "%:p:h")})
  :desc "Resume last search"   "\"" n  #(FzfLua.resume)
  :desc "Show commands"        ":"  n  #(FzfLua.commands)

  ;;;;;;;;;;; :desc "Run file's tests"          "t" n ":TestFile<CR>"
  ;;;;;;;;;;; :desc "Run nearest test"          "T" n ":TestNearest<CR>"
  ;;;;;;;;;;; :desc "File's tests" "f" n  ":TestFile<CR>"
  ;;;;;;;;;;; :desc "Nearest test" "n" n  ":TestNearest<CR>"
  ;;;;;;;;;;; :desc "Last test"    "t" n  ":TestLast<CR>"
  ;;;;;;;;;;; :desc "Program"      "r" n! #(vim.notify "No support within current buffer")
  ;;;;;;;;;;; :desc "Test project" "p" n  ":TestSuite<CR>")

  (:prefix
   "b" "Buffer"
   :desc "Switch buffer"   "b" n #(FzfLua.buffers)
   :desc "Set filetype"    "f" n #(FzfLua.filetypes)
   :desc "Next buffer"     "n" n ":bnext<CR>"
   :desc "Previous buffer" "p" n ":bprevious<CR>"
   :desc "Save buffer"     "s" n ":update<CR>")

  (:prefix
   "c" "Code"
   :desc "Compile"                    "c" n! ":make<CR>"
   :desc "Format buffer"              "f" n! #(if (_G.lsp? :documentFormattingProvider)
                                                  (vim.lsp.buf.format)
                                                  (vim.notify "No support within current buffer"))
   :desc "Format region"              "f" x! #(if (_G.lsp? :documentRangeFormattingProvider)
                                                  (vim.lsp.buf.format)
                                                  (vim.notify "No support within current buffer"))
   :desc "Organize imports"           "o" n! #(if (_G.lsp-organize-imports?)
                                                  (_G.lsp-organize-imports!)
                                                  (vim.notify "No support within current buffer"))
   :desc "Find type definition"       "t" n! #(if (_G.lsp? :typeDefinitionProvider)
                                                  (vim.cmd ":TroubleToggle lsp_type_definitions")
                                                  (vim.notify "No support within current buffer"))
   :desc "Delete trailing whitespace" "w" n  ":StripTrailingWS<CR>"
   :desc "List errors"                "x" n  ":Trouble<CR>"
   :desc "List project todos"         "X" n! ":CtrlSF -R '(TODO|NOTE|HACK|OPTIMIZE|XXX)(\\([^)]+\\))?:' '<C-r>=getcwd()<CR>'"
   :desc "List incoming calls"        "y" n  ":Trouble lsp_incoming_calls<CR>"
   :desc "List outgoing calls"        "Y" n  ":Trouble lsp_outgoing_calls<CR>"

   (:prefix
    "l" "Lsp"
    :desc "Show capabilities" "c" n! ":lua =vim.lsp.get_active_clients()[1].server_capabilities<CR>"
    :desc "Show DAP configs"  "d" n! ":lua =require('dap').configurations<CR>"
    :desc "Reload server"     "r" n! #(do (vim.lsp.stop_client (vim.lsp.get_active_clients)) (vim.cmd "edit"))))

  (:prefix
   "e" "Eval"
   :desc "Evaluate selection" "ee" n #(vim.notify "No support within current buffer"))

  (:prefix
   "g" "Git"
   :desc "Branches"             "b" n #(FzfLua.git_branches)
   :desc "File-related commits" "c" n #(FzfLua.git_bcommits)
   :desc "Commits"              "C" n #(FzfLua.git_commits)
   :desc "Files"                "f" n #(FzfLua.git_files)
   :desc "Status"               "g" n #(FzfLua.git_status)
   :desc "Blame"                "m" n ":GitMessenger<CR>"
   :desc "Stash"                "s" n #(FzfLua.git_stash))

  (:prefix
   "i" "Insert"
   :desc "Filename"     "f" n "i<C-r>=expand('%:t')<CR><ESC>l"
   :desc "Filepath"     "p" n "i<C-r>=fnameescape(expand('%:p:~'))<CR><ESC>l")

  (:prefix
   "n" "Number"
   :desc "Convert to binary"  "b" n "ciw<C-r>=printf('0b%b', <C-r>\")<CR><ESC>b"
   :desc "Convert to decimal" "d" n "ciw<C-r>=printf('%d', <C-r>\")<CR><ESC>b"
   :desc "Convert to hex"     "h" n "ciw<C-r>=printf('0x%x', <C-r>\")<CR><ESC>b"
   :desc "Convert to octal"   "o" n "ciw<C-r>=printf('0o%o', <C-r>\")<CR><ESC>b"
   :desc "Print radix"        "p" n ":echo printf('<%s> %d 0x%x 0o%o 0b%b', '<C-r><C-w>', <C-r><C-w>, <C-r><C-w>, <C-r><C-w>, <C-r><C-w>)<CR>")

  (:prefix
   "o" "Open"
   :desc "Reveal file in Finder"        "o" ne #(if (has? "mac") ":exe 'silent !open -R <C-r>=fnameescape(expand('%:p'))<CR>'<CR>"
                                                    (has? "win32") ":exe 'silent !explorer /select,\"<C-r>=fnameescape(expand('%:p'))<CR>\"'<CR>")
   :desc "Reveal project in Finder"     "O" ne #(if (has? "mac") ":exe 'silent !open <C-r>=fnameescape(getcwd())<CR>'<CR>"
                                                    (has? "win32") ":exe 'silent !explorer <C-r>=fnameescape(getcwd())<CR>'<CR>")
   :desc "Project sidebar"              "p" n  ":NvimTreeFocus<CR>"
   :desc "Find file in project sidebar" "P" n  ":NvimTreeFindFile<CR>"
   :desc "Tagbar"                       "t" n  ":TagbarOpen 'fj'<CR>"
   :desc "Symbols outline"              "s" n  #((. (require :symbols-outline) :toggle_outline))
   :desc "Undotree"                     "u" n  ":UndotreeShow<CR>"
   :desc "Vinegar"                      "v" n  #((. (require :nvim-tree) :open_replacing_current_buffer)))

  (:prefix
   "r" "Recent"
   :desc "Files"              "f" n #(FzfLua.oldfiles)
   :desc "Commands" ":" n  #(FzfLua.command_history)
   :desc "Search"  "/" n  #(FzfLua.search_history)
   :desc "Directories"  "r" n  #(FzfLua.zoxide))

  (:prefix
   "s" "Search"
   :desc "Search and replace" "/" n! ": '<C-r>=fnameescape(fnamemodify(getcwd(), ':~:.'))<CR>'<Home>CtrlSF "
   :desc "Buffer"             "b" n  #(FzfLua.blines)
   :desc "All open buffers"   "B" n  #(FzfLua.lines)
   :desc "Workspace symbols"  "i" n  #(if (_G.lsp? :workspaceSymbolProvider)
                                          (vim.lsp.buf.workspace_symbol)
                                          (vim.notify "No support within current buffer"))
   :desc "Jump list"          "j" n  #(FzfLua.jumps)
   :desc "Docset"             "k" n  #(_G.DashSearch {:query (vim.fn.expand "<cword>")})
   :desc "All docsets"        "K" n  #(_G.DashSearch {:query (vim.fn.expand "<cword>") :docsets "all"})
   :desc "Docset"             "k" x  #(_G.DashSearch {:query (table.concat (_G.selected-text) " ")})
   :desc "All docsets"        "K" x  #(_G.DashSearch {:query (table.concat (_G.selected-text) " ") :docsets "all"})
   :desc "Marks"              "r" n  #(FzfLua.marks)
   :desc "Tags"               "t" n  #(FzfLua.tags)
   :desc "Buffer tags"        "T" n  #(FzfLua.btags)
   :desc "Zoxide"             "z" n  #(FzfLua.zoxide))

  (:prefix
   "t" "Toggle"
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
    "i" "Indentation"
    :desc "Toggle expandtab"                "i" n! ":set <C-r>=&et ? 'noexpandtab' : 'expandtab'<CR><CR>"
    :desc "Increase indent"                 ">" n! ":set ts=<C-r>=&ts+2<CR>|set sw=<C-r>=&sw+2<CR><CR>"
    :desc "Decrease indent"                 "<" n! ":set ts=<C-r>=&ts-2<CR>|set sw=<C-r>=&sw-2<CR><CR>"
    :desc "Replace according to &expandtab" "r" nx ":<C-r>=&et ? 'Sp2Tb' : 'Tb2Sp'<CR><CR>"
    :desc "Replace with spaces"             "s" nx ":Tb2Sp<CR>"
    :desc "Replace with tabs"               "t" nx ":Sp2Tb<CR>"))

  (:prefix
   "w" "Workspace"
   :desc "Add folder"    "a" n #(vim.lsp.buf.add_workspace_folder)
   :desc "Remove folder" "d" n #(vim.lsp.buf.remove_workspace_folder)
   :desc "List folders"  "l" n ":lua =vim.lsp.buf.list_workspace_folders()<CR>")

  (:prefix
   "y" "Yank"
   :desc "Yank file's path"          "y" n ":let @+='<C-r>=fnameescape(expand('%:p:~'))<CR>'<CR>"
   :desc "Yank file's relative path" "Y" n ":let @+='<C-r>=fnameescape(expand('%:~'))<CR>'<CR>"))

 (:prefix
  "<C-h>" "Help"
  (:prefix
   "b" "Bindings"
   :desc "List all" "b" n #(FzfLua.keymaps))
  (:prefix
   "h" "Highlights"
   :desc "What's under cursor" "c" n ":TSHighlightCapturesUnderCursor<CR>"
   :desc "List all"            "l" n #(FzfLua.highlights))
  (:prefix
   "r" "Reload"
   :desc "Edit Snippets" "s" n  #(_G.luasnip_edit_snippets)))

 (:prefix
  "<C-x>" "Completion"
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

(fn _G.selected-text []
  (let [mode (vim.fn.mode)
        vmode (if (= mode "n")
                  (vim.fn.visualmode)
                  mode)
        rega (vim.fn.getpos
              (if (= vmode mode) "." "'<"))
        regb (vim.fn.getpos
              (if (= vmode mode) "v" "'>"))]
    (if (= vmode "V")
        (let [a (. rega 2)
              b (. regb 2)
              [start end] (if (< a b) [a b] [b a])]
          (vim.api.nvim_buf_get_lines 0 (- start 1) end true))
        (or (= vmode "v")
            (= vmode "\x16"))
        (let [a [(unpack rega 2 3)]
              b [(unpack regb 2 3)]
              [start end] (if (< (. a 1) (. b 1)) [a b]
                              (> (. a 1) (. b 1)) [b a]
                              (< (. a 2) (. b 2)) [a b] [b a])
              lines (vim.api.nvim_buf_get_lines
                     0 (- (. start 1) 1) (. end 1) true)
              from (. start 2)
              to (. end 2)]
          ;; Don't use vim.region, it's slow and alters its params.
          (if (= vmode "v")
              (let [last (# lines)]
                (tset lines last (string.sub (. lines last) 1 to))
                (tset lines 1 (string.sub (. lines  1) from))
                lines)
              (icollect [_ line (ipairs lines)]
                (string.sub line from to)))))))
