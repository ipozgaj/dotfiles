set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set nobackup

set incsearch
set hlsearch

set autoindent

set modeline

syntax on
colorscheme evening

:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+\%#\@<!$/

:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>
