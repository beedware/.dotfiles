set cin aw ai is ts=4 sw=4 tm=50 nu rnu noeb bg=dark ru cul
sy on
ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \| md5sum \| cut -c-6

"let mapleader = ' '
"
"" plugins
"let s:plug_path = expand('~/.vim/autoload/plug.vim')
"if empty(glob(s:plug_path))
"  silent execute '!curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif
"
"call plug#begin('~/.vim/plugged')
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
"Plug 'machakann/vim-highlightedyank'
"Plug 'c9rgreen/vim-colors-modus'
"call plug#end()
"
"let g:highlightedyank_highlight_duration = 200
"let g:netrw_banner = 0
"
"let g:fzf_colors = {
"      \ 'fg':      ['fg', 'Normal'],
"      \ 'bg':      ['bg', 'Normal'],
"      \ 'hl':      ['fg', 'Comment'],
"      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"      \ 'hl+':     ['fg', 'Statement'],
"      \ 'info':    ['fg', 'PreProc'],
"      \ 'prompt':  ['fg', 'Conditional'],
"      \ 'pointer': ['fg', 'Exception'],
"      \ 'marker':  ['fg', 'Keyword'],
"      \ 'spinner': ['fg', 'Label'],
"      \ 'header':  ['fg', 'Comment']
"      \ }
"
"let g:fzf_layout = { 'window': 'botright 14new' }
"let g:fzf_vim = {
"      \ 'preview_window': [],
"      \ 'files_options': ['--prompt', 'Files> ']
"      \ }
"
"if executable('fd')
"  let $FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix --exclude .git'
"  command! -bang -nargs=? -complete=dir FilesAll call fzf#vim#files(<q-args>, { 'source': 'fd --type f --hidden --follow --no-ignore --strip-cwd-prefix --exclude .git', 'options': ['--prompt', 'Files> '] }, <bang>0)
"else
"  let $FZF_DEFAULT_COMMAND = "find . -type f -not -path '*/.git/*' -not -path '*/.*'"
"  command! -bang -nargs=? -complete=dir FilesAll call fzf#vim#files(<q-args>, { 'source': "find . -type f -not -path '*/.git/*'", 'options': ['--prompt', 'Files> '] }, <bang>0)
"endif
"
"" options
"filetype plugin indent on
"syntax on
"
"set background=dark
"set laststatus=2
"set noshowmode
"set clipboard=
"set cursorline
"set cursorlineopt=both
"set completeopt=menu,popup,noselect
"set expandtab
"set autoindent
"set shiftwidth=2
"set softtabstop=2
"set tabstop=2
"set ignorecase
"set smartcase
"set mouse=a
"set number
"set relativenumber
"set numberwidth=2
"set noruler
"set signcolumn=yes
"set splitbelow
"set splitright
"set timeoutlen=400
"set undofile
"set foldmethod=indent
"set foldlevel=99
"set foldtext=substitute(getline(v:foldstart),'/\*\|\*/\|{{{\d\=','','g')
"set updatetime=250
"set fillchars=eob:\
"set guicursor=
"set shortmess+=sI
"set nowrap
"set whichwrap+=<,>,[,],h,l
"set hlsearch
"set incsearch
"set smartindent
"set showmatch
"set backspace=indent,eol,start
"
"" keybinds
"function! ToggleNetrw()
"  for winnr in range(1, winnr('$'))
"    if getbufvar(winbufnr(winnr), '&filetype') ==# 'netrw'
"      bd
"      return
"    endif
"  endfor
"
"  Ex
"endfunction
"
"nnoremap <silent> <leader>. :call ToggleNetrw()<CR>
"nnoremap <leader>fa :FilesAll<CR>
"nnoremap <leader>fr :History<CR>
"nnoremap <leader>ff :Files<CR>
"nnoremap <leader>fw :Rg <C-r><C-w><CR>
"nnoremap <leader>fb :Buffers<CR>
"nnoremap <leader>fh :Helptags<CR>
"nnoremap <leader>fk :Maps<CR>
"nnoremap <leader>fm :Marks<CR>
"nnoremap <leader>fz :BLines<CR>
"
"" colors
"if has('termguicolors')
"  set termguicolors
"else
"  set t_Co=256
"endif
"
"silent! colorscheme modus
