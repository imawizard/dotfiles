(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "html"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "vscode-html-language-server")
        (cfgs.html.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
