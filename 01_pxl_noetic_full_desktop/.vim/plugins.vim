scriptencoding utf-8
"--- vim-plug settings ---"
let g:plugged = '$HOME/.vim/plugged'
call plug#begin(g:plugged)

" Plug 'DanManN/vim-razer'
Plug 'jacoborus/tender.vim'
Plug 'base16-project/base16-vim'

Plug 'tpope/vim-commentary/'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
if v:version >= 800
	Plug 'lambdalisue/suda.vim'
endif
Plug 'vim-syntastic/syntastic'
Plug 'myint/syntastic-extras'
Plug 'Chiel92/vim-autoformat'

Plug 'DanManN/JavaDecompiler.vim'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'wsdjeg/vim-lua', {'for': 'lua'}
Plug 'OmniSharp/omnisharp-vim', {'for': 'cs'}
Plug 'clktmr/vim-gdscript3', {'for': 'gdscript3'}
Plug 'taketwo/vim-ros' ", { 'branch': 'py3' }
Plug 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp']}

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Plug 'honza/vim-snippets'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-neosnippet'

if has('timers')
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-buffer.vim'
	Plug 'prabirshrestha/asyncomplete-file.vim'
	Plug 'yami-beta/asyncomplete-omni.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
	Plug 'prabirshrestha/asyncomplete-neosnippet.vim'
endif

call plug#end()

let OS=substitute(system('lsb_release -si'),'\n','','')

function! IsPlugLoaded(name)
	return (
				\ has_key(g:plugs, a:name) &&
				\ isdirectory(g:plugs[a:name].dir) &&
				\ stridx(&rtp, g:plugs[a:name].dir[:-2]) >= 0
				\ )
endfunction

"--- base16 ---"

if IsPlugLoaded('base16-vim') && exists('$BASE16_THEME') && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
	" let base16colorspace=256
	colorscheme base16-$BASE16_THEME

	function! s:base16_customize() abort
		if !has('gui_running')
			highlight Normal guibg=NONE ctermbg=NONE
		endif
		call Base16hi('MatchParen', g:base16_gui05, g:base16_gui03, g:base16_cterm05, g:base16_cterm03, 'bold,italic', '')
		let g:NeatStatusLine_color_normal   = 'guifg=#'.g:base16_gui00.' guibg=#'.g:base16_gui0B.' gui=NONE ctermfg='.g:base16_cterm00.' ctermbg='.g:base16_cterm0B.' cterm=NONE'
		let g:NeatStatusLine_color_insert   = 'guifg=#'.g:base16_gui00.' guibg=#'.g:base16_gui0D.' gui=bold ctermfg='.g:base16_cterm00.' ctermbg='.g:base16_cterm0D.' cterm=bold'
		let g:NeatStatusLine_color_visual   = 'guifg=#'.g:base16_gui00.' guibg=#'.g:base16_gui09.' gui=NONE ctermfg='.g:base16_cterm00.' ctermbg='.g:base16_cterm09.' cterm=NONE'
		let g:NeatStatusLine_color_replace  = 'guifg=#'.g:base16_gui00.' guibg=#'.g:base16_gui08.' gui=bold ctermfg='.g:base16_cterm00.' ctermbg='.g:base16_cterm08.' cterm=bold'
		let g:NeatStatusLine_color_line     = 'guifg=#'.g:base16_gui0E.' guibg=#181818 gui=bold ctermfg='.g:base16_cterm0E.' ctermbg=234 cterm=bold'
		let g:NeatStatusLine_color_position = 'guifg=#'.g:base16_gui07.' guibg=#181818 gui=NONE ctermfg='.g:base16_cterm07.' ctermbg=234 cterm=NONE'
		let g:NeatStatusLine_color_modified = 'guifg=#181818 guibg=#'.g:base16_gui0E.' gui=NONE ctermfg=234 ctermbg='.g:base16_cterm0E.' cterm=NONE'
		let g:NeatStatusLine_color_filetype = 'guifg=#181818 guibg=#'.g:base16_gui0C.' gui=bold ctermfg=234 ctermbg='.g:base16_cterm0C.' cterm=bold'
	endfunction

	augroup on_change_colorschema
		autocmd!
		autocmd ColorScheme * call s:base16_customize()
	augroup END

	" call s:base16_customize()
	" calling function doesn't work but quickly switching themes back and forth does?
	colorscheme ron
	colorscheme base16-$BASE16_THEME
endif

"--- nerdcommenter ---"
let g:NERDSpaceDelims = 1
" let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'both'
let g:NERDCustomDelimiters = { 'python': { 'left': '#' } }
" let g:NERDCommentEmptyLines = 1

"--- indentLine ---"
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '·'

"--- suda.vim ---"
if v:version >= 800
	command! SW w suda://%
	command! SWQ wq suda://%
	command! SX x suda://%
else
	command! SW w !sudo tee > /dev/null %
	command! SWQ wq !sudo tee > /dev/null %
	command! SX x !sudo tee > /dev/null %
endif

"--- syntastic ---"
" let makeprg = self.makeprgBuild({
"		  \ "exe": self.getExec(),
"		  \ "args": "-a -b -c",
"		  \ "fname": shellescape(expand("%", 1)),
"		  \ "post_args": "--more --args",
"		  \ "tail": "2>/dev/null" })
if IsPlugLoaded('syntastic')
	noremap <leader>g :SyntasticCheck<Cr>
endif

let g:syntastic_error_symbol = '->'
let g:syntastic_warning_symbol = '>-'
let g:syntastic_style_error_symbol = '-<'
let g:syntastic_style_warning_symbol = '-<'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" let g:syntastic_c_compiler = 'clang'
" let g:syntastic_cpp_compiler = 'clang++'
" let g:syntastic_c_include_dirs = ['includes', 'headers']
let g:syntastic_c_check_header = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_tex_checkers = []
let g:syntastic_vim_checkers = ['vint']

"--- syntastic-extras ---"
" let g:syntastic_json_checkers = ['json_tool']
" let g:syntastic_make_checkers = ['gnumake']
let g:syntastic_c_checkers = ['check']
let g:syntastic_cpp_checkers = ['check']
let g:syntastic_c_config_file = '.ccargs'
let g:syntastic_cpp_config_file = '.ccargs'

"--- vim-autoformat ---"
if IsPlugLoaded('vim-autoformat')
	noremap <leader>f :Autoformat<Cr>
endif

let g:formatdef_latexindent = '"latexindent -g /dev/null -"'
" let g:formatdef_clang_java = ''
let g:formatters_java = ['clangformat', 'astyle_java']

let g:formatdef_luaformat = '"lua-format -c ~/.lua-format "'
let g:formatters_lua = ['luaformat']

let g:formatdef_jq = '"jq --tab . "'
let g:formatters_json = ['jq']

let g:formatters_python = ['yapf']

"--- JavaDecompiler.vim ---"
let g:javad_cmd = 'cfr'

"--- vimtex ---"
filetype plugin indent on
let g:tex_flavor = 'latex'
let g:tex_conceal = ''
let g:vimtex_view_general_viewer = 'okular'

"--- rust.vim ---"
augroup rust_conf
	autocmd!
	if IsPlugLoaded('rust.vim')
		autocmd FileType rust  | nnoremap <leader>f :RustFmt<Cr>
	endif
augroup END

"--- omnisharp-vim ---"
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_use_mono = 1
let g:syntastic_cs_checkers = ['code_checker']
augroup omnisharp_conf
	autocmd!
	autocmd FileType cs if IsPlugLoaded('omnisharp-vim') | nnoremap <leader>f :OmniSharpCodeFormat<Cr> | endif
	autocmd FileType cs if IsPlugLoaded('omnisharp-vim') | nnoremap <leader>d :OmniSharpDocumentation<Cr> | endif
augroup END

"--- vim-ros ---"
let g:ros_disable_warnings = 1
let g:formatters_roslaunch = ['htmlbeautify']
augroup ros_syntax
	autocmd!
	autocmd BufRead,BufNewFile *.launch set filetype=roslaunch
	autocmd BufRead,BufNewFile *.msg set filetype=rosmsg
	autocmd BufRead,BufNewFile *.srv set filetype=rossrv
augroup END

"--- vim-javacomplete2 ---"
let g:JavaComplete_AutoStartServer = 0

augroup javacomplete_conf
	autocmd!
	autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup END

function! StartJavaServer()
	execute 'JCstart'
	let g:syntastic_java_javac_classpath = javacomplete#server#GetClassPath()
	execute 'SyntasticCheck'
endfunction
command! JCRun call StartJavaServer()

nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Esc><Plug>(JavaComplete-Imports-AddSmart)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Esc><Plug>(JavaComplete-Imports-Add)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Esc><Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Esc><Plug>(JavaComplete-Imports-RemoveUnused)
" let g:JavaComplete_EnableDefaultMappings = 0
" nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
" nmap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
" nmap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
" nmap <leader>jii <Plug>(JavaComplete-Imports-Add)
" imap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
" imap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
" imap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
" imap <C-j>ii <Plug>(JavaComplete-Imports-Add)
" nmap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)
" imap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)
" nmap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
" nmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
" nmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
" nmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
" nmap <leader>jts <Plug>(JavaComplete-Generate-ToString)
" nmap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
" nmap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
" nmap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)
" imap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
" imap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
" imap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
" vmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
" vmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
" vmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
" nmap <silent> <buffer> <leader>jn <Plug>(JavaComplete-Generate-NewClass)
" nmap <silent> <buffer> <leader>jN <Plug>(JavaComplete-Generate-ClassInFile)

" --- neosnippet.vim ---"
" let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'
let mapreturn = "\<Plug>(neosnippet_expand)"
imap <C-d> <Plug>(neosnippet_expand_or_jump)
smap <C-d> <Plug>(neosnippet_expand_or_jump)
xmap <C-d> <Plug>(neosnippet_expand_target)

"--- vim-lsp ---"
let g:lsp_diagnostics_enabled = 0
if v:version > 800
	let g:lsp_settings = {
				\  'omnisharp': {'disabled': v:true},
				\  'eclipse-jdt-ls': {'disabled': v:true},
				\  'vim-language-server': {'disabled': v:true},
				\  'texlab': {'disabled': v:true}
				\}
else
	let g:lsp_settings = {
				\  'omnisharp': {'disabled': 1},
				\  'eclipse-jdt-ls': {'disabled': 1},
				\  'vim-language-server': {'disabled': 1},
				\  'texlab': {'disabled': 1}
				\}
endif
if (OS ==? 'Ubuntu')
	" let g:ncm2_pyclang#library_path = '/usr/lib/llvm-9/lib/libclang.so.1'
	let g:lsp_settings.clangd = {'cmd': ['clangd-9']}
endif

"--- asyncomplete.vim ---"
let g:asyncomplete_auto_completeopt = 0
try
	set completeopt+=noselect
catch
	let g:asyncomplete_auto_popup = 0
endtry

if IsPlugLoaded('asyncomplete.vim')
	imap <C-f> <Plug>(asyncomplete_force_refresh)
	inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
endif

augroup asyncomplete_conf
	autocmd!
augroup END
if IsPlugLoaded('asyncomplete-buffer.vim')
	autocmd asyncomplete_conf User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
				\ 'name': 'buffer',
				\ 'whitelist': ['*'],
				\ 'blacklist': ['go'],
				\ 'completor': function('asyncomplete#sources#buffer#completor'),
				\ 'config': { 'max_buffer_size': 5000000 }
				\ }))
endif
if IsPlugLoaded('asyncomplete-file.vim')
	autocmd asyncomplete_conf User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
				\ 'name': 'file',
				\ 'whitelist': ['*'],
				\ 'priority': 2,
				\ 'completor': function('asyncomplete#sources#file#completor')
				\ }))
endif
if IsPlugLoaded('asyncomplete-neosnippet.vim')
	autocmd asyncomplete_conf User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
				\ 'name': 'neosnippet',
				\ 'whitelist': ['*'],
				\ 'priority': 1,
				\ 'completor': function('asyncomplete#sources#neosnippet#completor'),
				\ }))
endif
if IsPlugLoaded('asyncomplete-omni.vim')
	autocmd asyncomplete_conf User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
				\ 'name': 'omni',
				\ 'whitelist': ['tex'],
				\ 'blacklist': ['c', 'cpp', 'html'],
				\ 'completor': function('asyncomplete#sources#omni#completor')
				\  }))
endif

function! s:sort_by_priority_preprocessor(options, matches) abort
	let l:items = []
	for [l:source_name, l:matches] in items(a:matches)
		for l:item in l:matches['items']
			if stridx(l:item['word'], a:options['base']) == 0
				let l:item['priority'] = get(asyncomplete#get_source_info(l:source_name),'priority',0)
				call add(l:items, l:item)
			endif
		endfor
	endfor
	let l:items = sort(l:items, {a, b -> a['priority'] - b['priority']})
	call asyncomplete#preprocess_complete(a:options, l:items)
endfunction
let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]
