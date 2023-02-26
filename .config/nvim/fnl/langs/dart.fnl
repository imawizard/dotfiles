(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "dart"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "dart")
        (cfgs.dartls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
