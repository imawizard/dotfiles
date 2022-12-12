(import-macros {: use!} :macros)

(use!
 ;; See :help toggleterm.txt.
 {:config
  (fn []
    (let [tt (require :toggleterm)]
      (tt.setup {:open_mapping "<C-z>"})))}
 :akinsho/toggleterm.nvim)
