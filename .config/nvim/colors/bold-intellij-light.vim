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

let s:colors_256 = [
    \ '#000000', '#800000', '#008000', '#808000', '#000080', '#800080',
    \ '#008080', '#c0c0c0', '#808080', '#ff0000', '#00ff00', '#ffff00',
    \ '#0000ff', '#ff00ff', '#00ffff', '#ffffff', '#000000', '#00005f',
    \ '#000087', '#0000af', '#0000d7', '#0000ff', '#005f00', '#005f5f',
    \ '#005f87', '#005faf', '#005fd7', '#005fff', '#008700', '#00875f',
    \ '#008787', '#0087af', '#0087d7', '#0087ff', '#00af00', '#00af5f',
    \ '#00af87', '#00afaf', '#00afd7', '#00afff', '#00d700', '#00d75f',
    \ '#00d787', '#00d7af', '#00d7d7', '#00d7ff', '#00ff00', '#00ff5f',
    \ '#00ff87', '#00ffaf', '#00ffd7', '#00ffff', '#5f0000', '#5f005f',
    \ '#5f0087', '#5f00af', '#5f00d7', '#5f00ff', '#5f5f00', '#5f5f5f',
    \ '#5f5f87', '#5f5faf', '#5f5fd7', '#5f5fff', '#5f8700', '#5f875f',
    \ '#5f8787', '#5f87af', '#5f87d7', '#5f87ff', '#5faf00', '#5faf5f',
    \ '#5faf87', '#5fafaf', '#5fafd7', '#5fafff', '#5fd700', '#5fd75f',
    \ '#5fd787', '#5fd7af', '#5fd7d7', '#5fd7ff', '#5fff00', '#5fff5f',
    \ '#5fff87', '#5fffaf', '#5fffd7', '#5fffff', '#870000', '#87005f',
    \ '#870087', '#8700af', '#8700d7', '#8700ff', '#875f00', '#875f5f',
    \ '#875f87', '#875faf', '#875fd7', '#875fff', '#878700', '#87875f',
    \ '#878787', '#8787af', '#8787d7', '#8787ff', '#87af00', '#87af5f',
    \ '#87af87', '#87afaf', '#87afd7', '#87afff', '#87d700', '#87d75f',
    \ '#87d787', '#87d7af', '#87d7d7', '#87d7ff', '#87ff00', '#87ff5f',
    \ '#87ff87', '#87ffaf', '#87ffd7', '#87ffff', '#af0000', '#af005f',
    \ '#af0087', '#af00af', '#af00d7', '#af00ff', '#af5f00', '#af5f5f',
    \ '#af5f87', '#af5faf', '#af5fd7', '#af5fff', '#af8700', '#af875f',
    \ '#af8787', '#af87af', '#af87d7', '#af87ff', '#afaf00', '#afaf5f',
    \ '#afaf87', '#afafaf', '#afafd7', '#afafff', '#afd700', '#afd75f',
    \ '#afd787', '#afd7af', '#afd7d7', '#afd7ff', '#afff00', '#afff5f',
    \ '#afff87', '#afffaf', '#afffd7', '#afffff', '#d70000', '#d7005f',
    \ '#d70087', '#d700af', '#d700d7', '#d700ff', '#d75f00', '#d75f5f',
    \ '#d75f87', '#d75faf', '#d75fd7', '#d75fff', '#d78700', '#d7875f',
    \ '#d78787', '#d787af', '#d787d7', '#d787ff', '#d7af00', '#d7af5f',
    \ '#d7af87', '#d7afaf', '#d7afd7', '#d7afff', '#d7d700', '#d7d75f',
    \ '#d7d787', '#d7d7af', '#d7d7d7', '#d7d7ff', '#d7ff00', '#d7ff5f',
    \ '#d7ff87', '#d7ffaf', '#d7ffd7', '#d7ffff', '#ff0000', '#ff005f',
    \ '#ff0087', '#ff00af', '#ff00d7', '#ff00ff', '#ff5f00', '#ff5f5f',
    \ '#ff5f87', '#ff5faf', '#ff5fd7', '#ff5fff', '#ff8700', '#ff875f',
    \ '#ff8787', '#ff87af', '#ff87d7', '#ff87ff', '#ffaf00', '#ffaf5f',
    \ '#ffaf87', '#ffafaf', '#ffafd7', '#ffafff', '#ffd700', '#ffd75f',
    \ '#ffd787', '#ffd7af', '#ffd7d7', '#ffd7ff', '#ffff00', '#ffff5f',
    \ '#ffff87', '#ffffaf', '#ffffd7', '#ffffff', '#080808', '#121212',
    \ '#1c1c1c', '#262626', '#303030', '#3a3a3a', '#444444', '#4e4e4e',
    \ '#585858', '#626262', '#6c6c6c', '#767676', '#808080', '#8a8a8a',
    \ '#949494', '#9e9e9e', '#a8a8a8', '#b2b2b2', '#bcbcbc', '#c6c6c6',
    \ '#d0d0d0', '#dadada', '#e4e4e4', '#eeeeee',
    \ ]

" Interface

call s:hi('Normal',                     '#080808', '#ffffff', 'NONE', '#080808')
call s:hi('Whitespace',                 '#ffffff', 'NONE')
call s:hi('SpecialKey',                 'NONE',    '#f9fbfd')
call s:hi('NonText',                    '#000000', 'NONE')

call s:hi('Visual',                     'NONE',    '#a6d2ff')
call s:hi('VisualNOS',                  'NONE',    'Pink')
hi! def link HighlightedyankRegion Visual

call s:hi('CursorLine',                 'NONE',    '#dddddd')
call s:hi('CursorColumn',               'NONE',    '#dddddd')

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
call s:hi('NormalFloat',                'NONE',    '#f2f2f2')

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
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
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
call s:hi(  'Boolean',                  '#002fa6', 'NONE')
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
call s:hi(  'Tag',                      'NONE',    'Gray')
call s:hi(  'Delimiter',                'NONE',    'NONE')
call s:hi(  'SpecialComment',           '#0037a6', 'NONE', 'bold')
call s:hi(  'Debug',                    'NONE',    'NONE', 'bold')

call s:hi('Underlined',                 'NONE',    'NONE', 'underline')
call s:hi('Ignore',                     'NONE',    'NONE')
call s:hi('Error',                      'NONE',    '#ffcccc')
call s:hi('Todo',                       'NONE',    'NONE', 'inverse,bold')

" For Treesitter's default groups, see
" https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c

" Treesitter misc
hi!  def link @comment               Comment        " line and block comments
"hi! def link @error                 ???            " syntax/parser errors
"hi! def link @none                  ???            " completely disable the highlight
hi!  def link @preproc               PreProc        " various preprocessor directives & shebangs
hi!  def link @define                Define         " preprocessor definition directives
hi!  def link @operator              Operator       " symbolic operators (e.g. `+` / `*`)

" Treesitter punctuation
hi!  def link @punctuation           Delimiter
"hi! def link @punctuation.delimiter Delimiter      " delimiters (e.g. `;` / `.` / `,`)
"hi! def link @punctuation.bracket   Delimiter      " brackets (e.g. `()` / `{}` / `[]`)
hi!  def link @punctuation.special   SpecialChar    " special symbols (e.g. `{}` in string interpolation)

" Treesitter literals
hi!  def link @string                String         " string literals
"hi! def link @string.regex          String         " regular expressions
hi!  def link @string.escape         SpecialChar    " escape sequences
hi!  def link @string.special        SpecialChar    " other special strings (e.g. dates)

hi!  def link @character             Character      " character literals
hi!  def link @character.special     SpecialChar    " special characters (e.g. wildcards)

hi!  def link @boolean               Boolean        " boolean literals
hi!  def link @number                Number         " numeric literals
hi!  def link @float                 Float          " floating-point number literals

" Treesitter functions
hi!  def link @function              Function       " function definitions
hi!  def link @function.builtin      Special        " built-in functions
"hi! def link @function.call         Function       " function calls
hi!  def link @function.macro        Macro          " preprocessor macros

hi!  def link @method                Function       " method definitions
"hi! def link @method.call           Function       " method calls

hi!  def link @constructor           Special        " constructor calls and definitions
hi!  def link @parameter             Identifier     " parameters of a function

" Treesitter keywords
hi!  def link @keyword               Keyword        " various keywords
"hi! def link @keyword.function      Keyword        " keywords that define a function (e.g. `func` in Go, `def` in Python)
"hi! def link @keyword.operator      Keyword        " operators that are English words (e.g. `and` / `or`)
"hi! def link @keyword.return        Keyword        " keywords like `return` and `yield`

hi!  def link @conditional           Conditional    " keywords related to conditionals (e.g. `if` / `else`)
hi!  def link @repeat                Repeat         " keywords related to loops (e.g. `for` / `while`)
hi!  def link @debug                 Debug          " keywords related to debugging
hi!  def link @label                 Label          " GOTO and other labels (e.g. `label:` in C)
hi!  def link @include               Include        " keywords for including modules (e.g. `import` / `from` in Python)
hi!  def link @exception             Exception      " keywords related to exceptions (e.g. `throw` / `catch`)

" Treesitter types
hi!  def link @type                  Type           " type or class definitions and annotations
"hi! def link @type.builtin          Type           " built-in types
"hi! def link @type.definition       Typedef        " type definitions (e.g. `typedef` in C)
"hi! def link @type.qualifier        Type           " type qualifiers (e.g. `const`)

hi!  def link @storageclass          StorageClass   " visibility/life-time/etc. modifiers (e.g. `static`)
hi!  def link @attribute             PreProc        " attribute annotations (e.g. Python decorators)
hi!  def link @field                 Identifier     " object and struct fields
hi!  def link @property              Identifier     " similar to `@field`
hi!  def link @structure             Structure

" Treesitter identifiers
hi!  def link @variable              Identifier     " various variable names
hi!  def link @variable.builtin      Special        " built-in variable names (e.g. `this`)

hi!  def link @constant              Constant       " constant identifiers
hi!  def link @constant.builtin      Special        " built-in constant values
hi!  def link @constant.macro        Macro          " constants defined by the preprocessor
hi!  def link @macro                 Macro

hi!  def link @namespace             Identifier     " modules or namespaces
hi!  def link @symbol                Identifier     " symbols or atoms

" Treesitter text
hi!  def link @text                  Normal         " non-structured text
hi!  def link @text.strong           Bold           " bold text
hi!  def link @text.emphasis         Italic         " text with emphasis
hi!  def link @text.underline        Underlined     " underlined text
hi!  def link @text.strike           Inverse        " strikethrough text
hi!  def link @text.title            Title          " text that is part of a title
hi!  def link @text.literal          Comment        " literal or verbatim text
hi!  def link @text.uri              Underlined     " URIs (e.g. hyperlinks)
hi!  def link @text.math             Special        " math environments (e.g. `$ ... $` in LaTeX)
hi!  def link @text.environment      Macro          " text environments of markup languages
hi!  def link @text.environment.name Type           " text indicating the type of an environment
hi!  def link @text.reference        Identifier     " text references, footnotes, citations, etc.

hi!  def link @text.todo             Todo           " todo notes
hi!  def link @text.note             SpecialComment " info notes
hi!  def link @text.warning          WarningMsg     " warning notes
hi!  def link @text.danger           ErrorMsg       " danger/error notes

hi!  def link @text.diff.add         DiffAdd        " added text (for diff files)
hi!  def link @text.diff.delete      DiffDelete     " deleted text (for diff files)

" Treesitter tags
hi!  def link @tag                   Tag            " XML tag names
hi!  def link @tag.attribute         Identifier     " XML tag attributes
hi!  def link @tag.delimiter         Delimiter      " XML tag delimiters

" Treesitter spell
call s:hi('@spell', 'None', 'None') " for defining regions to be spellchecked

" Treesitter non-standard
hi!  def link @variable.global       Identifier

" Treesitter locals
"call s:hi('@definition', 'NONE', 'LightMagenta', 'underline')
"hi! def link @definition            Identifier     " various definitions
"hi! def link @definition.constant   Identifier     " constants
"hi! def link @definition.function   Identifier     " functions
"hi! def link @definition.method     Identifier     " methods
"hi! def link @definition.var        Identifier     " variables
"hi! def link @definition.parameter  Identifier     " parameters
"hi! def link @definition.macro      Identifier     " preprocessor macros
"hi! def link @definition.type       Identifier     " types or classes
"hi! def link @definition.field      Identifier     " fields or properties
"hi! def link @definition.enum       Identifier     " enumerations
"hi! def link @definition.namespace  Identifier     " modules or namespaces
"hi! def link @definition.import     Identifier     " imported names
"hi! def link @definition.associated Identifier     " the associated type of a variable

"hi! def link @scope                 ???            " scope block
"hi! def link @reference             Identifier     " identifier reference
"call s:hi('@scope',     'NONE', 'LightMagenta', 'underline')
"call s:hi('@reference', 'NONE', 'LightMagenta', 'underline')

" Treesitter folds
"hi! def link @fold                  ???            " fold this node

" Treesitter injections
"hi! def link @language              ???            " dynamic detection of the injection language (i.e. the text of the captured node describes the language)
"hi! def link @content               ???            " region for the dynamically detected language
"hi! def link @combined              ???            " combine all matches of a pattern as one single block of content

" Treesitter indents
"call s:hi('@indent', 'NONE', 'LightMagenta', 'underline')
"hi! def link @indent                ???            " indent children when matching this node
"hi! def link @indent_end            ???            " marks the end of indented block
"hi! def link @aligned_indent        ???            " behaves like python aligned/hanging indent
"hi! def link @dedent                ???            " dedent children when matching this node
"hi! def link @branch                ???            " dedent itself when matching this node
"hi! def link @ignore                ???            " do not indent in this node
"hi! def link @auto                  ???            " behaves like 'autoindent' buffer option
"hi! def link @zero_indent           ???            " sets this node at position 0 (no indent)

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
