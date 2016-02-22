" ++++ vim-plug ++++
" Install it if we don't already have it
if empty(glob("~/.vim/autoload/plug.vim"))
	" Ensure all needed directories exist  (Thanks @kapadiamush)
	execute '!mkdir -p ~/.vim/plugged'
	execute '!mkdir -p ~/.vim/autoload'
	" Download the actual plugin manager
	execute '!curl -fLo ~/.vim/autoload/plug.vim
	\ https://raw.github.com/junegunn/vim-plug/master/plug.vim'
	" Execute plug install
	execute 'PlugInstall'
endif

" Call our plugins
call plug#begin()
" [plugin] color schemes
Plug 'captbaritone/molokai'
Plug 'altercation/vim-colors-solarized'
" [plugin] git gutter
Plug 'airblade/vim-gitgutter'
" [plugin] line plugins
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 0
" [plugin] extra
" Plug 'szw/vim-ctrlspace'
" Plug 'AlexJF/rename.vim', { 'on': 'Rename' }
call plug#end()

" ++++ config ++++
" hardmode: no arrow keys
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" essential: stuff i can't put in a category
set nocompatible " needed
set backspace=indent,eol,start " fix backspace
set ttyfast " enable fast terminal connection
set laststatus=2 " force displaying a statusbar
set nostartofline " prevent cursor from changing columns
set hidden " hide buffer when opening new ones
set visualbell " show a visual bell instead of beeping
set noerrorbells " dont beep
set confirm " prompt when failing to save

" essential: syntax & indent
syntax on " enable syntax highlighting
filetype indent plugin on " file-type detection
set shiftwidth=4 " shift by 4 every indent
set softtabstop=4
set tabstop=4 " display as 4 spaces
set noexpandtab " use tabs, not spaces!
set autoindent " auto-indent new lines
set copyindent " copy indent from previous lines
set shiftround " use multiple of shiftwidth when indenting with < and >

" essential: display
set ruler " display a ruler in the status line
set cursorline " highlight current line
set number " show line numbers
set colorcolumn=80 " display a column at 80
set list " show invisible characters, see next option
set listchars=trail:~,extends:>,tab:▸·,eol:↵
set textwidth=80 " auto-wrap at 80
set showmatch " show matching group pair (parenthesis, etc.)

" essential: search
set incsearch " scroll to nearest match when searching
set hlsearch " highlight searches
set ignorecase " ignore case when searching, needed for next option
set smartcase " smart-case searching

" essential: backup, swap, undo, autosave
set backupdir=~/.vim/backup
set directory=~/.vim/swap
if exists("&undodir")
	set undodir=~/.vim/undo
endif
autocmd BufLeave,FocusLost * silent! wall " autosave when losing focus
set autowriteall " save upon switching buffers

" essential: history & undos
set history=1000 " remembers lots
set undolevels=1000 " (lots)

" essential: commands
set wildmenu " allow TAB-completion in commands
set wildignore=*.swp,*.o,.git,*~ " ignore pattern for wildcards
set showcmd " display current command
set cmdheight=2 " use 2 spaces for the
set notimeout ttimeout ttimeoutlen=200 " 200ms timeout

" essential: others
set pastetoggle=<F2> " toggle pasting from external source
" yank till end of line
map Y y$
" ctrl-L removes highlight on redraw
nnoremap <C-L> :nohl<CR><C-L>

" ++++ colors ++++
colorscheme molokai
let g:airline_theme = "molokai"

" <3 from lemon
