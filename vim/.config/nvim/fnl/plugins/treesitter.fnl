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

        :refactor {:highlight_definitions {:enable false
                                           :clear_on_cursor_move true}
                   :highlight_current_scope {:enable false}
                   :smart_rename {:enable true}
                   :navigation {:enable true}}

        :playground {}

        :context_commentstring {:enable true
                                :enable_autocmd false}

        :matchup {:enable true
                  :disable_virtual_text true}})))}
 :nvim-treesitter/nvim-treesitter
 :nvim-treesitter/playground

 ;; See :help nvim-treesitter-textobjects.
 :nvim-treesitter/nvim-treesitter-textobjects

 ;; See :help nvim-treesitter-refactor.txt.
 :nvim-treesitter/nvim-treesitter-refactor

 :JoosepAlviste/nvim-ts-context-commentstring)
