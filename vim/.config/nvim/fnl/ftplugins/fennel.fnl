(import-macros {: gset!} :macros)

(gset!
 fennel_maxlines 300
 fennel_fuzzy_indent true
 fennel_fuzzy_indent_patterns ["^def" "^let" "^while" "^if" "^fn$" "^var$"
                               "^case$" "^for$" "^each$" "^local$" "^global$"
                               "^match$" "^macro" "^lambda$"
                               "^comment$" "^when" "when$"
                               "^accumulate$" "collect$"]
 fennel_fuzzy_indent_blacklist ["^if$"]
 fennel_special_indent_words ""
 fennel_align_multiline_strings false ; buggy
 fennel_align_subforms true)
