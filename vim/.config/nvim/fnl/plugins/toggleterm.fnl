(import-macros {: use! : executable? : aucmd! : bind! : trim-lines!} :macros)

(use!
 ;; See :help toggleterm.txt.
 {:config
  (fn []
    (let [tt (require :toggleterm)
          terminal (require :toggleterm.terminal)
          Terminal terminal.Terminal]

      (tt.setup {:open_mapping "<C-z>"})

      (fn _G.inject-repl [bufnr cmd]
        (local close-augrp "auto-close-repl")

        (fn on-create [self]
          (tset (. vim.bo self.bufnr) :buflisted false)
          (bind!
           :bufnr self.bufnr
           "<ESC>" tb #(self:hide))
          (vim.schedule
           #(aucmd!
             (:group
              (.. close-augrp "-" bufnr)
              [CursorMoved InsertEnter BufLeave]
              :bufnr bufnr
              #(self:hide)
              BufWipeout
              :bufnr bufnr
              #(self:shutdown)))))

        (fn on-exit [self]
          (pcall vim.api.nvim_del_augroup_by_name
                 (.. close-augrp "-" bufnr)))

        (when (and (. vim.bo bufnr :buflisted)
                   (executable? cmd))
          (let [width (math.ceil (* vim.o.columns 0.42))
                height (math.ceil (* vim.o.lines 0.3))
                row 0
                col (- vim.o.columns width)
                repl (Terminal:new
                      {:cmd cmd
                       :hidden true
                       :persist_mode false
                       :start_in_insert false
                       :direction "float"
                       :float_opts {:border "rounded"
                                    :relative "editor"
                                    :row row
                                    :col col
                                    :width width
                                    :height height}
                       :on_create on-create
                       :on_exit on-exit})]

            (fn repl.show [self]
              (when (not (self:is_open))
                (do
                 (self:open)
                 (when (self:is_focused)
                   (vim.cmd "noautocmd wincmd p | stopinsert")))))

            (fn repl.hide [self]
              (when (self:is_open)
                (self:close)))

            (fn repl.exec [self what]
              (self:show)
              (self:send what true))

            (let [ts vim.treesitter
                  utils (require :nvim-treesitter.ts_utils)]
              (bind!
               :desc "Buffer" :bufnr bufnr
               "<leader>eb" n #(repl:exec
                                (trim-lines!
                                 (vim.api.nvim_buf_get_lines 0 0 -1 false)))

               :desc "Enter REPL" :bufnr bufnr
               "<leader>ei" n #(do (repl:open)
                                   (when (not (repl:is_focused)) (repl:focus)))

               :desc "Under cursor" :bufnr bufnr
               "<leader>ew" n #(repl:exec
                                (trim-lines!
                                 (ts.query.get_node_text
                                  (utils.get_node_at_cursor)
                                  0 {:concat false})))

               :desc "Evaluate selection" :bufnr bufnr
               "<leader>E" x #(repl:exec (trim-lines! (_G.selected-text)))))
            (repl:show)
            repl)))))}
 :akinsho/toggleterm.nvim)
