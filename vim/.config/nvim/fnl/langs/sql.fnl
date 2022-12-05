(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "sqls")
      (cfgs.sqls.setup
       {:capabilities (cmp_lsp.default_capabilities)}))

  (if (executable? "sql-language-server")
      (cfgs.sqlls.setup
       {:capabilities (cmp_lsp.default_capabilities)})))
