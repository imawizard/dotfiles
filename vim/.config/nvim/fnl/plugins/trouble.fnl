(import-macros {: use! : aucmd! : bind!} :macros)

(use!
 ;; See :help trouble.txt.
 {:config
  (fn []
    (let [trouble (require :trouble)]
      (trouble.setup {:height 13
                      :action_keys {:close [] ; Unmap q
                                    :jump_close ["<CR>"]
                                    :jump ["o"]}})))}
 :folke/trouble.nvim)

(aucmd!
 (:group
  "trouble-bindings"
  Filetype
  :pattern "Trouble"
  #(do
    ;; Focus last active split instead of first when closing.
    (bind! "q" nb ":wincmd p<Bar>TroubleClose<CR>")
    ;; Disable wrap guides.
    (set vim.opt_local.colorcolumn []))))
