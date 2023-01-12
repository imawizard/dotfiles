(import-macros {: use! : aucmd! : bind!} :macros)

(use!
 ;; See :help symbols-outline.txt.
 {:config
  (fn []
    (let [so (require :symbols-outline)]
      (print " goooo ")
      (so.setup
       {:keymaps {:close ["q"]}})

      (fn so.toggle_outline []
        (if (not (so.view:is_open)) (so.open_outline)
            (if (not= (vim.api.nvim_get_current_win) so.view.winnr)
                (vim.api.nvim_set_current_win so.view.winnr)
                (so.close_outline))))))
  :cmd [:SymbolsOutline
        :SymbolsOutlineOpen
        :SymbolsOutlineClose]
  :module :symbols-outline}
 :simrat39/symbols-outline.nvim)

(aucmd!
 (:group
  "symbols-outline-bindings"
  Filetype
  :pattern "Outline"
  #(bind! "<ESC>" nb ":wincmd p<CR>")))
