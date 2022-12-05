(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "clojure-lsp")
      (cfgs.clojure_lsp.setup
       {:capabilities (cmp_lsp.default_capabilities)})))
