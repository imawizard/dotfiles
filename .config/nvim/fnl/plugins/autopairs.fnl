;;(import-macros {: use!} :macros)
;;
;;(use!
;; ;; See :help nvim-autopairs.txt and :help nvim-autopairs-rules.txt.
;; {:config
;;  (fn []
;;    (let [autopairs (require :nvim-autopairs)
;;          autopairs_cmp (require :nvim-autopairs.completion.cmp)
;;          cmp (require :cmp)
;;          Rule (require :nvim-autopairs.rule)
;;          conds (require :nvim-autopairs.conds)]
;;
;;      (autopairs.setup {:map_c_h true
;;                        :map_c_w true})
;;
;;      (if (not= cmp nil)
;;          (cmp.event:on "confirm_done" (autopairs_cmp.on_confirm_done)))))}
;; :windwp/nvim-autopairs)

;:ignored_next_char (string.gsub "[%s]* [%w%%%'%[%{%\"%.]" "%s+" "")
;(autopairs.clear_rules)
;;-- Don't autopair ' when in a .tex file
;;npairs.get_rule("'")[1]:with_pair(function()
;;    if vim.bo.filetype == "tex" then
;;        return false
;;    end
;;end)
;;
;;-- Don't autopair " when in a .tex file
;;npairs.get_rule('"')[1]:with_pair(function()
;;    if vim.bo.filetype == "tex" then
;;        return false
;;    end
;;end)
 ; {
 ;    'windwp/nvim-autopairs',
 ;    event = "InsertEnter",
 ;    config = true
 ;    -- use opts = {} for passing setup options
 ;    -- this is equivalent to setup({}) function}

;  {
;     enabled = function(bufnr) return true end, -- control if auto-pairs should be enabled when attaching to a buffer
;     disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
;     disable_in_macro = true, -- disable when recording or executing a macro
;     disable_in_visualblock = false, -- disable when insert after visual block mode
;     disable_in_replace_mode = true,
;     ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
;     enable_moveright = true,
;     enable_afterquote = true, -- add bracket pairs after quote
;     enable_check_bracket_line = true, --- check bracket in same line
;     enable_bracket_in_quote = true, --
;     enable_abbr = false, -- trigger abbreviation
;     break_undo = true, -- switch for basic rule break undo sequence
;     check_ts = false,
;     map_cr = true,
;     map_bs = true, -- map the <BS> key
;     map_c_h = false, -- Map the <C-h> key to delete a pair
;     map_c_w = false, -- map <c-w> to delete a pair if possible
; }

;  require('nvim-autopairs').setup({
;   disable_filetype = { "TelescopePrompt" , "vim" },
; })

{}
