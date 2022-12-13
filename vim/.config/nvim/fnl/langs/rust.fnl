(import-macros {: use! : has? : executable? : aucmd! : bind! : trim-lines!} :macros)

(use!
 ;; See :help ft_rust.txt.
 :rust-lang/rust.vim

 ;; See :help rust-tools.txt.
 {:config
  (fn []
    (let [rust_tools (require :rust-tools)
          rust_tools_dap (require :rust-tools.dap)
          cmplsp (require :cmp_nvim_lsp)]

      (when (executable? "rustup")
        (let [extension_path (.. vim.env.HOME ".vscode/extensions/vadimcn.vscode-lldb-1.8.1/")
              codelldb_path (.. extension_path "adapter/codelldb")
              liblldb_path (.. extension_path "lldb/bin/liblldb")]

          (rust_tools.setup
           {:server
            {:cmd ["rustup" "run" "nightly" "rust-analyzer"]
             :capabilities (cmplsp.default_capabilities)
             :settings
             {"rust-analyzer"
              {:completion
               {:snippets
                {:custom
                 {"thread spawn" {:prefix ["spawn" "tspawn"]
                                  :body ["thread::spawn(move || {"
                                         "\t$0"
                                         "});"]
                                  :description "Insert a thread::spawn call"
                                  :requires "std::thread"
                                  :scope "expr"}}}}}}}

            :dap
            {:adapter (rust_tools_dap.get_codelldb_adapter
                       (unpack
                        (if (has? "win32")
                            [(string.gsub (.. codelldb_path ".exe") "/" "\\")
                             (string.gsub (.. liblldb_path ".dll") "/" "\\")]
                            [codelldb_path
                             (.. liblldb_path ".a")])))}})))))}
 :simrat39/rust-tools.nvim)

(aucmd!
 (:group
  "rust-bindings"
  Filetype
  :pattern "rust"
  (fn [args]
    (let [[ok repl] [(pcall _G.inject-repl args.buf "evcxr")]
          ts vim.treesitter
          utils (require :nvim-treesitter.ts_utils)]

      (fn get-stmt-or-expr [node]
        (let [node (or node (utils.get_node_at_cursor 0))
              type (node:type)
              parent (node:parent)]
          (if (and (not (vim.endswith type "statement"))
                   (not (vim.endswith type "expression"))
                   (not (vim.endswith type "declaration"))
                   parent)
              (get-stmt-or-expr parent)
              node)))

      (fn get-block [node]
        (let [node (or node (utils.get_node_at_cursor 0))
              type (node:type)
              parent (node:parent)]
          (if (not= type "block")
              (get-block parent)
              node)))

      (fn trim-and-join [lines]
        (table.concat (trim-lines! lines) ""))

      (when ok
        (bind!
         :desc "Current expr" :bufnr args.buf
         "<leader>ee" n #(repl:exec
                          (trim-and-join
                           (ts.query.get_node_text
                            (get-stmt-or-expr (utils.get_node_at_cursor 0))
                            0 {:concat false})))

         :desc "Current scope" :bufnr args.buf
         "<leader>es" n #(repl:exec
                          (trim-and-join
                           (ts.query.get_node_text
                            (get-block (utils.get_node_at_cursor 0))
                            0 {:concat false})))

         :desc "Evaluate selection" :bufnr args.buf
         "<leader>E" x #(repl:exec (trim-and-join (_G.selected-text)))))))))
