(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "dockerfile"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "docker-langserver")
        (cfgs.dockerls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))
