(import-macros {: use!} :macros)

(use!
 {:requires [[:nvim-lua/plenary.nvim]]
  :branch "0.1.x"
  :config
  (fn []
    (let [telescope (require :telescope)
          builtin (require :telescope.builtin)
          actions (require :telescope.actions)
          themes (require :telescope.themes)]
      (telescope.setup
       {:defaults
        ((. themes :get_ivy) {:mappings {:i {"<ESC>" actions.close}}})
                              ;:dynamic_preview_title true})
                              ;:results_title true})
                              ;:prompt_title true})
        :pickers {}
        :extensions {}})))}
 :nvim-telescope/telescope.nvim)
