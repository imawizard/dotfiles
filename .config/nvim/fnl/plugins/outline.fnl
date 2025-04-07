(import-macros {: aucmd! : bind!} :macros)

[
 ;; See :help symbols-outline.txt.
 {1 :hedyhli/outline.nvim
  :cmd [:SymbolsOutline
        :SymbolsOutlineOpen
        :SymbolsOutlineClose]
  :opts {:keymaps {:close [:q]}}
  :init (fn []
          (aucmd!
           (:group
            "symbols-outline-bindings"
            Filetype
            :pattern "Outline"
            #(bind! "<ESC>" nb ":wincmd p<CR>"))))}

                ;(fn so.toggle_outline []
                ;  (if (not (so.view:is_open)) (so.open_outline)
                ;      (if (not= (vim.api.nvim_get_current_win) so.view.winnr)
                ;          (vim.api.nvim_set_current_win so.view.winnr)
                ;          (so.close_outline))))}

 {1 :chrisgrieser/nvim-spider}

 {1 :abecodes/tabout.nvim}]
