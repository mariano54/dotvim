execute pathogen#infect()

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
colorscheme molokai

let g:rehash256 = 1
"let g:molokai_original = 1
"set background=light
set linespace=1

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Nerdtree
cd ~/Projects
map <F2> :NERDTreeToggle<CR>
map <Leader>nt :NERDTree %:p:h<CR>

" Omni complete
set completeopt-=preview

" Latex
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = "pdf"


" Syntastic
let g:syntastic_tex_checkers = []
let g:syntastic_python_python_exec = 'python2'
let g:syntastic_python_checkers=['python']

" Building (Python)
autocmd FileType python nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>
autocmd FileType python nnoremap <buffer> <F8> :exec '!python2' shellescape(@%, 1)<cr>

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?
let mapleader=","
filetype plugin on

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
"set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
"set statusline  ne=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>
vnoremap <C-c> "+y
vnoremap <C-x> "+p


set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set number

"Show hidden files in NerdTree
let NERDTreeShowHidden=1
"
"autopen NERDTree and focus cursor in new document
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let g:neocomplcache_enable_at_startup = 1

set encoding=utf-8
set t_Co=256

let g:airline_powerline_fonts = 1
let g:airline_theme = "tomorrow"

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
"
" " Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" My preference with using buffers. See `:h hidden` for more details
 set hidden

autocmd FileType * unlet! g:airline#extensions#whitespace#checks
autocmd FileType markdown let g:airline#extensions#whitespace#checks = [ 'indent' ]


 " To open a new empty buffer
 " " This replaces :tabnew which I used to bind to this mapping
 nmap <leader>T :enew<cr>
 "
 " " Move to the next buffer
 "nmap <leader>f :bnext<CR>
 "
 " " Move to the previous buffer
 "nmap <leader>d :bprevious<CR>
 "
 " " Close the current buffer and move to the previous one
 " " This replicates the idea of closing a tab
 nmap <leader>q :bp <BAR> bd #<CR>
 "
 " " Show all open buffers and their status
 nmap <leader>l :ls<CR>

" Change cursor in insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Necesary  for lots of cool vim things
set nocompatible

" This shows what you are typing as a command.  I love this!
set showcmd

" Folding Stuffs
set foldmethod=marker

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" Next Tab
nnoremap <silent> <C-Right> :bnext<CR>


" Previous Tab
nnoremap <silent> <C-Left> :bprevious<CR>


noremap <Leader>m :NERDTreeToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

syntax on
filetype plugin indent on
