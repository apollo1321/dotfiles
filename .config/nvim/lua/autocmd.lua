-- [[ set cmake filetype for ya make for syntax highlight ]]
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = {"ya.make"},
  callback = function() vim.opt_local.filetype = "cmake" end
})
