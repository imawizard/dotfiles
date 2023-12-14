(import-macros {: use! : gset!} :macros)

(use!
 ;; See :help indent_blankline.txt.
 {:config
  (fn []
    (let [ibl (require :ibl)
          hooks (require :ibl.hooks)]
      (ibl.setup
       {:indent
        {:char "│"
         :highlight [:IndentBlanklineChar]}
        :scope
        {:char "│"
         :highlight [:IndentBlanklineContextChar]
         :show_start false
         :show_end false}
        :exclude
        {:filetypes ["lspinfo"
                     "packer"
                     "checkhealth"
                     "help"
                     "man"
                     "FTerm"]
         :buftypes ["terminal"
                    "nofile"
                    "quickfix"
                    "prompt"]}})
      (hooks.register
       hooks.type.WHITESPACE
       hooks.builtin.hide_first_space_indent_level)))
  :event :VimEnter}
 :lukas-reineke/indent-blankline.nvim)
