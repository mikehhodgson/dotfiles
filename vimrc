" http://stackoverflow.com/questions/164847/what-is-in-your-vimrc
" http://amix.dk/vim/vimrc.html

if has("gui_running")
"  set hlsearch
"  colorscheme macvim
"  set bs=2
"  set ai
"  set ruler
"
"  Hide toolbar
    set guioptions-=T
endif

set background=dark 
highlight Normal guifg=white guibg=black
set guifont=Inconsolata-dz:h11:cANSI

" always show current position
set ruler

" http://stackoverflow.com/questions/526858/how-do-i-make-vim-do-normal-bash-like-tab-completion-for-file-names
set wildmode=longest,list

" Actually 'colorcolumn' is option, not a feature, so use exists().
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
if exists('+colorcolumn')
  set colorcolumn=80
endif

" http://vim.wikia.com/wiki/Automatic_word_wrapping
" set tw=79
set tw=0

" http://stackoverflow.com/questions/467739/how-do-you-get-vim-to-display-wrapped-lines-without-inserting-newlines
" http://contsys.tumblr.com/post/491802835/vim-soft-word-wrap
set wrap
set linebreak

" not to break on words
set formatoptions=1

" fixing up moving line by line in the paragraph
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" This shows what you are typing as a command.  I love this!
set showcmd

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*

" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set shiftwidth=4
set softtabstop=4

" Enable mouse support in console
set mouse=a

" Got backspace?
set backspace=2

" Line Numbers PWN!
set number

filetype plugin indent on
syntax on

