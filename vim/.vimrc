call plug#begin('~/.vim/plugged') " ......................................{{{1

" Movement changes
if has('nvim')
    Plug 'folke/which-key.nvim'
endif
Plug 'tpope/vim-repeat'               " Make plugin-cmds repeatable.
Plug 'haya14busa/vim-asterisk'        " Enhance searching with *.
Plug 'farmergreg/vim-lastplace'       " Restore last position in file.
Plug 'unblevable/quick-scope'         " f{char}
Plug 'justinmk/vim-sneak'             " s{char}{char}
Plug 'romainl/vim-cool'               " Automatically clear search results.

" Extra movements
Plug 'tpope/vim-surround'
if has('nvim')
    Plug 'terrortylor/nvim-comment'   " Comment with gcc and v_gc.
endif
Plug 'junegunn/vim-easy-align'        " Align with e.g. :EasyAlign */[:;]\+/.

" Extra text objects
Plug 'vim-scripts/argtextobj.vim'     " Make function arguments operable with a.
Plug 'bkad/CamelCaseMotion'           " Prefix w, e and b to work on camel/snake case.
Plug 'kana/vim-textobj-user'
Plug 'beloglazov/vim-textobj-quotes'  " Make surrounding quotes operable with q.
Plug 'kana/vim-textobj-entire'        " Whole buffer with ae/ie.

" Extra functionality
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'               " Add various search popups.
Plug 'dyng/ctrlsf.vim'                " Search and replace with rg.
Plug 'tpope/vim-fugitive'             " Add a git wrapper (:G).
Plug 'ludovicchabant/vim-gutentags'   " Management of tag files.
Plug 'rizzatti/dash.vim'              " Add Dash activation.

" Language support
Plug 'editorconfig/editorconfig-vim'  " Respect .editorconfig.
Plug 'sheerun/vim-polyglot'
Plug 'vim-test/vim-test'              " Add :Test commands.
if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

" LSP and completion
if has('nvim')
    Plug 'neovim/nvim-lspconfig'
    Plug 'folke/trouble.nvim'

    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'

    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
endif

" Calculation support
Plug 'glts/vim-magnum'                " Dependency of vim-radical.
Plug 'glts/vim-radical'               " Convert between numeral bases with cr.
Plug 'arecarn/vim-selection'          " Dependency of vim-crunch.
Plug 'arecarn/vim-crunch'             " Calculator via g=.

" UI enhancements
Plug 'itchyny/lightline.vim'          " Add a status bar.
Plug 'preservim/nerdtree'             " Add a file explorer.
Plug 'Xuyuanp/nerdtree-git-plugin'    " Show git status in NERDTree.
Plug 'Lenovsky/nuake'                 " Add a terminal panel.
if has('nvim')
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'kyazdani42/nvim-web-devicons'
endif
Plug 'ryanoasis/vim-devicons'

" Split explorer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-ssh'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
if has('nvim')
    Plug 'antoinemadec/FixCursorHold.nvim'
endif

call plug#end()

" Progs and dirs .........................................................{{{1

let g:node_host_prog    = '/usr/local/bin/node'
let g:perl_host_prog    = '/usr/local/bin/perl'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:ruby_host_prog    = '/usr/bin/ruby'

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden\ -g\ "!.git/"
set grepformat=%f:%l:%c:%m,%f:%l:%m

let g:fzf_history_dir   = '~/.cache/fzf-history'

let g:gutentags_ctags_executable      = '/usr/local/bin/ctags'
let g:gutentags_ctags_executable_dart = '~/.pub-cache/bin/dart_ctags'
let s:z_sh_prog                       = '/usr/local/etc/profile.d/z.sh'

" Custom keymappings .....................................................{{{1

let mapleader = "\<Space>"

nnoremap <silent> <C-k> :lua vim.lsp.buf.hover()<CR>
inoremap <silent> <C-k> <C-o>:lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-@> :lua vim.diagnostic.open_float()<CR>

nnoremap <silent> <C-z> :FocusNuake<CR>
inoremap <silent> <C-z> <C-o>:FocusNuake<CR>
tnoremap <silent> <C-z> <C-\><C-n>:Nuake<CR><C-w>p

let g:find_todos = '(TODO|NOTE|HACK|OPTIMIZE|XXX)(\([^)]+\))?:'

" See https://github.com/folke/which-key.nvim
if has_key(plugs, 'which-key.nvim')
    lua <<HERE
        local whichkey = require"which-key"

        whichkey.setup {
            show_help = false,
            key_labels = {
                ["<space>"] = "SPC",
                ["<cr>"]    = "RET",
                ["<tab>"]   = "TAB",
            },
            icons = {
                breadcrumb = "›",
                separator  = "➜",
                group      = "",
            },
            spelling = {
                enabled = true,
            },
            layout = {
                spacing = 6,
            },
        }

        whichkey.register({
            ["<leader>"] = {
                name = "SPC",
                ["<leader>"] = { ":Files<CR>",                                                   "Find file in project"      },
                ["."]        = { ":Files <C-r>=fnameescape(fnamemodify(getcwd(), ':~:.'))<CR>/", "Find file", silent = false },
                [":"]        = { ":Commands<CR>",                                                "Show commands"             },
                ["@:"]       = { ":History:<CR>",                                                "Show command history"      },
            },
            ["<leader>b"] = {
                name = "buffer",
                b = { ":Buffers<CR>",   "Switch buffer"   },
                f = { ":Filetypes<CR>", "Set filetype"    },
                n = { ":bnext<CR>",     "Next buffer"     },
                p = { ":bprevious<CR>", "Previous buffer" },
                s = { ":update<CR>",    "Save buffer"     },
            },
            ["<leader>c"] = {
                name = "code",
                a = { ":lua vim.lsp.buf.code_action()<CR>",             "LSP Execute code action"    },
                d = { ":lua vim.lsp.buf.definition()<CR>",              "Jump to definition"         },
                D = { ":lua vim.lsp.buf.declaration()<CR>",             "Jump to declaration"        },
                f = { ":update|lua vim.lsp.buf.formatting()<CR>",       "Format buffer"              },
                i = { ":lua vim.lsp.buf.implementation()<CR>",          "Find implementations"       },
                o = { ":lua print'vim.lsp.buf.organize_imports()'<CR>", "LSP Organize imports"       },
                r = { ":lua vim.lsp.buf.rename()<CR>",                  "LSP Rename"                 },
                t = { ":lua vim.lsp.buf.type_definition()<CR>",         "Find type definition"       },
                u = { ":lua vim.lsp.buf.references()<CR>",              "Find usages"                },
                w = { ":StripTrailingWS<CR>",                           "Delete trailing whitespace" },
                x = { ":Trouble<CR>",                                   "List errors"                },
                X = { ":lua :vim.diagnostic.setqflist()<CR>",           "List errors in quickfix"    },
            },
            ["<leader>e"] = {
                name = "eval/encode",
                ["="] = { "<Plug>(crunch-operator-line)", "Evaluate equation" },
                n = {
                    name = "number",
                    b = { "<Plug>RadicalCoerceToBinary",  "Convert number to binary"  },
                    d = { "<Plug>RadicalCoerceToDecimal", "Convert number to decimal" },
                    o = { "<Plug>RadicalCoerceToOctal",   "Convert number to octal"   },
                    p = { "<Plug>RadicalView",            "Print number"              },
                    x = { "<Plug>RadicalCoerceToHex",     "Convert number to hex"     },
                },
            },
            ["<leader>f"] = {
                name = "file",
                P = { ":Editvimrc<CR>",                                       "Browse private config"     },
                r = { ":History<CR>",                                         "Recent files"              },
                t = { ":TestFile<CR>",                                        "Run file's tests"          },
                T = { ":TestNearest<CR>",                                     "Run nearest test"          },
                y = { ":let @+='<C-r>=fnameescape(expand('%:~:p'))<CR>'<CR>", "Yank file's path"          },
                Y = { ":let @+='<C-r>=fnameescape(expand('%:~'))<CR>'<CR>",   "Yank file's relative path" },
            },
            ["<leader>g"] = {
                name = "git",
                b = { ":Git branch<CR>", "Switch branch" },
                B = { ":Git blame<CR>",  "Blame"         },
                c = { name = "create",
                    r = { ":Git init", "Initialize repo" },
                },
                f = {
                    name = "find",
                    c = { ":BCommits<CR>", "Find file commit" },
                    C = { ":Commits<CR>",  "Find commit"      },
                },
                g = { ":Git<CR>",        "Show status" },
                S = { ":Gdiffsplit<CR>", "Stage file"  },
            },
            ["<leader>i"] = {
                name = "insert",
                f = { "i<C-r>=expand('%:t')<CR><ESC>l",              "Insert file's name"    },
                F = { "i<C-r>=fnameescape(expand('%:~'))<CR><ESC>l", "Insert file's path"    },
                s = { ":Snippets<CR>",                               "Insert snippet"        },
                y = { ":Yanklist<CR>",                               "Insert from yank list" },
            },
            ["<leader>o"] = {
                name = "open",
                o = { ":exe '!open -R <C-r>=fnameescape(expand('%:p'))<CR>'<CR>",                                      "Reveal file in Finder"        },
                O = { ":exe '!open <C-r>=fnameescape(getcwd())<CR>'<CR>",                                              "Reveal project in Finder"     },
                f = { ":Fern <C-r>=fnameescape(expand('%:p:h'))<CR> -reveal=<C-r>=fnameescape(expand('%:p'))<CR><CR>", "Open file"                    },
                p = { ":NERDTreeFocus<CR>",                                                                            "Project sidebar"              },
                P = { ":NERDTreeFind<CR>",                                                                             "Find file in project sidebar" },
                t = { ":terminal<CR>",                                                                                 "Toggle terminal popup"        },
            },
            ["<leader>p"] = {
                name = "project",
                a     = { ":NERDTree<CR>:EditBookmarks<CR>",                          "Add new project"      },
                d     = { ":NERDTree<CR>:EditBookmarks<CR>",                          "Remove known project" },
                p     = { ":NERDTreeFromBookmark <C-z>",                              "Switch project"       },
                t     = { ":CtrlSF -R '<C-r>=g:find_todos<CR>' '<C-r>=getcwd()<CR>'", "List project todos"   },
                T     = { ":TestSuite<CR>",                                           "Test project"         },
            },
            ["<leader>q"] = {
                name = "quit",
                q = { ":qa<CR>",  "Quit"                },
                Q = { ":qa!<CR>", "Quit without saving" },
            },
            ["<leader>s"] = {
                name = "search",
                b = { ":BLines<CR>",                                                           "Search buffer"                          },
                B = { ":Lines<CR>",                                                            "Search all open buffers"                },
                d = { ":Rg<CR>",                                                               "Search current directory"               },
                D = { ": '<C-r>=fnameescape(fnamemodify(getcwd(), ':~:.'))<CR>'<Home>CtrlSF ", "Search other directory", silent = false },
                f = { ":Locate ",                                                              "Locate file"                            },
                i = { ":lua vim.lsp.buf.workspace_symbol()<CR>",                               "Search workspace symbols"               },
                j = { ":Jumplist<CR>",                                                         "Search jump list"                       },
                k = { "<Plug>DashSearch",                                                      "Look up in local docsets"               },
                r = { ":Marks<CR>",                                                            "Jump to mark"                           },
                s = { ":lua vim.lsp.buf.document_symbol()<CR>",                                "Search buffer symbols"                  },
                t = { ":Tags<CR>",                                                             "Search tags"                            },
                T = { ":BTags<CR>",                                                            "Search buffer tags"                     },
            },
            ["<leader>t"] = {
                name = "toggle",
                c = { ":set <C-r>=&cc ? 'colorcolumn=' : 'colorcolumn=80'<CR><CR>", "Colored column" },
                C = { ":set cursorcolumn!<CR>",                                     "Cursor column"  },
                d = { ":<C-r>=&diff ? 'diffoff' : 'diffthis'<CR><CR>",              "Diff buffer"    },
                D = {
                    name = "diffing",
                    a = { ":call CycleDiffAlgo()<CR>", "Cycle diff-algo"               },
                    o = { ":diffoff!<CR>",             "Turn off diff for all buffers" },
                },
                i = {
                    name = "indentation",
                    i = { ":set expandtab!<CR>",                                     "Toggle indent"                   },
                    [">"] = { ":set ts=<C-r>=&ts+2<CR>|:set sw=<C-r>=&sw+2<CR><CR>", "Increase indent"                 },
                    ["<"] = { ":set ts=<C-r>=&ts-2<CR>|:set sw=<C-r>=&sw-2<CR><CR>", "Decrease indent"                 },
                    R = { ":<C-r>=&et ? 'Tb2Sp' : 'Sp2Tb'<CR><CR>",                  "Replace according to &expandtab" },
                },
                l = { ":set number!<CR>",                                                           "Line numbers"          },
                L = { ":set relativenumber!<CR>",                                                   "Relative line numbers" },
                v = { ":set <C-r>=&ve =~# 'all' ? 'virtualedit-=all' : 'virtualedit+=all'<CR><CR>", "Virtual editing"       },
                w = { ":set wrap!<CR>",                                                             "Soft line wrapping"    },
            },
            ["<leader>w"] = {
                name = "workspace",
                a = { ":lua vim.lsp.buf.add_workspace_folder()<CR>",                       "Add"    },
                d = { ":lua vim.lsp.buf.remove_workspace_folder()<CR>",                    "Remove" },
                l = { ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List"   },
            },
            ["<C-h>"] = {
                name = "help",
                r = {
                    name = "reload",
                    r = { ":Reload<CR>", ".vimrc", silent = false },
                },
                b = {
                    name = "bindings",
                    b = { ":Maps<CR>", "Show all" },
                },
            },
            ["[e"] = { ":lua vim.diagnostic.goto_prev()<CR>", "Previous error" },
            ["]e"] = { ":lua vim.diagnostic.goto_next()<CR>", "Next error"     },
        }, { mode = "n" })

        whichkey.register({
            ["<leader>c"] = {
                name = "code",
                f = { ":update|lua vim.lsp.buf.formatting()<CR>", "Format region" },
            },
            ["<leader>e"] = {
                name = "eval/encode",
                ["="] = { "<Plug>(visual-crunch-operator)", "Evaluate equation" },
                n = {
                    name = "number",
                    p = { "<Plug>RadicalView", "Print number" },
                },
                e = {
                    name = "encode",
                    b = { ":<C-u>call TransformSel('base64_encode')<CR>", "Base64"     },
                    h = { ":<C-u>call TransformSel('hex_encode')<CR>",    "Hex string" },
                    s = { ":<C-u>call TransformSel('string_encode')<CR>", "C string"   },
                    u = { ":<C-u>call TransformSel('url_encode')<CR>",    "URL"        },
                    x = { ":<C-u>call TransformSel('xml_encode')<CR>",    "XML"        },
                },
                d = {
                    name = "decode",
                    b = { ":<C-u>call TransformSel('base64_decode')<CR>", "Base64"     },
                    h = { ":<C-u>call TransformSel('hex_decode')<CR>",    "Hex string" },
                    s = { ":<C-u>call TransformSel('string_decode')<CR>", "C string"   },
                    u = { ":<C-u>call TransformSel('url_decode')<CR>",    "URL"        },
                    x = { ":<C-u>call TransformSel('xml_decode')<CR>",    "XML"        },
                },
            },
            ["<leader>t"] = {
                name = "toggle",
                i = {
                    name = "indentation",
                    r = { ":set <C-r>=&et ? 'Sp2Tb' : 'Tb2Sp'<CR><CR>", "Replace according to &expandtab" },
                    s = { ":Tb2Sp<CR>",                                 "Replace with spaces"             },
                    t = { ":Sp2Tb<CR>",                                 "Replace with tabs"               },
                },
            },
        }, { mode = "x" })
HERE
endif

" Move current line up and down.
nnoremap <silent> <C-\><C-d>  :move .+1<CR>==
nnoremap <silent> <C-\><C-u>  :move .-2<CR>==
inoremap <silent> <C-\><C-d>  <ESC>:move .+1<CR>==gi
inoremap <silent> <C-\><C-u>  <ESC>:move .-2<CR>==gi
xnoremap <silent> <C-\><C-d>  :move '>+1<CR>gv=gv
xnoremap <silent> <C-\><C-u>  :move '<-2<CR>gv=gv

" Sanity remappings ......................................................{{{1

" Move through wrapped lines.
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" Paste and keep clipboard.
xnoremap p pgvy

" Start search with '(very) magic'.
nnoremap / /\v
nnoremap ? ?\v
cnoremap %s/ %sm//g<Left><Left>

" Don't exit visual mode on shifting.
xnoremap < <gv
xnoremap > >gv

" Yank till the end of the line.
nnoremap Y y$

" Clear matches and redraw diff and syntax highlighting.
nnoremap <silent> <C-l> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>

" Same C-m (Return) as in insert mode.
nnoremap <C-m> o<ESC>

" Same C-j as in Emacs.
nnoremap <C-j> i<CR><ESC>

" Start new change before Ctrl-U and Ctrl-W for undo.
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" Respect an already typed prefix when iterating through history.
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"

" Join lines without moving the cursor.
nnoremap J mzJ`z

" Compatibility remappings ...............................................{{{1

" Emacs bindings in insert mode.
inoremap <expr> <C-a>  '<ESC>' . (col('.') > 1 ? '0' : '_') . 'i'
inoremap <expr> <C-e>  pumvisible() ? "\<C-e>" : "\<End>"
inoremap        <C-b>  <Left>
inoremap        <C-f>  <Right>
inoremap        <M-BS> <C-w>

" ... in command mode.
cnoremap        <C-a>  <Home>
cnoremap        <C-e>  <End>
cnoremap        <C-b>  <Left>
cnoremap        <C-f>  <Right>
cnoremap        <C-h>  <BS>
cnoremap        <C-d>  <Del>
cnoremap        <M-BS> <C-w>

" ... in terminal mode.
if has('nvim')
    tnoremap <expr> <C-a> len(filter(nvim_tabpage_list_wins(0), {k, v->nvim_win_get_config(v).relative != ""})) != 0 ? "\<C-a>" : "\<Home>"
    tnoremap <expr> <C-e> len(filter(nvim_tabpage_list_wins(0), {k, v->nvim_win_get_config(v).relative != ""})) != 0 ? "\<C-e>" : "\<End>"
else
    tnoremap <expr> <C-a> popup_findpreview() != 0 ? "\<C-a>" : "\<Home>"
    tnoremap <expr> <C-e> popup_findpreview() != 0 ? "\<C-e>" : "\<End>"
endif
tnoremap        <C-b>  <Left>
tnoremap        <C-f>  <Right>
tnoremap        <C-h>  <BS>
tnoremap        <M-BS> <C-w>
tnoremap <expr> <C-d>  <SID>CanPressDelete() ? "\<Del>" : "\<C-d>"

" Switch panes in terminal mode.
tnoremap <silent> <C-w><C-w> <C-\><C-n><C-w><C-w>
tnoremap <silent> <C-w><C-h> <C-\><C-n><C-w>h
tnoremap <silent> <C-w><C-j> <C-\><C-n><C-w>j
tnoremap <silent> <C-w><C-k> <C-\><C-n><C-w>k
tnoremap <silent> <C-w><C-l> <C-\><C-n><C-w>l
tnoremap <silent> <C-w>h     <C-\><C-n><C-w>h
tnoremap <silent> <C-w>j     <C-\><C-n><C-w>j
tnoremap <silent> <C-w>k     <C-\><C-n><C-w>k
tnoremap <silent> <C-w>l     <C-\><C-n><C-w>l

" Custom commands ........................................................{{{1

" Change indentation.
command! -range=% -nargs=0 Tb2Sp exe '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
command! -range=% -nargs=0 Sp2Tb exe '<line1>,<line2>s#^\( \{' . &ts . '\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'

" Diff current buffer and file it was loaded from.
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

" Change dir via z.
command! -nargs=+ Z call <SID>ZLookup(<q-args>)

" ... and open file.
command! -nargs=+ Ze call <SID>EditAfterZ(<f-args>)

" Trim trailing whitespaces.
command! StripTrailingWS call <SID>StripTrailingWhitespaces()

" Append modeline after last line in buffer.
command! AppendModeline call <SID>AppendModeline()

" Open or focus nuake.
command! FocusNuake call <SID>FocusNuake()

" Save file with sudo.
command! W w !sudo tee % >/dev/null

" Reload and open vim config.
command! Reload exe 'source ~/.vimrc'
command! Editvimrc exe 'tabedit ~/.vimrc'

augroup use-real-tabs-filetypes
    autocmd!
    autocmd FileType text,go
        \ setlocal noexpandtab        |
        \ setlocal shiftwidth=8       |
        \ setlocal softtabstop=0      |
        \ setlocal tabstop=8          |
augroup end

augroup close-preview-after-completion
    autocmd!
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
augroup end

augroup autosave-like-intellij
    autocmd!
    autocmd WinLeave,FocusLost * silent! wall
augroup end

"augroup revert-to-normal-mode
"    autocmd!
"    autocmd FocusLost * call feedkeys("\<C-\>\<C-n>")
"augroup end

if has('nvim')
    augroup highlight-on-yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="HighlightedyankRegion", timeout=400})
    augroup end
endif

augroup restore-C-m-if-readonly
    autocmd!
    autocmd BufReadPost * if !&modifiable | nnoremap <buffer> <C-m> <C-m> | endif
    autocmd Filetype netrw nnoremap <buffer> <C-m> <C-m>
augroup end

" Helper functions .......................................................{{{1

fun! s:ZLookup(args) abort
    let dir = system('. ' . s:z_sh_prog . ' && _z ' . a:args . ' && pwd')
    exe 'tcd ' . dir
    echo 'Changed directory to ' . substitute(dir, '\n', '', '')
endfun

fun! s:EditAfterZ(...) abort
    let args = join(a:000[:a:0 - 2], " ")
    call s:ZLookup(args)
    exe 'e ' . a:000[a:0 - 1] . '*'
endfun

fun! s:AppendModeline() abort
    " Other format:  vim:tw=78:ts=8:ft=help:norl:noet:fen:fdl=0:fdm=marker:
    "                vim:tw=78:ts=2:sts=2:sw=2:ft=help:norl:
    let opts = printf(" vim: set tw=%d ts=%d sw=%d %set: ",
        \ &textwidth,
        \ &tabstop,
        \ &shiftwidth,
        \ &expandtab ? '' : 'no'
        \ )
    " Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
    " files.
    let modeline = substitute(&commentstring, '%s', opts, 'g')
    call append(line("$"), modeline)
endfun

fun! s:StripTrailingWhitespaces() abort
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l,c)
endfun

fun! s:FocusNuake() abort
    let winnr = -1
    if exists('t:nuake_buf_nr')
        let winnr = bufwinnr(t:nuake_buf_nr)
    endif
    if winnr == -1 || winnr == winnr()
        exe 'Nuake'
    else
        exe winnr . "wincmd w"
    endif
endfun

" Does preceding text exist?
fun! s:CanComplete() abort
    let col = col('.') - 1
    return col != 0 && getline('.')[col - 1] !~ '\s'
endfun

" Does prepended text exist?
fun! s:CanPressDelete() abort
    return col('.') < virtcol('$')
endfun

fun! s:DelayedQuit(delay)
    call timer_start(a:delay, 'QuitCallback')
endfun

fun! QuitCallback(timer)
    quit
endfun

" Cycle between myers, patience and histogram for diffing.
fun! CycleDiffAlgo()
    let algos = ['algorithm:myers', 'algorithm:patience', 'algorithm:histogram']
    let current = &diffopt
    for i in range(0, len(algos)-1)
        let algo = algos[i]
        if current =~ algo
            let newalgo = algos[(i+1)%len(algos)]
            exe 'set diffopt-=' .. algo
            exe 'set diffopt+=' .. newalgo
            echo 'Diff algo set to ' . newalgo
            return
        endif
    endfor
endfun

" Encoding functions .....................................................{{{1
" Taken from tpope's vim-unimpaired.

fun! TransformSel(func) abort
    let old_sel = &selection
    if visualmode() ==# 'v'
        set selection=inclusive
    elseif visualmode() ==# 'V'
        set selection=exclusive
    else
        return
    endif
    let old_reg = @@
    exe "normal! `<v`>y"
    let @@ = s:{a:func}(@@)
    normal! gvp
    let @@ = old_reg
    let &selection = old_sel
endfun

fun! s:hex_encode(str) abort
    return substitute(a:str,
        \ '.',
        \ '\=printf("%x", char2nr(submatch(0)))',
        \ 'g')
endfun

fun! s:hex_decode(str) abort
    return substitute(a:str,
        \ '\x\x',
        \ '\=nr2char(printf("%d", "0x" . submatch(0)))',
        \ 'g')
endfun

fun! s:base64_encode(str) abort
    return trim(system('base64', a:str))
endfun

fun! s:base64_decode(str) abort
    return trim(system('base64 -d', a:str))
endfun

fun! s:string_encode(str) abort
    let map = {
        \ "\n": 'n',
        \ "\r": 'r',
        \ "\t": 't',
        \ "\b": 'b',
        \ "\f": '\f',
        \ '"' : '"',
        \ '\' : '\',
        \ }
    return substitute(a:str,
        \ "[\001-\033\\\\\"]",
        \ '\="\\" . get(map, submatch(0), printf("%03o", char2nr(submatch(0))))',
        \ 'g')
endfun

fun! s:string_decode(str) abort
    let map = {
        \ 'n' : "\n",
        \ 'r' : "\r",
        \ 't' : "\t",
        \ 'b' : "\b",
        \ 'f' : "\f",
        \ 'e' : "\e",
        \ 'a' : "\001",
        \ 'v' : "\013",
        \ "\n": '',
        \ }
    let str = a:str
    if str =~# '^\s*".\{-\}\\\@<!\%(\\\\\)*"\s*\n\=$'
        let str = substitute(str, '^\s*\zs"', '', '')
        let str = substitute(str, '"\ze\s*\n\=$', '', '')
    endif
    return substitute(str,
        \ '\\\(\o\{1,3\}\|x\x\{1,2\}\|u\x\{1,4\}\|.\)',
        \ '\=get(map, submatch(1), submatch(1) =~? "^[0-9xu]"'
        \ . '? nr2char("0" . substitute(submatch(1), "^[Uu]", "x", ""))'
        \ . ': submatch(1))',
        \ 'g')
endfun

fun! s:url_encode(str) abort
    let str = iconv(a:str, 'latin1', 'utf-8')
    return substitute(str,
        \ '[^A-Za-z0-9_.~-]',
        \ '\="%" . printf("%02X", char2nr(submatch(0)))',
        \ 'g')
endfun

fun! s:url_decode(str) abort
    let str = substitute(a:str, '%0[Aa]\n$', '%0A','')
    let str = substitute(str, '%0[Aa]', '\n', 'g')
    let str = substitute(str, '+', ' ', 'g')
    let str = substitute(str, '%\(\x\x\)', '\=nr2char("0x" . submatch(1))', 'g')
    return iconv(str, 'utf-8', 'latin1')
endfun

fun! s:xml_encode(str) abort
    let str = substitute(a:str, '&', '\&amp;', 'g')
    let str = substitute(str, '<', '\&lt;', 'g')
    let str = substitute(str, '>', '\&gt;', 'g')
    let str = substitute(str, '"', '\&quot;', 'g')
    return substitute(str, "'", '\&apos;', 'g')
endfun

fun! s:xml_decode(str) abort
    let str = substitute(a:str, '<\%([[:alnum:]-]\+=\%("[^"]*"\|''[^'']*''\)\|.\)\{-\}>', '', 'g')
    return s:xml_entity_decode(str)
endfun

let g:html_entities = {
    \ 'nbsp'   :  160, 'iexcl'  :  161, 'cent'    :  162, 'pound'  :  163,
    \ 'curren' :  164, 'yen'    :  165, 'brvbar'  :  166, 'sect'   :  167,
    \ 'uml'    :  168, 'copy'   :  169, 'ordf'    :  170, 'laquo'  :  171,
    \ 'not'    :  172, 'shy'    :  173, 'reg'     :  174, 'macr'   :  175,
    \ 'deg'    :  176, 'plusmn' :  177, 'sup2'    :  178, 'sup3'   :  179,
    \ 'acute'  :  180, 'micro'  :  181, 'para'    :  182, 'middot' :  183,
    \ 'cedil'  :  184, 'sup1'   :  185, 'ordm'    :  186, 'raquo'  :  187,
    \ 'frac14' :  188, 'frac12' :  189, 'frac34'  :  190, 'iquest' :  191,
    \ 'Agrave' :  192, 'Aacute' :  193, 'Acirc'   :  194, 'Atilde' :  195,
    \ 'Auml'   :  196, 'Aring'  :  197, 'AElig'   :  198, 'Ccedil' :  199,
    \ 'Egrave' :  200, 'Eacute' :  201, 'Ecirc'   :  202, 'Euml'   :  203,
    \ 'Igrave' :  204, 'Iacute' :  205, 'Icirc'   :  206, 'Iuml'   :  207,
    \ 'ETH'    :  208, 'Ntilde' :  209, 'Ograve'  :  210, 'Oacute' :  211,
    \ 'Ocirc'  :  212, 'Otilde' :  213, 'Ouml'    :  214, 'times'  :  215,
    \ 'Oslash' :  216, 'Ugrave' :  217, 'Uacute'  :  218, 'Ucirc'  :  219,
    \ 'Uuml'   :  220, 'Yacute' :  221, 'THORN'   :  222, 'szlig'  :  223,
    \ 'agrave' :  224, 'aacute' :  225, 'acirc'   :  226, 'atilde' :  227,
    \ 'auml'   :  228, 'aring'  :  229, 'aelig'   :  230, 'ccedil' :  231,
    \ 'egrave' :  232, 'eacute' :  233, 'ecirc'   :  234, 'euml'   :  235,
    \ 'igrave' :  236, 'iacute' :  237, 'icirc'   :  238, 'iuml'   :  239,
    \ 'eth'    :  240, 'ntilde' :  241, 'ograve'  :  242, 'oacute' :  243,
    \ 'ocirc'  :  244, 'otilde' :  245, 'ouml'    :  246, 'divide' :  247,
    \ 'oslash' :  248, 'ugrave' :  249, 'uacute'  :  250, 'ucirc'  :  251,
    \ 'uuml'   :  252, 'yacute' :  253, 'thorn'   :  254, 'yuml'   :  255,
    \ 'OElig'  :  338, 'oelig'  :  339, 'Scaron'  :  352, 'scaron' :  353,
    \ 'Yuml'   :  376, 'circ'   :  710, 'tilde'   :  732, 'ensp'   : 8194,
    \ 'emsp'   : 8195, 'thinsp' : 8201, 'zwnj'    : 8204, 'zwj'    : 8205,
    \ 'lrm'    : 8206, 'rlm'    : 8207, 'ndash'   : 8211, 'mdash'  : 8212,
    \ 'lsquo'  : 8216, 'rsquo'  : 8217, 'sbquo'   : 8218, 'ldquo'  : 8220,
    \ 'rdquo'  : 8221, 'bdquo'  : 8222, 'dagger'  : 8224, 'Dagger' : 8225,
    \ 'permil' : 8240, 'lsaquo' : 8249, 'rsaquo'  : 8250, 'euro'   : 8364,
    \ 'fnof'   :  402, 'Alpha'  :  913, 'Beta'    :  914, 'Gamma'  :  915,
    \ 'Delta'  :  916, 'Epsilon':  917, 'Zeta'    :  918, 'Eta'    :  919,
    \ 'Theta'  :  920, 'Iota'   :  921, 'Kappa'   :  922, 'Lambda' :  923,
    \ 'Mu'     :  924, 'Nu'     :  925, 'Xi'      :  926, 'Omicron':  927,
    \ 'Pi'     :  928, 'Rho'    :  929, 'Sigma'   :  931, 'Tau'    :  932,
    \ 'Upsilon':  933, 'Phi'    :  934, 'Chi'     :  935, 'Psi'    :  936,
    \ 'Omega'  :  937, 'alpha'  :  945, 'beta'    :  946, 'gamma'  :  947,
    \ 'delta'  :  948, 'epsilon':  949, 'zeta'    :  950, 'eta'    :  951,
    \ 'theta'  :  952, 'iota'   :  953, 'kappa'   :  954, 'lambda' :  955,
    \ 'mu'     :  956, 'nu'     :  957, 'xi'      :  958, 'omicron':  959,
    \ 'pi'     :  960, 'rho'    :  961, 'sigmaf'  :  962, 'sigma'  :  963,
    \ 'tau'    :  964, 'upsilon':  965, 'phi'     :  966, 'chi'    :  967,
    \ 'psi'    :  968, 'omega'  :  969, 'thetasym':  977, 'upsih'  :  978,
    \ 'piv'    :  982, 'bull'   : 8226, 'hellip'  : 8230, 'prime'  : 8242,
    \ 'Prime'  : 8243, 'oline'  : 8254, 'frasl'   : 8260, 'weierp' : 8472,
    \ 'image'  : 8465, 'real'   : 8476, 'trade'   : 8482, 'alefsym': 8501,
    \ 'larr'   : 8592, 'uarr'   : 8593, 'rarr'    : 8594, 'darr'   : 8595,
    \ 'harr'   : 8596, 'crarr'  : 8629, 'lArr'    : 8656, 'uArr'   : 8657,
    \ 'rArr'   : 8658, 'dArr'   : 8659, 'hArr'    : 8660, 'forall' : 8704,
    \ 'part'   : 8706, 'exist'  : 8707, 'empty'   : 8709, 'nabla'  : 8711,
    \ 'isin'   : 8712, 'notin'  : 8713, 'ni'      : 8715, 'prod'   : 8719,
    \ 'sum'    : 8721, 'minus'  : 8722, 'lowast'  : 8727, 'radic'  : 8730,
    \ 'prop'   : 8733, 'infin'  : 8734, 'ang'     : 8736, 'and'    : 8743,
    \ 'or'     : 8744, 'cap'    : 8745, 'cup'     : 8746, 'int'    : 8747,
    \ 'there4' : 8756, 'sim'    : 8764, 'cong'    : 8773, 'asymp'  : 8776,
    \ 'ne'     : 8800, 'equiv'  : 8801, 'le'      : 8804, 'ge'     : 8805,
    \ 'sub'    : 8834, 'sup'    : 8835, 'nsub'    : 8836, 'sube'   : 8838,
    \ 'supe'   : 8839, 'oplus'  : 8853, 'otimes'  : 8855, 'perp'   : 8869,
    \ 'sdot'   : 8901, 'lceil'  : 8968, 'rceil'   : 8969, 'lfloor' : 8970,
    \ 'rfloor' : 8971, 'lang'   : 9001, 'rang'    : 9002, 'loz'    : 9674,
    \ 'spades' : 9824, 'clubs'  : 9827, 'hearts'  : 9829, 'diams'  : 9830,
    \ 'apos'   :   39,
    \ }

fun! s:xml_entity_decode(str) abort
    let str = substitute(a:str, '\c&#\%(0*38\|x0*26\);', '&amp;', 'g')
    let str = substitute(str, '\c&#\(\d\+\);', '\=nr2char(submatch(1))', 'g')
    let str = substitute(str, '\c&#\(x\x\+\);', '\=nr2char("0" . submatch(1))', 'g')
    let str = substitute(str, '\c&apos;', "'", 'g')
    let str = substitute(str, '\c&quot;', '"', 'g')
    let str = substitute(str, '\c&gt;', '>', 'g')
    let str = substitute(str, '\c&lt;', '<', 'g')
    let str = substitute(str, '\C&\(\%(amp;\)\@!\w*\);', '\=nr2char(get(g:html_entities, submatch(1), 63))', 'g')
    return substitute(str, '\c&amp;', '\&', 'g')
endfun

" vim-repeat settings ....................................................{{{1
" See https://github.com/tpope/vim-repeat

" vim-asterisk settings ..................................................{{{1
" See https://github.com/haya14busa/vim-asterisk/blob/master/doc/asterisk.txt

if has_key(plugs, 'vim-asterisk')
    let g:asterisk#keeppos = 1 " Stay in the same column.

    map * <Plug>(asterisk-*)
    map # <Plug>(asterisk-#)
    map g* <Plug>(asterisk-g*)
    map g# <Plug>(asterisk-g#)

    " 'Stay' variants for searching.
    map z*  <Plug>(asterisk-z*)
    map z#  <Plug>(asterisk-z#)
    map gz* <Plug>(asterisk-gz*)
    map gz# <Plug>(asterisk-gz#)
endif

" vim-lastplace settings .................................................{{{1
" See https://github.com/farmergreg/vim-lastplace/blob/master/doc/vim-lastplace.txt

" Quick-scope settings ...................................................{{{1
" See https://github.com/unblevable/quick-scope/blob/master/doc/quick-scope.txt
" For fixing interaction with sneak,
" see https://github.com/unblevable/quick-scope/issues/55#issuecomment-629721429

if has_key(plugs, 'quick-scope')
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] " Highlight after pressing those keys.

    augroup qs-colors
        autocmd!
        autocmd ColorScheme * hi QuickScopePrimary   cterm=underline gui=underline ctermfg=0 guifg=Black ctermbg=155 guibg=#afff5f
        autocmd ColorScheme * hi QuickScopeSecondary cterm=underline gui=underline ctermfg=0 guifg=Black ctermbg=81  guibg=#5fffff
    augroup end
endif

" Sneak settings .........................................................{{{1
" See https://github.com/justinmk/vim-sneak/blob/master/doc/sneak.txt

if has_key(plugs, 'vim-sneak')
    let g:sneak#label = 1 " Show labels like EasyMotion.

    augroup sneak-colors
        autocmd!
        autocmd ColorScheme * hi SneakScope cterm=underline gui=underline ctermfg=0 guifg=Black ctermbg=155 guibg=#5fffff
        autocmd ColorScheme * hi Sneak                                    ctermfg=0 guifg=Black ctermbg=81  guibg=#afff5f
    augroup end
endif

" vim-cool settings ......................................................{{{1
" See https://github.com/romainl/vim-cool

" nvim-comment settings ..................................................{{{1
" See https://github.com/terrortylor/nvim-comment

if has_key(plugs, 'nvim-comment')
    lua require"nvim_comment".setup { marker_padding = false }
endif

" EasyAlign settings .....................................................{{{1
" See https://github.com/junegunn/vim-easy-align/blob/master/doc/easy_align.txt

if has_key(plugs, 'vim-easy-align')
    let g:easy_align_delimiters = {
        \     't': {
        \         'pattern': "\t",
        \         'left_margin': 0,
        \         'right_margin': 0,
        \         'stick_to_left': 1,
        \     },
        \     '\': {
        \         'pattern': '\',
        \         'left_margin': 0,
        \         'right_margin': 0,
        \         'stick_to_left': 1,
        \     },
        \     '-': {
        \         'pattern': '\-\+',
        \         'delimiter_align': "l",
        \         'ignore_groups': ["!Comment"],
        \     },
        \     'd': {
        \         'pattern': '\d\+',
        \         'delimiter_align': 'r',
        \         'left_margin': 1,
        \         'right_margin': 1,
        \         'stick_to_left': 0,
        \         'ignore_groups': [],
        \     },
        \     'j': {
        \         'pattern': ':\|,',
        \         'align': 'r',
        \         'delimiter_align': 'c',
        \         'left_margin': 1,
        \         'right_margin': 1,
        \         'stick_to_left': 0,
        \         'ignore_groups': [],
        \     },
        \ }

    nmap gl <Plug>(EasyAlign)
    xmap gl <Plug>(EasyAlign)
    xmap .  <Plug>(EasyAlignRepeat)
endif

" argtextobj.vim settings ................................................{{{1
" See https://github.com/vim-scripts/argtextobj.vim

" CamelCaseMotion settings ...............................................{{{1
" See https://github.com/bkad/CamelCaseMotion/blob/master/doc/camelcasemotion.txt

if has_key(plugs, 'CamelCaseMotion')
    let g:camelcasemotion_key = '\'
endif

" vim-textobj-quotes settings ............................................{{{1
" See https://github.com/beloglazov/vim-textobj-quotes/blob/master/doc/textobj-quotes.txt

if has_key(plugs, 'vim-textobj-quotes')
    " Shortcut for the inner quote text object.
    omap q iq
    xmap q iq
endif

" fzf.vim settings  ......................................................{{{1
" See https://github.com/junegunn/fzf.vim/blob/master/doc/fzf-vim.txt
" and https://github.com/junegunn/fzf/blob/master/doc/fzf.txt
" and https://github.com/junegunn/fzf/blob/master/man/man1/fzf.1

if has_key(plugs, 'fzf.vim')
    let $FZF_DEFAULT_COMMAND = 'fd -t f -H -E ".git" -E ".DS_Store"'
    let $FZF_DEFAULT_OPTS    = '--layout=reverse'
        \ . ' --bind ctrl-/:toggle-preview-wrap'
        \ . ' --bind ctrl-space:preview-half-page-down'
        \ . ' --bind ctrl-j:next-history'
        \ . ' --bind ctrl-k:previous-history'
        \ . ' --bind ctrl-p:up'
        \ . ' --bind ctrl-n:down'

    let g:fzf_buffers_jump        = 0                             " Don't jump to the existing window.
    let g:fzf_preview_window      = ['down:80%:hidden', 'ctrl-o'] " Toggle preview window with hotkey.
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black bold)%cr"'

    fun! s:build_quickfix_list(lines) abort
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen
        cc
    endfun

    let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit',
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ }

    let g:fzf_layout = {
        \     'window': {
        \         'width': 0.5,
        \         'height': 0.7,
        \         'xoffset': 0.6,
        \         'yoffset': 0.5,
        \     },
        \ }

    let g:fzf_colors = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'ErrorMsg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'ErrorMsg', 'Statement'],
        \ 'info':    ['fg', 'Exception', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'Exception', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'],
        \ }

    fun! s:FzfFilesWrapper(query, fullscreen) abort
        let dir = a:query
        if empty(dir)
            let cwd = fnamemodify(getcwd(), ':~:.')
            let dir = fnamemodify(cwd, ':t')
            if cwd != dir
                let dir = '../' . dir
            endif
        endif
        let opts = fzf#vim#with_preview()
        call fzf#vim#files(dir, opts, a:fullscreen)
    endfun

    fun! s:FzfRgWrapper(query, fullscreen) abort
        let cmd = 'rg --hidden -g "!.git/" --column --line-number --color=always --smart-case -- %s || true'
        let initial = printf(cmd, shellescape(a:query))
        let reload = printf(cmd, '{q}')
        let opts = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:' . reload]}
        call fzf#vim#grep(initial, 1, fzf#vim#with_preview(opts), a:fullscreen)
    endfun

    fun! s:FzfYankWrapper(query, fullscreen) abort
        let opts = {
            \ 'source': s:GetYanks(),
            \ 'sink': function('<SID>FzfYankHandler'),
            \ 'options': '--query="' . a:query . '" --prompt="Paste> "',
            \ }
        call fzf#run(fzf#wrap('yanks', opts))
    endfun

    fun! s:FzfYankHandler(line) abort
        let index = matchstr(a:line, '^\d\+') - 1
        exe "normal :YRPaste 'p'\<CR>"
        if index > 0
            exe "normal :YRReplace -" . index . " 'p'\<CR>"
        endif
    endfun

    fun! s:GetYanks() abort
        redir => a
        silent YRShow
        redir end
        return split(a, '\n')[2:]
    endfun

    fun! s:FzfJumpWrapper(query, fullscreen) abort
        let opts = {
            \ 'source': s:GetJumps(),
            \ 'sink': function('<SID>FzfJumpHandler'),
            \ 'options': '--query="' . a:query . '" --prompt="Jumps> "',
            \ }
        call fzf#run(fzf#wrap('jumps', opts))
    endfun

    fun! s:FzfJumpHandler(line) abort
        let index = matchstr(a:line, '^\s*\zs\d\+')
        keepjumps exe "normal " . index . "\<C-o>"
    endfun

    fun! s:GetJumps() abort
        redir => a
        silent jumps
        redir end
        return reverse(split(a, '\n')[1:])
    endfun

    command! -nargs=? -bang Files    call <SID>FzfFilesWrapper(<q-args>, <bang>0)
    command! -nargs=* -bang Rg       call <SID>FzfRgWrapper(<q-args>,    <bang>0)
    command! -nargs=* -bang Yanklist call <SID>FzfYankWrapper(<q-args>,  <bang>0)
    command! -nargs=* -bang Jumplist call <SID>FzfJumpWrapper(<q-args>,  <bang>0)
endif

" CtrlSF settings ........................................................{{{1
" See https://github.com/dyng/ctrlsf.vim/blob/master/doc/ctrlsf.txt

if has_key(plugs, 'ctrlsf.vim')
    let g:ctrlsf_winsize          = '40%'
    let g:ctrlsf_position         = 'bottom' " Open below.
    let g:ctrlsf_preview_position = 'inside' " Open preview as split.
    let g:ctrlsf_context          = '-B 2'   " Printy that many lines for context.

    let g:ctrlsf_extra_backend_args = {
        \ 'rg': '--hidden',
        \ }

    let g:ctrlsf_auto_focus = {
        \ 'at' : 'done',
        \ 'duration_less_than': 1000,
        \ }
endif

" Fugitive settings ......................................................{{{1
" See https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt

" Gutentags settings .....................................................{{{1
" See https://github.com/ludovicchabant/vim-gutentags/blob/master/doc/gutentags.txt

if has_key(plugs, 'vim-gutentags')
    let g:gutentags_project_root        = ['tags'] " Use the nearest tags-file.
    let g:gutentags_init_user_func      = 'GutentagsInitUserFunc' " Only activate if there already is a tags-file.
    let g:gutentags_generate_on_missing = 0 " Don't automatically generate tags.
    let g:gutentags_generate_on_new     = 0 " Same with this one.
    let g:gutentags_file_list_command   = 'fd -t f -H -E ".git" -E ".DS_Store" .'

    let g:gutentags_project_info = [
        \ { 'type': 'dart', 'file': 'pubspec.yaml' },
        \ ]

    " Activate gutentags only if there is a tags-file in cwd or project root.
    fun! GutentagsInitUserFunc(file) abort
        try
            let tagfile = expand('%:p:h') . '/tags'
            if filereadable(tagfile)
                " Save tags-file in cwd instead of project root.
                let b:gutentags_ctags_tagfile = tagfile
                return 1
            endif
        catch
        endtry
        try
            let tagfile = gutentags#get_project_root(a:file) . '/tags'
            return filereadable(tagfile)
        catch
        endtry
        return 0
    endfun
endif

" Dash settings ..........................................................{{{1
" See https://github.com/rizzatti/dash.vim/blob/master/doc/dash.txt

if has_key(plugs, 'dash.vim')
    let g:dash_activate = 1 " Whether Dash.app gets focussed.

    let g:dash_map = {
        \ 'java' : 'android',
        \ }
endif

" Dart settings ..........................................................{{{1
" See https://github.com/dart-lang/dart-vim-plugin/blob/master/doc/dart.txt

let g:dart_format_on_save = 1
let g:dart_style_guide    = 2
let dart_html_in_string   = v:true
"let g:lsc_auto_map       = v:true

" Go settings ............................................................{{{1
" See https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt

let g:go_fmt_command         = 'gofumports'
let g:go_def_mapping_enabled = 0

" Rust settings ..........................................................{{{1
" See https://github.com/rust-lang/rust.vim/blob/master/doc/rust.txt

let g:rustfmt_autosave = 0

" vim-test settings ......................................................{{{1
" See https://github.com/vim-test/vim-test/blob/master/doc/test.txt

if has_key(plugs, 'vim-test')
    let g:test#preserve_screen        = 0
    if has('nvim')
        let test#strategy             = "neovim"
        let test#neovim#term_position = "vert botright 30"
    else
        let test#strategy             = "vimterminal"
        let test#vim#term_position    = "belowright"
    endif
endif

" Treesitter settings ....................................................{{{1
" See https://github.com/nvim-treesitter/nvim-treesitter/blob/master/doc/nvim-treesitter.txt

if has_key(plugs, 'nvim-treesitter')
    lua <<HERE
        require"nvim-treesitter.configs".setup {
            ensure_installed = "maintained",
            highlight = {
                enable = false,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = false ,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
            indent = {
                enable = false,
            },
        }
HERE
endif

" Radical.vim settings ...................................................{{{1
" See https://github.com/glts/vim-radical/blob/master/doc/radical.txt
let g:radical_no_mappings = 1

" Crunch settings ........................................................{{{1
" See https://github.com/arecarn/vim-crunch/blob/master/doc/crunch.txt

" LSP settings ...........................................................{{{1
" See https://github.com/neovim/nvim-lspconfig/blob/master/doc/lspconfig.txt
" and https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
" and https://neovim.io/doc/user/lsp.html

if has_key(plugs, 'nvim-lspconfig')
    lua <<HERE
        local lspconfig = require"lspconfig"
        local util = require"lspconfig/util"
        local cmplsp = require"cmp_nvim_lsp"

        vim.fn.sign_define("LspDiagnosticsSignError", {
            -- text   = " ",
            -- texthl = "LspDiagnosticsSignError",
            numhl  = "LspDiagnosticsSignError",
        })
        vim.fn.sign_define("LspDiagnosticsSignWarning", {
            -- text   = " ",
            -- texthl = "LspDiagnosticsSignWarning",
            numhl  = "LspDiagnosticsSignWarning",
        })
        vim.fn.sign_define("LspDiagnosticsSignInformation", {
            -- text   = " ",
            -- texthl = "LspDiagnosticsSignInformation",
            numhl  = "LspDiagnosticsSignInformation",
        })
        vim.fn.sign_define("LspDiagnosticsSignHint", {
            -- text   = " ",
            -- texthl = "LspDiagnosticsSignHint",
            numhl  = "LspDiagnosticsSignHint",
        })

        vim.lsp.protocol.CompletionItemKind = {
            " text",        --  text
            " method",      -- method
            " function",    -- function
            " constructor", --  constructor
            " field",       -- ﰠ field
            " variable",    --  variable
            " class",       -- class
            "ﰮ interface",   -- interface
            " module",      --  module
            " property",    -- property
            " unit",        -- unit
            " value",       -- value
            " enum",        -- 了enum
            " keyword",     -- keyword
            "﬌ snippet",     --  snippet
            " color",       --  color
            " file",        --  file
            " reference",   --  reference
            " folder",      --  folder
            " enum member", -- enum member
            " const",       -- constant
            " struct",      -- struct
            " event",       -- ⌘ event
            "ﬦ operator",    --  operator
            " type param",  --  type parameter
        }

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                update_in_insert = false,
                -- underline = false,
                signs = {
                    -- severity_limit = "Warning",
                },
                virtual_text = {
                    -- severity_limit = "Warning",
                    -- spacing = 1,
                    -- prefix = "~",
                },
            })

        vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx, config)
            if err ~= nil or result == nil then
                return
            end
            if not vim.api.nvim_buf_get_option(ctx.bufnr, "modified") then
                local view = vim.fn.winsaveview()
                vim.lsp.util.apply_text_edits(result, ctx.bufnr)
                vim.fn.winrestview(view)
                if ctx.bufnr == vim.api.nvim_get_current_buf() then
                    vim.api.nvim_command("noautocmd :update")
                end
            end
        end

        -- See https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/protocol.lua#L621
        local function make_snippet_capabilities()
            local res = vim.lsp.protocol.make_client_capabilities()
            res.textDocument.completion.completionItem.snippetSupport = true
            res.textDocument.completion.completionItem.commitCharactersSupport = true
            res.textDocument.completion.completionItem.preselectSupport = true
            res.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                },
            }

            if cmplsp then
                res = cmplsp.update_capabilities(res)
            end
            return res
        end

        local function no_format(on_attach)
            return function(client, bufnr)
                client.resolved_capabilities.document_formatting = false
                return on_attach(client, bufnr)
            end
        end

        local function with_organize_imports(on_attach, func)
            return function(client, bufnr)
                client.resolved_capabilities.organize_imports = func
                return on_attach(client, bufnr)
            end
        end

        local function on_attach(client, bufnr)
            if client.resolved_capabilities.goto_definition then
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
                vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
            end
            if client.resolved_capabilities.organize_imports then
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>co",
                    "<Cmd>lua " .. client.resolved_capabilities.organize_imports .. "()<CR>",
                    { noremap=true, silent=true })
            end
        end

        local function root_pattern(...)
            return util.root_pattern(..., ".git", vim.fn.getcwd())
        end

        --
        -- bashls settings
        --
        lspconfig.bashls.setup {
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        --
        -- clangd settings
        --
        lspconfig.clangd.setup {
            cmd = {
                "xcrun",
                "--run",
                "clangd",
                "--background-index",
                "--suggest-missing-includes",
                "--clang-tidy",
                "--header-insertion=iwyu",
            },
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
            flags = { debounce_text_changes = 150 },
        }

        --
        -- cssls settings
        --
        lspconfig.cssls.setup {
            on_attach = no_format(on_attach),
            capabilities = make_snippet_capabilities(),
        }

        --
        -- dartls settings
        --
        lspconfig.dartls.setup {
            init_options = {
                suggestFromUnimportedLibraries = true,
                -- onlyAnalyzeProjectsWithOpenFiles = false,
                -- closingLabels = true,
                -- flutterOutline = true,
                -- outline = false,
            },
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
            flags = { debounce_text_changes = 150 },
        }

        --
        -- denols settings (start manually with :LspStart denols)
        --
        lspconfig.denols.setup {
            autostart = false,
            init_options = {
                enable = true,
                lint = true,
                unstable = true,
            },
            root_dir = root_pattern(),
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        --
        -- dotls settings
        --
        lspconfig.dotls.setup {
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        --
        -- efm settings
        --
        local tools = {
            eslint = {
                lintCommand = "npx eslint -f visualstudio --stdin --stdin-filename ${INPUT}",
                lintIgnoreExitCode = true,
                lintStdin = true,
                lintFormats = {
                    "%f(%l,%c): %tarning %m",
                    "%f(%l,%c): %rror %m",
                },
                formatCommand = "npx eslint --fix --stdin --stdin-filename ${INPUT}",
                formatStdin = true,
            },
            prettier = {
                formatCommand = "npx prettier --stdin-filepath ${INPUT}",
                formatStdin = true,
            },
            lua_format = {
                formatCommand = "lua-format -i",
                formatStdin = true,
            },
            shellcheck = {
                lintCommand = "shellcheck -f gcc -x",
                lintSource = "shellcheck",
                lintFormats = {
                    "%f:%l:%c: %trror: %m",
                    "%f:%l:%c: %tarning: %m",
                    "%f:%l:%c: %tote: %m",
                },
            },
            shfmt = {
                formatCommand = "shfmt -ci -s -bn",
                formatStdin = true,
            },
            phpstan = {
                lintCommand = "composer exec phpstan analyze --error-format raw --no-progress",
            },
            psalm = {
                lintCommand = "composer exec psalm --output-format=emacs --no-progress",
                lintFormats = {
                    "%f:%l:%c:%trror - %m",
                    "%f:%l:%c:%tarning - %m",
                },
            },
        }
        local languages = {
            javascript         = { tools.prettier, tools.eslint },
            javascriptreact    = { tools.prettier, tools.eslint },
            ["javascript.jsx"] = { tools.prettier, tools.eslint },
            typescript         = { tools.prettier, tools.eslint },
            typescriptreact    = { tools.prettier, tools.eslint },
            ["typescript.jsx"] = { tools.prettier, tools.eslint },
            css                = { tools.prettier },
            scss               = { tools.prettier },
            less               = { tools.prettier },
            json               = { tools.prettier },
            yaml               = { tools.prettier },
            markdown           = { tools.prettier },
            graphql            = { tools.prettier },
            html               = { tools.prettier },
            vue                = { tools.prettier },
            svelte             = { tools.prettier },
            sh                 = { tools.shellcheck, tools.shfmt },
            lua                = { tools.lua_format },
        }
        local filetypes = {}
        for lang, _ in pairs(languages) do
            table.insert(filetypes, lang)
        end
        lspconfig.efm.setup {
            init_options = {
                documentFormatting = true,
            },
            settings = {
                rootMarkers = { ".git/" },
                lintDebounce = 1000,
                languages = languages,
            },
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
            filetypes = filetypes,
        }

        --
        -- gopls settings
        --
        lspconfig.gopls.setup {
            cmd = {
                "gopls",
                "serve",
            },
            init_options = {
                completeUnimported = true,
                -- usePlaceholders = true,
                -- ExperimentalPostfixCompletions = true,
                -- LinksInHover = true,
                -- staticcheck = true,
                -- gofumpt = true,
                -- analyses = {
                    -- unusedparams = true,
                -- },
                -- codelenses = {
                    -- generate = true,
                    -- test = true,
                -- },
            },
            root_dir = root_pattern("go.mod"),
            on_attach = with_organize_imports(on_attach, "_G.gopls_organize_imports"),
            capabilities = make_snippet_capabilities(),
        }

        _G.gopls_organize_imports = function(bufnr)
            if not bufnr then
                bufnr = vim.api.nvim_get_current_buf()
            end

            local params = vim.lsp.util.make_range_params()
            params.context = {
                only = { "source.organizeImports" },
            }
            local res = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 500)
            for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit)
                    else
                        vim.lsp.buf.execute_command(r.command)
                    end
                end
            end
        end

        --
        -- html settings
        --
        lspconfig.html.setup {
            on_attach = no_format(on_attach),
            capabilities = make_snippet_capabilities(),
        }

        --
        -- jsonls settings
        --
        lspconfig.jsonls.setup {
            commands = {
                Format = {
                    function()
                        vim.lsp.buf.range_formatting({}, { 0,0 }, { vim.fn.line("$"), 0 })
                    end
                },
            },
            on_attach = no_format(on_attach),
            capabilities = make_snippet_capabilities(),
        }

        --
        -- perlpls settings
        --
        lspconfig.perlpls.setup {
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        --
        -- phpactor settings
        --
        lspconfig.phpactor.setup {
            cmd = {
                "composer",
                "exec",
                "phpactor",
                "--",
                "language-server",
            },
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        --
        -- prismals settings
        --
        lspconfig.prismals.setup {
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        vim.cmd [[
        augroup prisma-filetype
            autocmd!
            autocmd BufReadPost *.schema,*.prisma set filetype=prisma
        augroup end
        ]]

        --
        -- rust_analyzer settings
        --
        lspconfig.rust_analyzer.setup {
            cmd = {
                "rustup",
                "run",
                "nightly",
                "rust-analyzer",
            },
            root_dir = root_pattern("Cargo.toml", "rust-project.json"),
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
            flags = { debounce_text_changes = 150 },
        }

        vim.cmd [[
        augroup rust-inlay-hints
            autocmd!
            autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require"lsp_extensions".inlay_hints {
                \ prefix = "",
                \ aligned = false,
                \ only_current_line = false,
                \ highlight = "Comment",
                \ enabled = { "TypeHint", "ChainingHint", "ParameterHint" },
                \ }
        augroup end
        ]]

        --
        -- texlab settings
        --
        lspconfig.texlab.setup {
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

        --
        -- tsserver settings
        --
        lspconfig.tsserver.setup {
            on_attach = with_organize_imports(no_format(on_attach), "_G.tsserver_organize_imports"),
            capabilities = make_snippet_capabilities(),
            flags = { debounce_text_changes = 150 },
        }

        _G.tsserver_organize_imports = function(bufnr)
            if not bufnr then
                bufnr = vim.api.nvim_get_current_buf()
            end

            local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(bufnr) },
                title = "",
            }
            vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 500)
        end

        --
        -- vimls settings
        --
        lspconfig.vimls.setup {
            on_attach = on_attach,
            capabilities = make_snippet_capabilities(),
        }

HERE
endif

" nvim-cmp ...............................................................{{{1
" See https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt
" also https://github.com/hrsh7th/cmp-nvim-lsp
"      https://github.com/hrsh7th/cmp-buffer
"      https://github.com/hrsh7th/cmp-cmdline
"      https://github.com/hrsh7th/cmp-path
"      https://github.com/saadparwaiz1/cmp_luasnip

if has_key(plugs, 'nvim-cmp')
    lua <<HERE
        local cmp = require"cmp"
        local luasnip = require"luasnip"

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            mapping = {
                ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<C-b>"]     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                ["<C-f>"]     = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(),      { 'i', 'c' }),
                ["<C-y>"]     = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                ["<C-e>"]     = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
            },

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            })
        }

        cmp.setup.cmdline("/", {
            sources = {
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(":", {
            sources = cmp.config.sources({
                { name = "path" }
            }, {
                { name = "cmdline" }
            })
        })
HERE
endif

" Trouble settings .......................................................{{{1
" See https://github.com/folke/trouble.nvim

if has_key(plugs, 'trouble.nvim')
    lua <<HERE
        require"trouble".setup {
            height = 13,
            indent_lines = true,
            action_keys = {
                close = {},
            },
        }
HERE

    augroup trouble-bindings
        autocmd!
        autocmd Filetype Trouble nnoremap <buffer> q :wincmd p<Bar>TroubleClose<CR>
    augroup end
endif

" Lightline settings .....................................................{{{1
" See https://github.com/itchyny/lightline.vim/blob/master/doc/lightline.txt

if has_key(plugs, 'lightline.vim')
    let g:lightline = {
        \     'colorscheme': 'one',
        \     'active': {
        \         'left': [
        \             ['mode', 'paste'],
        \             ['readonly', 'relativepath', 'gutentags'],
        \             ['gitbranch'],
        \         ],
        \         'right': [
        \             ['percent'],
        \             ['fileformat', 'fileencoding', 'filetype'],
        \             ['lineinfo'],
        \             ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
        \         ],
        \     },
        \     'inactive': {
        \         'left': [
        \             [],
        \             ['filename'],
        \         ],
        \         'right': [
        \             [],
        \             ['percent'],
        \             ['lineinfo'],
        \         ],
        \     },
        \     'tab': {
        \         'active':   ['tabtitle_active'],
        \         'inactive': ['tabtitle_inactive'],
        \     },
        \     'tabline': {
        \         'right': [[]],
        \     },
        \     'component_function': {
        \         'mode':         'LightlineMode',
        \         'readonly':     'LightlineReadonly',
        \         'filename':     'LightlineFilename',
        \         'relativepath': 'LightlineRelativePath',
        \         'fileformat':   'LightlineFileformat',
        \         'fileencoding': 'LightlineFileencoding',
        \         'filetype':     'LightlineFiletype',
        \         'gitbranch':    'LightlineGitBranch',
        \         'gitdiffs':     'LightlineGitStatus',
        \         'gutentags':    'gutentags#statusline',
        \     },
        \     'component_type': {
        \         'linter_checking': 'right',
        \         'linter_infos':    'right',
        \         'linter_warnings': 'warning',
        \         'linter_errors':   'error',
        \         'linter_ok':       'right',
        \     },
        \     'tab_component_function': {
        \         'tabtitle_active':   'LightlineActiveTab',
        \         'tabtitle_inactive': 'LightlineInactiveTab',
        \     },
        \ }

    augroup refresh-lightline
        autocmd!
        autocmd User GutentagsUpdating,GutentagsUpdated call lightline#update()
    augroup end

    set noshowmode " Current mode is already shown in lightline.

    fun! s:CurrentMode() abort
        " TODO: Use active buffer from tab with getbufvar(x, '&ft').
        let fname = expand('%:t')
        return &ft ==# 'fzf' ? 'FZF'
            \ : &ft ==# 'nerdtree' ? 'NERDTree'
            \ : &ft ==# 'fern' ? 'Fern'
            \ : &ft ==# 'nuake' ? 'Nuake'
            \ : &ft ==# 'ctrlsf' ? 'CtrlSF'
            \ : ''
    endfun

    fun! LightlineMode() abort
        let cmode = s:CurrentMode()
        return empty(cmode)
            \ ? winwidth(0) > 60 ? lightline#mode() : ''
            \ : cmode
    endfun

    fun! LightlineReadonly() abort
        return &ft !=# 'help' && &readonly && empty(s:CurrentMode())
            \ ? 'RO'
            \ : ''
    endfun

    fun! LightlineRelativePath() abort
        let fname = expand('%:~')
        return empty(s:CurrentMode())
            \ ? !empty(fname) ? fname : '[No Name]'
            \ : ''
    endfun

    fun! LightlineFilename() abort
        let cmode = s:CurrentMode()
        let fname = expand('%:t')
        return empty(cmode)
            \ ? !empty(fname) ? fname : '[No Name]'
            \ : cmode
    endfun

    fun! LightlineFileformat() abort
        let et = &et ? 'sp' : 'tb'
        return winwidth(0) > 70 && empty(s:CurrentMode())
            \ ? printf('%s %s%s%s',
            \     &fileformat,
            \     &sw,
            \     et,
            \     &sw != &ts ? printf("%d", &ts) : ''
            \ ) : ''
    endfun

    fun! LightlineFileencoding()
        return winwidth(0) > 70 && empty(s:CurrentMode())
            \ ? (&fenc !=# '' ? &fenc : &enc)
            \ : ''
    endfun

    fun! LightlineFiletype() abort
        return winwidth(0) > 70 && empty(s:CurrentMode())
            \ ? (&filetype !=# '' ? 'ft: ' . &filetype : 'no ft')
            \ : ''
    endfun

    fun! LightlineGitBranch() abort
        if !exists('*FugitiveHead')
            return ''
        endif
        let branch = FugitiveHead()
        return !empty(branch)
            \ ? printf('%s %s', nr2char(0xe0a0), branch)
            \ : ''
    endfun

    fun! LightlineGitStatus() abort
        if !exists('GitGutterGetHunkSummary')
            return ''
        endif
        let [a,m,r] = GitGutterGetHunkSummary()
        return printf('+%d ~%d -%d', a, m, r)
    endfun

    fun! LightlineActiveTab(index) abort
        return LightlineTabTitle(a:index, v:true)
    endfun

    fun! LightlineInactiveTab(index) abort
        return LightlineTabTitle(a:index, v:false)
    endfun

    fun! LightlineTabTitle(index, active) abort
        let filename = lightline#tab#filename(a:index)
        let cmode = s:CurrentMode()
        let extra = 0
        if empty(cmode) || !a:active
            let dirty = lightline#tab#modified(a:index)
            if !empty(dirty)
                let filename = filename . ' ' . dirty
                let extra = 1
            endif
        else
            let filename = cmode
        endif

        " Don't switch between file and wd thus return here.
        let wd = fnamemodify(getcwd(-1, a:index), ':~:t')
        let suffix = !empty(wd) ? ' - ' . wd : ''
        return printf('%d %s%s', lightline#tab#tabnum(a:index), filename, suffix)

        let wd = '❨' . fnamemodify(getcwd(-1, a:index), ':~:t') . '❩'
        if a:active
            let front = filename
            let back = wd
        else
            let front = wd
            let back = filename
        endif

        let diff = max([strchars(back) - strchars(front), 0])
        let left = float2nr(ceil(diff / 2))
        let right = left + and(diff, 1)
        if extra > 0 && right > 0
            let left += extra
            let right -= extra
        endif

        return printf('%s%d %s%s',
            \ repeat(' ', left),
            \ lightline#tab#tabnum(a:index),
            \ front,
            \ repeat(' ', right))
    endfun
endif

" NERDTree settings ......................................................{{{1
" See https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt

if has_key(plugs, 'nerdtree')
    let g:NERDTreeHijackNetrw         = 0   " Don't replace Netrw.
    let g:NERDTreeStatusline          = -1  " Don't set the statusline.
    let g:NERDTreeChDirMode           = 1   " Set cwd only when passing an argument.
    let g:NERDTreeUseTCD              = 1   " Switch cwd local to tab.
    let g:NERDTreeShowHidden          = 1   " Initially show hidden files.
    let g:NERDTreeRespectWildIgnore   = 1   " But hide files like in wildmenu.
    let g:NERDTreeNaturalSort         = 1   " Sort in a natural order.
    let g:NERDTreeMinimalUI           = 1   " Hide clutter.
    let g:NERDTreeQuitOnOpen          = 2   " Hide bookmarks after opening one.
    let g:NERDTreeWinSize             = 33
    let g:NERDTreeDirArrowExpandable  = '' " Or ▸ or ▷.
    let g:NERDTreeDirArrowCollapsible = '' " Or ▾ or ◢.

    let g:NERDTreeMapActivateNode     = 'l'
    let g:NERDTreeMapCloseDir         = 'h'
    let g:NERDTreeMapUpdir            = '<BS>'
    let g:NERDTreeMapChangeRoot       = '<CR>'
    let g:NERDTreeMapCustomOpen       = ''

    let g:NERDTreeCustomOpenArgs = {
        \     'file': {
        \         'reuse': 'currenttab',
        \         'where': 'p',
        \         'keepopen': '0',
        \         'stay': '0',
        \     },
        \ }

    augroup autoclose-if-last-standing
        autocmd!
        autocmd BufEnter *
            \ if tabpagewinnr(tabpagenr(), '$') == 1
            \     && exists('b:NERDTree')
            \     && b:NERDTree.isTabTree()  |
            \     call <SID>DelayedQuit(100) |
            \ endif
    augroup end

    " Skip NERDTree when switching windows.
    nnoremap <silent> <C-w><C-w> <C-w>w:<C-r>=(&ft ==# 'nerdtree') ? "wincmd w" : ""<CR><CR>

    augroup nerdtree-bindings
        autocmd!
        autocmd Filetype nerdtree nnoremap <buffer> <ESC> <C-w>p
        autocmd Filetype nerdtree nmap     <buffer> <leader><leader> q<leader><leader>
        autocmd Filetype nerdtree nmap     <buffer> <C-h> <BS>
    augroup end
endif

" nerdtree-git-plugin settings ...........................................{{{1
" See https://github.com/Xuyuanp/nerdtree-git-plugin

if has_key(plugs, 'nerdtree-git-plugin')
    let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ 'Modified'  : 'm',
        \ 'Staged'    : 's',
        \ 'Untracked' : 'u',
        \ 'Renamed'   : 'r',
        \ 'Unmerged'  : '═',
        \ 'Deleted'   : 'd',
        \ 'Dirty'     : '*',
        \ 'Clean'     : '✔︎',
        \ 'Ignored'   : '!',
        \ 'Unknown'   : '?',
        \ }
endif

" Nuake settings .........................................................{{{1
" See https://github.com/Lenovsky/nuake/blob/master/doc/nuake.txt

if has_key(plugs, 'nuake')
    let g:nuake_per_tab = 1    " Give every tab its own terminal.
    let g:nuake_size    = 0.35
endif

" Fern settings ..........................................................{{{1
" See https://github.com/lambdalisue/fern.vim/blob/master/doc/fern.txt

if has_key(plugs, 'fern.vim')
    let g:fern#default_hidden                               = 1
    let g:fern#default_exclude                              = 'node_modules'
    let g:fern#renderer                                     = 'nerdfont'
    let g:fern#renderer#nerdfont#leading                    = '│  '
    let g:fern#renderer#nerdfont#padding                    = ' '
    let g:fern#hide_cursor                                  = 1
    let g:fern#keepalt_on_edit                              = 1
    let g:fern#scheme#file#show_absolute_path_on_root_label = 1

    "let g:fern_git_status#disable_ignored     = 1
    "let g:fern_git_status#disable_untracked   = 1
    "let g:fern_git_status#disable_submodules  = 1
    "let g:fern_git_status#disable_directories = 1

    fun! s:apply_fern_bindings() abort
        nmap <buffer> <C-h>
            \ <Plug>(fern-action-leave)
            \ <Plug>(fern-wait)
            \ <Plug>(fern-action-tcd:root)

        nmap <buffer> <CR>
            \ <Plug>(fern-action-open-or-enter)
            \ <Plug>(fern-wait)
            \ <Plug>(fern-action-tcd:root)

        nmap <silent> <buffer>        p     <Plug>(fern-action-preview:auto:toggle)
        nmap <silent> <buffer> <expr> <C-d> fern_preview#smart_preview("\<Plug>(fern-action-preview:scroll:down:half)", "\<C-d>")
        nmap <silent> <buffer> <expr> <C-u> fern_preview#smart_preview("\<Plug>(fern-action-preview:scroll:up:half)",   "\<C-u>")
        nmap <silent> <buffer>        r     <Plug>(fern-action-reload)
        nmap <silent> <buffer>        fg    <Plug>(fern-action-grep)
    endfun

    augroup fern-bindings
        autocmd!
        autocmd FileType fern call <SID>apply_fern_bindings()
    augroup end
endif

if has_key(plugs, 'glyph-palette.vim')
    augroup glyph-palette
        autocmd!
        autocmd FileType nerdtree,fern call glyph_palette#apply()
    augroup end
endif

" Vim settings ...........................................................{{{1

" Neovim's defaults.
if !has('nvim')
    if &compatible
        set nocompatible            " Enable improved mode.
    endif
    set encoding=utf-8              " Set default encoding.
    syntax on                       " Syntax highlighting.
    filetype plugin indent on       " Automatically detect file types.

    set autoindent                  " Indent at the same level of the previous line.
    set autoread                    " Automatically read a file changed outside of vim.
    set backspace=indent,eol,start  " Allow backspacing over everything.
    set complete-=i                 " Exclude files completion.
    set cscopeverbose               " Print messages when adding cscope dbs.
    set display+=lastline           " Show as much as possible of the last line.
    set formatoptions+=j            " Delete comment character when joining commented lines.
    set history=2000                " Maximum history records kept.
    set hlsearch                    " Highlight search matches.
    set incsearch                   " Match whilst typing when searching.
    set laststatus=2                " Always show status line.
    set nofsync                     " Don't call fsync after writes.
    set nrformats-=octal            " Ignore octal numbers for Ctrl-A and Ctrl-X.
    set ruler                       " Always show the cursor position.
    set sessionoptions-=options     " Don't save options in sessions.
    set shortmess+=F                " Don't show file info when editing a file.
    set shortmess-=S                " Show search count.
    set showcmd                     " Display incomplete commands.
    set sidescroll=1                " Scroll that many chars to the sides.
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
    set viminfo+=!                  " Include global vars.
    set wildmenu                    " Show list instead of just completing.
    set wildoptions=tagfile

    set belloff=all                 " Disable all bells.
    set ttyfast                     " Faster redrawing.
    set ttymouse=xterm2             " Use extended mouse-support.
    if has('langmap') && exists('+langremap')
        set nolangremap             " Ignore langmap for chars resulting from mappings.
    endif

    set nostartofline               " Preserve columns for various moves.
    set sessionoptions+=unix,slash  " Save with unix' line endings and path separators.
    set viewoptions+=unix,slash     " Save with unix' line endings and path separators.
    let g:vimsyn_embed = "l"
endif

set mouse=a                         " Enable mouse-support.
set virtualedit+=all                " Enable putting the cursor anywhere.
set timeoutlen=750                  " Time out on mappings.
set ttimeout                        " Time out on Escape after...
set ttimeoutlen=100                 " ...waiting this many ms for a special key.
set clipboard=unnamed               " Share clipboard with system.
if has('unnamedplus')
    set clipboard^=unnamedplus
endif

set autowriteall                    " Autosave when navigating between buffers.
set hidden                          " Enable unwritten buffers in background.
set confirm                         " Show dialog when closing with unwritten buffers.
if has('nvim') || has('patch-8.1.2315')
    set switchbuf+=uselast          " Use same window when opening quickfix results.
endif
set switchbuf+=useopen              " Or windows having the file already opened.
set swapfile                        " Don't directly write to files.
set directory=$HOME/.vim/swap//     " Save swap files in a folder.
set updatetime=250                  " Write swap file after this time (effects signcolumn).
set undofile                        " Enable persistent undos.
set undodir=$HOME/.vim/undo         " Save undos in a folder.
set undolevels=2000                 " Increase possible undos.
set sessionoptions-=tabpages        " Only save the current tab in sessions.
set fileformats=unix,dos,mac        " Use Unix as the standard file type.

set completeopt+=menuone            " Show even if only one match.
set completeopt+=noselect           " No automatic selection.
set completeopt+=noinsert           " Only insert on confirmation.
set completeopt+=preview            " Show extra information in preview window.
if has('vim')
    set completeopt+=popup          " Show extra information in a popup window.
elseif has('nvim')
    set diffopt+=algorithm:histogram " Use a different diff-algo.
    set pumblend=5                  " Transparency for popup menus.
    set winblend=5                  " Transparency for floating windows.
endif
set diffopt+=iwhite                 " Ignore amount of whitespace.
set diffopt+=indent-heuristic

set ignorecase                      " Ignore case when searching...
set smartcase                       " ...unless we type a capital.
set noinfercase                     " Don't adjust case of auto-completed matches.
set wildignorecase                  " Ignore case when completing filenames.
if has('nvim')
    set inccommand=nosplit          " Match whilst typing when substituting.
    set jumpoptions=stack           " When jumping discard any later entries.
endif

set redrawtime=1500
set cmdheight=2                     " Give command-line more space.
set colorcolumn=80                  " List of highlighted columns.
set cursorline                      " Highlight current line.
set nolazyredraw                    " Redraw whilst executing macros.
set matchtime=2                     " Duration for showing matching pairs after typing.
set pumheight=12                    " Maximum number of items in popup menu.
set nonumber                        " Show no absolute line numbers.
set norelativenumber                " And no relative numbers.
set shortmess+=c                    " Don't show completion messages.
set shortmess-=l                    " Use "lines, bytes" instead of "L, B".
set showmatch                       " Highlight matching [{()}].
set showtabline=2                   " Always show tabs.
set signcolumn=auto                 " Auto-hide sign-column.
set splitbelow                      " HSplit to the bottom.
set splitright                      " VSplit to the right.

set foldenable
set foldlevelstart=1                " Automatically open only the first level of folds.
set foldmethod=marker
set list                            " Show tabs, spaces, etc.
set listchars+=tab:\|\ ,space:·     " Use these for hidden characters.
set listchars+=trail:\ ,nbsp:␣
set listchars+=extends:↷,precedes:↶
set nowrap                          " Don't fit lines to the window's width.
set showbreak=\ ↪                   " Start wrapped lines with this.
set scrolloff=10                    " Begin scrolling up and down earlier.
set sidescrolloff=6                 " Begin scrolling sideways earlier.
set wrapmargin=0                    " Wrap in chars-to-the-right if textwidth is 0.

set breakindent                     " Continue wrapped lines' indentation.
set breakindentopt=sbr              " Use showbreak.
set copyindent                      " Continue with same indentation.
set fillchars+=fold:\ ,vert:│       " Use these characters for special areas.
set fillchars+=stl:\ ,stlnc:\ ,diff:⣿
set nopreserveindent                " Reconstruct indentation upon changing.
set smartindent                     " Indent C-like languages.

set expandtab                       " Use spaces instead of tab.
set nosmarttab                      " Don't mix tabs with spaces.
set shiftwidth=4                    " Use indents of 4 spaces.
set softtabstop=4                   " Let backspace delete indent.
set tabstop=4                       " A tab counts for so many spaces.

set wildcharm=<C-z>                 " Used to trigger auto completion in macros.
set wildignore+=*.DS_Store          " Ignore these for auto completion.
set wildignore+=*.swp
set wildignore+=*.zip
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=.git/*
set wildignore+=.svn/*
set wildignore+=.hg/*
set wildignore+=CVS/*
set wildignore+=*/tmp/*
set wildignore+=node_modules/*
set wildignore+=*~
set wildignore+=*.so
set wildignore+=*.o
set wildignore+=*.obj
set wildignore+=*.exe
set wildignore+=*.class
set wildignore+=*.pyc

" Color scheme ...........................................................{{{1

set guifont=Fira\ Code\ Light\ Nerd\ Font\ Complete\ Mono:h12
set guicursor=a:block-blinkwait1000-blinkon500-blinkoff500,i-ci:hor15

set background=light

if has('termguicolors')
    set termguicolors               " Use guifg and guibg.
endif
if &term =~ '256color'
    set t_Co=256                    " Indicate number of colors.
    set t_ut=                       " Disable Background Color Erase.
endif

" See https://github.com/norcalli/nvim-colorizer.lua
if has_key(plugs, 'nvim-colorizer.lua')
    lua <<HERE
        require"colorizer".setup {
            ['*'] = {
                RGB      = true,
                RRGGBB   = true,
                names    = true,
                RRGGBBAA = true,
            },
            html = { css = true },
            css  = { css = true },
        }
HERE
endif

if exists("g:loaded_webdevicons")
    call webdevicons#refresh()
endif

" See https://github.com/chrisbra/matchit/blob/master/doc/matchit.txt
packadd! matchit
