(import-macros {: gset! : aucmd! : has? : bind! : feedkeys! : trim-lines!} :macros)

(gset!
 fennel_maxlines                300
 fennel_fuzzy_indent            true
 fennel_fuzzy_indent_patterns   ["^def" "^let" "^while" "^if" "^fn$" "^var$"
                                 "^case$" "^for$" "^each$" "^local$" "^global$"
                                 "^match$" "^macro" "^lambda$"
                                 "^comment$" "^when" "when$"
                                 "^accumulate$" "collect$"]
 fennel_fuzzy_indent_blacklist  ["^if$"]
 fennel_special_indent_words    ""
 fennel_align_multiline_strings false ; buggy
 fennel_align_subforms          true)

(aucmd!
 (:group
  "fennel-bindings"
  Filetype
  :pattern "fennel"
  (fn [args]
    (if (not (vim.startswith (vim.fn.bufname args.buf)
                             "hotpot-reflect-session"))
        (do

         ;; (repl:exec (trim-lines! (vim.treesitter.query.get_node_text (get-form) 0 {:concat false})))
         (fn get-form [node]
           (let [node (or node (vim.treesitter.get_node))
                 parent (node:parent)]
             (if parent
                 (let [child (node:child 0)]
                   (if (or (not child)
                           (not= (child:type) "("))
                       (get-form parent)
                       node))
                 node)))

         ;; (repl:exec (trim-lines! (vim.treesitter.query.get_node_text (get-root) 0 {:concat false})))
         (fn get-root [node]
           (let [node (or node (vim.treesitter.get_node))
                 parent (node:parent)]
             (if (and parent
                      (parent:parent))
                 (get-root parent)
                 node)))

         ;; (select-node (get-form) 0)
         (fn select-node [node]
           (let [(start_row start_col end_row end_col) (node:range)]
             (vim.api.nvim_win_set_cursor 0 [(+ start_row 1) start_col])
             (vim.cmd "normal! v")
             (vim.api.nvim_win_set_cursor 0 [(+ end_row 1) (- end_col 1)])))

         ;; REPL via hotpot.nvim
         ;; see https://github.com/rktjmp/hotpot.nvim/blob/main/COOKBOOK.md#using-hotpot-reflect
         (let [reflect (require :hotpot.api.reflect)
               prop :hotpot-reflect-vars
               initial-mode :eval]

           (fn open-hotpot-reflect [bufnr]
             (let [{: id} (or (. vim.b bufnr prop) {})]
               (if id (do
                       (reflect.attach-input id bufnr)
                       (feedkeys! "<ESC>"))
                   (let [session-bufnr (vim.api.nvim_create_buf true true)
                         session-id (reflect.attach-output session-bufnr)]
                     ;; save session id and bufnr in current buffer
                     (tset (. vim.b bufnr) prop {:id session-id
                                                 :bufnr session-bufnr
                                                 :mode initial-mode})
                     (reflect.set-mode session-id initial-mode)
                     (reflect.attach-input session-id bufnr)
                     ;; create window, swap buffer, and move back to previous window
                     (vim.schedule
                      (fn []
                        (vim.api.nvim_command "botright vnew")
                        (vim.api.nvim_win_set_buf
                         (vim.api.nvim_get_current_win)
                         session-bufnr)
                        (vim.cmd "wincmd p")
                        ;; bind <CR> to toggle reflect-mode
                        (bind!
                         :bufnr session-bufnr
                         "<CR>" n (fn []
                                    (let [vars (. vim.b bufnr prop)
                                          session-mode (if (= (. vim.b bufnr prop :mode)
                                                              :eval) :compile :eval)]
                                      (tset vars :mode (if (= vars.mode :eval) :compile :eval))
                                      (tset (. vim.b bufnr) prop vars)
                                      (reflect.set-mode vars.id vars.mode)))
                         "q" n ":wincmd c|wincmd p<CR>")
                        ;; delete reflect buffer if current buffer got closed
                        (aucmd!
                         BufWipeout
                         :bufnr bufnr
                         :once true
                         (.. ":" session-bufnr "bdelete")
                         ;; remove saved values if reflect buffer got closed
                         BufWipeout
                         :bufnr session-bufnr
                         :once true
                         #(tset (. vim.b bufnr) prop nil))))))))

           (fn update-hotpot-reflect [bufnr]
             (let [{: id : mode} (or (. vim.b bufnr prop) {})]
               (when id
                 (reflect.set-mode id mode))))

           (when reflect
             (bind!
              :desc "Eval with hotpot.nvim" :bufnr args.buf
              "<Space>ll" v #(open-hotpot-reflect args.buf)

              :desc "Re-eval with hotpot.nvim" :bufnr args.buf
              "<Space>ll" n #(update-hotpot-reflect args.buf)

              :desc "Current form" :bufnr args.buf
              "<Space>el" n (fn []
                              (select-node (get-form) 0)
                              (open-hotpot-reflect args.buf))

              :desc "Root form" :bufnr args.buf
              "<Space>er" n (fn []
                              (select-node (get-root) 0)
                              (open-hotpot-reflect args.buf))))))))))

{1 :bakpakin/fennel.vim
 :ft "fennel"}
