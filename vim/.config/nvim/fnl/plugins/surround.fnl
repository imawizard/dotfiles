(import-macros {: use!} :macros)

(use!
 ;; Modify surrounding braces, quotes etc, see :help nvim-surround.txt.
 {:config
  (fn []
    (let [surround (require :nvim-surround)]
      (surround.setup)))}
 :kylechui/nvim-surround)
