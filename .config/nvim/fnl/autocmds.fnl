(import-macros {: aucmd! : feedkeys! : bind!} :macros)

(aucmd!
 (:group
  "reload-packer-config"
  ;; Reload plugins and keybindings on changes.
  BufWritePost
  :pattern "*/nvim/fnl/{plugins/*,langs/*,main,settings,keybinds,autocmds,commands}.fnl"
  "source $MYVIMRC | edit | PackerCompile")

 (:group
  "highlight-on-yank"
  ;; Highlight yanks.
  TextYankPost
  #(pcall vim.highlight.on_yank {:higroup "HighlightedyankRegion"
                                 :timeout 400}))

 (:group
  "close-preview-after-completion"
  ;; Close any popup windows if no popup menu is open.
  [InsertLeave CompleteDone]
  #(when (= (vim.fn.pumvisible) 0) (vim.cmd "silent! pclose")))

 (:group
  "autosave-like-intellij"
  ;; Save automatically.
  [WinLeave FocusLost]
  "silent! wall")

 ;;(:group
 ;; "revert-to-normal-mode"
 ;; ;; Always normal mode when coming back to a pane.
 ;; FocusLost
 ;; #(feedkeys! "<C-\\><C-n>l"))

 (:group
  :restore-C-m-if-readonly
  ;; CR is remapped to insert a line, restore it conditionally.
  BufReadPost
  #(when (not vim.bo.modifiable) (bind! "<CR>" nb "<CR>")))

 (:group
  :terminal-cmds
  ;; Start terminals in insert mode.
  TermOpen
  "startinsert"
  ;; Hide any gutter in terminal panes.
  TermOpen
  "set nonumber norelativenumber signcolumn=no")

 (:group
  :add-cwd-to-zoxide
  ;; Analogous to cd-hook in terminal.
  DirChanged
  #(vim.fn.system ["zoxide" "add" (vim.fn.expand "<afile>")])))
