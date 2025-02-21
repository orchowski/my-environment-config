vim.opt.relativenumber = true

vim.keymap.set('n', '<leader>:', ':vsplit<CR>', { desc = 'vertical split - new window' })
vim.keymap.set('n', '<leader>%', ':split<CR>', { desc = 'horizontal split - new window' })
vim.keymap.set('n', '<leader>pp', function()
	vim.fn.setreg('+', vim.fn.expand('%'))
end
)
