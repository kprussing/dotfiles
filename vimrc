" Only use vim not vi
set nocompatible
set modelines=0

" I want to see the line number and I like the 72 characters on a line
set number
set textwidth=72
if exists('+colorcolumn')
    set colorcolumn=73
endif

" Initialize pathogen
filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect('bundle/{}')
call pathogen#helptags()

" Detect file types and auto indent
filetype plugin indent on

" Flag *.text as pandoc.
autocmd BufNewFile,BufReadPost *.text set filetype=pandoc
let g:pandoc#syntax#conceal#use=0

" Set the color scheme here. zenburn for now!
syntax enable
"set background=dark
set t_Co=256
"colorscheme zenburn

" I like syntax highlighting and spelling on
set spell
set spellfile=$HOME/.vim/dictionary.add

" And of course these are my tab preferences
set autoindent      " Indent intelligently
set expandtab       " Tabs are spaces
set shiftwidth=4    " Indents are 4 spaces
set tabstop=4       " Indent every 4 spaces
set softtabstop=4   " Backspace deletes tabs

set nowrap                      " Don't wrap the lines. It's ugly
set encoding=utf-8              " Encode as UTF-8
set scrolloff=3                 " Number of line to keep around cursor
set showmode                    " Show the mode
set showcmd                     " Show partial command
set hidden                      " Hide a buffer instead of abandoning
set wildmenu                    " Show list instead of completing
set wildmode=list:longest       " Tab complete longest common part
set wildignore=*.pyc,*.aux      " Ignore some common file extensions
set visualbell                  " Use a visual bell instead of beeping
set ttyfast                     " Makes redraw fast. Smooths typing
set ruler                       " Turn on the ruler
set backspace=indent,eol,start  " Delete like a real program
set laststatus=2

" Now make myself learn to use the correct keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

" Maps for easier buffer switching.  This is analogous to window
" changing in tmux.
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bNext<CR>

" This remap will probably help me out a lot...
let mapleader = ","

set ignorecase  " Case insensitive search
set smartcase   " Case sensitive when upper case present
set incsearch   " Search while typing
set showmatch   " Show matching brackets
set hlsearch    " Highlight search

" Clear search highlighting
nnoremap <leader><space> :noh<cr>

" And remap keys for easy windowing
nnoremap <leader>w <C-w>v<C-w>l

"--------1---------2---------3---------4---------5---------6---------7--
" The function to create and set the backup directories for cleanliness
function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
        \ 'backup': 'backupdir',
        \ 'views': 'viewdir',
        \ 'swap': 'directory' }
    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . '/' . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: unable to create directory: " . directory
            echo "Try: mkdir -p " .directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

"--------1---------2---------3---------4---------5---------6---------7--
" Some abbreviations for sectioning code.
ab #f !--------1---------2---------3---------4---------5---------6---------7--
ab #c //-------1---------2---------3---------4---------5---------6---------7--
ab #m %--------1---------2---------3---------4---------5---------6---------7--
ab #p #--------1---------2---------3---------4---------5---------6---------7--
