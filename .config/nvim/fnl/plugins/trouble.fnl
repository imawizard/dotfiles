(import-macros {: aucmd! : bind!} :macros)

;; See :help trouble.txt.
{1 :folke/trouble.nvim
 :cmd [:Trouble
       :TroubleToggle]
 :opts {:height 13
        :action_keys {;; Unmap q
                      :close []}
        :jump_close ["<CR>"]
        :jump ["o"]}
 :init #(aucmd!
         (:group
          "trouble-bindings"
          Filetype
          :pattern "Trouble"
          (fn []
            ;; Focus last active split instead of first when closing.
            (bind! "q" nb ":wincmd p<Bar>TroubleClose<CR>")
            ;; Disable wrap guides.
            (set vim.opt_local.colorcolumn []))))}
