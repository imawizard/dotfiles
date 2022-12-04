(import-macros {: use! : gset!} :macros)

(use!
 ;; See :help gitsigns.nvim.
 {:requires [:nvim-lua/plenary.nvim]
  :config
  (fn []
    (let [gitsigns (require :gitsigns)]
      (gitsigns.setup)))}
 :lewis6991/gitsigns.nvim

 :rhysd/git-messenger.vim)

(gset!
 git_messenger_no_default_mappings true)
