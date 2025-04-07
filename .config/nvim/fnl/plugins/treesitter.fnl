(import-macros {: aucmd!} :macros)

;; For inspection, use:
;;  :Inspect to show the highlight groups under the cursor)
;;  :InspectTree to show the parsed syntax tree ("TSPlayground")
;;  :EditQuery to open the Live Query Editor (Nvim 0.10+)
;;
;; For treesitter-based indentation, use:
;;  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
;;
;; See also :help nvim-treesitter-api
[{1 :nvim-treesitter/nvim-treesitter
  :lazy false
  :branch "main"
  :build ":TSUpdate"
  :opts (fn []
          (aucmd!
           (:group
            "auto-install-and-activate-tresitter-grammars"
            FileType
            (fn [args]
              (let [ts (require :nvim-treesitter)
                    ft args.match
                    bufnr args.buf]
                ;; Auto-install and activate treesitter grammars.
                (: (ts.install ft) :await
                   #(pcall vim.treesitter.start bufnr)))))))}

 ;; See :help nvim-treesitter-textobjects.
 {1 :nvim-treesitter/nvim-treesitter-textobjects
  :branch "main"
  :opts {:select
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
                        "<leader>dF" "@class.outer"}}}}]

 ; {1 :JoosepAlviste/nvim-ts-context-commentstring}]
 ; {:config
 ;  (fn []
 ;    (let [cs (require :ts_context_commentstring)]
 ;      (tset vim.g :skip_ts_context_commentstring_module true)
 ;      (cs.setup
 ;       {:enable_autocmd false})))}
 ; :JoosepAlviste/nvim-ts-context-commentstring]
