;; See :help indent_blankline.txt.
{1 :lukas-reineke/indent-blankline.nvim
 :event :VimEnter
 :main :ibl
 :opts {:indent
        {:char "│"
         :highlight [:IndentBlanklineChar]}
        :scope
        {:char "│"
         :highlight [:IndentBlanklineContextChar]
         :show_start false
         :show_end false}
        :exclude
        {:filetypes ["lspinfo"
                     "checkhealth"
                     "help"
                     "man"
                     "FTerm"]
         :buftypes ["terminal"
                    "nofile"
                    "quickfix"
                    "prompt"]}}
 :init #(let [hooks (require :ibl.hooks)]
          (hooks.register
           hooks.type.WHITESPACE
           hooks.builtin.hide_first_space_indent_level))}

