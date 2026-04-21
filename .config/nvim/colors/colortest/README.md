# Colorscheme test suite

Colorscheme-agnostic test files that collectively exercise every Vim, treesitter,
and LSP highlight group the colorscheme defines.

## Prerequisites

- A colorscheme active (`:colorscheme <name>`)
- Treesitter parsers installed for each language you want to test:
  `:TSInstall python markdown html c diff javascript`
  (or the parsers come bundled — check `:checkhealth treesitter`)
- Optional but recommended for LSP / diagnostic testing:
  a language server attached (e.g. `pyright`/`ruff-lsp` for Python,
  `typescript-language-server` for JS, `clangd` for C)
- Optional for plugin-specific groups: `gitsigns.nvim`, `trouble.nvim`,
  `leap.nvim`, `nvim-surround`, `indent-blankline.nvim`

## Files

Each file covers the groups that only fire for its filetype.

| File               | Filetype   | Key groups exercised                                                         |
| ------------------ | ---------- | ---------------------------------------------------------------------------- |
| `sample.py`        | Python     | `@comment.*`, `@function.*`, `@variable.*`, `@constant.*`, `@property`, `@attribute`, `@module`, `@constructor`, `@string`, `@character`, `@number`, `@boolean`, `@operator`, `@keyword.*`, `@punctuation.*`, plus all base syntax groups via fallback |
| `sample.md`        | Markdown   | `@markup.strong`, `@markup.italic`, `@markup.strikethrough`, `@markup.underline`, `@markup.heading.1–6`, `@markup.quote`, `@markup.link`, `@markup.link.url`, `@markup.list`, `@markup.list.checked`, `@markup.list.unchecked`, `@markup.raw`, `@markup.raw.block`, `@markup.math` |
| `sample.html`      | HTML       | `@tag`, `@tag.builtin`, `@tag.attribute`, `@tag.delimiter`, `@string.special.url` |
| `sample.c`         | C          | `@label`, `@function.macro`, `@keyword.directive`, `@keyword.directive.define`, `@keyword.type`, `@keyword.modifier`, `@type.definition`, `Macro`, `Structure`, `Typedef`, `Include`, `Define`, `PreCondit`, `StorageClass` |
| `sample.diff`      | diff       | `@diff.plus`, `@diff.minus`, `@diff.delta`, `Added`, `Removed`, `Changed`     |
| `sample.js`        | JavaScript | `@string.regexp`, `@character.special`, `@string.special.symbol` (via `Symbol`), template-literal `@punctuation.special` |

## How to use

```vim
:colorscheme <your-scheme>
:e colors/colortest/sample.py
:Inspect                            " at cursor — shows syntax + TS + LSP sources
:InspectTree                        " shows treesitter tree for this buffer
:so $VIMRUNTIME/syntax/hitest.vim  " buffer listing every :highlight group
```

Open each file in turn. Each has inline `# group.name` or `<!-- group.name -->`
annotations on the relevant line. Use `:Inspect` on any token to verify the
capture actually fired.

## Switching between highlight layers

Neovim layers highlights: **syntax (legacy) → treesitter → LSP semantic tokens**,
with LSP winning when present. To see what each layer contributes independently:

```vim
" Layer 1 — legacy syntax
:syntax off
:syntax on

" Layer 2 — treesitter (per buffer)
:lua vim.treesitter.stop()
:lua vim.treesitter.start()

" Layer 3 — LSP semantic tokens
:lua vim.lsp.semantic_tokens.stop(0, vim.lsp.get_clients({bufnr=0})[1].id)
:lua vim.lsp.semantic_tokens.start(0, vim.lsp.get_clients({bufnr=0})[1].id)
```

Use `:Inspect` to see **which layer produced** the color at the cursor.

## Groups that require runtime triggers (no file can cover these)

Some groups render only when Neovim is in a particular state. Files can't
trigger them; you have to do the action.

### UI state

| Group(s)                                        | How to trigger                                   |
| ----------------------------------------------- | ------------------------------------------------ |
| `Visual`, `VisualNOS`                           | press `v` / `V` / `<C-v>` and select text        |
| `CursorLine`, `CursorColumn`                    | `:set cursorline` / `:set cursorcolumn`          |
| `CursorLineNr`, `CursorLineSign`, `CursorLineFold` | visible with `cursorline` on                    |
| `ColorColumn`                                   | `:set colorcolumn=80`                            |
| `Search`                                        | `/foo<CR>`                                       |
| `IncSearch` / `CurSearch`                       | while typing in the `/` prompt                   |
| `Substitute`                                    | `:%s/x/y/gc`                                     |
| `MatchParen`                                    | cursor on `(` `[` `{`                            |
| `MatchWord`                                     | vim-matchup or similar plugin                    |
| `Folded`                                        | `zf{motion}` then `zc`                           |
| `HighlightedyankRegion`                         | yank any text (`yy`, `yw`, …) — flashes briefly  |
| `Pmenu`, `PmenuSel`, `PmenuMatch`, `PmenuMatchSel`, `PmenuKind`, `PmenuKindSel`, `PmenuExtra`, `PmenuExtraSel`, `PmenuSbar`, `PmenuThumb`, `PmenuBorder`, `PmenuShadow`, `PmenuShadowThrough` | trigger completion (`<C-n>` in insert mode) |
| `NormalFloat`, `FloatBorder`, `FloatTitle`, `FloatFooter` | press `K` (LSP hover) or open a diagnostic float |
| `SpecialKey`                                    | appears for unprintable chars in `listchars`     |
| `NonText`                                       | appears for `listchars` flags: `extends` / `precedes` / `eol` |
| `Whitespace`                                    | appears for `listchars` flags: `space` / `tab` / `trail` |
| `ExtraWhitespace`                               | trailing whitespace (see `python.py` L191)       |
| `Directory`                                     | `:Explore` / `netrw` or file pickers             |
| `Error`                                         | syntax-level errors (distinct from `Diagnostic*`)|
| `Title`                                         | terminal title / `:set title`                    |
| `LineNr`, `SignColumn`, `FoldColumn`            | always visible (gutter)                          |
| `StatusLine`, `StatusLineNC`                    | always visible (active/inactive windows)         |
| `WinSeparator`                                  | visible with `:vsplit`                           |
| `Normal`                                        | always (main text/bg)                            |
| `@spell`                                        | `:setlocal spell` — spellcheckable regions       |

### Diff mode

| Group(s)                                         | How to trigger                             |
| ------------------------------------------------ | ------------------------------------------ |
| `DiffAdd`, `DiffDelete`, `DiffChange`, `DiffText`| `:diffsplit` or `:DiffOrig` a modified file|
| `Added`, `Removed`, `Changed`                    | open a `.diff` file (cascades from `@diff.*`) — see `sample.diff` |

### LSP / diagnostics

Require an LSP server attached to the buffer.

| Group(s) | How to trigger |
|---|---|
| `DiagnosticSignError`, `DiagnosticSignWarn`, `DiagnosticSignInfo`, `DiagnosticSignHint` | write code with real errors/warnings |
| `DiagnosticUnderlineError`, `DiagnosticUnderlineWarn`, `DiagnosticUnderlineInfo`, `DiagnosticUnderlineHint` | same — squiggles on error ranges |
| `DiagnosticVirtualTextError`, `DiagnosticVirtualTextWarn`, `DiagnosticVirtualTextInfo`, `DiagnosticVirtualTextHint` | if `virtual_text=true` in `vim.diagnostic.config()` |
| `DiagnosticVirtualLinesError`, `DiagnosticVirtualLinesWarn`, `DiagnosticVirtualLinesInfo`, `DiagnosticVirtualLinesHint` | if `virtual_lines=true` |
| `DiagnosticDeprecated`                          | use a deprecated API the LSP flags         |
| `DiagnosticUnnecessary`                         | unused import/variable the LSP flags       |
| `LspReferenceText`, `LspReferenceRead`, `LspReferenceWrite` | cursor on a symbol; document highlight fires |
| `LspSignatureActiveParameter`                   | inside a function-call signature help popup |
| `LspInlayHint`                                  | `:lua vim.lsp.inlay_hint.enable()` then view types |
| `LspCodeLens`, `LspCodeLensSeparator`           | language with codelens (Rust tests, Go, …) |
| `@lsp.mod.readonly`                             | `const` / `readonly` / `final` tokens      |
| `@lsp.mod.deprecated`                           | deprecated API tokens                      |
| `@lsp.mod.defaultLibrary`                       | standard-library symbols (e.g. `os.path`)  |
| `@lsp.type.*`                                   | any symbol the LSP types (all 20+ captures)|

### Plugin-specific

| Plugin | Group(s) | How to trigger |
|---|---|---|
| gitsigns.nvim     | `GitSignsAdd`, `GitSignsChange`, `GitSignsDelete`, `GitSignsChangedelete`, `GitSignsTopdelete`, `GitSignsUntracked` | in a git repo, edit a tracked file |
| trouble.nvim      | `TroubleIndent`, `TroubleLocation`, `TroubleSignError`, `TroubleSignWarning`, `TroubleSignInformation`, `TroubleSignHint`, `TroubleSignOther` | `:Trouble diagnostics toggle` |
| leap.nvim         | `LeapBackdrop`, `LeapMatch` | press `s{char}{char}` |
| nvim-surround     | `NvimSurroundHighlight` | surround operators (`ys…`, `cs…`) |
| indent-blankline  | `IndentBlanklineChar`, `IndentBlanklineContextChar` | indent-blankline rendering |

## How to actually verify a colorscheme

String-presence in files doesn't prove visual rendering. The real verification
is visual — open each file with your colorscheme active and look.

### See every defined highlight group on one screen

```vim
:so $VIMRUNTIME/syntax/hitest.vim
```

This is the canonical "show me every `:highlight` group" command. It opens a
buffer with one line per group, each line rendered in that group's actual
styling. Scroll through this to spot:

- Contrast problems (fg and bg too close)
- Unreadable combinations
- Groups accidentally left with `NONE/NONE` that should have color

`hitest.vim` shows **every group currently defined in your runtime**, including
groups that other plugins or `default link` chains contributed, so it may list
more than just your colorscheme.

### Verify a specific group at the cursor

```vim
:Inspect
```

Run with the cursor on any token. Output shows the cascade of highlight groups
that applied there — syntax, treesitter captures, LSP semantic tokens,
extmarks. Each layer is labeled, so you can tell whether the color you see
came from `@function` (treesitter) or `@lsp.type.function` (LSP) or
`Function` (legacy syntax).

### Verify a group fires in these test files

Open each `sample.*` and hit `:Inspect` on representative tokens. The inline
`# @group.name` annotations tell you what capture *should* be firing. If
`:Inspect` shows a different group, the grammar has changed or the annotation
is wrong — grep a fresh `:help treesitter-highlight-groups` to double-check.

### Runtime-triggered groups can't be verified this way

For UI state (Visual, Search, Pmenu, etc.), LSP, diagnostics, git signs, and
plugin groups, follow the "Runtime triggers" tables above. There's no file-only
way to see them — you have to perform the action or load the dependency first.
