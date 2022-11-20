(import-macros {: use!} :macros)

(use!
 {:run ":TSUpdate"
  :config
  (fn []
    (let [cfgs (require :nvim-treesitter.configs)]
      (cfgs.setup
       {:ensure_installed "all"
        :highlight {:enable true
                    :additional_vim_regex_highlighting false}
        :incremental_selection {:enable true}
        :indent {:enable true}

        :refactor {:highlight_definitions {:enable true
                                           :clear_on_cursor_move true}
                   :highlight_current_scope {:enable false}
                   :smart_rename {:enable true}
                   :navigation {:enable true}}

        :matchup {:enable true
                  :disable {}}

        :context_commentstring {:enable true
                                :enable_autocmd false}})))}
 :nvim-treesitter/nvim-treesitter

 ;; See :help nvim-treesitter-textobjects.
 :nvim-treesitter/nvim-treesitter-textobjects
 ;; See :help nvim-treesitter-refactor.txt.
 :nvim-treesitter/nvim-treesitter-refactor
 :nvim-treesitter/playground

 :JoosepAlviste/nvim-ts-context-commentstring)
