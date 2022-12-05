(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (or (executable? "clangd")
          (executable? "xcrun"))
      (let [cmd ["clangd"
                 "--background-index"
                 "--suggest-missing-includes"
                 "--clang-tidy"
                 "--header-insertion=iwyu"]]
        (when (not (executable? "clangd"))
          (do
           (table.insert cmd 1 "xcrun")
           (table.insert cmd 2 "--run")))

        (cfgs.clangd.setup
         {:cmd cmd
          :capabilities (cmp_lsp.default_capabilities)}))))
