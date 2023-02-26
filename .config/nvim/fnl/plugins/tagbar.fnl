(import-macros {: use! : gset! : aucmd! : bind!} :macros)

(use!
 ;; See :help tagbar.txt.
 {:cmd :TagbarOpen}
 :preservim/tagbar)

(gset!
 tagbar_ctags_bin vim.g.ctags_host_prog
 tagbar_compact   true)

(aucmd!
 (:group
  "tagbar-bindings"
  Filetype
  :pattern "tagbar"
  #(bind! "<ESC>" nb ":wincmd p<CR>")))
