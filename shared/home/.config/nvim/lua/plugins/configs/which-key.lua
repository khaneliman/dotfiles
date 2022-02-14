local wk = require("which-key")

wk.setup {
  window = {
    border = "single", -- none, single, double, shadow
  }
}

wk.register({
  ["<leader>"] = {
    w = {
      name = "Window",
      q = {"<cmd>q<cr>", "Close"},
      s = {"<cmd>sp<cr>", "Split Horizontal"},
      v = {"<cmd>vs<cr>", "Split Vertical"},
      H = {"<cmd>:vertical resize -5<cr>", "Decrease Vertical Size"},
      L = {"<cmd>:vertical resize +5<cr>", "Increase Vertical Size"},
      K = {"<cmd>:resize +5<cr>", "Increase Horizontal Size"},
      J = {"<cmd>:resize -5<cr>", "Decrease Horizontal Size"},
    },
    n = {
      name = "Neovim",
      q = {"<cmd>qa<cr>", "Close"},
      x = {"<cmd>qa!<cr>", "Force Close"},
      s = {"<cmd>source %<cr>", "Source Buffer"},
      c = {"<cmd>checkhealth<cr>", "Check Health"},
    }, 
    p = {
      name = "Packer",
      y = {"<cmd>:PackerSync<cr>", "Sync"},
      i = {"<cmd>:PackerInstall<cr>", "Install"},
      s = {"<cmd>:PackerStatus<cr>", "Status"},
      d = {"<cmd>:PackerClean<cr>", "Clean"},
      c = {"<cmd>:PackerCompile<cr>", "Compile"},
    },
  }
})
