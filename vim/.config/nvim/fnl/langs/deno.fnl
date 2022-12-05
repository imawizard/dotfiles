(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      util (require :lspconfig.util)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "deno")
      (cfgs.denols.setup
       {:capabilities (cmp_lsp.default_capabilities)
        :root_dir (util.root_pattern "deno.json" "deno.jsonc")
        :init_options {:enable true
                       :lint true
                       :unstable true}})))
