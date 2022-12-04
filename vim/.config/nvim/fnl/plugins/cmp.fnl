(import-macros {: use!} :macros)

(use!
 :hrsh7th/cmp-buffer
 :hrsh7th/cmp-nvim-lsp
 :hrsh7th/cmp-path
 :hrsh7th/cmp-cmdline
 :hrsh7th/cmp-calc
 :quangnguyen30192/cmp-nvim-tags
 :saadparwaiz1/cmp_luasnip
 :rcarriga/cmp-dap

 ;; Full-blown completion, see :help nvim-cmp.
 {:config
  (fn []
    (fn has_words_before []
      (let [[line col] (vim.api.nvim_win_get_cursor 0)]
        (and (not= col 0)
             (= (: (: (. (vim.api.nvim_buf_get_lines 0 (- line 1) line true) 1)
                      :sub col col)
                   :match "%s")
                nil))))

    (fn feedkeys [key mode]
      (vim.api.nvim_feedkeys
       (vim.api.nvim_replace_termcodes key true true true)
       mode
       false))

    (let [cmp (require :cmp)
          cmp_types (require :cmp.types)
          luasnip (require :luasnip)
          cmp_dap (require :cmp_dap)]
      (cmp.setup
       {:enabled (fn []
                   (or (not= (vim.api.nvim_buf_get_option 0 "buftype") "prompt")
                       (cmp_dap.is_dap_buffer)))
        :snippet {:expand (fn [args]
                            (luasnip.lsp_expand args.body))}
        :preselect cmp.PreselectMode.None
        :completion {:autocomplete false}
        :experimental {:ghost_text true}
        :formatting {:format
                     (fn [entry vim_item]
                       (set vim_item.kind
                            (if (not= entry.source.name "calc")
                                (. vim.lsp.protocol.CompletionItemKind
                                   (. cmp_types.lsp.CompletionItemKind vim_item.kind))
                                ""))
                       vim_item)}
        :sources (cmp.config.sources
                  [{:name "path"}
                   {:name "calc"}]
                  [{:name "nvim_lsp"}
                   {:name "luasnip"}]
                  [{:name "tags"}
                   {:name "buffer"}])
        :mapping
        {:<TAB> (cmp.mapping
                 {:i (fn [fallback]
                       (if (cmp.visible) (cmp.confirm {:select true})
                           (luasnip.expand_or_jumpable) (luasnip.expand_or_jump)
                           (has_words_before) (do
                                               (cmp.complete)
                                               (vim.schedule
                                                (fn []
                                                  (let [entries (cmp.get_entries)]
                                                    (if (= (# entries) 0)
                                                        (print "No entries")
                                                        (and (= (# entries) 1)
                                                             (not (. (. entries 1) :fuzzy)))
                                                        (cmp.confirm {:select true}))))))
                           (fallback)))
                  :c (fn [fallback]
                       (if (= (vim.fn.wildmenumode) 1) (feedkeys "<C-y>" "n")
                           (cmp.visible) (cmp.confirm {:select true})
                           (do
                            (cmp.complete)
                            (vim.schedule
                             (fn []
                               (let [entries (cmp.get_entries)]
                                 (if (= (# entries) 0)
                                     (print "No entries")
                                     (and (= (# entries) 1)
                                          (not (. (. entries 1) :fuzzy)))
                                     (cmp.confirm {:select true}))))))))})
         :<S-TAB> (cmp.mapping
                   {:i (fn [fallback]
                         (if (luasnip.jumpable -1)
                             (luasnip.jump -1)
                             (fallback)))}
                   {:s (fn [fallback]
                         (if (luasnip.jumpable -1)
                             (luasnip.jump -1)
                             (fallback)))})
         :<CR> (cmp.mapping
                {:i (fn [fallback]
                      (if (cmp.visible)
                          (do (cmp.confirm {:select true})
                              (vim.schedule fallback))
                          (fallback)))
                 :c (fn [fallback]
                      (if (cmp.visible)
                          (do (cmp.confirm {:select true})
                              (vim.schedule fallback))
                          (fallback)))})
         :<ESC> (cmp.mapping
                 {:i (fn [fallback]
                       (if (cmp.visible)
                           (do (feedkeys "<C-e>" "i")
                               (vim.schedule fallback))
                           (fallback)))
                  :c (fn [fallback]
                       (feedkeys "<C-c>" "n"))})
         :<C-p> (cmp.mapping
                 {:i (fn [fallback]
                       (if (cmp.visible)
                           (cmp.select_prev_item {:behavior cmp.SelectBehavior.Select})
                           (cmp.complete {:config {:preselect cmp.PreselectMode.Item}})))
                  :c (fn [fallback]
                       (if (= (vim.fn.wildmenumode) 1) (feedkeys "<C-p>" "n")
                           (cmp.visible) (cmp.select_prev_item {:behavior cmp.SelectBehavior.Select})
                           (feedkeys "<Up>" "n")))})
         :<C-n> (cmp.mapping
                 {:i (fn [fallback]
                       (if (cmp.visible)
                           (cmp.select_next_item {:behavior cmp.SelectBehavior.Select})
                           (cmp.complete {:config {:preselect cmp.PreselectMode.Item}})))
                  :c (fn [fallback]
                       (if (= (vim.fn.wildmenumode) 1) (feedkeys "<C-n>" "n")
                           (cmp.visible) (cmp.select_next_item {:behavior cmp.SelectBehavior.Select})
                           (feedkeys "<Down>" "n")))})
         :<C-y> (cmp.mapping {:i (cmp.mapping.confirm {:select false})
                              :c (cmp.mapping.confirm {:select false})})
         :<C-e> (cmp.mapping {:i (cmp.mapping.abort)
                              :c (cmp.mapping.abort)})
         :<C-u> (cmp.mapping {:i (cmp.mapping.scroll_docs -4)
                              :c (cmp.mapping.scroll_docs -4)})
         :<C-d> (cmp.mapping {:i (cmp.mapping.scroll_docs 4)
                              :c (cmp.mapping.scroll_docs 4)})}})
      (cmp.setup.cmdline
       "/" {:sources (cmp.config.sources [{:name "buffer"
                                           :option {:keyword_pattern "[^\\v[:blank:]].*"}}])})
      (cmp.setup.cmdline
       ":" {:sources (cmp.config.sources [{:name "path"}
                                          {:name "cmdline"}])})
      (cmp.setup.filetype
       ["dap-repl" "dapui_watches" "dapui_hover"]
       {:sources (cmp.config.sources [{:name "dap"}])})))}
 :hrsh7th/nvim-cmp)

(set vim.lsp.protocol.CompletionItemKind [" text"         ;  text
                                          " method"       ; method
                                          " function"     ; function
                                          " constructor"  ;  constructor
                                          " field"        ; ﰠ field
                                          " variable"     ;  variable
                                          " class"        ; class
                                          "ﰮ interface"    ; interface
                                          " module"       ;  module
                                          " property"     ; property
                                          " unit"         ; unit
                                          " value"        ; value
                                          " enum"         ; 了enum
                                          " keyword"      ; keyword
                                          "﬌ snippet"      ;  snippet
                                          " color"        ;  color
                                          " file"         ;  file
                                          " reference"    ;  reference
                                          " folder"       ;  folder
                                          " enum member"  ; enum member
                                          " const"        ; constant
                                          " struct"       ; struct
                                          " event"        ; ⌘ event
                                          "ﬦ operator"     ;  operator
                                          " type param"]) ;  type parameter
