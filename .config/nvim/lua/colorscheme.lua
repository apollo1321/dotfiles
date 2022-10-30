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

vim.cmd [[colorscheme nordfox]]
