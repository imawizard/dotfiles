(local require-forcefully
  (fn [path]
    (tset package.loaded path nil)
    (pcall require path)))

;; Load modules from root-folder.
(each [_ v (ipairs [:settings :keybinds :autocmds :commands])]
  (require-forcefully v))

(vim.cmd "colorscheme bold-intellij-light")

(vim.diagnostic.config {:severity_sort true})

(vim.fn.sign_define "DiagnosticSignError" {:text "E" :texthl "DiagnosticSignError" :numhl "DiagnosticSignError"})
(vim.fn.sign_define "DiagnosticSignWarn"  {:text "W" :texthl "DiagnosticSignWarn"  :numhl "DiagnosticSignWarn"})
(vim.fn.sign_define "DiagnosticSignInfo"  {:text "I" :texthl "DiagnosticSignInfo"  :numhl "DiagnosticSignInfo"})
(vim.fn.sign_define "DiagnosticSignHint"  {:text "H" :texthl "DiagnosticSignHint"  :numhl "DiagnosticSignHint"})
