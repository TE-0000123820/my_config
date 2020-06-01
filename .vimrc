"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set params
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmode=list:longest
set smartindent
set expandtab
set incsearch
set sw=4
set bs=2
set tabstop=4
set laststatus=2
set hlsearch
set encoding=utf-8
set ruler
set nonumber
set statusline=%f:%l(%L)\ %m%r%h%w\ [%{&fenc}][%{&ff}]%y%6l,%-6c[%p%%(%l)]
set cursorline
"set cursorcolumn
set fileformats=unix,dos,mac
set grepprg=mgrep
set nf="hex"
set ignorecase
set smartcase
set smarttab
set timeoutlen=1000
set directory=~/vim_swap
"set foldmethod=syntax
set foldmethod=marker
set foldlevel=10
set foldlevelstart=10

set guioptions=M
set filetype=off
set relativenumber number
"set scrolloff=5
set scrolloff=0
let g:clipboard = "tmux"
"set clipboard=
set belloff=all
set completeopt=longest,menuone

if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"autocmd BufReadPost * normal g;|zz
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | exe "normal zz"

au! QuickfixCmdPost vimgrep,grep,make if len(getqflist()) != 0 | bo copen | wincmd p | endif

"
" python mode {{{
"
let g:pymode_folding = 0
let g:pymode_lint_ignore = "E501,E226,E225,E228"
let g:pymode_lint_write = 0
autocmd! FileType python
autocmd  FileType python nnoremap <leader>l :PyLint<CR>
" }}}

" md preview
autocmd FileType markdown set makeprg=pandoc\ -r\ markdown\ -t\ html\ -c\ ~/devel/css/markdown.css\ %\ -o\ /tmp/md.html\ &&\ open\ /tmp/md.html
autocmd FileType log set makeprg=cat\ %
autocmd FileType text set makeprg=cat\ %


let g:Gtags_No_Auto_Jump=1
let g:errorformat="%*[^\"]\"%f\"%*\D%l: %m,\"%f\"%*\D%l: %m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l) :%m,%f:%l:%m,\"%f\"\, line %l%*\D%c%*[^ ] %m,%D%*\a[%*\d]: Entering directory %*[`']%f',%X%*\a[%*\d]: Leaving directory %*[`']%f',%D%*\a: Entering directory %*[`']%f',%X%*\a: Leaving directory %*[` ']%f',%DMaking %*\a in %f,%f|%l| %m"
"let &makeprg="make -j " . system('cat /proc/cpuinfo | grep "core id" | wc -l | tr -d "\r" | tr -d "\n"')

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

"
" Tab settings {{{
"
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]l :tablast<CR>
map <silent> [Tag]r :tabnext<CR>
map <silent> [Tag]e :tabprevious<CR>
map <silent> [Tag]c :tabnew .<CR>
map <silent> [Tag]n :tabnew .<CR>
map <silent> [Tag]gf <c-w>gf
" }}}

"
" filetype
"
autocmd BufRead,BufNewFile *.log setfiletype log
autocmd BufRead,BufNewFile log setfiletype log

augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cnoremap <C-D> <Del>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <C-A> <Home>
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nnoremap <space>n :next<CR>
nnoremap <space>p :prev<CR>
nnoremap <space>l $
nnoremap <space>h ^
nnoremap * :Search \<<c-r><c-w>\><cr>
nnoremap <Leader><C-M> :make<CR>
nnoremap <C-W>C :cclose<CR>
nnoremap <Leader>C :set cursorcolumn!<CR>
nnoremap <Leader>N :set relativenumber! number!<CR>
nnoremap <Leader>S :syntax off<CR>
nnoremap <Leader>Q :QuickfixsignsToggle<CR>
nnoremap <C-j> 5j
nnoremap <C-k> 5k
xnoremap <C-j> 5j
xnoremap <C-k> 5k
vnoremap <C-j> 5j
vnoremap <C-k> 5k
"nnoremap <C-K> 8<c-y>
nnoremap <c-_>r :reg<cr>
nnoremap <leader>C : <c-r><c-w><Home>
"nnoremap + :let @t=@/<cr>:let @/='[A-Z]'<cr>n:let @/=@t<cr>
"nnoremap - :let @t=@/<cr>:let @/='[A-Z]'<cr>N:let @/=@t<cr>
nnoremap <leader>y :call writefile(split(@@, '\n'), $HOME . "/yank.txt")<cr>
nnoremap <leader>p :read $HOME/yank.txt<cr>
"nnoremap zm :PosListAdd<CR>
"nnoremap zl :PosListShow<CR>:QuickfixsignsEnable<cr>
nnoremap cn :cnext<CR>
nnoremap cp :cprev<CR>
nnoremap zn :cnext<cr>
nnoremap zp :cprev<cr>
nnoremap <space>d :silent execute("!echo 'cd " . expand("%:p:h") . "' >" . "~/.vimrc.cwd")<cr><c-l>
nnoremap md d`z
nnoremap my "ry`z<c-o>
nnoremap mD d'z
nnoremap mY "ry'z<c-o>
nnoremap m= ='z<c-o>
nnoremap m> >'z<c-o>
nnoremap m< <'z<c-o>
nnoremap QQ :wqa<cr>
nnoremap <space>F /^[^\t #\/}]<cr>
nnoremap <space>L /\(\<for\>\)\\|\(\<while\>\)\\|\(\<do\>\)<cr>
nnoremap ( F 
nnoremap ) f 
nnoremap <space>r :OverCommandLine<cr>
inoremap <c-s> <esc>:w<cr>
nnoremap <c-s> <esc>:w<cr>
"nnoremap n nzz
nnoremap <c-q> @@
nnoremap <space>[ [`
nnoremap <space>] ]`

inoremap <c-x><c-i> <esc>:Snippets<cr>
nnoremap <c-x><c-i> :Snippets<cr>

nnoremap <m-d> dd
vnoremap <m-d> dd
xnoremap <m-d> dd

noremap <leader>r :%s/<c-r><c-w>/
noremap <leader>lm :REefmMK log<cr>
noremap <leader>s :SvnGetStat 

vnoremap <C-j> 4j
vnoremap <C-k> 4k
vnoremap [[ :<c-u>let @t=@/<cr>:let @/='{'<cr>N:let @/=@t<cr>mv`>V`v
vnoremap ]] :<c-u>let @t=@/<cr>:let @/='}'<cr>`>n:let @/=@t<cr>mv`<V`v
vnoremap <leader>C y: <c-r>"<Home>
vnoremap <leader>r y:%s/<c-r>=escape(@",'\/')<cr>/
vnoremap <silent> * "vy:Search \V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
vnoremap <silent> <leader>g "vy:exec ":vimgrep /" . escape(getreg('v'), '\/') . "/j %"<CR>
"vnoremap <C-R> y:<C-R>=substitute(@", "\n", "", "g")<CR><CR>
vnoremap <C-R> y:call <SID>ExecLines(@")<cr>
function! s:ExecLines(lines) range
    for i in split(a:lines, "\n")
        exec i
    endfor
endfunction

" grep
nnoremap <leader>g :vimgrep /<C-R><C-W>/j %<CR>:let @/="<C-R><C-W>"<CR>:set hlsearch<CR>
nnoremap gG :vimgrep /<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')/j %<CR>

"
" key maps for quickfix
"
autocmd! FileType qf
"autocmd  FileType qf nnoremap <buffer> <CR> <CR>zz:wincmd p<CR>
autocmd  FileType qf nnoremap <buffer> q :wincmd p<CR>:cclose<CR>


nnoremap <leader>C :cclose<cr>

nnoremap mm :marks<cr>
nnoremap mr :reg<cr>

nnoremap <space>f :let @0="+" . line(".") . " " . expand("%:p")<cr>

nnoremap ml :doautocmd User<cr>
nnoremap <space>c :ccl<cr>:copen 50<cr>

" input mode
inoremap <c-b> <left>
inoremap <c-f> <right>
" }}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set bg=dark
colorscheme industry
"colorscheme evening
" overwrite settings
hi CursorLine   term=reverse cterm=bold 
hi CursorColumn   term=reverse cterm=bold 

hi JpSpace cterm=underline ctermbg=red
au BufRead,BufNew * match JpSpace /　/

"hi EasyMotionTarget ctermfg=cyan cterm=bold
hi EasyMotionTarget ctermfg=cyan
hi EasyMotionTarget2First ctermfg=yellow
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Vundle
"
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'gmarik/Vundle.vim'

"
" ps.vim {{{
"
Bundle 'katonori/ps.vim'
if stridx(system("uname -a "), "Linux") != -1
    let g:PS_PsCmd = "ps axuf"
else
    let g:PS_PsCmd = "ps aux"
endif
let g:PS_KillCmd = "kill -9"
let g:PS_RegExRule = '\w\+\s\+\zs\d\+\ze'
autocmd FileType ps nnoremap <buffer> <silent> K :PsKillLine<CR>
autocmd FileType ps vnoremap <buffer> <silent> K :PsKillAllLines<CR>
autocmd FileType ps nnoremap <buffer> <silent> <C-K> 8k
" }}}

"
" vim-fugitive {{{
"
Bundle 'tpope/vim-fugitive'
autocmd! FileType gitcommit
autocmd! FileType gitcommit nmap <c-d> :let @t=winnr()<cr>:normal D<cr>:exec @t . "wincmd w"<cr>
autocmd! FileType fugitive
autocmd! FileType fugitive nmap <c-d> :let @t=winnr()<cr>:normal D<cr>:exec @t . "wincmd w"<cr>
" }}}

"Bundle 'kana/vim-textobj-user'
let g:textobj_multiblock_blocks = [
    \ [ ",", ","],
    \ [ ",", ")"],
    \ [ "(", ")" ],
    \ [ "[", "]" ],
    \ [ "{", "}" ],
    \ [ '<', '>' ],
    \ [ '"', '"', 1 ],
    \ [ "'", "'", 1 ],
\ ]
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)


"
" vim-easymotion {{{
"
Bundle 'Lokaltog/vim-easymotion'
" Show target key with upper case to improve readability
let g:EasyMotion_use_upper = 1
" Jump to first match with enter & space
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys='asdghklwertyuiopzxcvbnmfj;'
" map settings
nmap <space>w <Plug>(easymotion-w)
xmap <space>w <Plug>(easymotion-w)
nmap <space>b <Plug>(easymotion-b)
xmap <space>b <Plug>(easymotion-b)
nmap <space>e <Plug>(easymotion-e)
xmap <space>e <Plug>(easymotion-e)
nmap <space>S <Plug>(easymotion-s2)
xmap <space>S <Plug>(easymotion-s2)
nmap <space>s <Plug>(easymotion-s)
xmap <space>s <Plug>(easymotion-s)
nmap <space>t <Plug>(easymotion-t)
xmap <space>t <Plug>(easymotion-t)
nmap <space>f <Plug>(easymotion-bd-fl)
xmap <space>f <Plug>(easymotion-bd-fl)
nmap <space>j <Plug>(easymotion-j)
xmap <space>j <Plug>(easymotion-j)
nmap <space>k <Plug>(easymotion-k)
xmap <space>k <Plug>(easymotion-k)
" }}}

Bundle "honza/vim-snippets"

"
" unite.vim {{{
"
Bundle 'Shougo/unite.vim'
let g:unite_source_grep_max_candidates = 200
let g:unite_source_rec_find_args=["-maxdepth=2"]
nnoremap Uu :Unite -direction=below<cr>
nnoremap Uf :Unite -direction=below file_mru<cr>
nnoremap UF :Unite -direction=below file_rec<cr>
nnoremap Ul :Unite -direction=below line<cr>
"nnoremap Uf :History<cr>
"nnoremap UF :Files<cr>
"nnoremap Ul :BLines<cr>
"}}}

"Bundle 'tomtom/quickfixsigns_vim'
"let g:quickfixsigns_events = ['BufReadPost', 'BufEnter', 'CursorHold', 'CursorHoldI', 'InsertLeave', 'InsertEnter', 'User']
Bundle 'Shougo/neomru.vim'
Bundle 'MultipleSearch'

"
" Switch.vim {{{
"
Bundle 'AndrewRadev/switch.vim'
let g:switch_custom_definitions =
    \ [
    \   {
    \     'True':       'False',
    \     'False':      'True',
    \   },
    \ ]
nnoremap + :Switch<cr>
" }}}

Bundle 'davidhalter/jedi-vim'
"Bundle 'osyo-manga/vim-over'
"Bundle 'benekastah/neomake'
Bundle 'lyuts/vim-rtags'
"Bundle 'Valloric/YouCompleteMe'
let g:ycm_filetype_blacklist = {}
"Bundle 'tpope/vim-surround'
"Bundle 'scrooloose/nerdtree'
"let NERDTreeShowHidden=1
"let NERDTreeMapOpenInTab='T'
"let NERDTreeMapOpenInTabSilent='<c-t>'

"
" fzf {{{
"
Bundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Bundle 'junegunn/fzf.vim'
let g:fzf_layout = { 'window': 'bel split' }
let g:fzf_preview_window = 'right:60%'
command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --color always --column --line-number --no-heading --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort --color hl:2,hl+:14'}, 'up:50%', '?'),
    \   1) 
"   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
nnoremap <space>g :LinesWithPreview<CR>
"let g:fzf_layout = { 'window': '~40%' }
nnoremap Ff :History!<cr>
" }}}

"Bundle 'Raimondi/vim_search_objects'
"Bundle 'simeji/winresizer'
"let g:winresizer_vert_resize = 1
"let g:winresizer_horiz_resize = 1
"let g:winresizer_start_key = '<c-x><c-e>'

"
" ultisnips {{{
"
Bundle 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories=[$HOME."/misc_kato/UltiSnips"]
let g:UltiSnipsListSnippets="<c-x><c-o>"
let g:UltiSnipsExpandTrigger="<c-o>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

"
" yankround.vim {{{
"
Bundle 'LeafCage/yankround.vim'
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history = 50
"" }}}

"Bundle 'Shougo/vimproc.vim'
Bundle 'osyo-manga/vim-vigemo'
nmap g/ <Plug>(vigemo-search)

Bundle 'tomasr/molokai'
Bundle 'mechatroner/rainbow_csv'
Bundle 'jreybert/vimagit'
Bundle 'tpope/vim-rhubarb'
Bundle 'powerman/vim-plugin-AnsiEsc'
Bundle 'airblade/vim-gitgutter'
hi GitGutterAdd ctermfg=green ctermbg=blue term=bold
hi GitGutterDelete ctermfg=red ctermbg=blue term=bold
hi GitGutterChange ctermfg=yellow ctermbg=blue term=bold
hi GitGutterChangeDelete ctermfg=brown ctermbg=blue term=bold
Bundle 'junegunn/vim-peekaboo'
Bundle 'junegunn/rainbow_parentheses.vim'
augroup rainbow_lisp
  autocmd!
  autocmd FileType * RainbowParentheses
augroup END

"
" gtags
"
nnoremap <C-G>r :Gtags -r <C-R><C-W><CR>
nnoremap <C-G>d :Gtags <C-R><C-W><CR>
nnoremap <C-G>g :Gtags -g <C-R><C-W><CR>
