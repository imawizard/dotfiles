(import-macros {: use! : gset!} :macros)

(use!
 ;; See :help indent_blankline.txt.
 {:config
  (fn []
    (let [ib (require :indent_blankline)]
      (ib.setup
       {:filetype_exclude ["lspinfo"
                           "packer"
                           "checkhealth"
                           "help"
                           "man"
                           "FTerm"]
        :buftype_exclude ["terminal"
                          "nofile"
                          "quickfix"
                          "prompt"]})))
  :event :VimEnter}
 :lukas-reineke/indent-blankline.nvim)

(gset!
 indent_blankline_show_first_indent_level false
 indent_blankline_show_trailing_blankline_indent false)
