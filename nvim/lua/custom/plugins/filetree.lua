return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require('neo-tree').setup {
      vim.api.nvim_set_keymap('n', '<C-n>', '<Cmd>Neotree toggle<CR>', {silent = true});
      vim.api.nvim_set_keymap('n', '<C-S-s>', '<Cmd>Neotree reveal<CR>', {silent = true});
    }
  end,
}
