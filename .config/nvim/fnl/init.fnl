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
      loadfn (fn [root dir path]
               (require-forcefully (string.gsub
                                    (.. dir "/" (string.sub path 1 -5))
                                    "\\" "/"))
               nil)]
  (build (join-path (vim.fn.fnamemodify vim.env.MYVIMRC ":h") :fnl)
         {:verbosity 0}

         ;; Load everything in plugins and langs.
         (join-path "(.+)" "(plugins)" "(.+)")
         loadfn
         (join-path "(.+)" "(langs)" "(.+)")
         loadfn

         ;; Compile ftplugins to external ftplugin-folder.
         (join-path "(.+)" :ftplugins "(.+)")
         (fn [root path]
           (join-path root ".." :ftplugin path))

         ;; Compile snippets to external luasnippets-folder.
         (join-path "(.+)" :snippets "(.+)")
         (fn [root path]
           (join-path root ".." :luasnippets path))))

(vim.cmd "colorscheme bold-intellij-light")

(vim.diagnostic.config {:severity_sort true})

(vim.fn.sign_define "DiagnosticSignError" {:text "E" :texthl "DiagnosticSignError" :numhl "DiagnosticSignError"})
(vim.fn.sign_define "DiagnosticSignWarn"  {:text "W" :texthl "DiagnosticSignWarn"  :numhl "DiagnosticSignWarn"})
(vim.fn.sign_define "DiagnosticSignInfo"  {:text "I" :texthl "DiagnosticSignInfo"  :numhl "DiagnosticSignInfo"})
(vim.fn.sign_define "DiagnosticSignHint"  {:text "H" :texthl "DiagnosticSignHint"  :numhl "DiagnosticSignHint"})
