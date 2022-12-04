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
      (let [pkg (table.remove rest 1)]
        (if (not (table? pkg))
            (table.insert out `(,use ,pkg))
            (let [opts pkg
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
  (:when (has! :nvim-0.7)
  laststatus 3))

  Results in:
  (tset vim.opt :lisp true)
  (when (has! :nvim-0.7)
  (tset vim.opt :laststatus 3))
  "
  (M.xset!
   (fn [key value]
     (if (and (list? value)
              (> (# value) 1)
              (= (type (. value 1)) :string))
         (let [op (. value 1)
               vsa [(select 2 (unpack value))]
               vsu (if (= (# vsa) 1)
                       (. vsa 1)
                       vsa)]
           (match op
             :append  `(: (. vim.opt ,(tostring key)) :append ,vsu)
             :prepend `(: (. vim.opt ,(tostring key)) :prepend ,vsu)
             :remove  `(: (. vim.opt ,(tostring key)) :remove ,vsu)))
         `(tset vim.opt ,(tostring key) ,value)))
   ...))

(fn M.xset! [cb ...]
  (let [rest [...]
        out []]
    (var opts [])
    (while (> (# rest) 0)
      (let [key (table.remove rest 1)]
        (if
         (sym? key) (let [value (table.remove rest 1)]
                      (table.insert out (cb key value opts))
                      (set opts []))
         (list? key) (table.insert
                      out
                      (match (. key 1)
                        :when (let [cond (. key 2)
                                    body [(select 3 (unpack key))]]
                                `(when ,cond ,(M.xset! cb (unpack body))))
                        _ `nil))
         (table.insert opts key))))
    `(do ,(unpack out))))

(fn M.bind! [...]
  "Wrapper for VimL's map"
  (fn bind [prefix ...]
    (let [rest [...]
          out []]
      (var desc nil)
      (while (> (# rest) 0)
        (let [from (table.remove rest 1)]
          (if (list? from)
              (table.insert
               out
               (match (. from 1)
                 :prefix (let [key (. from 2)
                               name (. from 3)
                               body [(select 4 (unpack from))]]
                           (bind key (unpack body)))))
              (match from
                :desc (set desc (table.remove rest 1))
                _ (let [opts (tostring (table.remove rest 1))
                        to (table.remove rest 1)]
                    (table.insert
                     out
                     (let [key (.. prefix from)
                           modes (icollect [s (string.gmatch opts "[nivxcto]")] s)
                           flags {:buffer (if (string.match opts "b") true false)
                                  :desc desc
                                  :expr (if (string.match opts "e") true false)
                                  :remap (if (string.match opts "r") true false)
                                  :silent (if (string.match opts "!") false true)}]
                       (if (= (?. to 1 1) :quote)
                           `(vim.keymap.set ,modes ,key (fn [] ,(. to 2)) ,flags)
                           `(vim.keymap.set ,modes ,key ,to ,flags))))
                    (set desc nil))))))
      `(do ,(unpack out))))
  (bind "" ...))

(fn M.binds! [...]
  "Like bind! but returns the mapping as a table"
  (let [rest [...]
        out {}]
    (var desc nil)
    (while (> (# rest) 0)
      (let [from (table.remove rest 1)]
        (if (list? from)
            (match (. from 1)
              :prefix (let [key (. from 2)
                            name (. from 3)
                            body [(select 4 (unpack from))]
                            tbl (M.binds! (unpack body))]
                        (tset tbl :name name)
                        (tset out key tbl)))
            (match from
              :desc (set desc (table.remove rest 1))
              _ (let [opts (tostring (table.remove rest 1))
                      to (table.remove rest 1)]
                  (let [key (if (= (?. to 1 1) :quote)
                                [`(fn [] ,(. to 2)) desc]
                                [to desc])
                        modes (icollect [s (string.gmatch opts "[nivxcto]")] s)
                        flags {:buffer (if (string.match opts "b") `(vim.fn.bufnr "%"))
                               :expr (if (string.match opts "e") true false)
                               :mode modes
                               :noremap (if (string.match opts "r") false true)
                               :silent (if (string.match opts "!") false true)}]
                    (tset
                     out
                     from
                     (collect [i v (ipairs key) &into flags] i v)))
                  (set desc nil))))))
    out))

(fn M.has! [value]
  "Shorthand for vim.fn.has returning boolean"
  `(= (vim.fn.has ,value) 1))

(fn M.mode? [v]
  "Shorthand for checking current mode"
  `(= (. (vim.api.nvim_get_mode) :mode) ,v))

(fn M.feedkeys! [key mode]
  "Shorthand for nvim_feedkeys with nvim_replace_termcodes"
  `(vim.api.nvim_feedkeys
    (vim.api.nvim_replace_termcodes ,key true true true)
    ,(if (not= mode nil) mode "n")
    false))

(fn M.aucmd! [...]
  (fn parse-cmd [group rest]
    (var out nil)
    (var events nil)
    (var pattern "")
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
              cmd (set out
                       `(vim.api.nvim_create_autocmd
                         ,events
                         {:group ,group
                          :pattern ,pattern
                          :callback ,(if (= (?. cmd 1 1) :quote)
                                         `(fn [] ,(. cmd 2))
                                         (not= (type cmd) "string")
                                         cmd)
                          :command ,(if (= (type cmd) "string")
                                        cmd)}))))))
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
             (match (?. arg 1)
               :group (parse-group (select 2 (unpack arg)))
               other (assert-compile false (.. "Unexpected " other)))
             (parse-cmd "" rest)))))
    `(do ,(unpack out))))

M
