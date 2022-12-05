(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "perl")
      (cfgs.perlls.setup
       {:capabilities (cmp_lsp.default_capabilities)}))

  (if (executable? "pls")
      (cfgs.perlpls.setup
       {:capabilities (cmp_lsp.default_capabilities)}))

  (if (executable? "perlnavigator")
      (cfgs.perlnavigator.setup
       {:cmd ["perlnavigator"]
        :capabilities (cmp_lsp.default_capabilities)})))
