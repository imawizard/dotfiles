(import-macros {: use! : gset! : aucmd! : has? : bind! : feedkeys! : trim-lines!} :macros)

(use!
 :bakpakin/fennel.vim)

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

         ;; REPL via fennel.bat
         (let [[ok repl] [(pcall _G.inject-repl args.buf (if (has? "win32")
                                                             "fennel.bat"
                                                             "fennel"))]
               ts vim.treesitter
               utils (require :nvim-treesitter.ts_utils)]

           (fn get-form [node]
             (let [node (or node (utils.get_node_at_cursor 0))
                   parent (node:parent)]
               (if parent
                   (let [child (node:child 0)]
                     (if (or (not child)
                             (not= (child:type) "("))
                         (get-form parent)
                         node))
                   node)))

           (fn get-root [node]
             (let [parent (node:parent)]
               (if (and parent
                        (parent:parent))
                   (get-root parent)
                   node)))

           (when ok
             (bind!
              :desc "Current form" :bufnr args.buf
              "<leader>ee" n #(repl:exec
                               (trim-lines!
                                (ts.query.get_node_text
                                 (get-form (utils.get_node_at_cursor 0))
                                 0 {:concat false})))

              :desc "Root form" :bufnr args.buf
              "<leader>er" n #(repl:exec
                               (trim-lines!
                                (ts.query.get_node_text
                                 (get-root (utils.get_node_at_cursor 0))
                                 0 {:concat false}))))))

         ;; REPL via hotpot.nvim
         ;; see https://github.com/rktjmp/hotpot.nvim/blob/master/COOKBOOK.md#using-hotpot-reflect
         (let [reflect (require :hotpot.api.reflect)
               prop :hotpot-reflect-vars
               initial-mode :eval]

           (fn open-hotpot-reflect [bufnr]
             (let [{: id} (or (. vim.b bufnr prop) {})]
               (if id (do
                       (reflect.attach-input id bufnr)
                       (feedkeys! "<ESC>"))
                   (let [new-buf (vim.api.nvim_create_buf true true)
                         new-id (reflect.attach-output new-buf)]
                     (tset (. vim.b bufnr) prop {:id new-id
                                                 :mode initial-mode})
                     (tset (. vim.b new-buf) prop {:mode initial-mode})
                     (reflect.set-mode new-id initial-mode)
                     (reflect.attach-input new-id bufnr)
                     (vim.schedule
                      #(do
                        (vim.api.nvim_command "botright vnew")
                        (vim.api.nvim_win_set_buf
                         (vim.api.nvim_get_current_win)
                         new-buf)
                        (vim.cmd "wincmd p")
                        (bind!
                         :bufnr new-buf
                         "<CR>" n #(let [new-mode (if (= (. vim.b new-buf prop :mode)
                                                         :eval) :compile :eval)]
                                     (reflect.set-mode new-id new-mode)
                                     (tset (. vim.b new-buf) prop {:mode new-mode}))
                         "q" n ":wincmd c|wincmd p<CR>")
                        (aucmd!
                         BufWipeout
                         :bufnr bufnr
                         :once true
                         (.. ":" new-buf "bdelete")
                         BufWipeout
                         :bufnr new-buf
                         :once true
                         #(tset (. vim.b bufnr) prop nil))))))))

           (fn update-hotpot-reflect [bufnr]
             (let [{: id : mode} (or (. vim.b bufnr prop) {})]
               (when id
                 (reflect.set-mode id mode))))

           (when reflect
             (bind!
              :desc "Eval with hotpot.nvim" :bufnr args.buf
              "<leader>eh" v #(open-hotpot-reflect args.buf)

              :desc "Re-eval with hotpot.nvim" :bufnr args.buf
              "<leader>eh" n #(update-hotpot-reflect args.buf)))))))))
