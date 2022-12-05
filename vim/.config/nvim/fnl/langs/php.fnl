(import-macros {: use! : executable?} :macros)

(let [cfgs (require :lspconfig)
      util (require :lspconfig.util)
      cmp_lsp (require :cmp_nvim_lsp)]

  (if (executable? "composer")
      (cfgs.phan.setup
       {:capabilities (cmp_lsp.default_capabilities)}
       {:root_dir (util.root_pattern ".phan/config.php")
        :cmd ["composer"
              "exec"
              "phan"
              "--"
              "-m"
              "json"
              "--no-color"
              "--no-progress-bar"
              "-x"
              "-u"
              "-S"
              "--language-server-on-stdin"
              "--allow-polyfill-parser"]}))

  (cfgs.psalm.setup
   {:capabilities (cmp_lsp.default_capabilities)}
   {:root_dir (util.root_pattern "psalm.xml" "psalm.xml.dist")
    :cmd ["composer"
          "exec"
          "psalm-language-server"]})

  (if (executable? "phpactor")
      (cfgs.phpactor.setup
       {:capabilities (cmp_lsp.default_capabilities)}
       {:root_dir (util.root_pattern "phpactor.yml")
        :cmd ["composer"
              "exec"
              "psalm-language-server"]})))
