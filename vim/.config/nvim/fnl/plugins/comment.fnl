(import-macros {: use!} :macros)

(use!
 ;; Comment with gcc and v_gc, see :help comment-nvim.txt.
 {:config
  (fn []
    (let [cmnt (require :Comment)
          ts (require :ts_context_commentstring.integrations.comment_nvim)]
      (cmnt.setup
       {:padding false
        :pre_hook (if (not= ts nil) (ts.create_pre_hook))})))}
 :numToStr/Comment.nvim)
