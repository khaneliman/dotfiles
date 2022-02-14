local gitlinker = require("gitlinker")
local wk = require("which-key")

gitlinker.setup {
  mappings = nil,
}

wk.register({
  ["<leader>"] = {
    g = {
      name = "Git",
      l = {
        function()
          local mode = string.lower(vim.fn.mode())
          gitlinker.get_buf_range_url(mode)
        end,
        "get git permlink"
      },
      o = {
        function()
          gitlinker.get_repo_url({
            action_callback = gitlinker.actions.open_in_browser
          })
        end,
        "browse repo in browser"
      },
    },
  },
})
