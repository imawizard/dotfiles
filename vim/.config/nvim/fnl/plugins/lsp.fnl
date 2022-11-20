(import-macros {: use!} :macros)

(use!
 ;; See :help lspconfig.txt and :help lspconfig-all
 {:config
  (fn []
    (let [cfg (require :lspconfig)
          util (require :lspconfig/util)
          cmplsp (require :cmp_nvim_lsp)]
      (cfg.gopls.setup
       {:cmd ["gopls" "serve"]
        :settings
        {:gopls {:experimentalPostfixCompletions true
                 :analyses {:unusedparams true
                            :shadow true}
                 :staticcheck true}
         :capabilities (cmplsp.default_capabilities)}})))}
 :neovim/nvim-lspconfig)
;; --
;; -- Asciidoc
;; --
;;
;; vim.cmd [=[
;; augroup asciidoc-autocmds
;;     autocmd!
;;     autocmd FileType asciidoc setlocal commentstring=//%s
;; augroup end
;; ]=]
;;
;; --
;; -- AutoHotkey
;; --
;;
;; vim.cmd [=[
;; augroup autohotkey-autocmds
;;     autocmd!
;;     autocmd FileType autohotkey setlocal commentstring=;%s
;; augroup end
;; ]=]
;;
;; --
;; -- Bash
;; --
;;
;; if vim.fn.executable("bash-language-server") == 1 then
;;     lspconfig.bashls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Clang
;; --
;;
;; if vim.fn.executable("clangd") == 1 or vim.fn.executable("xcrun") == 1 then
;;     local cmd = {
;;         "clangd",
;;         "--background-index",
;;         "--suggest-missing-includes",
;;         "--clang-tidy",
;;         "--header-insertion=iwyu",
;;     }
;;     if vim.fn.executable("clangd") == 0 then
;;         table.insert(cmd, 1, "xcrun")
;;         table.insert(cmd, 2, "--run")
;;     end
;;     lspconfig.clangd.setup {
;;         cmd = cmd,
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Clojure
;; --
;;
;; if vim.fn.executable("clojure-lsp") == 1 then
;;     lspconfig.clojure_lsp.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- CSS
;; --
;;
;; if vim.fn.executable("vscode-css-language-server") == 1 then
;;     lspconfig.cssls.setup {
;;         --cmd = vim.fn.has("win32") and { "vscode-css-language-server.cmd", "--stdio" },
;;         -- kein format
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Dart
;; --
;; -- See :h dart-vim-plugin
;;
;; vim.g.dart_format_on_save = 1
;; vim.g.dart_style_guide    = 2
;; vim.g.dart_html_in_string   = true
;; --vim.g.lsc_auto_map       = true
;;
;; if vim.fn.executable("dart") == 1 then
;;     lspconfig.dartls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Deno
;; --
;;
;; if vim.fn.executable("deno") == 1 then
;;     lspconfig.denols.setup {
;;         root_dir = lsputil.root_pattern("deno.json", "deno.jsonc"),
;;         init_options = {
;;             enable = true,
;;             lint = true,
;;             unstable = true,
;;         },
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Docker
;; --
;;
;; if vim.fn.executable("docker-langserver") == 1 then
;;     lspconfig.dockerls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- EditorConfig
;; --
;;
;; --
;; -- EFM (general purpose)
;; --
;;
;; --[[
;; if vim.fn.executable("efm-langserver") == 1 then
;;     lspconfig.efm.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;; ]]
;;
;; --
;; -- Go
;; --
;; -- See :h vim-go.txt
;; -- also https://github.com/leoluz/nvim-dap-go
;;
;; require("dap-go").setup()
;; -- require("dap-go").debug_test()
;;
;; vim.g.go_gopls_enabled       = false
;; vim.g.go_gopls_options       = ""
;; vim.g.go_fmt_command         = "gofumports"
;; vim.g.go_def_mapping_enabled = 0
;;
;; vim.cmd [=[
;; augroup golang-autocmds
;;     autocmd!
;;     autocmd FileType go
;;         \ setlocal noexpandtab   |
;;         \ setlocal shiftwidth=8  |
;;         \ setlocal softtabstop=0 |
;;         \ setlocal tabstop=8     |
;; augroup end
;; ]=]
;;
;; if vim.fn.executable("golangci-lint-langserver") == 1 then
;;     lspconfig.golangci_lint_ls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("gopls") == 1 then
;;     lspconfig.gopls.setup {
;;         cmd = {
;;             "gopls",
;;             "serve",
;;         },
;;         settings = {
;;             gopls = {
;;                 experimentalPostfixCompletions = true,
;;                 analyses = {
;;                     unusedparams = true,
;;                     shadow = true,
;;                 },
;;                 staticcheck = true,
;;             },
;;         },
;;         --init_options = {
;;         --    usePlaceholders = true,
;;         --    completeUnimported = true,
;;         --    usePlaceholders = true,
;;         --    ExperimentalPostfixCompletions = true,
;;         --    LinksInHover = true,
;;         --    staticcheck = true,
;;         --    gofumpt = true,
;;         --    analyses = {
;;         --        unusedparams = true,
;;         --    },
;;         --    codelenses = {
;;         --        generate = true,
;;         --        test = true,
;;         --    },
;;         --},
;;     --    on_attach = with_organize_imports(on_attach, "_G.gopls_organize_imports"),
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;;
;;     _G.gopls_organize_imports = function(bufnr)
;;         if not bufnr then
;;             bufnr = vim.api.nvim_get_current_buf()
;;         end
;;
;;         local params = vim.lsp.util.make_range_params()
;;         params.context = {
;;             only = { "source.organizeImports" },
;;         }
;;         local res = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 500)
;;         for _, res in pairs(result or {}) do
;;             for _, r in pairs(res.result or {}) do
;;                 if r.edit then
;;                     vim.lsp.util.apply_workspace_edit(r.edit)
;;                 else
;;                     vim.lsp.buf.execute_command(r.command)
;;                 end
;;             end
;;         end
;;     end
;; end
;;
;; --
;; -- Graphviz
;; --
;;
;; if vim.fn.executable("dot-language-server") == 1 then
;;     lspconfig.dotls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- HTML
;; --
;;
;; if vim.fn.executable("vscode-html-language-server") == 1 then
;;     lspconfig.html.setup {
;;     --    cmd = vim.fn.has("win32") and { "vscode-html-language-server.cmd", "--stdio" },
;;     -- kein format
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- JSON
;; --
;;
;; if vim.fn.executable("vscode-json-language-server") == 1 then
;;     lspconfig.jsonls.setup {
;;     --    cmd = vim.fn.has("win32") and { "vscode-json-language-server.cmd", "--stdio" },
;;     --    commands = {
;;     --        Format = {
;;     --            function()
;;     --                vim.lsp.buf.range_formatting({}, { 0,0 }, { vim.fn.line("$"), 0 })
;;     --            end
;;     --        },
;;     --    },
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- LaTeX
;; --
;;
;; if vim.fn.executable("texlab") == 1 then
;;     lspconfig.texlab.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Lua
;; --
;;
;; if vim.fn.executable("lua-language-server") == 1 then
;;     lspconfig.sumneko_lua.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Markdown
;; --
;;
;; vim.g.markdown_fenced_languages = {
;;     "bash=sh",
;;     "c++=cpp",
;;     "ini=dosini",
;;     "ts=typescript",
;;     "viml=vim",
;; }
;;
;; vim.g.vim_markdown_fenced_languages = vim.g.markdown_fenced_languages
;;
;; --
;; -- Perl
;; --
;;
;; if vim.fn.executable("perl") == 1 then
;;     lspconfig.perlls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("pls") == 1 then
;;     lspconfig.perlpls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("perlnavigator") == 1 then
;;     lspconfig.perlnavigator.setup {
;;         cmd = { "perlnavigator" },
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- PHP
;; --
;;
;; if vim.fn.executable("composer") == 1 then
;;     lspconfig.phan.setup {
;;         root_dir = lsputil.root_pattern(".phan/config.php"),
;;         cmd = {
;;             "composer",
;;             "exec",
;;             "phan",
;;             "--",
;;             "-m",
;;             "json",
;;             "--no-color",
;;             "--no-progress-bar",
;;             "-x",
;;             "-u",
;;             "-S",
;;             "--language-server-on-stdin",
;;             "--allow-polyfill-parser",
;;         },
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;;
;;     lspconfig.psalm.setup {
;;         root_dir = lsputil.root_pattern("psalm.xml", "psalm.xml.dist"),
;;         cmd = {
;;             "composer",
;;             "exec",
;;             "psalm-language-server",
;;         },
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("phpactor") == 1 then
;;     lspconfig.phpactor.setup {
;;         root_dir = lsputil.root_pattern("phpactor.yml"),
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Plaintext
;; --
;;
;; vim.cmd [=[
;; augroup plaintext-autocmds
;;     autocmd!
;;     autocmd FileType text
;;         \ setlocal noexpandtab   |
;;         \ setlocal shiftwidth=8  |
;;         \ setlocal softtabstop=0 |
;;         \ setlocal tabstop=8     |
;; augroup end
;; ]=]
;;
;; --
;; -- Rust
;; --
;; -- See :h rust-tools.txt and :h ft_rust.txt
;;
;; local rust_tools = require"rust-tools"
;; local rust_tools_dap = require"rust-tools/dap"
;;
;; --[[
;; :Cargo <args> Runs 'cargo' with the provided arguments.
;; :Cbuild <args> Shortcut for 'cargo build`.
;; :Cclean <args> Shortcut for 'cargo clean`.
;; :Cdoc <args> Shortcut for 'cargo doc`.
;; :Cinit <args> Shortcut for 'cargo init`.
;; :Crun <args> Shortcut for 'cargo run`.
;; :Ctest <args> Shortcut for 'cargo test`.
;; :Cupdate <args> Shortcut for 'cargo update`.
;; :Cbench <args> Shortcut for 'cargo bench`.
;; :Csearch <args> Shortcut for 'cargo search`.
;; :Cpublish <args> Shortcut for 'cargo publish`.
;; :Cinstall <args> Shortcut for 'cargo install`.
;; :Cruntarget <args> Shortcut for 'cargo run --bin' or 'cargo run --example',
;;                 depending on the currently open buffer.
;;
;; :RustFmt                                                       *:RustFmt*
;; 		Runs |g:rustfmt_command| on the current buffer. If
;; 		|g:rustfmt_options| is set then those will be passed to the
;; 		executable.
;;
;; 		If |g:rustfmt_fail_silently| is 0 (the default) then it
;; 		will populate the |location-list| with the errors from
;; 		|g:rustfmt_command|. If |g:rustfmt_fail_silently| is set to 1
;; 		then it will not populate the |location-list|.
;;
;; :RustFmtRange                                                  *:RustFmtRange*
;; 		Runs |g:rustfmt_command| with selected range. See
;; 		|:RustFmt| for any other information.
;;
;; -- Command:
;; -- RustRunnables
;; --require('rust-tools').runnables.runnables()
;;
;; -- Commands:
;; -- RustEnableInlayHints
;; -- RustDisableInlayHints
;; -- RustSetInlayHints
;; -- RustUnsetInlayHints
;;
;; -- Set inlay hints for the current buffer
;; require('rust-tools').inlay_hints.set()
;; -- Unset inlay hints for the current buffer
;; require('rust-tools').inlay_hints.unset()
;;
;; -- Enable inlay hints auto update and set them for all the buffers
;; require('rust-tools').inlay_hints.enable()
;; -- Disable inlay hints auto update and unset them for all buffers
;; require('rust-tools').inlay_hints.disable()
;;
;;  -- Command:
;; -- RustExpandMacro
;; require'rust-tools'.expand_macro.expand_macro()
;;
;;  -- Command:
;; -- RustOpenCargo
;; require'rust-tools'.open_cargo_toml.open_cargo_toml()
;;
;;  -- Command:
;; -- RustParentModule
;; require'rust-tools'.parent_module.parent_module()
;;
;;  -- Command:
;; -- RustSSR [query]
;; require'rust-tools'.ssr.ssr(query)
;;
;;  -- Command:
;; -- RustViewCrateGraph [backend [output
;; require'rust-tools'.crate_graph.view_crate_graph(backend, output)
;;
;;  rt.move_item.move_item(false)
;;   rt.move_item.move_item(true)
;;   rt.workspace_refresh.reload_workspace
;;
;;             ]]
;;
;; local extension_path = vim.env.HOME .. ".vscode/extensions/vadimcn.vscode-lldb-1.8.1/"
;; local codelldb_path = extension_path .. "adapter/codelldb"
;; local liblldb_path = extension_path .. "lldb/bin/liblldb"
;;
;; if not vim.fn.has("win32") then
;;     codelldb_path = vim.fn.expand(codelldb_path .. ".exe")
;;     liblldb_path = vim.fn.expand(liblldb_path .. ".a")
;; else
;;     codelldb_path = vim.fn.expand(codelldb_path .. ".exe")
;;     liblldb_path = vim.fn.expand(liblldb_path .. ".dll")
;; end
;;
;; if vim.fn.executable("rustup") == 1 then
;;     rust_tools.setup {
;;         server = {
;;             cmd = {
;;                 "rustup",
;;                 "run",
;;                 "nightly",
;;                 "rust-analyzer",
;;             },
;;             --flags = { debounce_text_changes = 100 },
;;             capabilities = cmplsp.default_capabilities(),
;;             on_attach = function(client, bufnr)
;;                 vim.keymap.set("n", "<C-k>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
;;                 vim.keymap.set("x", "<C-k>", rust_tools.hover_range.hover_range, { buffer = bufnr })
;;                 vim.keymap.set("n", "<leader>ca", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
;;                 vim.keymap.set("n", "J", rust_tools.join_lines.join_lines, { buffer = bufnr })
;;
;;                 if vim.fn.filereadable(".vscode/launch.json") then
;;                     require('dap.ext.vscode').load_launchjs(nil, { rt_lldb = {"rust"} })
;;                 end
;;             end,
;;         },
;;         dap = {
;;             adapter = rust_tools_dap.get_codelldb_adapter(codelldb_path, liblldb_path),
;;         },
;;     }
;; end
;;
;; --
;; -- SQL
;; --
;;
;; if vim.fn.executable("sqls") == 1 then
;;     lspconfig.sqls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("sql-language-server") == 1 then
;;     lspconfig.sqlls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- Terraform
;; --
;;
;; if vim.fn.executable("terraform-ls") == 1 then
;;     lspconfig.terraformls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("terraform-lsp") == 1 then
;;     lspconfig.terraform_lsp.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; if vim.fn.executable("tflint") == 1 then
;;     lspconfig.tflint.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- TypeScript
;; --
;;
;; if vim.fn.executable("typescript-language-server") == 1 then
;;     lspconfig.tsserver.setup {
;;         root_dir = lsputil.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
;;     --    on_attach = with_organize_imports(no_format(on_attach), "_G.tsserver_organize_imports"),
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;;
;;     _G.tsserver_organize_imports = function(bufnr)
;;         if not bufnr then
;;             bufnr = vim.api.nvim_get_current_buf()
;;         end
;;
;;         local params = {
;;             command = "_typescript.organizeImports",
;;             arguments = { vim.api.nvim_buf_get_name(bufnr) },
;;             title = "",
;;         }
;;         vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 500)
;;     end
;; end
;;
;; if vim.fn.executable("vscode-eslint-language-server") == 1 then
;;     require'lspconfig'.eslint.setup{}
;; end
;;
;; --
;; -- VimScript
;; --
;;
;; if vim.fn.executable("vim-language-server") == 1 then
;;     lspconfig.vimls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end
;;
;; --
;; -- YAML
;; --
;;
;; if vim.fn.executable("yaml-language-server") == 1 then
;;     lspconfig.yamlls.setup {
;;         capabilities = cmplsp.default_capabilities(),
;;     }
;; end




;;; TODO
;;;;;   lua <<HERE
;;;;;--[[
;;;;;
;;;;;    --
;;;;;    -- efm settings
;;;;;    --
;;;;;    local tools = {
;;;;;        eslint = {
;;;;;            lintCommand = "npx eslint -f visualstudio --stdin --stdin-filename ${INPUT}",
;;;;;            lintIgnoreExitCode = true,
;;;;;            lintStdin = true,
;;;;;            lintFormats = {
;;;;;                "%f(%l,%c): %tarning %m",
;;;;;                "%f(%l,%c): %rror %m",
;;;;;            },
;;;;;            formatCommand = "npx eslint --fix --stdin --stdin-filename ${INPUT}",
;;;;;            formatStdin = true,
;;;;;        },
;;;;;        prettier = {
;;;;;            formatCommand = "npx prettier --stdin-filepath ${INPUT}",
;;;;;            formatStdin = true,
;;;;;        },
;;;;;        lua_format = {
;;;;;            formatCommand = "lua-format -i",
;;;;;            formatStdin = true,
;;;;;        },
;;;;;        shellcheck = {
;;;;;            lintCommand = "shellcheck -f gcc -x",
;;;;;            lintSource = "shellcheck",
;;;;;            lintFormats = {
;;;;;                "%f:%l:%c: %trror: %m",
;;;;;                "%f:%l:%c: %tarning: %m",
;;;;;                "%f:%l:%c: %tote: %m",
;;;;;            },
;;;;;        },
;;;;;        shfmt = {
;;;;;            formatCommand = "shfmt -ci -s -bn",
;;;;;            formatStdin = true,
;;;;;        },
;;;;;        phpstan = {
;;;;;            lintCommand = "composer exec phpstan analyze --error-format raw --no-progress",
;;;;;        },
;;;;;        psalm = {
;;;;;            lintCommand = "composer exec psalm --output-format=emacs --no-progress",
;;;;;            lintFormats = {
;;;;;                "%f:%l:%c:%trror - %m",
;;;;;                "%f:%l:%c:%tarning - %m",
;;;;;            },
;;;;;        },
;;;;;    }
;;;;;    local languages = {
;;;;;        javascript         = { tools.prettier, tools.eslint },
;;;;;        javascriptreact    = { tools.prettier, tools.eslint },
;;;;;        ["javascript.jsx"] = { tools.prettier, tools.eslint },
;;;;;        typescript         = { tools.prettier, tools.eslint },
;;;;;        typescriptreact    = { tools.prettier, tools.eslint },
;;;;;        ["typescript.jsx"] = { tools.prettier, tools.eslint },
;;;;;        css                = { tools.prettier },
;;;;;        scss               = { tools.prettier },
;;;;;        less               = { tools.prettier },
;;;;;        json               = { tools.prettier },
;;;;;        yaml               = { tools.prettier },
;;;;;        markdown           = { tools.prettier },
;;;;;        graphql            = { tools.prettier },
;;;;;        html               = { tools.prettier },
;;;;;        vue                = { tools.prettier },
;;;;;        svelte             = { tools.prettier },
;;;;;        sh                 = { tools.shellcheck, tools.shfmt },
;;;;;        lua                = { tools.lua_format },
;;;;;    }
;;;;;    local filetypes = {}
;;;;;    for lang, _ in pairs(languages) do
;;;;;        table.insert(filetypes, lang)
;;;;;    end
;;;;;    lspconfig.efm.setup {
;;;;;        init_options = {
;;;;;            documentFormatting = true,
;;;;;        },
;;;;;        settings = {
;;;;;            rootMarkers = { ".git/" },
;;;;;            lintDebounce = 1000,
;;;;;            languages = languages,
;;;;;        },
;;;;;        on_attach = on_attach,
;;;;;        capabilities = make_snippet_capabilities(),
;;;;;        filetypes = filetypes,
;;;;;    }
;;;;;
;;;;;
;;;;;    --
;;;;;    -- prismals settings
;;;;;    --
;;;;;    lspconfig.prismals.setup {
;;;;;        on_attach = on_attach,
;;;;;        capabilities = make_snippet_capabilities(),
;;;;;    }
;;;;;
;;;;;    vim.cmd [=[
;;;;;    augroup prisma-filetype
;;;;;        autocmd!
;;;;;        autocmd BufReadPost *.schema,*.prisma set filetype=prisma
;;;;;    augroup end
;;;;;    ]=]
;;;;;
;;;;;
;;;;;table.insert(masontools, "dot-language-server")
;;;;;table.insert(masontools, "html-lsp")
;;;;;table.insert(masontools, "luacheck")
;;;;;table.insert(masontools, "stylua")
;;;;;table.insert(masontools, "cpptools")
;;;;;table.insert(masontools, "codelldb")
;;;;;table.insert(masontools, "vint")
;;;;;table.insert(masontools, "sql-formatter")
;;;;;table.insert(masontools, "bash-debug-adapter")
;;;;;table.insert(masontools, "shellcheck")
;;;;;table.insert(masontools, "shfmt")
;;;;;table.insert(masontools, "joker")
;;;;;table.insert(masontools, "editorconfig-checker")
;;;;;table.insert(masontools, "misspell")
;;;;;table.insert(masontools, "delve")
;;;;;table.insert(masontools, "staticcheck")
;;;;;table.insert(masontools, "gofumpt")
;;;;;table.insert(masontools, "gofumpt")
;;;;;table.insert(masontools, "fixjson")
;;;;;table.insert(masontools, "golangci-lint")
;;;;;table.insert(masontools, "revive")
;;;;;table.insert(masontools, "golines")
;;;;;table.insert(masontools, "gomodifytags")
;;;;;table.insert(masontools, "gotests")
;;;;;table.insert(masontools, "impl")
;;;;;table.insert(masontools, "json-to-struct")
;;;;;
;;;;;
;;;;;
;;;;;
;;;;;
;;;;;local function no_format(on_attach)
;;;;;    return function(client, bufnr)
;;;;;        client.resolved_capabilities.document_formatting = false
;;;;;        return on_attach(client, bufnr)
;;;;;    end
;;;;;end
;;;;;
;;;;;local function with_organize_imports(on_attach, func)
;;;;;    return function(client, bufnr)
;;;;;        client.resolved_capabilities.organize_imports = func
;;;;;        return on_attach(client, bufnr)
;;;;;    end
;;;;;end
;;;;;
;;;;;]]
;;;;;HERE
