scriptencoding utf-8
execute pathogen#infect()
call pathogen#helptags()
" ^^ Please leave the above line at the start of the file.

" Default configuration file for Vim
" $Id$

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
	set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
if v:lang =~? "^ko"
	set fileencodings=euc-kr
	set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
	set fileencodings=euc-jp
	set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
	set fileencodings=big5
	set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
	set fileencodings=gb2312
	set guifontset=*-r-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
	set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
	" If we have to add this, the default encoding is not Unicode.
	" We use this fact later to revert to the default encoding in plaintext/empty
	" files.
	let g:added_fenc_utf8 = 1
	set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
if &fileencodings !~? "default"
	set fileencodings+=default
endif
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
	set t_Sb=^[4%dm
	set t_Sf=^[3%dm
	set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
	" Set useful keys that vim doesn't discover via termcap but are in the
	" builtin xterm termcap. See bug #122562. We use exec to avoid having to
	" include raw escapes in the file.
	exec "set <C-Left>=\eO5D"
	exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
if isdirectory(expand("$VIMRUNTIME/ftplugin"))
	filetype plugin on

	" Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
	" indent settings. Some people don't like these, so we won't turn them on by
	" default.
	" filetype indent on
endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
	if executable("/bin/bash")
		set shell=/bin/bash
	elseif executable("/bin/sh")
		set shell=/bin/sh
	endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
	let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

	augroup gentoo
		au!

		" Gentoo-specific settings for ebuilds.  These are the federally-mandated
		" required tab settings.  See the following for more information:
		" http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
		" Note that the rules below are very minimal and don't cover everything.
		" Better to emerge app-vim/gentoo-syntax, which provides full syntax,
		" filetype and indent settings for all things Gentoo.
		au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
		au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

		" In text files, limit the width of text to 78 characters, but be careful
		" that we don't override the user's setting.
		autocmd BufNewFile,BufRead *.txt
					\ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
					\     setlocal textwidth=78 |
					\ endif

		" When editing a file, always jump to the last cursor position
		autocmd BufReadPost *
					\ if ! exists("g:leave_my_cursor_position_alone") |
					\     if line("'\"") > 0 && line ("'\"") <= line("$") |
					\         exe "normal g'\"" |
					\     endif |
					\ endif

		" When editing a crontab file, set backupcopy to yes rather than auto. See
		" :help crontab and bug #53437.
		autocmd FileType crontab set backupcopy=yes

		" If we previously detected that the default encoding is not UTF-8
		" (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
		" characters at all) isn't a Unicode file, but is in the default encoding.
		" Except of course if a byte-order mark is in effect.
		autocmd BufReadPost *
					\ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" &&
					\    ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
					\       set fileencoding= |
					\ endif

	augroup END

endif " has("autocmd")
" }}}

" {{{ vimrc.local
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif
" }}}

"fast window resizing with +/- keys (horizontal); / and * keys (vertical)
if bufwinnr(1)
	map <kPlus> <C-W>+
	map <kMinus> <C-W>-
	map <kDivide> <c-w><
	map <kMultiply> <c-w>>
endif


" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/.vimshell_hist',
			\ 'scheme' : $HOME.'/.gosh_completions'
			\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
let g:neocomplete#ctags_command = "ctags"
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
vnoremap // y/<C-R>"<CR>
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
	" For no inserting <CR> key.
	"return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
let g:neocomplete#enable_auto_select = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:airline_mode_map = {
			\ '__' : '-',
			\ 'n'  : 'N',
			\ 'i'  : 'I',
			\ 'R'  : 'R',
			\ 'c'  : 'C',
			\ 'v'  : 'V',
			\ 'V'  : 'V',
			\ '' : 'V',
			\ 's'  : 'S',
			\ 'S'  : 'S',
			\ '' : 'S',
			\ }
" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
map <F9> :NERDTreeToggle<CR>
filetype plugin indent on
set hidden
let g:airline_theme='base16_bright'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_inactive_collapse=1
let g:airline#extensions#syntastic#enabled = 1
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set softtabstop=4
set backspace=indent,eol,start
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set noerrorbells         " don't beep
set autoindent    " always set autoindenting on
set expandtab
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set fileformat=unix
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
set smarttab      " insert tabs on the start of a line according to
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set nocompatible
set clipboard=unnamedplus
set omnifunc=syntaxcomplete#Complete
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set mouse=a
set foldmethod=syntax
highlight ColorColumn ctermbg=1 guibg=lightgrey
call matchadd('ColorColumn', '\(\%80v\|\%100v\)', 100)
let g:Tex_Folding=0
let g:tex_flavor='latex'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
			\ "mode": "passive",
			\ "active_filetypes": [],
			\ "passive_filetypes": [] }
nnoremap <buffer> <LocalLeader>e :call EvinceNearestLabel()<CR>
