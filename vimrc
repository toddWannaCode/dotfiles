python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set hidden
set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with > use 4 spaces width
set shiftwidth=4
" on pressing tab, insert 4 spaces
set expandtab

" :verbose imap <tab>

call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'ajh17/VimCompletesMe'
Plug 'pangloss/vim-javascript'
Plug 'ervandew/supertab'
Plug 'rust-lang/rust.vim'
Plug 'mattn/emmet-vim'
Plug 'vim-syntastic/syntastic'
Plug 'racer-rust/vim-racer'
Plug 'flowtype/vim-flow'

call plug#end()

if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $VIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $VIMRC if has('gui_running') | so % | echom "Reloaded " . $GVIMRC | endif | redraw
  augroup END
endif " has autocmd

set laststatus=2

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_rust_checkers = ['rustc']

let g:racer_cmd = '~/.cargo/bin/racer'
" let g:racer_experimental_completer = 1

set completefunc=syntaxcomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-x><c-p>", "&omnifunc:<c-x><c-o>"]

let g:flow#autoclose = 1
