(import-macros {: use!} :macros)

(use!
 ;; See :help parinfer.txt.
 {:run "cargo build --release"
  :after :vim-sexp}
 :eraserhd/parinfer-rust)
