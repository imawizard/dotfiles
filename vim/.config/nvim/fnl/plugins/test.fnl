(import-macros {: use! : gset!} :macros)

(use!
 :vim-test/vim-test)

(gset!
 test#preserve_screen 0
 test#strategy        "neovim")
