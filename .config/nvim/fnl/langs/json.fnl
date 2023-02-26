(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern [:json :json5 :jsonc :hjson]
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "vscode-json-language-server")
        (cfgs.jsonls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
