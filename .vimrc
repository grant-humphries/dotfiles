" pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" syntax highlighting
syntax on

" wrap lines at particular widths based on the file type
filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4

" when indenting with '>' use 4 spaces width
set shiftwidth=4

" on pressing tab insert 4 spaces
set expandtab

" make backspace behave in standard fashion
set backspace=indent,eol,start


" show white space characters (conditional is for old versions of vim)
" to show CR characters launch vim with the -b flag
if has("patch-7.4.710")
    set listchars=eol:¬,space:·,tab:»-
else
    set listchars=eol:¬,tab:»-
endif

set list

" set white space colors to dark gray, color reference:
" http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
hi SpecialKey ctermfg=236
hi NonText ctermfg=236


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
