(local M {})

(fn M.use! [...]
  "Shorthand for packer.use

  Example:
  (use!
   {:run ...} :nvim-treesitter/nvim-treesitter
   :nvim-treesitter/nvim-treesitter-textobjects)

  Results in:
  (let [packer (require ...) use (. packer :use)]
    (use {1 :nvim-treesitter/nvim-treesitter :run ...})
    (use :nvim-treesitter/nvim-treesitter-textobjects))
  "
  (let [rest [...]
        packer (gensym :packer)
        use (gensym :use)
        out []]
    (while (> (# rest) 0)
      (let [arg (table.remove rest 1)]
        (if (not (table? arg))
            (table.insert out `(,use ,arg))
            (let [opts arg
                  pkg (table.remove rest 1)]
              (table.insert
               out
               `(,use ,(collect [k v (pairs opts)
                                 &into {1 pkg}] k v)))))))
    (table.insert out `nil)
    `(let [,packer (require :packer)
           ,use (. ,packer :use)]
       ,(unpack out))))

(fn M.gset! [...]
  "Shorthand for `let g:x = y`
  y can be a list with :when, :append, :prepend or :remove as head.

  Example:
  (gset!
   fennel_maxlines 300
   fennel_fuzzy_indent true)

  Results in:
  (tset vim.g :fennel_maxlines 300)
  (tset vim.g :fennel_fuzzy_indent true)
  "
  (M.xset! #`(tset vim.g ,(tostring $1) ,$2) ...))

(fn M.oset! [...]
  "Shorthand like gset! but for `set x=y`

  Example:
  (oset!
   lisp true
   (:when (has? :nvim-0.7)
     laststatus 3))

  Results in:
  (tset vim.opt :lisp true)
  (when (has? :nvim-0.7)
    (tset vim.opt :laststatus 3))
  "
  (M.xoset! `vim.opt ...))

(fn M.xoset! [what ...]
  (M.xset!
   (fn [key value]
     (if (and (list? value)
              (= (type (. value 1)) :string))
         (let [op (. value 1)
               vsa [(select 2 (unpack value))]
               vsu (if (= (# vsa) 1)
                       (. vsa 1)
                       vsa)]
           (match op
             :append  `(: (. ,what ,(tostring key)) :append ,vsu)
             :prepend `(: (. ,what ,(tostring key)) :prepend ,vsu)
             :remove  `(: (. ,what ,(tostring key)) :remove ,vsu)
             other (assert-compile false (.. "Unexpected " other))))
         `(tset ,what ,(tostring key) ,value)))
   ...))

(fn M.xset! [cb ...]
  (let [rest [...]
        out []]
    (var opts [])
    (while (> (# rest) 0)
      (let [arg (table.remove rest 1)]
        (if
         (sym? arg) (let [value (table.remove rest 1)]
                      (table.insert out (cb arg value opts))
                      (set opts []))
         (list? arg) (table.insert
                      out
                      (match (. arg 1)
                        :when (let [cond (. arg 2)
                                    body [(select 3 (unpack arg))]]
                                `(when ,cond ,(M.xset! cb (unpack body))))
                        other (assert-compile false (.. "Unexpected " other))))
         (table.insert opts arg))))
    `(do ,(unpack out))))

(fn M.bind! [...]
  "Wrapper for VimL's map"
  (fn bind [prefix ...]
    (let [rest [...]
          out []]
      (var desc nil)
      (var bufnr nil)
      (while (> (# rest) 0)
        (let [arg (table.remove rest 1)]
          (if (list? arg)
              (table.insert
               out
               (match (. arg 1)
                 :prefix (let [key (.. prefix (. arg 2))
                               name (. arg 3)
                               body [(select 4 (unpack arg))]]
                           (bind key (unpack body)))
                 :when (let [cond (. arg 2)
                             body [(select 3 (unpack arg))]]
                         `(when ,cond ,(bind prefix (unpack body))))
                 other (assert-compile false (.. "Unexpected " other))))
              (match arg
                :desc (set desc (table.remove rest 1))
                :bufnr (set bufnr (table.remove rest 1))
                _ (let [opts (tostring (table.remove rest 1))
                        to (table.remove rest 1)]
                    (table.insert
                     out
                     (let [key (.. prefix arg)
                           modes (icollect [s (string.gmatch opts "[nivxcto]")] s)
                           buffer (or bufnr (if (string.match opts "b") 0))
                           flags {:buffer buffer
                                  :desc desc
                                  :expr (if (string.match opts "e") true false)
                                  :remap (if (string.match opts "r") true false)
                                  :silent (if (string.match opts "!") false true)}]
                       `(vim.keymap.set ,modes ,key ,to ,flags)))
                    (set desc nil))))))
      `(do ,(unpack out))))
  (bind "" ...))

(fn M.has? [value]
  "Shorthand for vim.fn.has returning boolean"
  `(= (vim.fn.has ,value) 1))

(fn M.executable? [value]
  "Shorthand for vim.fn.executable returning boolean"
  `(= (vim.fn.executable ,value) 1))

(fn M.mode? [v]
  "Shorthand for checking current mode"
  `(= (. (vim.api.nvim_get_mode) :mode) ,v))

(fn M.feedkeys! [key mode]
  "Shorthand for nvim_feedkeys with nvim_replace_termcodes"
  `(vim.api.nvim_feedkeys
    (vim.api.nvim_replace_termcodes ,key true true true)
    ,(if (not= mode nil) mode "n")
    false))

(fn M.trim-lines! [lines]
  `(icollect [_# line# (ipairs ,lines)]
       (let [s# (vim.trim line#)]
         (if (not= s# "") s#))))

(fn M.aucmd! [...]
  (fn parse-cmd [group rest]
    (var out nil)
    (var events nil)
    (var pattern nil)
    (var bufnr nil)
    (var once nil)
    (while (and (= out nil)
                (> (# rest) 0))
      (let [arg (table.remove rest 1)]
        (if (= events nil)
            (if (sym? arg)
                (set events (tostring arg))
                (sequence? arg)
                (set events (icollect [_ ev (ipairs arg)] (tostring ev))))
            (match arg
              :pattern (set pattern (table.remove rest 1))
              :bufnr (set bufnr (table.remove rest 1))
              :once (set once (table.remove rest 1))
              cmd (let [cmd-sym (gensym :cmd)
                        once-sym (gensym :once)
                        iscb-sym (gensym :iscb)]
                    (set out
                         `(let [,cmd-sym ,cmd
                                ,once-sym ,once
                                ,iscb-sym (= (type ,cmd-sym) "function")]
                            (vim.api.nvim_create_autocmd
                             ,events
                             {:group ,group
                              :pattern ,pattern
                              :buffer ,bufnr
                              :once (if (not ,iscb-sym) ,once-sym)
                              :callback (if ,iscb-sym #(do (,cmd-sym $1) ,once-sym))
                              :command (if (not ,iscb-sym) ,cmd-sym)}))))))))
    out)

  (fn parse-group [name ...]
    (let [rest [...]
          grp (gensym :grp)
          cmds []]
      (while (> (# rest) 0)
        (table.insert cmds (parse-cmd grp rest)))
      `(let [,grp (vim.api.nvim_create_augroup ,name {:clear true})]
         ,(unpack cmds))))

  (let [rest [...]
        out []]
    (while (> (# rest) 0)
      (let [arg (table.remove rest 1)]
        (table.insert
         out
         (if (list? arg)
             (match (. arg 1)
               :group (parse-group (select 2 (unpack arg)))
               other (assert-compile false (.. "Unexpected " other)))
             (do
               (table.insert rest 1 arg)
               (parse-cmd nil rest))))))
    `(do ,(unpack out))))

M
