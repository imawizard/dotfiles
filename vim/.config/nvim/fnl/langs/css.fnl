(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "css"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "vscode-css-language-server")
        (cfgs.cssls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
