" syntax highlighting
syntax on


filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>' use 4 spaces width
set shiftwidth=4
" on pressing tab insert 4 spaces
set expandtab

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

