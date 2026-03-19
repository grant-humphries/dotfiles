set encoding=utf-8
scriptencoding utf-8

call plug#begin('~/.vim/plugged')

" plug-ins
Plug 'sainnhe/everforest'
Plug 'ntpeters/vim-better-whitespace'

call plug#end()

" Active everforest color scheme if plugin exists
if isdirectory(expand('~/.vim/plugged/everforest'))
    set background=dark

    if has('termguicolors')
        set termguicolors
    endif

    colorscheme everforest
endif

" set tabs to four spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" make backspace behave in standard fashion in insert mode
set backspace=indent,eol,start

" show whitespace characters
set listchars=space:·,tab:»-,
set list

" strip trailing whitespace on save (uses vim-better-whitespace plugin)
autocmd BufEnter * EnableStripWhitespaceOnSave

" ensure vim with not litter home/project directories
set backup
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

" Set up spell checking
function! s:setup_spell_check() abort
    " enable spell checking
    setlocal spell
    setlocal spelllang=en_us

    " highlight misspelled words
    highlight clear SpellBad
    highlight SpellBad cterm=underline ctermfg=Red guifg=Red gui=undercurl
endfunction

" Apply settings only to gitcommit filetype
autocmd FileType gitcommit call s:setup_spell_check()
