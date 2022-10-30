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
    },
    styles = {
      types = "bold",
      functions = "bold",
      comments = "italic"
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
      NormalFloat = {
        bg = "bg3"
      }
    }
  }
})

vim.cmd [[colorscheme nordfox]]
