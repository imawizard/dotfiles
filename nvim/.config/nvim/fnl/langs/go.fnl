(import-macros {: use! : gset! : aucmd! : executable? : bind!} :macros)

(use!
 ;; See :help vim-go.txt.
 :fatih/vim-go

 {:config
  (fn []
    (let [dap_go (require :dap-go)]
      (dap_go.setup)))
  :ft "go"}
 :leoluz/nvim-dap-go)

(gset!
 go_gopls_enabled           true
 go_fmt_autosave            false
 go_def_mapping_enabled     false)

(aucmd!
 Filetype
 :pattern "go"
 :once true
 #(let [cfgs (require :lspconfig)
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
                   :usePlaceholders true
                   :codelenses {:generate true
                                :test true}}}}))

    (if (executable? "golangci-lint-langserver")
        (cfgs.golangci_lint_ls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))

(aucmd!
 (:group
  "go-bindings"
  Filetype
  :pattern "go"
  (fn [args]
    (bind!
     :desc "Run go build"    "<leader>cc" nb ":GoBuild<CR>"
     :desc "Format buffer"   "<leader>cf" n! ":GoFmt<CR>"
     :desc "Run go run"      "<leader>rr" nb ":GoRun<CR>"
     :desc "Debug last test" "<leader>dt" nb #(let [dg (require :dap-go)]
                                                (dg.debug_test "debug_last_test"))))))
