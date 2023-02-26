(import-macros {: gset!} :macros)

(gset!
 markdown_fenced_languages ["bash=sh"
                            "c++=cpp"
                            "ini=dosini"
                            "ts=typescript"
                            "viml=vim"]
 vim_markdown_fenced_languages vim.g.markdown_fenced_languages)
