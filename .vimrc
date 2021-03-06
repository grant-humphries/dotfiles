set encoding=utf-8
scriptencoding utf-8

" pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()
syntax enable

" enable file type detection and wrap lines at particular widths based
" on the file type
filetype plugin indent on

" color scheme
set background=dark
let g:solarized_visibility="low"

if $TERM == 'xterm-256color'
    let g:solarized_termcolors=256
endif

colorscheme solarized

" set tabs to four spaces
set expandtab
set shiftwidth=4
set tabstop=4

" make backspace behave in standard fashion in insert mode
set backspace=indent,eol,start


" show white space characters (conditional is for old versions of vim)
" to show CR characters launch vim with the -b flag
if has("patch-7.4.710")
    set listchars=eol:¬,space:·,tab:»-
else
    set listchars=eol:¬,tab:»-
endif

set list

" strip trailing whitespace on save (uses vim-better-whitespace plugin)
autocmd BufEnter * EnableStripWhitespaceOnSave


" versioning
if has("vms")
    " if vim has versioning don't use backup files
    set nobackup
else
    " if no versioning use backup files but write them to the temp dir
    set backup
    set backupdir=$TEMP,$TMP,.
    set directory=$TEMP,$TMP,.
    set undodir=$TEMP,$TMP,.
endif
