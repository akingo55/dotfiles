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
opt.ignorecase = true
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

vim.opt.clipboard:append({ "unnamedplus" }) -- Use system clipboard


-- HTML autocomplete
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "xml" },
  callback = function()
    vim.keymap.set("i", "</", "</<C-x><C-o>", { buffer = true, noremap = true })
  end,
})

-- Show zenkaku space / highlight line number
vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter", "WinEnter", "BufRead"}, {
  callback = function()
    vim.cmd([[highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray]])
    vim.fn.matchadd("ZenkakuSpace", "　")
    vim.api.nvim_set_hl(0, "LineNr", { ctermfg = 205 })
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
vim.keymap.set("n", "<C-b>", "<cmd>bprevious<CR>")

-- fzf-lua key mappings
vim.keymap.set('n', '<leader>f', "<cmd>lua require('fzf-lua').files()<CR>")
vim.keymap.set('n', '<leader>g', "<cmd>lua require('fzf-lua').grep({search_dirs = { vim.fn.expand('%:p:h') }})<CR>")
vim.keymap.set('n', '<leader>j', "<cmd>lua require('fzf-lua').lsp_definitions()<CR>")

-- lazy.nvim 初期化
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
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
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "ruby", "lua", "html", "javascript", "typescript", "json", "css", "yaml", "bash", "dockerfile" },
        highlight = { enable = true },
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
      -- 1. 補完のための共通設定を定義
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 2. vim.lsp.config で設定をカスタマイズ (従来の .setup{} に相当)
      -- Ruby
      vim.lsp.config('ruby_lsp', {
        cmd = { "ruby-lsp" },
        filetypes = { "ruby" },
        root_markers = { "Gemfile", ".git" },
        capabilities = capabilities,
        init_options = {
          formatting = "auto",
        },
      })

      -- Terraform
      vim.lsp.config('terraformls', {
        filetypes = { "terraform", "tfvars" },
        capabilities = capabilities,
      })

      -- YAML
      vim.lsp.config('yamlls', {
        filetypes = { "yaml" },
        root_markers = { ".git" },
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              kubernetes = "/*.yaml",
            },
          },
        },
      })

      -- TypeScript / JavaScript
      vim.lsp.config('ts_ls', {
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_markers = { "tsconfig.json", "package.json", ".git" },
        capabilities = capabilities,
      })

      -- 3. vim.lsp.enable でサーバーを有効化 (これが起動のスイッチ)
      vim.lsp.enable('ruby_lsp')
      vim.lsp.enable('terraformls')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('yamlls')
    end
  },
  -- neovim用補完
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
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
            html = { 'htmlhint' },
            terraform = { 'tflint' },
            typescript = { 'eslint' },
            javascript = { 'eslint' },
        }
    end
  },
  -- diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>d", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
      { "<leader>ds", "<cmd>Trouble symbols toggle<CR>", desc = "Symbols" },
    },
    opts = {},
  },
  -- git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 500,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end
          map("n", "]c", gs.next_hunk, "Next hunk")
          map("n", "[c", gs.prev_hunk, "Prev hunk")
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", gs.blame_line, "Blame line")
        end,
      })
    end,
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
          dotfiles = false,  -- ドットファイルを表示
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
    lazy = false,
    config = function()
      -- Copilot の設定
      vim.g.copilot_no_tab_map = true -- Tab キーのマッピングを無効化
      vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Accept("<CR>")', {
        expr = true,
        noremap = true,
        silent = true,
      })
    end,
  }
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

