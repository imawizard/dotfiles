(import-macros {: oset! : aucmd!} :macros)

(local modes
  {:n    {:name "NORMAL"   :color "#98c379"}
   :no   {:name "O-PEND"   :color "#98c379"}
   :i    {:name "INSERT"   :color "#61afef"}
   :ic   {:name "INSERT"   :color "#61afef"}
   :R    {:name "REPLACE"  :color "#e06c75"}
   :v    {:name "VISUAL"   :color "#c678dd"}
   :V    {:name "V-LINE"   :color "#c678dd"}
   "\22" {:name "V-BLOCK"  :color "#c678dd"}
   :c    {:name "COMMAND"  :color "#8bbccc"}
   :t    {:name "TERMINAL" :color "#98c379"}})

(fn set-mode-hl []
  (let [bg (or (?. modes (vim.fn.mode) :color) "#98c379")]
    (vim.api.nvim_set_hl
     0
     :StatusLineMode
     {:fg "#fafafa" :bg bg :bold true})))

(set-mode-hl)

(aucmd!
 (:group
  :colorize-statusline-mode
  [ModeChanged ColorScheme]
  set-mode-hl))

(oset!
 showmode    false
 statusline  "%!v:lua.Statusline.build()")

(local M {})

(fn M.mode []
  (let [m (vim.fn.mode)]
    (or (?. modes m :name) m)))

(fn M.filename []
  (let [name (vim.fn.expand "%:f")]
    (if (= "" name)
        "[scratch]"
        name)))

(fn M.branch []
  (if vim.b.gitsigns_head
      (.. vim.b.gitsigns_head " ")
      ""))

(fn M.indentation []
  (let [b vim.bo]
    (if b.expandtab
        (.. "SP:" b.shiftwidth)
        (if (= b.shiftwidth b.tabstop)
            (.. "TB:" b.shiftwidth)
            (.. "TB:" b.shiftwidth "/" b.tabstop)))))

(fn M.fileformat []
  (match vim.bo.fileformat
    "unix" "LF"
    "dos" "CRLF"
    _ "CR"))

(fn M.percentage []
  (let [cur (vim.fn.line ".")
        total (vim.fn.line "$")]
    (if (> total 0)
        (.. (math.floor (* 100 (/ cur total))) "%")
        "0%")))

(fn M.diagnostics []
  (if (next (vim.diagnostic.count))
      (.. (vim.diagnostic.status) " ")
      ""))

;; Default is:
;; %<%f %h%w%m%r
;; %{% v:lua.require('vim._core.util').term_exitcode() %}
;; %=
;; %{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}
;; %{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}
;; %{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}
;; %{% &busy > 0 ? '◐ ' : '' %}
;; %{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or '''' ') %}
;; %{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}
(fn M.build []
  (let [active? (= (vim.api.nvim_get_current_win)
                   (tonumber (or vim.g.statusline_winid -1)))]
    (.. (if active? (.. "%#StatusLineMode# " (M.mode) " %*") "")
        "%{&busy > 0 ? '◐ ' : '  '}"
        "%{v:lua.Statusline.filename()} "
        "%{&modified ? '[+]' : '   '}"
        "%h%w%r "
        "%{v:lua.require'vim._core.util'.term_exitcode()}"
        "%{v:lua.Statusline.branch()}  "
        "  "
        "%{% v:lua.Statusline.diagnostics() %}"
        "%="
        (if active? (or (vim.ui.progress_status) "") "")
        "%l:%c "
        "%{v:lua.Statusline.percentage()}  "
        "%{&fileencoding !=# '' ? &fileencoding : &encoding}  "
        "%{v:lua.Statusline.indentation()} "
        "%{v:lua.Statusline.fileformat()}  "
        "%{&filetype} ")))

(set _G.Statusline M)
