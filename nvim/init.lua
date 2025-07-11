-- ~/.config/nvim/init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Set options
local opt = vim.opt
opt.encoding = "utf-8"
opt.swapfile = false
opt.ruler = true
opt.cmdheight = 2
opt.laststatus = 2
opt.title = true
opt.wildmenu = true
opt.showcmd = true
opt.smartcase = true
opt.hlsearch = true
opt.background = "dark"
opt.expandtab = true
opt.incsearch = true
opt.hidden = true
opt.list = true
opt.listchars = { tab = "> ", extends = "<" }
opt.number = true
opt.showmatch = true
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smarttab = true
opt.whichwrap = "b,s,h,l,<,>,[,]"
opt.backspace = { "indent", "eol", "start" }
opt.fileformats = { "unix", "dos", "mac" }
opt.fileencodings = { "utf-8", "sjis" }

vim.cmd([[syntax on]])
vim.cmd([[filetype plugin indent on]])

-- Set runtime path
vim.opt.rtp:append("/opt/homebrew/opt/fzf")

-- Highlight line number
vim.cmd([[highlight LineNr ctermfg=205]])

vim.opt.clipboard:append({ "unnamedplus" }) -- Use system clipboard

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- HTML autocomplete
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "xml" },
  callback = function()
    vim.keymap.set("i", "</", "</<C-x><C-o>", { buffer = true, noremap = true })
  end,
})

-- Show zenkaku space
vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter", "WinEnter", "BufRead"}, {
  callback = function()
    vim.cmd([[highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray]])
    vim.fn.matchadd("ZenkakuSpace", "　")
  end,
})

-- <Esc><Esc> で検索ハイライトを消す
vim.keymap.set('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>', { noremap = true, silent = true })

-- Insert mode mappings
vim.keymap.set("i", "{", "{}<Left>")
vim.keymap.set("i", "[", "[]<Left>")
vim.keymap.set("i", "(", "()<Left>")
vim.keymap.set("i", "\"", "\"\"<Left>")
vim.keymap.set("i", "'", "''<Left>")

-- buffer navigation
vim.keymap.set("n", "<C-n>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<C-b>", "<cmd>bnprev<CR>")

-- fzf-lua key mappings
vim.keymap.set('n', '<leader>f', "<cmd>lua require('fzf-lua').files()<CR>")
vim.keymap.set('n', '<leader>g', "<cmd>lua require('fzf-lua').grep({search_dirs = { vim.fn.expand('%:p:h') }})<CR>")
vim.keymap.set('n', '<leader>j', "<cmd>lua require('fzf-lua').lsp_definitions()<CR>")

-- lazy.nvim 初期化
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Plugin management using lazy.nvim
require("lazy").setup({
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
      }
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
    theme = 'gruvbox',
   }
      })
    end
  },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup()
    end
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2, -- the degree by which to darken terminal highlights
        start_in_insert = true,
        persist_size = true,
        direction = 'horizontal', -- 'vertical' | 'horizontal' | 'tab' | 'float'
      })
    end
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "ruby", "lua", "html", "javascript", "json", "css" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end
  },
  -- bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      vim.opt.termguicolors = true
      require("bufferline").setup{}
    end
  },
  { "tpope/vim-rails" },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      -- cmp と連携するための capabilities を取得
      local capabilities = cmp_nvim_lsp.default_capabilities()

      lspconfig.ruby_lsp.setup({
        cmd = { 'ruby-lsp' },
        filetypes = { "ruby" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        init_options = {
          formatting = "auto",
        },
        single_file_support = true,
        capabilities = capabilities,
      })
      --terraform-lsp の設定
      lspconfig.terraformls.setup({
        filetypes = { "terraform", "tfvars" },
        single_file_support = true,
        capabilities = capabilities,
      })
    end
  },
  -- neovim用補完
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "tpope/vim-endwise" },
  { "tomtom/tcomment_vim" },
  { "tpope/vim-surround" },
  { "bronson/vim-trailing-whitespace" },
  { "nathanaelkane/vim-indent-guides"},
  -- terraform
  {
    "hashivim/vim-terraform", config = function()
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_align = 1
    end
  },
  { "juliosueiras/vim-terraform-completion" },
  -- lint
  {
    'dense-analysis/ale',
    config = function()
        local g = vim.g

        g.ale_ruby_rubocop_auto_correct_all = 0
        g.ale_fix_on_save = 0
        g.ale_completion_enabled = 0

        g.ale_linters = {
            ruby = {'rubocop', 'ruby'},
            slim = { 'slim-lint' },
            lua = {'lua_language_server'},
            json = { 'jsonlint' },
            html = { 'htmlhint' }
        }
    end
  },
  -- colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
  -- tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- nvim-tree の設定
      require("nvim-tree").setup({
          sort = {
            sorter = "case_sensitive", -- ソート方法を大文字小文字を区別する
          },
          view = {
            width = 30, -- ツリーの幅
          },
          renderer = {
            group_empty = true, -- 空のディレクトリをグループ化
          },
        filters = {
          dotfiles = true,  -- ドットファイルを表示
        }
      })

      -- NERDTree と同じキーマップを設定
      -- <C-t> でツリーを開閉
      vim.keymap.set("n", "<C-t>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      -- <C-f> で現在のファイルをツリー内で表示（ツリーが開いていなければ開く）
      vim.keymap.set("n", "<C-f>", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
    end,
  },
  -- copilot
  {
    "github/copilot.vim",
    lazy=false,
    event = "InsertEnter",
    config = function()
      -- Copilot の設定
      vim.g.copilot_no_tab_map = true -- Tab キーのマッピングを無効化
      vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Accept("<CR>")', {
        expr = true,
        noremap = true,
        silent = true,
      })
    end,
  },
  -- neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec"
    },
    config = function()
      require("neotest").setup({
        output  = {
          open_on_run = true, -- テスト実行時に出力を開く
        },
        adapters = {
          require("neotest-rspec")( {
            rspec_cmd = function()
              return { "bundle", "exec", "rspec" }
            end,
          }),
        },
      })
      -- キーマップの設定
      vim.keymap.set("n", "<leader>tt", function()
        require("neotest").run.run()
      end, { noremap = true, silent = true, desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>to", function()
        require("neotest").output.open({ enter = true })
      end, { desc = "Open test output" })
    end
  }
})

-- cmp 設定
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
})

-- nvim-tree 自動起動
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- 起動時に無条件で nvim-tree を開く
    require("nvim-tree.api").tree.open()

    -- もしファイル引数がある場合は、ファイル側のウィンドウにフォーカスを移す
    -- (NERDTreeの時の wincmd p と同じ挙動を再現)
    if vim.fn.argc() > 0 or vim.g.std_in then
      vim.cmd("wincmd p")
    end
  end,
  desc = "Open nvim-tree on startup and focus file window",
})

-- nvim-tree が最後のウィンドウなら Neovim を終了する
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.fn.tabpagenr("$") == 1 and vim.fn.winnr("$") == 1 and vim.bo.filetype == "NvimTree" then
      -- 変更がある場合は確認を出す
      vim.cmd("confirm quit")
    end
  end,
  desc = "Quit Neovim if nvim-tree is the last window",
})

