;; Comment with gcc and v_gc, see :help comment-nvim.txt.
[{1 :numToStr/Comment.nvim
  :dependencies [:JoosepAlviste/nvim-ts-context-commentstring]
  :keys [{1 "gcc" :mode :n}
         {1 "gc"  :mode :v}]
  :config #(let [cmnt (require :Comment)
                 ts (require :ts_context_commentstring.integrations.comment_nvim)]
             (cmnt.setup
              {:padding  false
               :pre_hook (ts.create_pre_hook)}))}
 {1 "JoosepAlviste/nvim-ts-context-commentstring"
  :opts {:enable_autocmd false}}]

