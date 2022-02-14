local global_icons = require("core.globals").icons
local nvim_tree = require("nvim-tree")
local which_key = require("which-key")

nvim_tree.setup {
  open_on_setup = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
  view = {
    adaptive_size = true
  },
  renderer = {
    full_name = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder_arrow = false,
      },
    }
  },
  git = {
    enable = true,
    ignore = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = global_icons.hint,
      info = global_icons.info,
      warning = global_icons.warning,
      error = global_icons.error,
    },
  },
}

which_key.register({
  ["<leader>"] = {
    e = {
      name = "Explorer",
      t = { "<cmd>NvimTreeToggle<cr>", "Toggle File Explorere" },
      f = { "<cmd>NvimTreeFocus<cr>", "Focus File Explorere" },
      r = { "<cmd>NvimTreeRefresh<cr>", "Refersh File Explorere" },
      m = { "<cmd>NvimTreeFindFile<cr>", "Move to Current Buffer" },
    }
  }
})

local colors = require("catppuccin.palettes").get_palette() -- fetch colors from palette
require("catppuccin.lib.highlighter").syntax({
  NvimTreeEndOfBuffer = { fg = colors.mantle, bg = colors.mantle }
})
