" set encoding of this file
scriptencoding utf-8
set encoding=utf-8

" syntax highlighting
syntax on

" make backspace behave in standard fashion
set backspace=indent,eol,start

" this will automatically wrap lines at given width based on the file type
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>' use 4 spaces width
set shiftwidth=4
" on pressing tab insert 4 spaces
set expandtab


" show white space characters
" to show CR characters launch vim with the -b flag
set listchars=eol:¬,space:·,tab:»-
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

