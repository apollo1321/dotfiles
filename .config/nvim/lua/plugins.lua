local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup({ function(use)
  use { 'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end
  }

  use { "ellisonleao/glow.nvim" }
  use { "kazhala/close-buffers.nvim" }
  use { "kyazdani42/nvim-tree.lua" }
  use { "lukas-reineke/indent-blankline.nvim" }
  use { "nvim-telescope/telescope.nvim", tag = "0.1.0" }
  use { "p00f/clangd_extensions.nvim" }
  use { "simrat39/rust-tools.nvim" }
  use { "tpope/vim-commentary" }
  use { "windwp/nvim-autopairs" }
  use { 'EdenEast/nightfox.nvim' }
  use { 'akinsho/bufferline.nvim', tag = "v2.*" }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-cmdline' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-lualine/lualine.nvim' }
  use { 'ojroques/vim-oscyank' }
  use { 'wbthomason/packer.nvim' }

  if Work then
    use { "~/arcadia/junk/kuzns/gitsigns.nvim_with_arc_support" }
  else
    use { "lewis6991/gitsigns.nvim" }
  end

  if packer_bootstrap then
    require('packer').sync()
  end
end })

-- [[ plugin initialization ]]

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

require("nvim-autopairs").setup()
require("cmp").event:on(
  'confirm_done',
  require('nvim-autopairs.completion.cmp').on_confirm_done()
)

require('gitsigns').setup()

require('telescope').setup()

-- require('glow').setup({
--   border = "single"
-- })


require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    offsets = { {
      filetype = "NvimTree",
      text = "NvimTree",
      highlight = "Directory",
      text_align = "center",
      separator = true
    } }
  }
})

require('lualine').setup({
  sections = {
    lualine_c = { "%F" }
  }
})

require('nvim-tree').setup({
  view = {
    width = "20%"
  },
  renderer = {
    symlink_destination = false
  }
})

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  }
}
