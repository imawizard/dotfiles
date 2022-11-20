(import-macros {: use!} :macros)

(use!
 ;; Comment with gcc and v_gc.
 {:config
  (fn []
    ((. (require :nvim_comment) :setup)
     {:marker_padding false
      :hook (fn []
              (let [cs (require :ts_context_commentstring.internal)]
                (if (not= cs nil)
                    (cs.update_commentstring))))}))}
 :terrortylor/nvim-comment)
