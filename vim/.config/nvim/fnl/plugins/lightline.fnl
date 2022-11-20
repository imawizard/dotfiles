(import-macros {: use!} :macros)

(use!
 ;; See :help lightline.txt.
 {:config
  (fn []
    (vim.cmd "
    let g:lightline = {
        \\   'colorscheme': 'one',
        \\   'active': {
        \\     'left': [
        \\       ['mode', 'paste'],
        \\       ['readonly', 'relativepath', 'gutentags'],
        \\       ['gitbranch'],
        \\     ],
        \\     'right': [
        \\       ['percent'],
        \\       ['fileformat', 'fileencoding', 'filetype'],
        \\       ['lineinfo'],
        \\       ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
        \\     ],
        \\   },
        \\   'inactive': {
        \\     'left': [
        \\       [],
        \\       ['filename'],
        \\     ],
        \\     'right': [
        \\       [],
        \\       ['percent'],
        \\       ['lineinfo'],
        \\     ],
        \\   },
        \\   'tab': {
        \\     'active':   ['tabtitle_active'],
        \\     'inactive': ['tabtitle_inactive'],
        \\   },
        \\   'tabline': {
        \\     'right': [[]],
        \\   },
        \\   'component_function': {
        \\     'mode':         'LightlineMode',
        \\     'readonly':     'LightlineReadonly',
        \\     'filename':     'LightlineFilename',
        \\     'relativepath': 'LightlineRelativePath',
        \\     'fileformat':   'LightlineFileformat',
        \\     'fileencoding': 'LightlineFileencoding',
        \\     'filetype':     'LightlineFiletype',
        \\     'gitbranch':    'LightlineGitBranch',
        \\     'gitdiffs':     'LightlineGitStatus',
        \\     'gutentags':    'gutentags#statusline',
        \\   },
        \\   'component_type': {
        \\     'linter_checking': 'right',
        \\     'linter_infos':    'right',
        \\     'linter_warnings': 'warning',
        \\     'linter_errors':   'error',
        \\     'linter_ok':       'right',
        \\   },
        \\   'tab_component_function': {
        \\     'tabtitle_active':   'LightlineActiveTab',
        \\     'tabtitle_inactive': 'LightlineInactiveTab',
        \\   },
        \\ }

    augroup refresh-lightline
        autocmd!
        autocmd User GutentagsUpdating,GutentagsUpdated call lightline#update()
    augroup end

    set noshowmode \" Current mode is already shown in lightline.

    fun! CurrentMode() abort
        return &ft ==# 'fzf' ? 'FZF'
            \\ : &ft ==# 'nerdtree' ? 'NERDTree'
            \\ : &ft ==# 'fern' ? 'Fern'
            \\ : &ft ==# 'nuake' ? 'Nuake'
            \\ : &ft ==# 'ctrlsf' ? 'CtrlSF'
            \\ : ''
    endfun

    fun! LightlineMode() abort
        let cmode = CurrentMode()
        return empty(cmode)
            \\ ? winwidth(0) > 60 ? lightline#mode() : ''
            \\ : cmode
    endfun

    fun! LightlineReadonly() abort
        return &ft !=# 'help' && &readonly && empty(CurrentMode())
            \\ ? 'RO'
            \\ : ''
    endfun

    fun! LightlineRelativePath() abort
        let fname = expand('%:~')
        return empty(CurrentMode())
            \\ ? !empty(fname) ? fname : '[No Name]'
            \\ : ''
    endfun

    fun! LightlineFilename() abort
        let cmode = CurrentMode()
        let fname = expand('%:t')
        return empty(cmode)
            \\ ? !empty(fname) ? fname : '[No Name]'
            \\ : cmode
    endfun

    fun! LightlineFileformat() abort
        let et = &et ? 'sp' : 'tb'
        return winwidth(0) > 70 && empty(CurrentMode())
            \\ ? printf('%s %s%s%s',
            \\     &fileformat,
            \\     &sw,
            \\     et,
            \\     &sw != &ts ? printf(\"%d\", &ts) : ''
            \\ ) : ''
    endfun

    fun! LightlineFileencoding()
        return winwidth(0) > 70 && empty(CurrentMode())
            \\ ? (&fenc !=# '' ? &fenc : &enc)
            \\ : ''
    endfun

    fun! LightlineFiletype() abort
        return winwidth(0) > 70 && empty(CurrentMode())
            \\ ? (&filetype !=# '' ? 'ft: ' . &filetype : 'no ft')
            \\ : ''
    endfun

    fun! LightlineGitBranch() abort
        if !exists('*FugitiveHead')
            return ''
        endif
        let branch = FugitiveHead()
        return !empty(branch)
            \\ ? printf('%s %s', nr2char(0xe0a0), branch)
            \\ : ''
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
        let cmode = CurrentMode()
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

        let wd = fnamemodify(getcwd(-1, a:index), ':~:t')
        let suffix = !empty(wd) ? ' - ' . wd : ''
        return printf('%d %s%s',
            \\ lightline#tab#tabnum(a:index),
            \\ filename,
            \\ suffix)
    endfun
    "))} :itchyny/lightline.vim)
