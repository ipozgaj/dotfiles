" fuck the compatibility, no one uses Teh Old Vim (TM) anymore
set nocompatible

" syntax highlighting
syntax enable
set background=dark

" cursor line highlightning (requires TERM that supports 256 colors)
set cursorline
hi CursorLine ctermbg=233 cterm=none

" indent style
set autoindent                      " carry indent over to new lines
set tabstop=4                       " four spaces per tab
set softtabstop=4                   " number of spaces per tab when inserting
set shiftwidth=4                    " four spaces per indent
set expandtab                       " substitue spaces for tabs
set smarttab                        " smarted tab

" display
set ruler                           " show cursor position
set nonumber                        " hide line numbers
set nolist                          " hide tabs and EOL chars
set showcmd                         " show normal mode commands as they are entered
set showmode                        " show editing mode in status (-- INSERT --)
set showmatch                       " flash matching delimiters

" scrolling
set scrolljump=5                    " scroll five lines at a time vertically
set sidescroll=10                   " minumum columns to scroll horizontally

" search
set hlsearch                        " highlight seach words
set incsearch                       " search with typeahead

" splits
set splitbelow                      " open new split pane to bottom
set splitright                      " open new vsplit pane to right

" misc
set noerrorbells                    " no bells in terminal
set backspace=indent,eol,start      " backspace over everything
set tags=tags;/                     " search up the directory tree for tags
set undolevels=1000                 " number of undos stored
set viminfo='50,"50                 " '=marks for x files, "=registers for x files
set modelines=0                     " turn off modelines
set nobackup                        " don't create backups when overwriting files

" show whitespaces at the end of lines
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+\%#\@<!$/

" map gb (both in visual and normal mode) to open git blame for selection/file
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>

" map gp and gnp to set paste/nopaste
:nmap gp :set paste<CR>
:nmap gnp :set nopaste<CR>
