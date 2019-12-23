" plugins
call plug#begin()
" theme
Plug 'tomasr/molokai'
Plug 'kien/rainbow_parentheses.vim'
" gutter
Plug 'airblade/vim-gitgutter'
" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" syntax
"   jsx-pretty BEFORE polyglot
"   https://github.com/MaxMEllon/vim-jsx-pretty/issues/69
Plug 'MaxMEllon/vim-jsx-pretty'

Plug 'sheerun/vim-polyglot'

Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'pangloss/vim-javascript'
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
" checkers
Plug 'w0rp/ale'
" autocomplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'wokalski/autocomplete-flow'
" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'pbondoer/vim-snippets'
" header
Plug 'pbondoer/vim-42header'
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
set encoding=utf-8 " unicode!

" syntax & indent
syntax on " enable syntax highlighting
filetype indent plugin on " file-type detection

set shiftwidth=2 " shift by 2 every indent
set softtabstop=2
set tabstop=2 " display as 2 spaces
set expandtab " use spaces

" environment specific overrides
if $ENV ==? '42'
  set shiftwidth=4 " shift by 4 every indent
  set softtabstop=4
  set tabstop=4 " display as 4 spaces
  set noexpandtab " use tabs
elseif $ENV ==? $WORK_ENV
  set shiftwidth=2 " shift by 2 every indent
  set softtabstop=2
  set tabstop=2 " display as 2 spaces
  set expandtab " use spaces
endif

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

" relative numbers
if exists('+relativenumber')
  set rnu
  autocmd InsertEnter * :set nornu
  autocmd InsertLeave * :set rnu
endif

" plugin: rainbow parantheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:rbpt_colorpairs = [
      \ ['red',         'firebrick3'],
      \ ['brown',       'RoyalBlue3'],
      \ ['Darkblue',    'SeaGreen3'],
      \ ['darkgray',    'DarkOrchid3'],
      \ ['darkgreen',   'firebrick3'],
      \ ['darkcyan',    'RoyalBlue3'],
      \ ['darkred',     'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['brown',       'firebrick3'],
      \ ['gray',        'RoyalBlue3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['Darkblue',    'firebrick3'],
      \ ['darkgreen',   'RoyalBlue3'],
      \ ['darkcyan',    'SeaGreen3'],
      \ ['darkred',     'DarkOrchid3'],
      \ ]

" plugin: javascript
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" jsx
let g:vim_jsx_pretty_colorful_config = 1

" polyglot
let g:polyglot_disabled = ['markdown', 'typescript', 'jsx', 'rust', 'toml']

" pretty colors
if !empty(globpath(&rtp, 'colors/molokai.vim'))
  colorscheme molokai
endif

" airline
let g:airline_theme = "molokai"
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#ale#enabled = 1

" ale
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %severity% > %s'
let g:ale_linters = {
      \   'javascript': ['eslint', 'flow'],
      \   'typescript': ['tsserver', 'tslint'],
      \   'markdown': ['markdownlint'],
      \   'rust': ['rls', 'cargo'],
      \   'bash': ['shellcheck'],
      \   'sh': ['shellcheck'],
      \ }
let g:ale_fixers = {
      \   'javascript': ['prettier'],
      \   'typescript': ['prettier'],
      \   'markdown': ['prettier'],
      \   'scss': ['prettier'],
      \   'rust': ['rustfmt'],
      \   'vim': ['remove_trailing_lines', 'trim_whitespace'],
      \ }
let g:ale_completion_enabled = 1

let g:ale_close_preview_on_insert = 1

let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1

" ale_rust
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_rls_toolchain = 'stable'

" python support
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" deoplete
let g:deoplete#enable_at_startup = 1

" neosnippet
imap <c-k> <Plug>(neosnippet_expand_or_jump)
smap <c-k> <Plug>(neosnippet_expand_or_jump)
xmap <c-k> <Plug>(neosnippet_expand_target)
vmap <c-k> <Plug>(neosnippet_expand_target)

let g:neosnippet#snippets_directory = globpath(&rtp, 'snippets')

" <3 from lemon
