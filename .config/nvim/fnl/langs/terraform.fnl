(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "terraform"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "terraform-ls")
        (cfgs.terraformls.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (if (executable? "terraform-lsp")
        (cfgs.terraform_lsp.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (if (executable? "tflint")
        (cfgs.tflint.setup
         {:capabilities (cmp_lsp.default_capabilities)}))

    (vim.cmd "LspStart")))