(import-macros {: use! : has? : executable?} :macros)

(use!
 ;; See :help ft_rust.txt.
 :rust-lang/rust.vim

 ;; See :help rust-tools.txt.
 {:config
  (fn []
    (let [rust_tools (require :rust-tools)
          rust_tools_dap (require :rust-tools/dap)
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
                       (.. codelldb_path (if (has? "win32")
                                             ".exe"
                                             ""))
                       (.. liblldb_path (if (has? "win32")
                                            ".dll"
                                            ".a")))}})))))}
 :simrat39/rust-tools.nvim)
