local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    g = {
      name = "Git",
      g = { "<cmd>Git<cr>", "Git Status" },
      a = { "<cmd>Gwrite<cr>", "Git Add" },
      c = { "<cmd>Git commit<cr>", "Git Commit" },
      t = { "<cmd>Flog<cr>", "Git History" },
      r = { "<cmd>Conflicted<cr>", "Resolve conflicts" },
      d = {
        name = 'Diff',
        d = { "<cmd>Gdiffsplitff<cr>", "Git Diff" },
      },
      p = {
        name = "Sync",
        l = { "<cmd>Git pull<cr>", "Git Pull" },
        u = { "<cmd>Git push<cr>", "Git Push" }
      },
    },
  },
})
