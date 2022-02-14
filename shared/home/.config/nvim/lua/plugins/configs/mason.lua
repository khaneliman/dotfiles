require("mason").setup({
  ui = {
    border = 'single'
  }
})

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    m = {
      name = "Mason",
      o = {"<cmd>Mason<cr>", "Open"},
    },
  },
})
