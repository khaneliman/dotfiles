vim.g.catppuccin_flavour = "mocha"

local catppuccin = require'catppuccin'
catppuccin.setup({
  integrations = {
    which_key = true,
  }
})

vim.cmd[[colorscheme catppuccin]]
