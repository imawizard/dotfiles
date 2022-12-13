(import-macros {: aucmd! : executable?} :macros)

(aucmd!
 Filetype
 :pattern "lua"
 :once true

 #(let [cfgs (require :lspconfig)
        cmp_lsp (require :cmp_nvim_lsp)]

    (if (executable? "lua-language-server")
        (cfgs.sumneko_lua.setup
         {:capabilities (cmp_lsp.default_capabilities)
          :settings
          {:Lua
           {:runtime {:version "LuaJIT"}
            :telemetry {:enable false}}}}))

    (vim.cmd "LspStart")))
