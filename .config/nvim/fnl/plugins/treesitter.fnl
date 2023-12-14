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

        :textobjects {:select
                      {:enable true
                       :lookahead false
                       :include_surrounding_whitespace true
                       :keymaps
                       {"af" {:query "@function.outer"  :desc "Select outer part of a function"}
                        "if" {:query "@function.inner"  :desc "Select inner part of a function"}
                        "ac" {:query "@call.outer"      :desc "Select outer part of a call"}
                        "ic" {:query "@call.inner"      :desc "Select inner part of a call"}
                        "aC" {:query "@class.outer"     :desc "Select outer part of a class region"}
                        "iC" {:query "@class.inner"     :desc "Select inner part of a class region"}
                        "aa" {:query "@parameter.outer" :desc "Select outer part of a parameter"}
                        "ia" {:query "@parameter.inner" :desc "Select inner part of a parameter"}}
                       :selection_modes {"@function.outer" "V"}}
                      :lsp_interop {:enable true
                                    :border "none"
                                    :peek_definition_code
                                    {"<leader>df" "@function.outer"
                                     "<leader>dF" "@class.outer"}}}

        :refactor {:highlight_definitions {:enable true
                                           :clear_on_cursor_move true}
                   :highlight_current_scope {:enable false}
                   :smart_rename {:enable true}
                   :navigation {:enable true}}

        :playground {}

        :matchup {:enable true
                  :disable_virtual_text true}})))}
 :nvim-treesitter/nvim-treesitter
 :nvim-treesitter/playground

 ;; See :help nvim-treesitter-textobjects.
 :nvim-treesitter/nvim-treesitter-textobjects

 ;; See :help nvim-treesitter-refactor.txt.
 :nvim-treesitter/nvim-treesitter-refactor

 {:config
  (fn []
    (let [cs (require :ts_context_commentstring)]
      (tset vim.g :skip_ts_context_commentstring_module true)
      (cs.setup
       {:enable_autocmd false})))}
 :JoosepAlviste/nvim-ts-context-commentstring)
