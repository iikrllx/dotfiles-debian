call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'iberianpig/tig-explorer.vim'

call plug#end()

syntax on                 " syntax highlighting
filetype indent off       " disable auto indent
set ls=2                  " show filename in status line
set number                " numbers each line
"set expandtab            " space characters instead of tabs
"set tabstop=2            " tab width to 2 columns
"set shiftwidth=2         " shift width to 2 spaces
set hlsearch              " highlighting when doing a search (F3)
set incsearch             " incrementally highlight matching
set ignorecase            " ignore capital letters during search
set noswapfile            " disable .swap files
colorscheme slate         " select 'slate' colorscheme
                          " visual mode change color highlight
highlight Visual cterm=bold ctermbg=Gray ctermfg=NONE
let NERDTreeShowHidden=1  " show hidden files (nerdtree plugin)

map <C-n> :NERDTreeToggle<CR>
map <F3> :set hlsearch!<CR>
map <C-f> :Files<CR>
map <C-q> :Rg<CR>
nnoremap <C-m> :tabnew<CR>
nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>
" <Leader> key is mapped to \ by default
" For tig (text-mode interface for Git)
nnoremap <Leader>g :TigGrep<CR>
nnoremap <Leader>b :TigBlame<CR>
nnoremap <Leader>t :TigOpenProjectRootDir<CR>
" Display or hide invisible characters
nnoremap <Leader>q :set list! listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:↲,precedes:«,extends:»<CR>

" Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
