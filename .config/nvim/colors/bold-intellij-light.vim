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
" IntelliJ's 'Function declaration' — dark teal, underlined to distinguish from calls.
" DEFAULT_FUNCTION_CALL has no override in IntelliJ Light, so calls use default fg.
call s:hi('@function',               '#00627a', 'NONE', 'underline')
call s:hi('@function.call',          'NONE',    'NONE')
hi!  def link @function.builtin      Special        " built-in functions
hi!  def link @function.macro        Macro          " preprocessor macros

" Method definitions — teal italic + underline. Calls stay default.
call s:hi('@function.method',        '#00627a', 'NONE', 'italic,underline')
call s:hi('@function.method.call',   'NONE',    'NONE')
hi!  def link @method                @function      " method definitions (fallback)

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
" IntelliJ's 'Instance field' / 'Static field' — purple. Treesitter can't
" distinguish static vs instance, so all fields/properties get the same color.
call s:hi('@field',                  '#871094', 'NONE')
call s:hi('@property',               '#871094', 'NONE')
call s:hi('@variable.member',        '#871094', 'NONE')
hi!  def link @structure             Structure

" Treesitter identifiers
hi!  def link @variable              Identifier     " various variable names
hi!  def link @variable.builtin      Special        " built-in variable names (e.g. `this`)

" IntelliJ's 'Constant' — purple italic.
call s:hi('@constant',               '#871094', 'NONE', 'italic')
call s:hi('@constant.builtin',       '#871094', 'NONE', 'italic')
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

" LSP semantic tokens (0.9+). More accurate than treesitter for typed languages.
" Mirror the treesitter groups above — LSP tokens win when available.
hi!  def link @lsp.type.class         Type
hi!  def link @lsp.type.decorator     PreProc
hi!  def link @lsp.type.enum          Type
hi!  def link @lsp.type.enumMember    @constant
hi!  def link @lsp.type.function      @function
hi!  def link @lsp.type.interface     Type
hi!  def link @lsp.type.keyword       Keyword
hi!  def link @lsp.type.macro         Macro
hi!  def link @lsp.type.method        @function.method
hi!  def link @lsp.type.namespace     Identifier
hi!  def link @lsp.type.number        Number
hi!  def link @lsp.type.operator      Operator
hi!  def link @lsp.type.parameter     Identifier
hi!  def link @lsp.type.property      @property
hi!  def link @lsp.type.regexp        String
hi!  def link @lsp.type.string        String
hi!  def link @lsp.type.struct        Structure
hi!  def link @lsp.type.type          Type
hi!  def link @lsp.type.typeParameter @lsp.type.type
hi!  def link @lsp.type.variable      Identifier
hi!  def link @lsp.mod.deprecated     DiagnosticDeprecated
hi!  def link @lsp.mod.readonly       @constant
hi!  def link @lsp.mod.defaultLibrary Special

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
