(import-macros {: use!} :macros)

(use!
 {:requires [[:nvim-lua/plenary.nvim]]
  :config
  (fn []
    (let [gitsigns (require :gitsigns)]
      (gitsigns.setup)))} :lewis6991/gitsigns.nvim)
