set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set nobackup

set incsearch
set hlsearch

set cindent
set showmatch

set modeline

syntax on
set background=dark

" show whitespaces at the end of lines
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+\%#\@<!$/

" map gb (both in visual and normal mode) to open git blame for selection/file
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>

" map gp and gnp to set paste/nopaste
:nmap gp :set paste<CR>
:nmap gnp :set nopaste<CR>
