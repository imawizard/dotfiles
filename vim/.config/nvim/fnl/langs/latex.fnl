(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "texlab")
      (cfgs.texlab.setup
       {:capabilities (cmp_lsp.default_capabilities)})))
