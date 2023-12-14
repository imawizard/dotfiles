(local require-forcefully
  (fn [path]
    (tset package.loaded path nil)
    (pcall require path)))

;; Startup packer.nvim, see :help packer.txt.
(let [packer (require :packer)
      {: startup } packer]
  (startup {1 (fn [use]
                (use :wbthomason/packer.nvim)
                (use :rktjmp/hotpot.nvim))
            :config {:log {:level "info"}
                     :autoremove true}}))

;; Load modules from root-folder.
(each [_ v (ipairs [:settings :keybinds :autocmds :commands])]
  (require-forcefully v))

;; Compile config with hotpot, see :help hotpot-api.
(let [{: build} (require :hotpot.api.make)
      {: join-path} (require :hotpot.fs)
      cfg-path (vim.fn.fnamemodify vim.env.MYVIMRC ":h")
      fnl-path (join-path cfg-path :fnl)
      loadfn (fn [path]
               (require-forcefully (-> path
                                       (string.gsub fnl-path "")
                                       (string.gsub "\\" "/")
                                       (string.sub 2 -5)))
               false)]
  (build fnl-path
         {:verbose false}

         ;; Load everything in plugins and langs.
         [[:plugins/**/*.fnl loadfn]
          [:langs/**/*.fnl loadfn]

          ;; Compile ftplugins to external ftplugin-folder.
          [:ftplugins/**/*.fnl (fn [path]
                                 (-> path
                                     (string.gsub (join-path :fnl :ftplugins) :ftplugin)
                                     (string.gsub :.fnl$ :.lua)))]

          ;; Compile snippets to external luasnippets-folder.
          [:snippets/**/*.fnl (fn [path]
                                (-> path
                                    (string.gsub (join-path :fnl :snippets) :luasnippets)
                                    (string.gsub :.fnl$ :.lua)))]]))

(vim.cmd "colorscheme bold-intellij-light")

(vim.diagnostic.config {:severity_sort true})

(vim.fn.sign_define "DiagnosticSignError" {:text "E" :texthl "DiagnosticSignError" :numhl "DiagnosticSignError"})
(vim.fn.sign_define "DiagnosticSignWarn"  {:text "W" :texthl "DiagnosticSignWarn"  :numhl "DiagnosticSignWarn"})
(vim.fn.sign_define "DiagnosticSignInfo"  {:text "I" :texthl "DiagnosticSignInfo"  :numhl "DiagnosticSignInfo"})
(vim.fn.sign_define "DiagnosticSignHint"  {:text "H" :texthl "DiagnosticSignHint"  :numhl "DiagnosticSignHint"})
