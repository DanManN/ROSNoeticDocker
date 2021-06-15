set encoding=utf-8
scriptencoding utf-8

" if not using neovim
if !has('nvim')
	"--- Fast KeyCodes ---"
	" MapFastKeycode: helper for fast keycode mappings
	" makes use of unused vim keycodes <[S-]F15> to <[S-]F37>
	function! <SID>MapFastKeycode(key, keycode)
		if s:fast_i == 46
			echohl WarningMsg
			echomsg 'Unable to map '.a:key.': out of spare keycodes'
			echohl None
			return
		endif
		let vkeycode = '<'.(s:fast_i/23==0 ? '' : 'S-').'F'.(15+s:fast_i%23).'>'
		exec 'set '.vkeycode.'='.a:keycode
		exec 'map '.vkeycode.' '.a:key
		exec 'map! '.vkeycode.' '.a:key
		let s:fast_i += 1
	endfunction
	let s:fast_i = 0
	call <SID>MapFastKeycode('<M-h>','h')
	call <SID>MapFastKeycode('<M-j>','j')
	call <SID>MapFastKeycode('<M-k>','k')
	call <SID>MapFastKeycode('<M-l>','l')
	call <SID>MapFastKeycode('<M-H>','H')
	call <SID>MapFastKeycode('<M-J>','J')
	call <SID>MapFastKeycode('<M-K>','K')
	call <SID>MapFastKeycode('<M-L>','L')
	call <SID>MapFastKeycode('<M-q>','q')
	call <SID>MapFastKeycode('<M-Q>','Q')
else
	set runtimepath^=$HOME/.vim
endif

let mapleader = ' '
let mapreturn = ''
let g:indentLine_char = '¦'
if filereadable(expand('$HOME/.vim/plugins.vim'))
	source ~/.vim/plugins.vim
else
	colorscheme evening
endif

"--- Basic Settings ---"
if (has('termguicolors'))
	set termguicolors
endif
set noshowmode
set laststatus=2
set ttimeout
set ttimeoutlen=10
set showcmd
set wildmenu
set mouse=a
set cursorline
set cursorcolumn
set conceallevel=1
set matchpairs+=<:>
set whichwrap+=<,>,[,]
set clipboard=unnamedplus
set backspace=indent,eol,start

" search and highlighting
set smartcase
set ignorecase
set hlsearch
if has('reltime')
	set incsearch
endif
nnoremap <silent> <leader>/ :nohlsearch<Cr>
execute 'set list listchars=nbsp:⎵,trail:·,tab:'.indentLine_char.'\ '
vnoremap <silent> * :<C-U>
			\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
			\gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
			\escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
			\gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
			\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
			\gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
			\escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
			\gVzv:call setreg('"', old_reg, old_regtype)<CR>

" alt for quick escape
noremap <M-q> <Esc>
noremap! <M-q> <Esc>

" <F12> as escape (nice if capslock is remapped)
noremap <F12> <Esc>
noremap! <F12> <Esc>

" smart line numbers
set number relativenumber
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

"--- Typos ---"
command! WQ wq
command! Wq wq
command! Qw wq
command! QW wq
command! W w
command! Q q

"--- Symbols ---"
inoremap ?! ‽
inoremap ?A ᐰ
inoremap ?<= ≤
inoremap ?>= ≥
inoremap ?in ∈
inoremap ?ni ∋
inoremap ?so ⊆
inoremap ?sf ⊇
inoremap ?po ⊂
inoremap ?pf ⊃

"--- File Extensions ---"
augroup fileextensions
	autocmd!
	autocmd BufRead,BufNewFile .extrarc set filetype=sh
	autocmd BufRead,BufNewFile *.bbx set filetype=tex
augroup END

"--- Movement ---"
" alt-hjkl in insert mode
noremap! <silent> <M-h> <Left>
noremap! <silent> <M-j> <Down>
noremap! <silent> <M-k> <Up>
noremap! <silent> <M-l> <Right>
noremap <silent> <M-h> <Left>
noremap <silent> <M-j> <Down>
noremap <silent> <M-k> <Up>
noremap <silent> <M-l> <Right>

" center next search forward/backward
nnoremap n nzz
nnoremap N Nzz

" move vertically by visual line
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" easier split navigation
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <M-H> <C-w><
nnoremap <M-J> <C-W>-
nnoremap <M-K> <C-W>+
nnoremap <M-L> <C-w>>

" buffer navigation
nnoremap <leader>n :bnext<Cr>
nnoremap <leader>b :bprevious<Cr>
nnoremap <leader>x :bdelete<Cr>
nnoremap <leader>1 :buffer 1<Cr>
nnoremap <leader>2 :buffer 2<Cr>
nnoremap <leader>3 :buffer 3<Cr>
nnoremap <leader>4 :buffer 4<Cr>
nnoremap <leader>5 :buffer 5<Cr>
nnoremap <leader>6 :buffer 6<Cr>
nnoremap <leader>7 :buffer 7<Cr>
nnoremap <leader>8 :buffer 8<Cr>
nnoremap <leader>9 :buffer 9<Cr>

" popup menuone navigation
try
	set completeopt=noinsert,menuone,noselect
catch
	set completeopt=menuone
endtry

imap <expr> <Cr> pumvisible() ? "\<C-y>".mapreturn : "\<Cr>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
nnoremap <leader>j :lnext<Cr>
nnoremap <leader>k :lprevious<Cr>

" jump to previous known position
augroup last_position_jump
	autocmd!
	autocmd BufReadPost *
				\ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
				\ | exe "normal! g`\"zz"
				\ | endif
augroup END

"--- Netrw ---"
set hidden
" let g:netrw_banner = 0
let g:netrw_liststyle = 3
nnoremap <silent> <leader>v :vsplit<Cr>
nnoremap <silent> <leader>e :Explore!<Cr>
nnoremap <silent> <leader>s :Sexplore!<Cr>

"--- Spelling ---"
function! SpellToggle()
	if &spell
		setlocal nospell
	else
		setlocal spell
	endif
	return ''
endfunction
noremap <silent> <F2> :call SpellToggle()<Cr>
inoremap <silent> <F2> <C-r>=SpellToggle()<Cr>

"--- Indentation ---"
set shiftwidth=8
execute 'set tabstop='.&shiftwidth
set softtabstop=-1
set noexpandtab
function! TabToggle()
	if &expandtab
		execute 'setlocal tabstop='.&shiftwidth
		setlocal softtabstop=0
		setlocal noexpandtab
		echo 'Spaces -> Tabs'
	else
		execute 'setlocal softtabstop='.&shiftwidth
		setlocal expandtab
		echo 'Tabs -> Spaces'
	endif
	retab!
	return ''
endfunction
noremap <M-Q> :call TabToggle()<Cr>
inoremap <M-Q> <C-r>=TabToggle()<Cr>

augroup fileshiftwidths
	autocmd!
	autocmd FileType javascript setlocal shiftwidth=2
	autocmd FileType roslaunch setlocal shiftwidth=2
	autocmd FileType PKGBUILD setlocal shiftwidth=2
	autocmd FileType markdown setlocal shiftwidth=2
	autocmd FileType lua setlocal shiftwidth=2
	autocmd FileType cs setlocal shiftwidth=4
	autocmd FileType javascript,roslaunch,PKGBUILD,markdown,lua,cs execute 'setlocal expandtab tabstop='.&shiftwidth
augroup END

"--- GUI Options ---"
set guifont=Iosevka\ 15
" set guifont=FiraCode\ Nerd\ Font\ 14.5
" set guifont=VictorMono\ Nerd\ Font\ \Medium\ 14
if has('gui_running')
	set winaltkeys=no
	set guioptions=a
	function! GuiToggle()
		if &guioptions ==# 'a'
			set guioptions=agimtT
		else
			set guioptions=a
		endif
		return ''
	endfunction
	noremap <silent> <F11> :call GuiToggle()<Cr>
	inoremap <silent> <F11> <C-r>=GuiToggle()<Cr>
	let g:gtk_nocache=[0x00000000, 0xfc00ffff, 0xf8000001, 0x78000001]
else
	highlight Normal guibg=NONE ctermbg=NONE
endif

"--- Surf browser ---"
function! SurfJob()
	let l:cmdstr = 'surf '.expand('%:p')
	if exists('*jobstart')
		call jobstart(l:cmdstr)
	elseif exists('*job_start')
		call job_start(l:cmdstr)
	endif
endfunction
augroup starsurf
	autocmd!
	autocmd FileType html nnoremap <buffer> <leader>h :call SurfJob()<Cr>
augroup END
