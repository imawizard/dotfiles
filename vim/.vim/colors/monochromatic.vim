" Monochromatic color scheme (based on mswift42's Greymatters)
" For syntax and highlight groups see https://neovim.io/doc/user/syntax.html.

let g:colors_name = "monochromatic"
hi clear
if exists('g:syntax_on')
    syntax reset
endif

if &background ==# 'light'
    let s:fg       = "#2f2f2f" | let s:cfg       = "0"
    let s:fg2      = "#404040" | let s:cfg2      = "0"
    let s:fg3      = "#505050" | let s:cfg3      = "0"
    let s:fg4      = "#616161" | let s:cfg4      = "0"
    let s:bgb      = "#ffffff" | let s:cbgb      = "15"
    let s:bg       = "#f9fbfd" | let s:cbg       = "0"
    let s:bg2      = "#e5e7e9" | let s:cbg2      = "0"
    let s:bg3      = "#d1d3d5" | let s:cbg3      = "0"
    let s:bg4      = "#bdbfc0" | let s:cbg4      = "0"
    let s:keyword  = "#3f567b" | let s:ckeyword  = "0"
    let s:builtin  = "#7b4135" | let s:cbuiltin  = "0"
    let s:const    = "#64502f" | let s:cconst    = "0"
    let s:comment  = "#949494" | let s:ccomment  = "0"
    let s:func     = "#714355" | let s:cfunc     = "0"
    let s:str      = "#305f5e" | let s:cstr      = "0"
    let s:type     = "#634575" | let s:ctype     = "0"
    let s:var      = "#3f5b32" | let s:cvar      = "0"
    let s:warning  = "#fa0c0c" | let s:cwarning  = "0"
    let s:warning2 = "#fa7b0c" | let s:cwarning2 = "0"

    let s:hilight  = "#ffe959" | let s:chilight  = "221"
    let s:select   = "#a6d2ff" | let s:cselect   = "235"
    let s:fgdiff1  = "#000000" | let s:cfgdiff1  = "0"
    let s:bgdiff1  = "#bef6dc" | let s:cbgdiff1  = "0"
    let s:fgdiff2  = "#ffffff" | let s:cfgdiff2  = "0"
    let s:bgdiff2  = "#5b76ef" | let s:cbgdiff2  = "0"
    let s:fgdiff3  = "#ffffff" | let s:cfgdiff3  = "0"
    let s:bgdiff3  = "#ff0000" | let s:cbgdiff3  = "0"

    " More colors:
    "let s:fg      = "#080808" | let s:cfg       = "232"
    "let s:fg      = "#6c6c6c" | let s:cfg       = "242"
    "let s:fg      = "#8c8c8c" | let s:cfg       = "245"
    "let s:fg      = "#adadad" | let s:cfg       = "244"
    "let s:bg      = "#ffffff" | let s:cbg       = "15"
    "let s:bg      = "#f2f2f2" | let s:cbg       = "255"
    "let s:bg      = "#dddddd" | let s:cbg       = "253"
else
    let s:fg       = "#2f2f2f" | let s:cfg       = "0"
    let s:fg2      = "#404040" | let s:cfg2      = "0"
    let s:fg3      = "#505050" | let s:cfg3      = "0"
    let s:fg4      = "#616161" | let s:cfg4      = "0"
    let s:bgb      = "#f9fbfd" | let s:cbgb      = "0"
    let s:bg       = "#f9fbfd" | let s:cbg       = "0"
    let s:bg2      = "#e5e7e9" | let s:cbg2      = "0"
    let s:bg3      = "#d1d3d5" | let s:cbg3      = "0"
    let s:bg4      = "#bdbfc0" | let s:cbg4      = "0"
    let s:keyword  = "#3f567b" | let s:ckeyword  = "0"
    let s:builtin  = "#7b4135" | let s:cbuiltin  = "0"
    let s:const    = "#64502f" | let s:cconst    = "0"
    let s:comment  = "#949494" | let s:ccomment  = "0"
    let s:func     = "#714355" | let s:cfunc     = "0"
    let s:str      = "#305f5e" | let s:cstr      = "0"
    let s:type     = "#634575" | let s:ctype     = "0"
    let s:var      = "#3f5b32" | let s:cvar      = "0"
    let s:warning  = "#fa0c0c" | let s:cwarning  = "0"
    let s:warning2 = "#fa7b0c" | let s:cwarning2 = "0"

    let s:hilight  = "#ffe959" | let s:chilight  = "221"
    let s:select   = "#a6d2ff" | let s:cselect   = "235"
    let s:fgdiff1  = "#000000" | let s:cfgdiff1  = "0"
    let s:bgdiff1  = "#bef6dc" | let s:cbgdiff1  = "0"
    let s:fgdiff2  = "#ffffff" | let s:cfgdiff2  = "0"
    let s:bgdiff2  = "#5b76ef" | let s:cbgdiff2  = "0"
    let s:fgdiff3  = "#ffffff" | let s:cfgdiff3  = "0"
    let s:bgdiff3  = "#ff0000" | let s:cbgdiff3  = "0"

    " More colors:
    "let s:fg      = "#cecece" | let s:cfg       = "253"
    "let s:fg      = "#bebebe" | let s:cfg       = "250"
    "let s:fg      = "#a1a1a1" | let s:cfg       = "246"
    "let s:fg      = "#616161" | let s:cfg       = "241"
    "let s:fg      = "#29beea" | let s:cfg       = "45"
    "let s:fg      = "#151415" | let s:cfg       = "234"
    "let s:bg      = "#1c1c1c" | let s:cbg       = "234"
    "let s:bg      = "#262626" | let s:cbg       = "235"
    "let s:bg      = "#2c535d" | let s:cbg       = "23"
    "let s:bg      = "#f06292" | let s:cbg       = "132"
    "let s:cursor  = "#29beea" | let s:ccursor   = "45"
endif

exe  'hi Normal                gui=NONE           guifg='s:fg'      guibg='s:bg'       cterm=NONE           ctermfg='s:cfg'      ctermbg='s:cbg
exe  'hi WhiteSpace            gui=NONE           guifg='s:bgb'     guibg=NONE         cterm=NONE           ctermfg='s:cbgb'     ctermbg=NONE'
exe  'hi SpecialKey            gui=NONE           guifg='s:fg2'     guibg='s:bg2'      cterm=NONE           ctermfg='s:cfg2'     ctermbg='s:cbg2
exe  'hi NonText               gui=NONE           guifg='s:bg4'     guibg='s:bg2'      cterm=NONE           ctermfg='s:cbg4'     ctermbg='s:cbg2
exe  'hi ColorColumn           gui=NONE           guifg=NONE        guibg='s:bg2'      cterm=NONE           ctermfg=NONE         ctermbg='s:cbg2
exe  'hi SignColumn            gui=NONE           guifg=NONE        guibg='s:bg2'      cterm=NONE           ctermfg=NONE         ctermbg='s:cbg2

exe  'hi LineNr                gui=NONE           guifg='s:fg2'     guibg='s:bg2'      cterm=NONE           ctermfg='s:cfg2'     ctermbg='s:cbg2
exe  'hi Folded                gui=NONE           guifg='s:fg4'     guibg='s:bg'       cterm=NONE           ctermfg='s:cfg4'     ctermbg='s:cbg
exe  'hi CursorLine            gui=NONE           guifg=NONE        guibg='s:bg2'      cterm=NONE           ctermfg=NONE         ctermbg='s:cbg2
exe  'hi CursorColumn          gui=NONE           guifg=NONE        guibg='s:bg2'      cterm=NONE           ctermfg=NONE         ctermbg='s:cbg2

exe  'hi Search                gui=underline      guifg=NONE        guibg='s:hilight'  cterm=underline      ctermfg=NONE         ctermbg='s:chilight
exe  'hi IncSearch             gui=bold           guifg='s:bg'      guibg='s:keyword'  cterm=bold           ctermfg='s:cbg'      ctermbg='s:ckeyword
exe  'hi MatchParen            gui=bold,underline guifg='s:fg'      guibg=NONE         cterm=bold,underline ctermfg='s:cfg'      ctermbg=NONE'

exe  'hi Cursor                gui=NONE           guifg='s:bg'      guibg='s:fg'       cterm=NONE           ctermfg='s:cbg'      ctermbg='s:cfg

exe  'hi DiffAdd               gui=bold           guifg='s:fgdiff1' guibg='s:bgdiff1'  cterm=bold           ctermfg='s:cfgdiff1' ctermbg='s:cbgdiff1
exe  'hi DiffDelete            gui=NONE           guifg='s:bg2'     guibg=NONE         cterm=NONE           ctermfg='s:cbg2'     ctermbg=NONE'
exe  'hi DiffChange            gui=NONE           guifg='s:fgdiff2' guibg='s:bgdiff2'  cterm=NONE           ctermfg='s:cfgdiff2' ctermbg='s:cbgdiff2
exe  'hi DiffText              gui=bold           guifg='s:fgdiff3' guibg='s:bgdiff3'  cterm=bold           ctermfg='s:cfgdiff3' ctermbg='s:cbgdiff3

exe  'hi Comment               gui=NONE           guifg='s:comment' guibg=NONE         cterm=NONE           ctermfg='s:ccomment' ctermbg=NONE'

exe  'hi Constant              gui=NONE           guifg='s:const'   guibg=NONE         cterm=NONE           ctermfg='s:cconst'   ctermbg=NONE'
exe  'hi String                gui=NONE           guifg='s:str'     guibg=NONE         cterm=NONE           ctermfg='s:cstr'     ctermbg=NONE'
exe  'hi Character             gui=NONE           guifg='s:const'   guibg=NONE         cterm=NONE           ctermfg='s:cconst'   ctermbg=NONE'
exe  'hi Number                gui=NONE           guifg='s:const'   guibg=NONE         cterm=NONE           ctermfg='s:cconst'   ctermbg=NONE'
exe  'hi Boolean               gui=NONE           guifg='s:const'   guibg=NONE         cterm=NONE           ctermfg='s:cconst'   ctermbg=NONE'
exe  'hi Float                 gui=NONE           guifg='s:const'   guibg=NONE         cterm=NONE           ctermfg='s:cconst'   ctermbg=NONE'

exe  'hi Identifier            gui=italic         guifg='s:type'    guibg=NONE         cterm=italic         ctermfg='s:ctype'    ctermbg=NONE'
exe  'hi Function              gui=NONE           guifg='s:func'    guibg=NONE         cterm=NONE           ctermfg='s:cfunc'    ctermbg=NONE'

exe  'hi Statement             gui=bold           guifg='s:keyword' guibg=NONE         cterm=bold           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Conditional           gui=bold           guifg='s:keyword' guibg=NONE         cterm=bold           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Repeat                gui=bold           guifg='s:keyword' guibg=NONE         cterm=bold           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Label                 gui=bold           guifg='s:var'     guibg=NONE         cterm=bold           ctermfg='s:cvar'     ctermbg=NONE'
exe  'hi Operator              gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Keyword               gui=bold           guifg='s:keyword' guibg=NONE         cterm=bold           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Exception             gui=bold           guifg='s:keyword' guibg=NONE         cterm=bold           ctermfg='s:ckeyword' ctermbg=NONE'

exe  'hi PreProc               gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Include               gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Define                gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Macro                 gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi PreCondit             gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'

exe  'hi Type                  gui=bold           guifg='s:type'    guibg=NONE         cterm=bold           ctermfg='s:ctype'    ctermbg=NONE'
exe  'hi StorageClass          gui=italic         guifg='s:type'    guibg=NONE         cterm=italic         ctermfg='s:ctype'    ctermbg=NONE'
exe  'hi Structure             gui=italic         guifg='s:type'    guibg=NONE         cterm=italic         ctermfg='s:ctype'    ctermbg=NONE'
exe  'hi Typedef               gui=italic         guifg='s:type'    guibg=NONE         cterm=italic         ctermfg='s:ctype'    ctermbg=NONE'

exe  'hi Special               gui=underline      guifg='s:fg'      guibg=NONE         cterm=underline      ctermfg='s:cfg'      ctermbg=NONE'
exe  'hi SpecialChar           gui=NONE           guifg='s:fg'      guibg=NONE         cterm=underline      ctermfg='s:cfg'      ctermbg=NONE'
exe  'hi Tag                   gui=NONE           guifg='s:keyword' guibg=NONE         cterm=NONE           ctermfg='s:ckeyword' ctermbg=NONE'
exe  'hi Delimiter             gui=NONE           guifg=NONE        guibg=NONE         cterm=NONE           ctermfg=NONE         ctermbg=NONE'
exe  'hi SpecialComment        gui=bold           guifg=NONE        guibg=NONE         cterm=bold           ctermfg=NONE         ctermbg=NONE'
exe  'hi Debug                 gui=bold           guifg=NONE        guibg=NONE         cterm=bold           ctermfg=NONE         ctermbg=NONE'

exe  'hi Underlined            gui=underline      guifg=NONE        guibg=NONE         cterm=underline      ctermfg=NONE         ctermbg=NONE'

"exe 'hi Ignore                gui=NONE           guifg=NONE        guibg=#f06292      cterm=NONE           ctermfg=NONE         ctermbg=132'

"exe 'hi Error                 gui=NONE           guifg=NONE        guibg=#f06292      cterm=NONE           ctermfg=NONE         ctermbg=132'

exe  'hi Todo                  gui=inverse,bold   guifg='s:fg2'     guibg=NONE         cterm=inverse,bold   ctermfg='s:cfg2'     ctermbg=NONE'

exe  'hi VertSplit             gui=NONE           guifg='s:fg3'     guibg='s:bg3'      cterm=NONE           ctermfg='s:cfg3'     ctermbg='s:cbg3
exe  'hi StatusLine            gui=bold           guifg='s:fg2'     guibg='s:bg3'      cterm=bold           ctermfg='s:cfg2'     ctermbg='s:cbg3
exe  'hi Pmenu                 gui=NONE           guifg='s:fg'      guibg='s:bg2'      cterm=NONE           ctermfg='s:cfg'      ctermbg='s:cbg2
exe  'hi PmenuSel              gui=NONE           guifg=NONE        guibg='s:bg3'      cterm=NONE           ctermfg=NONE         ctermbg='s:cbg3

exe  'hi Directory             gui=NONE           guifg='s:const'   guibg=NONE         cterm=NONE           ctermfg='s:cconst'   ctermbg=NONE'
exe  'hi ErrorMsg              gui=bold           guifg='s:warning' guibg='s:bg2'      cterm=bold           ctermfg='s:cwarning' ctermbg='s:cbg2
exe  'hi WarningMsg            gui=NONE           guifg='s:fg'      guibg='s:warning2' cterm=NONE           ctermfg='s:cfg'      ctermbg='s:cwarning
exe  'hi Title                 gui=bold           guifg='s:fg'      guibg=NONE         cterm=bold           ctermfg='s:cfg'      ctermbg=NONE'

exe  'hi Visual                gui=NONE           guifg=NONE        guibg='s:select'   cterm=NONE           ctermfg=NONE         ctermbg='s:cselect
exe  'hi ExtraWhitespace       gui=NONE           guifg=NONE        guibg=Pink         cterm=NONE           ctermfg=NONE         ctermbg=218'
" Or rgba(252, 232, 244, 155):
exe  'hi HighlightedyankRegion gui=NONE           guifg=NONE        guibg='s:select'   cterm=NONE           ctermfg=NONE         ctermbg='s:cselect

"hi NormalNC       cterm=NONE           gui=NONE           ctermfg=250  guifg=#bebebe ctermbg=234  guibg=#1c1c1c
"hi FoldColumn     cterm=NONE           gui=NONE           ctermfg=NONE guifg=#ff0000 ctermbg=235  guibg=#dddddd
"hi FoldColumn     cterm=NONE           gui=NONE           ctermfg=NONE guifg=NONE    ctermbg=NONE guibg=NONE
"hi CursorLineNr   cterm=NONE           gui=NONE           ctermfg=250  guifg=#bebebe ctermbg=235  guibg=#262626
"hi Substitute     cterm=NONE           gui=NONE           ctermfg=NONE guifg=#ff0000 ctermbg=221  guibg=Red
"hi Cursor         cterm=NONE           gui=NONE           ctermfg=45   guifg=#29beea ctermbg=NONE guibg=NONE
"hi CursorIM       cterm=NONE           gui=NONE           ctermfg=81   guifg=#29beea ctermbg=NONE guibg=NONE
"hi TermCursor     cterm=NONE           gui=NONE           ctermfg=45   guifg=#29beea ctermbg=NONE guibg=NONE
"hi TermCursorNC   cterm=NONE           gui=NONE           ctermfg=45   guifg=#29beea ctermbg=NONE guibg=NONE

hi def link ExtraTodo Todo

augroup hlmatch-extra-ws
    autocmd!
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
augroup end

augroup hlmatch-extra-todo
    autocmd!
    autocmd Syntax * syn match ExtraTodo /\v(TODO|NOTE|HACK|OPTIMIZE|XXX)(\([^)]+\))?:/ containedin=.*Comment,vimCommentTitle
augroup end

" vim.lsp.buf.document_highlight()
hi link LspReferenceRead CursorLine
hi link LspReferenceText CursorLine
hi link LspReferenceWrite CursorLine

" vim.lsp.diagnostic.show_line_diagnostics()
"LspDiagnosticsDefaultError
"LspDiagnosticsDefaultWarning
"LspDiagnosticsDefaultInformation
"LspDiagnosticsDefaultHint

"LspDiagnosticsVirtualTextError
"LspDiagnosticsVirtualTextWarning
"LspDiagnosticsVirtualTextInformation
"LspDiagnosticsVirtualTextHint

"LspDiagnosticsUnderlineError
"LspDiagnosticsUnderlineWarning
"LspDiagnosticsUnderlineInformation
"LspDiagnosticsUnderlineHint

"LspDiagnosticsFloatingError
"LspDiagnosticsFloatingWarning
"LspDiagnosticsFloatingInformation
"LspDiagnosticsFloatingHint

"LspDiagnosticsSignError
"LspDiagnosticsSignWarning
"LspDiagnosticsSignInformation
"LspDiagnosticsSignHint

"LspCodeLens
"LspCodeLensSeparator
"LspSignatureActiveParameter

" Trouble
exe  'hi TroubleIndent         gui=NONE           guifg=#adadad     guibg=NONE         cterm=NONE           ctermfg=244          ctermbg=NONE'
hi link TroubleLocation Comment

" Go
exe 'hi goBuiltins guifg='s:builtin' ctermfg='s:cbuiltin

" Html
exe 'hi htmlLink           guifg='s:var'     ctermfg='s:cvar'    gui=underline'
exe 'hi htmlStatement      guifg='s:keyword' ctermfg='s:ckeyword
exe 'hi htmlSpecialTagName guifg='s:keyword' ctermfg='s:ckeyword

" Javascript
exe 'hi jsBuiltins       guifg='s:builtin' ctermfg='s:cbuiltin
exe 'hi jsFunction       guifg='s:keyword' ctermfg='s:ckeyword' gui=bold'
exe 'hi jsGlobalObjects  guifg='s:type'    ctermfg='s:ctype
exe 'hi jsAssignmentExps guifg='s:var'     ctermfg='s:cvar

" Markdown
exe 'hi mkdCode guifg='s:builtin' ctermfg='s:cbuiltin

" Python
exe 'hi pythonBuiltinFunc guifg='s:builtin' ctermfg='s:cbuiltin

" Ruby
exe 'hi rubyAttribute             guifg='s:builtin' ctermfg='s:cbuiltin
exe 'hi rubyLocalVariableOrMethod guifg='s:var'     ctermfg='s:cvar
exe 'hi rubyGlobalVariable        guifg='s:var'     ctermfg='s:cvar'     gui=italic'
exe 'hi rubyInstanceVariable      guifg='s:var'     ctermfg='s:cvar
exe 'hi rubyKeyword               guifg='s:keyword' ctermfg='s:ckeyword
exe 'hi rubyKeywordAsMethod       guifg='s:keyword' ctermfg='s:ckeyword' gui=bold'
exe 'hi rubyClassDeclaration      guifg='s:keyword' ctermfg='s:ckeyword' gui=bold'
exe 'hi rubyClass                 guifg='s:keyword' ctermfg='s:ckeyword' gui=bold'
exe 'hi rubyNumber                guifg='s:const'   ctermfg='s:cconst
