(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "bash"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "bash-language-server")
        (cfgs.bashls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
