;; Stop hiding diagnostics when entering insert mode.
;; Also see https://github.com/neovim/neovim/issues/26078.
(let [original-hide vim.diagnostic.handlers.signs.hide]
  (set vim.diagnostic.handlers.signs.hide
       (fn [namespace bufnr]
         (let [mode (. (vim.api.nvim_get_mode) :mode)]
           (when (not (mode:match "^[iR]"))
             ;; Skip when in insert or replace mode.
             (original-hide namespace bufnr))))))

(let [severity vim.diagnostic.severity
      hl-map   {severity.ERROR "DiagnosticSignError"
                severity.WARN  "DiagnosticSignWarn"
                severity.INFO  "DiagnosticSignInfo"
                severity.HINT  "DiagnosticSignHint"}
      order    [severity.ERROR severity.WARN severity.INFO severity.HINT]]
    (vim.diagnostic.config
     {:virtual_text {:current_line true}
      :virtual_lines false
      :update_in_insert false
      :severity_sort true
      :signs {:text {severity.ERROR "●"
                     severity.WARN  "●"
                     severity.INFO  "●"
                     severity.HINT  "●"}}
      :status {:format (fn [counts]
                           (let [parts []]
                               (each [_ sev (ipairs order)]
                                   (let [count (. counts sev)]
                                       (when (and count (> count 0))
                                           (table.insert
                                            parts
                                            (string.format "%%#%s#●%%* %d" (. hl-map sev) count)))))
                               (table.concat parts " ")))}}))
