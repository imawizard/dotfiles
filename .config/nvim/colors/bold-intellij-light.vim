" Bold Intellij Light color scheme
" For syntax and highlight groups see :help syntax.

hi clear
if exists('g:syntax_on')
    syntax reset
endif

if &background ==# 'dark'
    echoerr 'No dark background'
    finish
endif

let g:colors_name = 'Bold Intellij Light'

fun! s:hi(group, fg, bg, attr = 'NONE', sp = '') abort
    let attr = !empty(a:attr) ? 'gui=' . a:attr : ''
    let sp = !empty(a:sp) ? 'guisp=' . a:sp : ''
    exe 'hi 'a:group' guifg='a:fg' guibg='a:bg ' 'attr' 'sp
endfun

" Interface

call s:hi('Normal',                     '#080808', '#ffffff', 'NONE', '#080808')
call s:hi('Whitespace',                 '#ffffff', 'NONE')
call s:hi('SpecialKey',                 'NONE',    '#f9fbfd')
call s:hi('NonText',                    '#000000', 'NONE')

call s:hi('Visual',                     'NONE',    '#a6d2ff')
hi! def link VisualNOS Visual
hi! def link HighlightedyankRegion Visual

call s:hi('CursorLine',                 'NONE',    '#fcfaed')
call s:hi('CursorColumn',               'NONE',    '#fcfaed')

call s:hi('ColorColumn',                'NONE',    '#eeeeee')
call s:hi('IndentBlanklineChar',        '#e6e6e6', 'NONE', 'nocombine')
call s:hi('IndentBlanklineContextChar', '#c8c8c8', 'NONE', 'nocombine')

call s:hi('SignColumn',                 '#adadad', '#f2f2f2')
call s:hi('FoldColumn',                 '#adadad', '#f2f2f2')
call s:hi('LineNr',                     '#adadad', '#f2f2f2')
call s:hi('CursorLineSign',             '#080808', '#f2f2f2')
call s:hi('CursorLineFold',             '#080808', '#f2f2f2')
call s:hi('CursorLineNr',               '#080808', '#f2f2f2')
call s:hi('Folded',                     'NONE',    '#f2f2f2')
call s:hi('VertSplit',                  '#000000', '#f2f2f2')

call s:hi('Search',                     '#000000', '#ffe959')
hi! def link Substitute Search
call s:hi('IncSearch',                  '#f9fbfd', '#3f567b', 'bold')
call s:hi('MatchParen',                 'NONE',    'NONE', 'bold,underline')
call s:hi('MatchWord',                  'NONE',    'NONE', 'underline', '#c8c8c8')

call s:hi('DiffAdd',                    'NONE',    '#bee6be')
call s:hi('DiffDelete',                 'NONE',    '#d6d6d6')
call s:hi('DiffChange',                 'NONE',    '#c2d8f2')
call s:hi('DiffText',                   'NONE',    'NONE')

call s:hi('Pmenu',                      'Black',   '#fff8dc')
call s:hi('PmenuSel',                   'NONE',    '#adadad')
call s:hi('PmenuSbar',                  'NONE',    '#dddddd')
call s:hi('PmenuThumb',                 'NONE',    'Gray')
call s:hi('PmenuMatch',                 '#0033b3', '#fff8dc', 'bold')
call s:hi('PmenuMatchSel',              '#0033b3', '#adadad', 'bold')
call s:hi('PmenuKind',                  '#8c8c8c', '#fff8dc')
call s:hi('PmenuKindSel',               '#494b53', '#adadad')
call s:hi('PmenuExtra',                 '#8c8c8c', '#fff8dc')
call s:hi('PmenuExtraSel',              '#494b53', '#adadad')
call s:hi('PmenuBorder',                '#adadad', '#fff8dc')
call s:hi('PmenuShadow',                'NONE',    '#d0d0d0')
call s:hi('PmenuShadowThrough',         'NONE',    'NONE')

call s:hi('NormalFloat',                'NONE',    '#f2f2f2')
call s:hi('FloatBorder',                '#adadad', '#f2f2f2')
call s:hi('FloatTitle',                 '#080808', '#f2f2f2', 'bold')
call s:hi('FloatFooter',                '#8c8c8c', '#f2f2f2')

call s:hi('Directory',                  'NONE',    'NONE')
call s:hi('Title',                      'NONE',    'NONE', 'bold')

"call s:hi('WinBar',                    'NONE',    'NONE')
"call s:hi('WinBarNC',                  'NONE',    'NONE')
"call s:hi('Menu',                      'NONE',    'NONE')
"call s:hi('Tooltip',                   'NONE',    'NONE')
"call s:hi('Scrollbar',                 'NONE',    'NONE')
"call s:hi('StatusLine',                'NONE',    'NONE')
"call s:hi('StatusLineNC',              'NONE',    'NONE')

call s:hi('ExtraWhitespace',            'NONE',    'Pink')

augroup hlmatch-extra-ws
    autocmd!
    autocmd BufReadPost * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
augroup end

hi! def link ExtraTodo Todo

augroup hlmatch-extra-todo
    autocmd!
    autocmd Syntax * syn match ExtraTodo /\v(TODO|NOTE|HACK|OPTIMIZE|XXX|FIXME)(\([^)]+\))?:/ containedin=.*Comment,vimCommentTitle
augroup end

" Syntax

call s:hi('Comment',                    '#8c8c8c', 'NONE', 'italic')

call s:hi('Constant',                   'NONE',    'NONE')
call s:hi(  'String',                   '#067d17', 'NONE')
hi!  def link Character String
call s:hi(  'Number',                   '#1750eb', 'NONE')
call s:hi(  'Boolean',                  '#0033b3', 'NONE')
hi!  def link Float Number

call s:hi('Identifier',                 '#000000', 'NONE')
hi!  def link Function Identifier

call s:hi('Statement',                  'NONE',    'NONE')
hi!  def link Conditional Keyword
hi!  def link Repeat Keyword
hi!  def link Label Keyword
call s:hi(  'Operator',                 'NONE',    'NONE')
call s:hi(  'Keyword',                  '#181818', 'NONE', 'bold')
hi!  def link Exception Keyword

call s:hi('PreProc',                    '#9e880d', 'NONE', 'NONE')
hi!  def link Include PreProc
hi!  def link Define PreProc
call s:hi('Macro',                      '#dd6718', 'NONE', 'nocombine')
hi!  def link PreCondit PreProc

call s:hi('Type',                       'NONE',    'NONE', 'NONE')
call s:hi(  'StorageClass',             'NONE',    'NONE', 'NONE')
call s:hi(  'Structure',                'NONE',    'NONE', 'NONE')
call s:hi(  'Typedef',                  'NONE',    'NONE', 'NONE')

call s:hi('Special',                    'NONE',    'NONE')
call s:hi(  'SpecialChar',              '#0037a6', 'NONE')
call s:hi(  'Tag',                      'NONE',    'NONE')
call s:hi(  'Delimiter',                'NONE',    'NONE')
call s:hi(  'SpecialComment',           '#0037a6', 'NONE', 'bold')
call s:hi(  'Debug',                    'NONE',    'NONE', 'bold')

call s:hi('Underlined',                 'NONE',    'NONE', 'underline')
call s:hi('Ignore',                     'NONE',    'NONE')
call s:hi('Error',                      'NONE',    '#ffcccc')
call s:hi('Todo',                       'NONE',    'NONE', 'inverse,bold')

" Treesitter captures (see :help treesitter-highlight-groups).
" Only non-default / overridden groups are listed here — Neovim 0.12 ships
" default links for the rest (see highlight_group.c).

" Variables
hi!  def link @variable              Identifier
call s:hi('@variable.member',        '#871094', 'NONE')               " IntelliJ instance/static field purple

" Constants — IntelliJ purple italic
call s:hi('@constant',               '#871094', 'NONE', 'italic')
call s:hi('@constant.builtin',       '#871094', 'NONE', 'italic')

" Modules (was @namespace)
hi!  def link @module                Identifier

" Strings
hi!  def link @string.special.symbol Identifier                       " was @symbol

" Attributes / properties
hi!  def link @attribute             PreProc                          " override default (@attribute → Macro)
call s:hi('@property',               '#871094', 'NONE')               " IntelliJ instance field purple

" Functions — IntelliJ teal; definitions underlined, calls default
call s:hi('@function',               '#00627a', 'NONE', 'underline')
call s:hi('@function.call',          'NONE',    'NONE')
hi!  def link @function.macro        Macro
call s:hi('@function.method',        '#00627a', 'NONE', 'italic,underline')
call s:hi('@function.method.call',   'NONE',    'NONE')

" Punctuation
hi!  def link @punctuation.special   SpecialChar                      " override default (@punctuation.special → Special)

" Comments — defaults cover @comment.todo → Todo. Override the rest.
hi!  def link @comment.note          SpecialComment
hi!  def link @comment.warning       WarningMsg
hi!  def link @comment.error         ErrorMsg

" Markup (was @text.*)
hi!  def link @markup.raw            Comment                          " was @text.literal
hi!  def link @markup.math           Special                          " was @text.math
hi!  def link @markup.link           Identifier                       " override default (→ Underlined)
hi!  def link @markup.link.url       Underlined

" Diff — override defaults (@diff.plus → Added, @diff.minus → Removed)
hi!  def link @diff.plus             DiffAdd
hi!  def link @diff.minus            DiffDelete

" Tags
hi!  def link @tag.attribute         Identifier
hi!  def link @tag.delimiter         Delimiter

" Spell check regions
call s:hi('@spell', 'None', 'None')

" Non-standard / legacy
hi!  def link @variable.global       Identifier

" LSP semantic token modifiers that have no Neovim default link.
" (@lsp.type.* → treesitter groups is handled by Neovim core.)
call s:hi('@lsp.mod.readonly',        '#871094', 'NONE', 'italic')
hi!  def link @lsp.mod.defaultLibrary Special

" For vim.lsp.buf.document_highlight()
hi!  def link LspReferenceText CursorLine
call s:hi('LspReferenceRead',  'NONE', '#edebfc') " or #ccccff
call s:hi('LspReferenceWrite', 'NONE', '#fce8f4') " or #ffcdff

" For vim.lsp.handlers.signature_help()
call s:hi('LspSignatureActiveParameter', 'NONE', 'NONE', 'bold')

" For codelenses
call s:hi('LspCodeLens',          '#ffcccc', 'NONE', 'underdouble', '#595959')
call s:hi('LspCodeLensSeparator', 'NONE',    'NONE')

" For diagnostics
"call s:hi('DiagnosticError',            'NONE',      'NONE')
"call s:hi('DiagnosticWarn',             'NONE',      'NONE')
"call s:hi('DiagnosticInfo',             'NONE',      'NONE')
"call s:hi('DiagnosticHint',             'NONE',      'NONE')
"call s:hi('DiagnosticVirtualTextError', 'NONE',      'NONE')
"call s:hi('DiagnosticVirtualTextWarn',  'NONE',      'NONE')
"call s:hi('DiagnosticVirtualTextInfo',  'NONE',      'NONE')
"call s:hi('DiagnosticVirtualTextHint',  'NONE',      'NONE')
call s:hi('DiagnosticUnderlineError',    'NONE',      'NONE', 'undercurl')
call s:hi('DiagnosticUnderlineWarn',     'NONE',      'NONE', 'undercurl')
call s:hi('DiagnosticUnderlineInfo',     'NONE',      'NONE', 'undercurl')
call s:hi('DiagnosticUnderlineHint',     'NONE',      'NONE', 'undercurl')
call s:hi('DiagnosticDeprecated',        'NONE',      'NONE', 'strikethrough')
call s:hi('DiagnosticUnnecessary',       '#8c8c8c',   'NONE')
"call s:hi('DiagnosticFloatingError',    'NONE',      'NONE')
"call s:hi('DiagnosticFloatingWarn',     'NONE',      'NONE')
"call s:hi('DiagnosticFloatingInfo',     'NONE',      'NONE')
"call s:hi('DiagnosticFloatingHint',     'NONE',      'NONE')
call s:hi('DiagnosticSignError',         'Red',       '#f2f2f2')
call s:hi('DiagnosticSignWarn',          'Orange',    '#f2f2f2')
call s:hi('DiagnosticSignInfo',          'LightBlue', '#f2f2f2')
call s:hi('DiagnosticSignHint',          'LightGrey', '#f2f2f2')

" Trouble
call s:hi('TroubleIndent',          '#adadad',   'NONE')
call s:hi('TroubleSignError',       'Red',       'NONE')
call s:hi('TroubleSignWarning',     'Orange',    'NONE')
call s:hi('TroubleSignInformation', 'LightBlue', 'NONE')
call s:hi('TroubleSignHint',        'LightGrey', 'NONE')
call s:hi('TroubleSignOther',       '#008700',   'NONE')
hi!  def link TroubleLocation Comment

" Leap
hi!  def link LeapBackdrop Comment
call s:hi('LeapMatch',           'Black', 'NONE', 'bold,nocombine')
"call s:hi('LeapLabelPrimary',   'Black', '#afff5f', 'underline,nocombine')
"call s:hi('LeapLabelSecondary', 'Black', '#5fffff', 'underline,nocombine')
"call s:hi('LeapLabelSelected',  'Black', 'NONE', 'underline,nocombine')

" nvim-surround
hi!  def link NvimSurroundHighlight Visual

" Markdown
call s:hi('markdownError', 'NONE', 'NONE')
call s:hi('mkdLt',         'NONE', 'NONE')
call s:hi('mkdGt',         'NONE', 'NONE')
