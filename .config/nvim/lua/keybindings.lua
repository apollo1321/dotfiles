local function map(modes, lhs, rhs, opts)
  local function map_impl(mode)
    if opts then
      vim.keymap.set(mode, lhs, rhs, opts)
    else
      vim.keymap.set(mode, lhs, rhs, { noremap = true })
    end
  end

  if #modes == 0 then
    map_impl(modes)
  else
    for i = 1, #modes do
      map_impl(modes:sub(i, i))
    end
  end
end

-- [[ escape ]]
map("i", "jj", "<Esc>")
map("t", "jj", "<C-\\><C-N>")
map("t", "<Esc>", "<C-\\><C-N>")

-- [[ navigation ]]
map("ti", "<C-h>", "<C-\\><C-N><C-w>h")
map("ti", "<C-j>", "<C-\\><C-N><C-w>j")
map("ti", "<C-k>", "<C-\\><C-N><C-w>k")
map("ti", "<C-l>", "<C-\\><C-N><C-w>l")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-p>", "<cmd>bp<CR>")
map("n", "<C-n>", "<cmd>bn<CR>")
map("t", "<C-p>", "<C-\\><C-N><cmd>bp<CR>")
map("t", "<C-n>", "<C-\\><C-N><cmd>bn<CR>")
map('', "<A-u>", "10k")
map('', "<A-d>", "10j")

-- [[ registers ]]
map('n', '<A-p>', '"0p')
map('v', '<A-p>', '"0p')

-- [[ arrows ]]
map("", "<Left>", "<cmd>echoe 'Use h'<CR>")
map("", "<Right>", "<cmd>echoe 'Use l'<CR>")
map("", "<Up>", "<cmd>echoe 'Use k'<CR>")
map("", "<Down>", "<cmd>echoe 'Use j'<CR>")

-- [[ term ]]
map("n", "<C-t>", "<cmd>split | term<CR><cmd>res 15<CR> i")

-- [[ save ]]
map('n', '<A-s>', '<cmd>w<CR>')

-- [[ telescope ]]
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>")
map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').resume()<CR>")

-- [[ close_buffers ]]
map("n", "<leader>bf", "<cmd>lua require('close_buffers').delete({type = 'this', force = true})<CR>")
map("n", "<leader>bc", "<cmd>lua require('close_buffers').delete({type = 'this'})<CR>")
map("n", "<leader>bh", "<cmd>lua require('close_buffers').delete({type = 'nameless', force = true})<CR>")

-- [[ lsp ]]
map('n', '<A-e>', vim.diagnostic.show)
map('n', '<A-d>', vim.diagnostic.hide)
map('n', '<A-r>', vim.lsp.buf.rename)
map('n', '<A-a>', vim.lsp.buf.code_action)
map('n', '<A-h>', '<cmd>lua vim.diagnostic.open_float()<CR>')
if vim.version().minor >= 8 then
  map('n', '<A-f>', '<cmd>lua vim.lsp.buf.format({ asyn = true })<CR>')
else
  map('n', '<A-f>', vim.lsp.buf.formatting)
end
map('n', 'gD', vim.lsp.buf.declaration)
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gr', vim.lsp.buf.references)
map('n', 'H', vim.lsp.buf.hover)

-- [[ gitsigns ]]
map("n", "gsp", "<cmd>Gitsigns preview_hunk<CR>")
map("n", "gsa", "<cmd>Gitsigns stage_hunk<CR>")

-- [[ nvim tree ]]
map("n", "<A-b>", "<cmd>NvimTreeToggle<CR>")
map("n", "|", "<cmd>NvimTreeFindFile<CR>")
map("t", "<A-b>", "<C-\\><C-N><cmd>NvimTreeToggle<CR>")
