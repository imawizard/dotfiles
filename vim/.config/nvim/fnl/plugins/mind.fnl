(import-macros {: use!} :macros)

(use!
 ;; See :help mind.txt.
 {:requires [:nvim-lua/plenary.nvim]
  :branch "v2.2"
  :config
  (fn []
    (let [mind (require :mind)]
      (mind.setup)))
  :cmd [:MindOpenMain
        :MindOpenProject
        :MindOpenSmartProject
        :MindReloadState
        :MindClose]}
 :phaazon/mind.nvim)
