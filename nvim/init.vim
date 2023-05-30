"###################################################################################################
"                                 _
"  _ __     ___    ___   __   __ (_)  _ __ ___
" | '_ \   / _ \  / _ \  \ \ / / | | | '_ ` _ \
" | | | | |  __/ | (_) |  \ V /  | | | | | | | |
" |_| |_|  \___|  \___/    \_/   |_| |_| |_| |_|
"
" neovim configuration file
"###################################################################################################
" set script encoding
scriptencoding utf8

"###################################################################################################
" PLUGINS
" managed using vim-plug
"###################################################################################################
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" List starts here

" Ale
" https://github.com/dense-analysis/ale
" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
" List of languages
" https://github.com/dense-analysis/ale/blob/master/supported-tools.md
Plug 'dense-analysis/ale'

" Indent Guides
" https://github.com/nathanaelkane/vim-indent-guides
" A Vim plugin for visually displaying indent levels in code
Plug 'nathanaelkane/vim-indent-guides'

" DelimitMate
" https://github.com/Raimondi/delimitMate
" Vim plugin, provides insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'raimondi/delimitmate'

" vim-go
" https://github.com/fatih/vim-go
" Go development plugin for Vim
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" vim-surround
" https://github.com/tpope/vim-surround
" surround.vim: Delete/change/add parentheses/quotes/XML-tags/much more with ease 
Plug 'tpope/vim-surround'

" nvim-treesitter
" Nvim Treesitter configurations and abstraction layer
" List of supported languages https://github.com/nvim-treesitter/nvim-treesitter/tree/master#supported-languages
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" vim-nightfly-colors
" A dark midnight theme for modern Neovim & classic Vim 
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }

" vim-moonfly-colors
" A dark charcoal theme for modern Neovim & classic Vim 
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }

" List ends here
call plug#end()

"###################################################################################################
" PLUGIN SETTINGS
"###################################################################################################
" Vim-Indent-Guides
let g:indent_guides_enable_on_vim_startup = 1

"################################################
" ALE SETTINGS
"################################################
" lint on opening file
let g:ale_lint_on_enter = 1

" enable ALE completion
let g:ale_completion_enabled = 1

" set fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace','prettier'],
\   'go': ['gofmt'],
\   'sh': ['shfmt'],
\   'markdown': ['pandoc'],
\}

" set linters
let g:ale_linters = {
\   '*': ['prettier'],
\   'go': ['gopls'],
\   'sh': ['bashate'],
\}

" enable hovering
"let g:ale_hover_cursor = 1
"let g:ale_set_balloons = 1
"let g:ale_cursor_detail = 1

" function for counting number of erros in buffer, used in statusline
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" custom ALE commands
command Alint ALELint
command Afix ALEFix
command Agoto ALEGoToDefinition

" go to next error
nmap <silent> <C-e> <Plug>(ale_next_wrap)
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)

"################################################
" TREESITTER SETTINGS
"################################################
" Use inline lua here to set treesitter options
" TODO Surely i will port my config to lua someday
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

"###################################################################################################
" CUSTOM STATUSLINE
"###################################################################################################
set statusline=                                 " Clear line
set statusline+=\--\                            " Divider
set statusline+=%r                              " Display read only
set statusline+=\ %F                            " Full Path to file
set statusline+=\ %m                            " Display modified flag

set statusline+=\ --\                           " Divider
set statusline+=%=
set statusline+=\ %{LinterStatus()}
set statusline+=%*                              "

set statusline+=%=                              " Seperate left and right part of line

set statusline+=\ [Enc:%{&fenc}]                " Display file encoding
set statusline+=\ [Format:%{&ff}]               " Display file format
set statusline+=\ --\                           " Divider
set statusline+=\ Pos:%c                       " Display current line number
set statusline+=\ Line:%l                       " Display current line number
set statusline+=\/%L                      " Display total number of lines
set statusline+=\ --\                           " Divider

"###################################################################################################
" CUSTOM SETTINGS
"###################################################################################################
" system clipboard (requires +clipboard)
set clipboard^=unnamed,unnamedplus
set modeline          " enable vim modelines
set hlsearch          " highlight search items
set incsearch         " searches are performed as you type
set number            " enable line numbers
set rnu               " Enable relative line numbering
set confirm           " ask confirmation like save before quit.
set wildmenu          " Tab completion menu when using command mode
set expandtab         " Tab key inserts spaces not tabs
set softtabstop=4     " spaces to enter for each tab
set shiftwidth=4      " amount of spaces for indentation
set shortmess+=aAcIws " Hide or shorten certain messages
set showmode          " Show current mode vim is in
set colorcolumn=+1
set textwidth=100

" map leader to ,
let g:mapleader = ","

" set colorscheme
" colorscheme meitnerium
colorscheme moonfly

" enable filetype specific plugins
filetype plugin on

" enable syntax highlighting
syntax enable

"###################################################################################################
" SPELL CHECKER SETTINGS
"###################################################################################################
" enable spellcheck for language DE or EN
" use z= to check for correction
command SpellDE setlocal spell spelllang=de
command SpellEN setlocal spell spelllang=en

hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal

hi SpellBad cterm=underline, ctermfg=red
hi SpellCap cterm=underline, ctermfg=yellow
hi SpellRare cterm=underline, ctermfg=green
hi SpellLocal cterm=underline, ctermfg=grey

"###################################################################################################
" settings i have not checked yet and idk what they do
"###################################################################################################
" local keyword jump
nnoremap <Leader>fw
    \ [I:let b:jump = input('Go To: ') <Bar>
    \ if b:jump !=? '' <Bar>
    \   execute "normal! ".b:jump."[\t" <Bar>
    \   unlet b:jump <Bar>
    \ endif <CR>


" quit the current buffer and switch to the next
" without this vim will leave you on an empty buffer after quiting the current
function! <SID>quitbuffer() abort
    let l:bf = bufnr('%')
    let l:pb = bufnr('#')
    if buflisted(l:pb)
        buffer #
    else
        bnext
    endif
    if bufnr('%') == l:bf
        new
    endif
    if buflisted(l:bf)
        execute('bdelete! ' . l:bf)
    endif
endfunction

" switch active buffer based on pattern matching
" if more than one match is found then list the matches to choose from
function! <SID>bufferselect(pattern) abort
    let l:bufcount = bufnr('$')
    let l:currbufnr = 1
    let l:nummatches = 0
    let l:matchingbufnr = 0
    " walk the buffer count
    while l:currbufnr <= l:bufcount
        if (bufexists(l:currbufnr))
            let l:currbufname = bufname(l:currbufnr)
            if (match(l:currbufname, a:pattern) > -1)
                echo l:currbufnr.': '.bufname(l:currbufnr)
                let l:nummatches += 1
                let l:matchingbufnr = l:currbufnr
            endif
        endif
        let l:currbufnr += 1
    endwhile

    " only one match
    if (l:nummatches == 1)
        execute ':buffer '.l:matchingbufnr
    elseif (l:nummatches > 1)
        " more than one match
        let l:desiredbufnr = input('Enter buffer number: ')
        if (strlen(l:desiredbufnr) != 0)
            execute ':buffer '.l:desiredbufnr
        endif
    else
        echoerr 'No matching buffers'
    endif
endfunction
