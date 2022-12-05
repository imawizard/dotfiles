(import-macros {: use! : executable?} :macros)

(use!
 ;; See :help vim-go.txt.
 ;:fatih/vim-go

 {:config
  (fn []
    (let [dap_go (require :dap-go)]
      (dap_go.setup)))}
 :leoluz/nvim-dap-go)

(let [cfgs (require :lspconfig)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "gopls")
      ;; See https://github.com/golang/tools/blob/master/gopls/internal/lsp/source/options.go.
      (cfgs.gopls.setup
       {:cmd ["gopls" "serve"]
        :capabilities (cmp_lsp.default_capabilities)
        :settings
        {:gopls {:experimentalPostfixCompletions true
                 :analyses {:unusedparams true
                            :shadow true}
                 :staticcheck true
                 :gofumpt true
                 :usePlaceholders  true
                 :codelenses {:generate true
                              :test true}}}}))

  (if (executable? "golangci-lint-langserver")
      (cfgs.golangci_lint_ls.setup
       {:capabilities (cmp_lsp.default_capabilities)})))
