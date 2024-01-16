""""""""""""""""""""""""""""""
" 各種オプションの設定
""""""""""""""""""""""""""""""
set encoding=utf-8
" vimのランタイムパス（プラグイン等読み込むディレクトリ）
set rtp +=~/.vim
" swapファイル無効にする
set noswapfile
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" コマンドラインに使われる画面上の行数
set cmdheight=2
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" 入力中のコマンドを表示する
set showcmd
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索結果をハイライト表示する
set hlsearch
" 暗い背景色に合わせた配色にする
set background=dark
" タブ入力を複数の空白入力に置き換える
set expandtab
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden
" 不可視文字を表示する
set list
" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<
" 行番号を表示する
set number
" 対応する括弧やブレースを表示する
set showmatch
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" タブ文字の表示幅
set tabstop=2
" Vimが挿入するインデントの幅
set shiftwidth=2
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 構文毎に文字色を変化させる
syntax on
" filetype検出、filetype別プラグイン、インデントのロードを有効化
filetype plugin indent on
" カラースキーマの指定
colorscheme default
" 行番号の色
highlight LineNr ctermfg=205
"インサートモード中の BS、CTRL-W、CTRL-U による文字削除を柔軟にする
set backspace=indent,eol,start
"ctags対応
set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis

""""""""""""""""""""""""""""""
" 行末の空白文字をハイライト
""""""""""""""""""""""""""""""
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
  "html 補完
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

""""""""""""""""""""""""""""""
" 全角スペースの表示
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif

""""""""""""""""""""""""""""""
" insertモード
""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

" タブ補完を有効にする"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

""""""""""""""""""""""""""""""
" nomalモード
""""""""""""""""""""""""""""""
" tree表示を閉じる
nnoremap <C-t> :NERDTreeToggle<CR>
" 表示しているファイルの場所に移動する
nnoremap <C-f> :NERDTreeFind<CR>

" タブ移動
nmap <C-b> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" vimのステータスバー
Plug 'vim-airline/vim-airline'
" enable tabline
let g:airline#extensions#tabline#enabled = 1
" enable tabline number
let g:airline#extensions#tabline#buffer_idx_mode = 1
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = 'bubblegum'

" Rails向けのコマンドを提供する
Plug 'tpope/vim-rails'
Plug 'neoclide/coc.nvim', {'branch': 'develop'}
" Ruby向けにendを自動挿入してくれる
Plug 'tpope/vim-endwise'
" コメントON/OFFを手軽に実行(gcc)
Plug 'tomtom/tcomment_vim'
" シングルクオートとダブルクオートの入れ替え等(cs)
Plug 'tpope/vim-surround'
" インデントに色を付けて見やすくする
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
" 行末の半角スペースを可視化
Plug 'bronson/vim-trailing-whitespace'
" CSVをカラム単位に色分けする
Plug 'mechatroner/rainbow_csv'

"" terraform
Plug 'hashivim/vim-terraform'
" terraform fmtを自動で実行
let g:terraform_fmt_on_save = 1
" settingsを自動で整列させる
let g:terraform_align = 1
Plug 'juliosueiras/vim-terraform-completion'

"" Lint
Plug 'dense-analysis/ale'
let g:ale_completion_enabled = 1
let g:ale_disable_lsp = 1
let g:ale_lint_on_text_changed = 1
" JSONLintをALEで使うよう指定
let g:ale_linters = {
    \   'json': ['jsonlint'],
    \}

" ファイルをtree表示してくれる
Plug 'preservim/nerdtree'
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" 隠しファイルを表示する
let NERDTreeShowHidden = 1

call plug#end()
