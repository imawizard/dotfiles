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

call s:hi('Normal',                     '#080808', '#ffffff')
call s:hi('Whitespace',                 '#ffffff', 'NONE')  " IntelliJ guide: ~#bfbfbf
call s:hi('SpecialKey',                 'NONE',    '#f9fbfd')
call s:hi('NonText',                    '#000000', 'NONE')

call s:hi('Visual',                     'NONE',    '#a6d2ff')
hi! def link HighlightedyankRegion Visual

call s:hi('CursorLine',                 'NONE',    '#dddddd')  " IntelliJ CARET_ROW_COLOR: #fcfaed
call s:hi('CursorColumn',               'NONE',    '#dddddd')  " IntelliJ CARET_ROW_COLOR: #fcfaed

call s:hi('ColorColumn',                'NONE',    '#eeeeee')
call s:hi('IndentBlanklineChar',        '#e6e6e6', 'NONE', 'nocombine')
call s:hi('IndentBlanklineContextChar', '#c8c8c8', 'NONE', 'nocombine')

call s:hi('SignColumn',                 '#adadad', '#f2f2f2')
call s:hi('FoldColumn',                 '#adadad', '#f2f2f2')
call s:hi('LineNr',                     '#adadad', '#f2f2f2')
call s:hi('CursorLineSign',             '#282828', '#f2f2f2')  " Helix: ui.gutter.selected
call s:hi('CursorLineFold',             '#282828', '#f2f2f2')  " Helix: ui.gutter.selected
call s:hi('CursorLineNr',               '#282828', '#f2f2f2')  " Helix: ui.gutter.selected
call s:hi('Folded',                     'NONE',    '#f2f2f2')
call s:hi('WinSeparator',               '#000000', '#f2f2f2')

call s:hi('Search',                     '#000000', '#ffe959')
call s:hi('IncSearch',                  '#f9fbfd', '#3f567b', 'bold')
call s:hi('MatchParen',                 'NONE',    'NONE', 'bold,underline')
call s:hi('MatchWord',                  'NONE',    'NONE', 'underline', '#c8c8c8')

call s:hi('DiffAdd',                    'NONE',    '#bee6be')
call s:hi('DiffDelete',                 'NONE',    '#d6d6d6')
call s:hi('DiffChange',                 'NONE',    '#c2d8f2')
call s:hi('DiffText',                   'NONE',    'NONE')
" 0.10+ semantic diff groups (used by @diff.* — defaults link Added → DiffAdd etc. only when defined)
hi! def link Added   DiffAdd
hi! def link Removed DiffDelete
hi! def link Changed DiffChange

" Gitsigns — foreground sign-column marks. Matches Helix theme:
" add=Green, modify=Gray, delete=Red.
call s:hi('GitSignsAdd',             '#008000', 'NONE')
call s:hi('GitSignsChange',          '#808080', 'NONE')
call s:hi('GitSignsDelete',          '#ff0000', 'NONE')
call s:hi('GitSignsChangedelete',    '#ff0000', 'NONE')
call s:hi('GitSignsTopdelete',       '#ff0000', 'NONE')
call s:hi('GitSignsUntracked',       '#808080', 'NONE')

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

call s:hi('NormalFloat',                'NONE',    '#f7f7f7')  " Helix: ui.popup
call s:hi('FloatBorder',                '#adadad', '#f7f7f7')
call s:hi('FloatTitle',                 '#080808', '#f7f7f7', 'bold')
call s:hi('FloatFooter',                '#8c8c8c', '#f7f7f7')

" Match Helix ui.statusline / ui.statusline.inactive
call s:hi('StatusLine',                 '#080808', '#d0d0d0')
call s:hi('StatusLineNC',               '#8c8c8c', '#f2f2f2')

call s:hi('Directory',                  'NONE',    'NONE')
call s:hi('Title',                      'NONE',    'NONE', 'bold')

call s:hi('ExtraWhitespace',            'NONE',    '#ffc0cb')

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

call s:hi('Identifier',                 '#000000', 'NONE')
hi!  def link Function Identifier       " override Neovim default (NvimLightCyan)

call s:hi('Statement',                  'NONE',    'NONE')
hi!  def link Conditional Keyword
hi!  def link Repeat Keyword
call s:hi('Label',                      'NONE',    'NONE', 'underline', '#808080')  " Helix: underlined gray
call s:hi(  'Operator',                 'NONE',    'NONE')
call s:hi(  'Keyword',                  '#181818', 'NONE', 'bold')
hi!  def link Exception Keyword

call s:hi('PreProc',                    '#9e880d', 'NONE', 'NONE')
call s:hi('Macro',                      '#dd6718', 'NONE', 'nocombine')

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
call s:hi('@variable.builtin',       '#181818', 'NONE', 'bold')       " Helix: variable.builtin — dark bold
call s:hi('@variable.member',        '#871094', 'NONE')               " IntelliJ instance/static field purple

" Constants — IntelliJ purple italic; builtin navy (matches Helix — keyword-like)
call s:hi('@constant',               '#871094', 'NONE', 'italic')
call s:hi('@constant.builtin',       '#002fa6', 'NONE')               " Helix: constant.builtin navy

" Modules (was @namespace)
hi!  def link @module                Identifier

" Strings
call s:hi('@string.special.symbol',  '#181818', 'NONE', 'bold')       " Helix: bold dark

" Types
call s:hi('@type.builtin',           '#002fa6', 'NONE')               " Helix: type.builtin navy

" Attributes / properties
hi!  def link @attribute             PreProc                          " override default (@attribute → Macro)
call s:hi('@property',               '#871094', 'NONE')               " IntelliJ instance field purple

" Constructor
call s:hi('@constructor',            '#871094', 'NONE')               " Helix: constructor purple

" Keywords
call s:hi('@keyword.directive',      '#9e880d', 'NONE')               " Helix: olive (like PreProc / attributes)

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
call s:hi('@markup.link',            '#3d3d3d', 'NONE', 'italic')     " Helix: #3d3d3d italic
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

" For inlay hints (Helix ui.virtual.inlay-hint)
call s:hi('LspInlayHint',                '#7a7a7a',   '#ededed')

" For diagnostics — Helix colors: error=Red, warning=Orange, info=Green, hint=Gray.
" Signs bold; undercurls carry the matching severity color.
call s:hi('DiagnosticUnderlineError',    'NONE',      'NONE', 'undercurl', '#ff0000')
call s:hi('DiagnosticUnderlineWarn',     'NONE',      'NONE', 'undercurl', '#ffa500')
call s:hi('DiagnosticUnderlineInfo',     'NONE',      'NONE', 'undercurl', '#008000')
call s:hi('DiagnosticUnderlineHint',     'NONE',      'NONE', 'undercurl', '#808080')
call s:hi('DiagnosticDeprecated',        'NONE',      'NONE', 'strikethrough')
call s:hi('DiagnosticUnnecessary',       '#8c8c8c',   'NONE')
call s:hi('DiagnosticSignError',         '#ff0000',   '#f2f2f2', 'bold')
call s:hi('DiagnosticSignWarn',          '#ffa500',   '#f2f2f2', 'bold')
call s:hi('DiagnosticSignInfo',          '#008000',   '#f2f2f2', 'bold')
call s:hi('DiagnosticSignHint',          '#808080',   '#f2f2f2', 'bold')

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

" nvim-surround
hi!  def link NvimSurroundHighlight Visual
