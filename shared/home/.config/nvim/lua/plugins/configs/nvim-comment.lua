require('nvim_comment').setup({
  create_mappings = false
})

local wk = require("which-key")
wk.register({
  ["<leader>/"] = {"<cmd>CommentToggle<cr>", "Comment Toggle Line " },
})

wk.register({
  ["<leader>/"] = {"<esc><cmd>'<,'>CommentToggle<cr>'<", "Comment Toggle Block"},
}, { mode = "v" })

