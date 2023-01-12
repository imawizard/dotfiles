(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern [:javascript :javascriptreact
           :typescript :typescriptreact]
 :once true

 #(let [cfgs (require :lspconfig)
        util (require :lspconfig.util)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "typescript-language-server")
        (cfgs.tsserver.setup
         {:capabilities (cmp_lsp.default_capabilities)
          :root_dir (util.root_pattern "package.json" "tsconfig.json" "jsconfig.json")}))

    (if (executable? "vscode-eslint-language-server")
        (cfgs.eslint.setup
         {:root_dir (util.root_pattern "package.json" "tsconfig.json" "jsconfig.json")}))

    (vim.cmd "LspStart")))
