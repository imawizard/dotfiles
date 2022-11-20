(local require-forcefully
  (fn [path]
    (tset package.loaded path nil)
    (require path)))

;; Startup packer.nvim, see :help packer.txt.
(let [packer (require :packer)
      {: startup } packer]
  (startup (fn [use]
             (use :wbthomason/packer.nvim)
             (use :rktjmp/hotpot.nvim))))

;; Load modules from root-folder.
(each [_ v (ipairs [:settings :keybinds :autocmds])]
  (require-forcefully v))

;; Compile config with hotpot, see :help hotpot-api.
(let [{: build} (require :hotpot.api.make)
      {: join-path} (require :hotpot.fs)
      loadfn (fn [root dir path]
               (require-forcefully (string.gsub
                                    (.. dir "/" (string.sub path 1 -5))
                                    "\\" "/"))
               nil)]
  (build (join-path (vim.fn.fnamemodify (os.getenv :MYVIMRC) ":h") :fnl)
         {:verbosity 0}

         ;; Load everything in plugins and langs.
         (join-path "(.+)" "(plugins)" "(.+)")
         loadfn
         (join-path "(.+)" "(langs)" "(.+)")
         loadfn

         ;; Compile ftplugins to external ftplugin-folder.
         (join-path "(.+)" :ftplugins "(.+)")
         (fn [root path]
           (join-path root ".." :ftplugin path))))
