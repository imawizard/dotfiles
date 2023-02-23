(import-macros {: use!} :macros)

(use!
 ;; s{char}{char}, see :help leap.nvim.
 {:config
  (fn []
    (let [leap (require :leap)]
      (leap.add_default_mappings)
      (set leap.opts.highlight_unlabeled_phase_one_targets true)))
  :keys [[:n "s"] [:v "x"]
         [:n "S"] [:v "X"]]}
 :ggandor/leap.nvim

 ;; Enhanced f/t.
 {:requires [:ggandor/leap.nvim]
  :config
  (fn []
    (let [flit (require :flit)]
      (flit.setup
       {:labeled_modes "nvo"})))
  :keys [[:n "f"] [:v "f"]
         [:n "t"] [:v "t"]
         [:n "F"] [:v "F"]
         [:n "T"] [:v "T"]]}
 :ggandor/flit.nvim)
