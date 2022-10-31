local opt = vim.opt
local g = vim.g

opt.clipboard = 'unnamedplus'
opt.completeopt = 'menuone,noselect'
opt.cursorline = true
opt.expandtab = true
opt.fixeol = true
opt.ignorecase = true
opt.laststatus = 3
opt.mouse = nil
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.showmatch = true
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true

if Work then
  opt.shiftwidth = 4
else
  opt.shiftwidth = 2
end

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
