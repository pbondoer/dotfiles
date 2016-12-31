" plugins
call plug#begin()
" Plug 'captbaritone/molokai'
Plug 'tomasr/molokai'
Plug 'airblade/vim-gitgutter'
" Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-commentary'
Plug 'kien/rainbow_parentheses.vim'
call plug#end()

" no arrow keys!
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" stuff i can't put in a category
if !has('nvim')
	set nocompatible " needed for plug in vim
	set ttyfast " make vim faster if using vim
endif

set backspace=indent,eol,start " fix backspace
set laststatus=2 " force displaying a statusbar
set nostartofline " prevent cursor from changing columns
set hidden " hide buffer when opening new ones
set visualbell " show a visual bell instead of beeping
set noerrorbells " dont beep
set confirm " prompt when failing to save
set lazyredraw " doesn't redraw when executing commands that havent been typed

" syntax & indent
syntax on " enable syntax highlighting
filetype indent plugin on " file-type detection
set shiftwidth=4 " shift by 4 every indent
set softtabstop=4
set tabstop=4 " display as 4 spaces
set noexpandtab " use tabs, not spaces!
set autoindent " auto-indent new lines
set copyindent " copy indent from previous lines
set shiftround " use multiple of shiftwidth when indenting with < and >

" display
set ruler " display a ruler in the status line
set cursorline " highlight current line
set number " show line numbers
set colorcolumn=80 " display a column at 80
set list " show invisible characters, see next option
set listchars=trail:~,extends:>,tab:▸·,eol:↵
set textwidth=80 " auto-wrap at 80
set showmatch " show matching group pair (parenthesis, etc.)
set background=dark " tell vim that we have a dark background

" search
set incsearch " scroll to nearest match when searching
set hlsearch " highlight searches
set ignorecase " ignore case when searching, needed for next option
set smartcase " smart-case searching

" backup, swap, undo, autosave
set backupdir=~/.vim/backup
set directory=~/.vim/swap
if exists("&undodir")
	set undodir=~/.vim/undo
endif
autocmd BufLeave,FocusLost * silent! wall " autosave when losing focus
set autowriteall " save upon switching buffers

" history & undos
set history=1000 " remembers lots
set undolevels=1000 " (lots)

" commands
set wildmenu " allow TAB-completion in commands
set wildignore=*.swp,*.o,.git,*~ " ignore pattern for wildcards
set showcmd " display current command
set cmdheight=1 " use 2 columns for the command line
set notimeout ttimeout ttimeoutlen=20 " 20ms timeout

" splits
set splitbelow " saner defaults
set splitright " same as above

" other stuff
set pastetoggle=<F2> " toggle pasting from external source
" quickly yank till the end of a line
map Y y$
" ctrl-L removes highlight on redraw
nnoremap <C-L> :nohl<CR><C-L>

" plugin: rainbow parantheses 
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" plugin: indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" pretty colors
colorscheme molokai

let g:airline_theme = "molokai"
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
" <3 from lemon
