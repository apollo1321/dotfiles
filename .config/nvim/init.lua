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
opt.laststatus = 3
opt.cursorline = true
opt.scrolloff = 8

-- [[ Other ]]

opt.clipboard = 'unnamedplus' 
opt.fixeol = true
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
opt.mouse = nil
opt.signcolumn = "yes"

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- [[ Functions ]]

function map(mode, lhs, rhs, opts)
  if opts then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.keymap.set(mode, lhs, rhs, {noremap = true})
  end
end

-- [[ Plugins ]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use) 
  use {'nvim-treesitter/nvim-treesitter', 
    run = function() 
      require('nvim-treesitter.install').update({ with_sync = true }) 
    end
  }
  use {'wbthomason/packer.nvim'}
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
  use {"ellisonleao/glow.nvim"}
  use {"simrat39/rust-tools.nvim"}
  use {"kyazdani42/nvim-tree.lua", requires = 'kyazdani42/nvim-web-devicons'}

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- [[ Plugins setup]]

vim.cmd [[colorscheme nordfox]]

require("nightfox").setup({
  options = {
    modules = {
      cmp = true,
      gitsigns = true,
      telescope = true,
      native_lsp = {
        enable = true,
      },
      treesitter = true,
      nvimtree = true,
    }
  },
  groups = {
    all = {
      WinSeparator = {
        fg = "palette.bg4"
      },
      TerminalNormal = {
        bg = "palette.bg0"
      },
    }
  }
})

require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    offsets = {{
      filetype = "NvimTree",
      text = "NvimTree",
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

require('lualine').setup({ 
  sections = {
    lualine_c = {"%F"}
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
    ['<CR>'] = cmp.mapping.confirm(),
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
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered() 
  }  
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

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, buffer=bufnr }
  map('n', 'gD', vim.lsp.buf.declaration, bufopts)
  map('n', 'gd', vim.lsp.buf.definition, bufopts)
  map('n', 'H', vim.lsp.buf.hover, bufopts)
  map('n', '<A-r>', vim.lsp.buf.rename, bufopts)
  map('n', '<A-a>', vim.lsp.buf.code_action, bufopts)
  map('n', 'gr', vim.lsp.buf.references, bufopts)
  map('n', '<A-f>', vim.lsp.buf.formatting, bufopts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = require("lspconfig").util.root_pattern(".root") 
  },
  inlay_hints = {
    right_align = true
  }
}

require("rust-tools").setup {
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      }
    },
    capabilities = capabilities,
    on_attach = on_attach
  },
  tools = {
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
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

require('telescope').setup()

require('glow').setup({
  border = "rounded"
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

require('lspconfig.ui.windows').default_options.border = 'single'

require('nvim-tree').setup({
  view = {
    width = "20%"
  },
  renderer = {
    symlink_destination = false
  }
})

-- [[ Maps ]]

map("i", "jj", "<Esc>")
map("", "<Left>", "<cmd>echoe 'Use h'<CR>")
map("", "<Right>", "<cmd>echoe 'Use l'<CR>")
map("", "<Up>", "<cmd>echoe 'Use k'<CR>")
map("", "<Down>", "<cmd>echoe 'Use j'<CR>")
map("t", "<Esc>", "<C-\\><C-N>")
map("t", "jj", "<C-\\><C-N>")
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>")
map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').resume()<CR>")
map("n", "<leader>bf", "<cmd>lua require('close_buffers').delete({type = 'this', force = true})<CR>")
map("n", "<leader>bc", "<cmd>lua require('close_buffers').delete({type = 'this'})<CR>")
map("n", "<leader>bh", "<cmd>lua require('close_buffers').delete({type = 'nameless', force = true})<CR>")
map("n", "<C-t>", "<cmd>split | term<CR><cmd>res 15<CR> i")
map('n', '<A-e>', vim.diagnostic.show)
map('n', '<A-d>', vim.diagnostic.hide)
map('n', '<A-p>', '"0p')
map('v', '<A-p>', '"0p')

map("n", "gsp", "<cmd>Gitsigns preview_hunk<CR>")
map("n", "gsa", "<cmd>Gitsigns stage_hunk<CR>")

map('n', '<A-s>', '<cmd>w<CR>')
map('n', '<A-h>', '<cmd>lua vim.diagnostic.open_float({ border = "rounded"})<CR>')

map("n", "<C-p>", "<cmd>bp<CR>")
map("n", "<C-n>", "<cmd>bn<CR>")
map("t", "<C-p>", "<C-\\><C-N><cmd>bp<CR>")
map("t", "<C-n>", "<C-\\><C-N><cmd>bn<CR>")

map("n", "<A-b>", "<cmd>NvimTreeToggle<CR>")
map("n", "|", "<cmd>NvimTreeFindFile<CR>")
map("t", "<A-b>", "<C-\\><C-N><cmd>NvimTreeToggle<CR>")

map("t", "<C-h>", "<C-\\><C-N><C-w>h")
map("t", "<C-j>", "<C-\\><C-N><C-w>j")
map("t", "<C-k>", "<C-\\><C-N><C-w>k")
map("t", "<C-l>", "<C-\\><C-N><C-w>l")
map("i", "<C-h>", "<C-\\><C-N><C-w>h")
map("i", "<C-j>", "<C-\\><C-N><C-w>j")
map("i", "<C-k>", "<C-\\><C-N><C-w>k")
map("i", "<C-l>", "<C-\\><C-N><C-w>l")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

vim.cmd [[cnoreabbrev H vert bo h]]

-- [[ Events ]]

function set_terminal_highlight()
  vim.opt_local.winhighlight = "Normal:TerminalNormal"
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = set_terminal_highlight
})

