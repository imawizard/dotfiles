(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "yaml"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "yaml-language-server")
        (cfgs.yamlls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
