
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
opt.splitbelow = true
opt.smartindent = true
opt.expandtab = true 

-- [[ Other ]]
opt.clipboard = 'unnamedplus' 
opt.fixeol = true
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
opt.mouse = nil
opt.signcolumn = "yes"
g.material_style = "darker"

-- [[ Functions ]]
function map(mode, lhs, rhs, opts)
  if opts then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.keymap.set(mode, lhs, rhs, {noremap = true})
  end
end

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
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp'
    },
  }
  use {"lukas-reineke/indent-blankline.nvim"}
  use {"tpope/vim-commentary"}
  use {"kazhala/close-buffers.nvim"}
  use {"windwp/nvim-autopairs"}
  use {"lewis6991/gitsigns.nvim"}
  use {"nvim-telescope/telescope.nvim", tag = "0.1.0", requires = 'nvim-lua/plenary.nvim'}
  use {"p00f/clangd_extensions.nvim"}
end)

-- [[ Plugins setup]]
require("neo-tree").setup({
  source_selector = {
    statusline = true
  },
  view = {
    adaptive_size = true
  }
})

require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    offsets = {{
      filetype = "neo-tree",
      text = "File Explorer",
      highlight = "Directory",
      text_align = "center",
      separator = true
    }}
  }
})

require('close_buffers').setup({
  preserve_window_layout = { 'this' },
  next_buffer_cmd = function(windows)
    require('bufferline').cycle(1)
    local bufnr = vim.api.nvim_get_current_buf()

    for _, window in ipairs(windows) do
      vim.api.nvim_win_set_buf(window, bufnr)
    end
  end,
})

vim.cmd [[colorscheme nightfox]]

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

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'vsnip'},
  }, {
    {name = 'buffer'},
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<A-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
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

require("clangd_extensions").setup {
  server = {
    cmd = {
      "clangd", 
      "--header-insertion=never",
      "--background-index",
      "--clang-tidy",
      "-j=4",
      "--inlay-hints"
    },
    filetypes = { "c", "cpp" },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client, bufnr)
      local bufopts = { noremap=true, buffer=bufnr }
      map('n', 'gD', vim.lsp.buf.declaration, bufopts)
      map('n', 'gd', vim.lsp.buf.definition, bufopts)
      map('n', 'H', vim.lsp.buf.hover, bufopts)
      map('n', '<A-r>', vim.lsp.buf.rename, bufopts)
      map('n', '<A-a>', vim.lsp.buf.code_action, bufopts)
      map('n', 'gr', vim.lsp.buf.references, bufopts)
      map('n', '<A-f>', vim.lsp.buf.formatting, bufopts)
    end,
    root_dir = require("lspconfig").util.root_pattern(".root") 
  },
  inlay_hints = {
    right_align = true
  }
}

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}

require("nvim-autopairs").setup()

cmp.event:on(
  'confirm_done',
  require('nvim-autopairs.completion.cmp').on_confirm_done()
)

require('gitsigns').setup()

require('telescope').setup{}

-- [[ Maps ]]
map("i", "jj", "<Esc>")
map("n", "<A-b>", "<cmd>Neotree left toggle<CR>")
map("n", "|", "<cmd>Neotree reveal<CR>")
map("n", "<leader>s", "<cmd>Neotree float git_status<CR>")
map("", "<Left>", "<cmd>echoe 'Use h'<CR>")
map("", "<Right>", "<cmd>echoe 'Use l'<CR>")
map("", "<Up>", "<cmd>echoe 'Use k'<CR>")
map("", "<Down>", "<cmd>echoe 'Use j'<CR>")
map("t", "<Esc>", "<C-\\><C-N>h")
map("n", "<leader>ff", "<cmd>lua require('close_buffers').delete({type = 'this', force = true})<CR>")
map("n", "<leader>c", "<cmd>lua require('close_buffers').delete({type = 'this'})<CR>")
map("n", "<leader>h", "<cmd>lua require('close_buffers').delete({type = 'nameless', force = true})<CR>")
map("n", "<C-t>", "<cmd>split | term<CR><cmd>res 15<CR> i")
map('n', '<A-e>', vim.diagnostic.show)
map('n', '<A-d>', vim.diagnostic.hide)
map('n', '<A-p>', '"0p')
map('v', '<A-p>', '"0p')

map("n", "<C-p>", "<cmd>bp<CR>")
map("n", "<C-n>", "<cmd>bn<CR>")

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

