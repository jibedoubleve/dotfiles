" --- Core Settings ---
" Enable filetype detection, plugin loading, and indentation rules
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Show hybrid line numbers (absolute for current line, relative for others)
set nu rnu

" Enable mouse support in all modes
set mouse=a

" --- Visuals & Status Bar ---
" Handle colours
set termguicolors

" Force the status line to always be visible (2 = always)
set laststatus=2

" Ensure the status line displays information even without a plugin
set showmode
set showcmd

" Apply the Catppuccin theme
" Note: If you use a plugin manager, ensure 'catppuccin/vim' is installed
colorscheme catppuccin_mocha

" --- XAML Configuration ---
" Associate .xaml files with the XML filetype for syntax highlighting
autocmd BufNewFile,BufRead *.xaml set filetype=xml

" Set indentation for XML/XAML files to 2 spaces
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 expandtab

" --- Netrw (File Explorer) Configuration ---
" Netrw configuration for a lateral sidebar
let g:netrw_banner = 0          " Remove the help banner at the top
let g:netrw_liststyle = 3       " Display files in a tree-like view
let g:netrw_browse_split = 4    " Open files in the previously active window
let g:netrw_altv = 1            " Open the sidebar on the left side
let g:netrw_winsize = 25        " Set sidebar width to 25% of the screen

" Toggle the file explorer with Ctrl+n
nnoremap <silent> <C-n> :Lexplore<CR>
