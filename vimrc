" note: 
"
"    the philosophy of this vimrc is defer to the _right_ plugins.
"    in many cases, this means tpope plugins, with exceptions.
"    one exception is using Plug instead of Pathogen, because it's
"    simpler for me to use at this time. I can drop this vimrc anywhere,
"    and get all of my plugins by running "PlugInstall".
"
"    Once I learn git submodules, 
"    I may want to switch to Pathogen.

"""""""""""""""""""""""""""""""""""""""""""""""""
" Doug's additions
"""""""""""""""""""""""""""""""""""""""""""""""""

" space is your leader.
let mapleader="\<Space>"

" make clipboard register work for pasting outside vim
set clipboard=unnamed

" dark background
set background=dark

" fix highlighting in visual mode (set to 256 colors)
set t_Co=256

" Automatically create folds based on indent
set foldmethod=indent

" Disable folds by default
set nofoldenable

" Don't wrap searches
" set nowrapscan

" remap 'Y' as suggested in :help
nmap Y y$

" visual-search (as suggested in :help)
vmap X y/<C-R>"<CR>

" enable mouse features in all modes
set mouse=a

" mouse scroll two lines at a time
map <ScrollWheelUp> <C-Y><C-Y>
map <ScrollWheelDown> <C-E><C-E>

" ESC with jk
imap jk 

" make vim recognize markdown files based on .md extension
autocmd BufNewFile,BufRead *.md set filetype=markdown

" set up markdown fold markers
function MakeFoldsMarkdown ()
    silent set foldmethod=marker
    silent keepp %s/ <!--{{{[0-9]-->$//e
    silent keepp %s/^# .*[^>]$/& <!--{{{1-->/e
    silent keepp %s/^## .*[^>]$/& <!--{{{2-->/e
    silent keepp %s/^### .*[^>]$/& <!--{{{3-->/e
    silent keepp %s/^#### .*[^>]$/& <!--{{{4-->/e
    silent keepp %s/^##### .*[^>]$/& <!--{{{5-->/e
    silent keepp %s/^###### .*[^>]$/& <!--{{{6-->/e
endfunction
command MFMarkdown call MakeFoldsMarkdown()

" manual indentation override
function IndentSpaces(numspaces)
silent setlocal expandtab
silent exec "setlocal shiftwidth=".a:numspaces
silent exec "setlocal softtabstop=".a:numspaces
endfunction
command Indent4 call IndentSpaces(4)
command Indent2 call IndentSpaces(2)

" like ':!', but uses ':term'
function! Bang(cmd)
  let l:escaped=substitute(a:cmd, '"', '\\"', 'g')
  " use `shellescape` ?
  " let l:escaped=shellescape(a:cmd)
  " echo l:escaped
  exe 'term '.&shell.' -c "'.l:escaped.'"'
endfunction
command! -nargs=+ Bang call Bang(<q-args>)

" see commands directly defined in this vimrc
command MyCommands !awk '$1~/^command\!?$/ {$1=""; $0=$0; print $0}' <~/.vimrc

" lint php on save, integrate with quickfix
autocmd! FileType php
autocmd! BufEnter,BufWritePost *.php
autocmd FileType php setlocal makeprg=php\ -ln\ %
autocmd FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l
autocmd BufEnter *.php setlocal makeprg=php\ -ln\ %
autocmd BufEnter *.php setlocal errorformat=%m\ in\ %f\ on\ line\ %l
autocmd BufWritePost *.php sil! make | cwindow | redraw!

" terminal-related stuff
" tnoremap <Esc> <C-W>N
tnoremap jk <C-W>N
set timeout ttimeout timeoutlen=500


" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
"    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute '!mkdir -p ~/.vim/autoload'
    execute '!wget https://raw.github.com/junegunn/vim-plug/master/plug.vim -O ~/.vim/autoload/plug.vim'
endif

" Ensure help files are recognized as help files on restoring session
function! SetupEnvironment()
    let l:path = expand('%:p')
    if ( l:path =~ '/home/.*/\.vim/plugged/.*/doc/.*\.txt' ) || ( l:path =~ '/usr/share/vim/vim74/doc/.*\.txt' )
        set filetype=help buftype=help readonly syntax=help
    endif
endfunction
autocmd! SessionLoadPost * call SetupEnvironment() " ,BufReadPost,BufNewFile

""""""""""""""
" Plugins
""""""""""""""

" enable man.vim
runtime! ftplugin/man.vim

" begin Plug-managed plugins
call plug#begin()

" Surround -- key-bindings for surrounding stuff
Plug 'tpope/vim-surround'

" delimitMate -- auto insert closing paren/bracket/etc
Plug 'Raimondi/delimitMate'
au FileType m4 let b:delimitMate = 0

" sneak -- multiline, 2 letter find
Plug 'justinmk/vim-sneak'

" Vinegar -- netrw enhancements (basic dir listing)
Plug 'tpope/vim-vinegar'

" Dispatch -- asynchronous operation via tmux
Plug 'tpope/vim-dispatch'

" Tbone -- tmux integrations
Plug 'tpope/vim-tbone'

" Fugitive -- git integration
Plug 'tpope/vim-fugitive'

" Eunuch -- Unix shell commands
Plug 'tpope/vim-eunuch'

" Sensible -- sensible defaults
Plug 'tpope/vim-sensible'

" Unimpaired -- complementary key-bindings
Plug 'tpope/vim-unimpaired'
    " add unimpaired-esque bindings to toggle (no)foldenable
    nnoremap [oz :setlocal foldenable<CR>
    nnoremap ]oz :setlocal nofoldenable <CR>
    nnoremap coz :setlocal <C-R>=&foldenable ? 'nofoldenable' : 'foldenable'<CR><CR>
    " add unimpaired-esque bindings to toggle mouse
    nnoremap [om :set mouse=a<CR>
    nnoremap ]om :set mouse=<CR>
    nnoremap com :set mouse=<C-R>=&mouse == 'a' ? '' : 'a'<CR><CR>

" Sleuth -- auto indentation
Plug 'tpope/vim-sleuth'

" Commentary -- key-bindings for (un)commenting lines
Plug 'tpope/vim-commentary'

" Repeat -- extends using '.' to repeat custom commands
Plug 'tpope/vim-repeat'

" CtrlP -- fuzzy finder
" Plug 'ctrlpvim/ctrlp.vim'
"     " Scan for dotfiles and dotdirs
"     let g:ctrlp_show_hidden = 1

" fzf.vim -- fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
" Plug '/home/doug/go/src/github.com/junegunn/fzf'
Plug 'junegunn/fzf.vim'

nnoremap <C-P> :Files %:h<CR>
autocmd FileType netrw nnoremap <buffer> <C-P> :Files %<CR>

" Vimux -- run commands in nearby tmux pane
Plug 'dkrieger/vimux'
    " Prompt for a command to run
    map <Leader>vp :VimuxPromptCommand<CR>

    " Run last command executed by VimuxRunCommand
    map <Leader>vl :VimuxRunLastCommand<CR>

    " Inspect runner pane
    map <Leader>vi :VimuxInspectRunner<CR>

    " Close vim tmux runner opened by VimuxRunCommand
    map <Leader>vq :VimuxCloseRunner<CR>

    " Interrupt any command running in the runner pane
    map <Leader>vx :VimuxInterruptRunner<CR>

    " Zoom the runner pane (use <bind-key> z to restore runner pane)
    map <Leader>vz :call VimuxZoomRunner()<CR>

    " Always run split-window instead of using nearest pane
    let VimuxUseNearest = 0

    " Use last pane as runner
    let g:VimUseLast = 1

    " Run current file with nodejs
    map <Leader>js :VimuxRunCommand("clear; nodejs " . bufname("%"))<CR>

" vim-tmux-navigator -- navigate tmux/vim windows seamlessly with C-h/j/k/l
Plug 'christoomey/vim-tmux-navigator'

    "" NERDTree -- full tree dir listing
        "Plug 'scrooloose/nerdtree'
        ""nmap <C-n> :NERDTreeToggle <CR>
        "" ^ commented out to encourage split explorer workflow
        "let NERDTreeHijackNetrw=1

    tnoremap <silent> <C-k> <C-W>:TmuxNavigateUp<cr>
    tnoremap <silent> <C-l> <C-W>:TmuxNavigateRight<cr>
    tnoremap <silent> <C-j> <C-W>:TmuxNavigateDown<cr>
    tnoremap <silent> <C-h> <C-W>:TmuxNavigateLeft<cr>

" vim-colorscheme -- collection of useful vim colorscheme files
Plug 'dkrieger/vim-colorscheme'

" jq.vim -- Syntax highlighting for jq script files
Plug 'vito-c/jq.vim'

" Plug 'vim-airline/vim-airline'
"     let g:airline_powerline_fonts = 1

" vim-go -- Go development plugin for vim
Plug 'fatih/vim-go', { 'tag': 'v1.18'}

" gocode wasn't finding parts of my libs
let g:go_info_mode = 'guru'
au FileType go nmap <leader>i <Plug>(go-info)
au FileType go nmap <leader>v <Plug>(go-vet)

" DrawIt -- Ascii drawing plugin: lines, ellipses, arrows, fills, and more!
Plug 'vim-scripts/DrawIt'

" end Plug-managed plugins
call plug#end()

" ==== ultra-minimal ====

imap jk 
runtime ftplugin/man.vim
let g:ft_man_open_mode = 'vert'
set laststatus=2

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
