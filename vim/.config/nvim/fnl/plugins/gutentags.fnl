(import-macros {: use! : gset! : aucmd! : bind!} :macros)

(use!
 ;; Management of tag files, see :help gutentags.txt.
 :ludovicchabant/vim-gutentags)

(gset!
 gutentags_ctags_executable         vim.g.ctags_host_prog
 gutentags_ctags_extra_args         ["--with-list-header=true"]
 gutentags_ctags_exclude_wildignore false
 gutentags_ctags_tagfile            "tags"
 gutentags_project_root             [vim.g.gutentags_ctags_tagfile] ; Use the nearest tags-file.
 gutentags_init_user_func           "GutentagsInitUserFunc"         ; Only activate if there already is a tags-file.
 gutentags_generate_on_missing      0                               ; Don't automatically generate tags.
 gutentags_generate_on_new          0                               ; Same with this one.
 gutentags_file_list_command        "rg --files --color=never -g \"!.git/\"")

;; Activate gutentags only if there is a tags-file:
;; Create the first one manually with :!touch tags and :edit, after that it gets
;; updated by gutentags on every save.
(vim.cmd
 "
 fun! GutentagsInitUserFunc(file) abort
     try
         let tagfile = gutentags#get_project_root(a:file) . '/' . g:gutentags_ctags_tagfile
         return filereadable(tagfile)
     catch
     endtry
     return 0
 endfun
 ")
