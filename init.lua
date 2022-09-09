-- [[ Search ]]
local opt = vim.opt
local g = vim.g

opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true
opt.number = true
opt.relativenumber = true

-- [[ Tabs ]]
opt.shiftwidth = 2
opt.tabstop = 2
opt.splitright = true
opt.smartindent = true
opt.expandtab = true 

-- [[ Other ]]
opt.clipboard = 'unnamedplus' 
opt.fixeol = true
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
opt.mouse = nil
g.material_style = "darker"

-- [[ Maps ]]
function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("i", "jj", "<Esc>")
map("n", "<C-b>", "<cmd>Neotree left toggle<CR>")
map("n", "|", "<cmd>Neotree reveal<CR>")
map("n", "<leader>s", "<cmd>Neotree float git_status<CR>")
map("n", "<C-n>", "<cmd>bn<CR>")
map("n", "<C-q>", "<cmd>bp<CR>")
map("", "<Left>", "<cmd>echoe 'Use h'<CR>")
map("", "<Right>", "<cmd>echoe 'Use l'<CR>")
map("", "<Up>", "<cmd>echoe 'Use k'<CR>")
map("", "<Down>", "<cmd>echoe 'Use j'<CR>")
map("t", "<Esc>", "<C-\\><C-N>h")

vim.cmd [[
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<C-j>'
let g:VM_maps["Add Cursor Up"] = '<C-k>'
]]

map("t", "<A-h>", "<C-\\><C-N><C-w>h")
map("t", "<A-j>", "<C-\\><C-N><C-w>j")
map("t", "<A-k>", "<C-\\><C-N><C-w>k")
map("t", "<A-l>", "<C-\\><C-N><C-w>l")
map("i", "<A-h>", "<C-\\><C-N><C-w>h")
map("i", "<A-j>", "<C-\\><C-N><C-w>j")
map("i", "<A-k>", "<C-\\><C-N><C-w>k")
map("i", "<A-l>", "<C-\\><C-N><C-w>l")
map("n", "<A-h>", "<C-w>h")
map("n", "<A-j>", "<C-w>j")
map("n", "<A-k>", "<C-w>k")
map("n", "<A-l>", "<C-w>l")

vim.cmd [[cnoreabbrev H vert bo h]]

-- [[ Plugins ]]
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use) 
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'wbthomason/packer.nvim'}
  use {'nvim-neo-tree/neo-tree.nvim', 
    requires = {
      'kyazdani42/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim'
    },
    branch = "v2.x"
  }
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons', tag = "v2.*"}
  use {'EdenEast/nightfox.nvim'}
  use {'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use {'neovim/nvim-lspconfig'}
  use {'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp'
    },
  }
  use {"lukas-reineke/indent-blankline.nvim"}
  use {"sbdchd/neoformat"}
  use {"tpope/vim-commentary"}
  use {"mg979/vim-visual-multi"}
end)

-- [[ Plugins setup]]
require("nvim-web-devicons").setup()

require("neo-tree").setup()

require("bufferline").setup({
  options = {
    offsets = {{
      filetype = "neo-tree",
      text = "File Explorer",
      highlight = "Directory",
      text_align = "center",
      separator = true
    }}
  }
})

vim.cmd [[colorscheme nordfox]]

require('lualine').setup({ 
  options = {
    disabled_filetypes = {
      statusline = {"neo-tree"},
      winbar = {}
    },
  }
})

require('nvim-treesitter.configs').setup{
  highlight = {
    enable = true
  }
}

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ["<C-q>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require('lspconfig').clangd.setup{
  cmd = {"clangd"},
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}

