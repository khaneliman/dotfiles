local utils = require("user.utils")

return {
  n = {
    ["<leader>"] = {
      N = { "<cmd>enew<cr>", "New Buffer" },
      ["<cr>"] = { '<esc>/<++><cr>"_c4l', "Next Template" },
      ["."] = { "<cmd>Neotree dir=%:p:h<cr>", "Set CWD" },

      a = {
        name = "Annotate",
        ["<cr>"] = {
          function()
            require("neogen").generate()
          end,
          "Current",
        },
        c = {
          function()
            require("neogen").generate({ type = "class" })
          end,
          "Class",
        },
        f = {
          function()
            require("neogen").generate({ type = "func" })
          end,
          "Function",
        },
        t = {
          function()
            require("neogen").generate({ type = "type" })
          end,
          "Type",
        },
        F = {
          function()
            require("neogen").generate({ type = "file" })
          end,
          "File",
        },
      },

      f = {
        ["'"] = { "<cmd>Telescope marks<cr>", "Marks" },
        e = { "<cmd>Telescope file_browser<cr>", "Explorer" },
        d = { "<cmd>Telescope dir live_grep<cr>", "Directory" },
        h = { "<cmd>Telescope oldfiles<cr>", "History" },
        M = { "<cmd>Telescope media_files<cr>", "Media" },
        p = { "<cmd>Telescope projects<cr>", "Projects" },
        r = { "<cmd>Telescope registers<cr>", "Registers" },
      },

      s = {
        name = "Search",
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        n = { "<cmd>Telescope notify<cr>", "Notifications" },
      },

      u = {
        t = { "<cmd>Telescope colorscheme<cr>", "Change Theme" },
      },

      n = {
        name = "Navigate",
        s = {
          function()
            require("syntax-tree-surfer").select()
          end,
          "Surf",
        },
        S = {
          function()
            require("syntax-tree-surfer").select_current_node()
          end,
          "Surf Node",
        },
        v = {
          function()
            require("syntax-tree-surfer").targeted_jump({
              "variable_declaration",
            })
          end,
          "Go to Variables",
        },
        f = {
          function()
            require("syntax-tree-surfer").targeted_jump({ "function" })
          end,
          "Go to Functions",
        },
        i = {
          function()
            require("syntax-tree-surfer").targeted_jump({
              "if_statement",
              "else_clause",
              "else_statement",
              "elseif_statement",
            })
          end,
          "Go to If Statements",
        },
        r = {
          function()
            require("syntax-tree-surfer").targeted_jump({
              "for_statement",
            })
          end,
          "Go to For Statements",
        },
        w = {
          function()
            require("syntax-tree-surfer").targeted_jump({
              "white_statement",
            })
          end,
          "Go to While Statements",
        },
        c = {
          function()
            require("syntax-tree-surfer").targeted_jump({
              "switch_statement",
            })
          end,
          "Go to Switch Statements",
        },
        t = {
          function()
            require("syntax-tree-surfer").targeted_jump({
              "function",
              "if_statement",
              "else_clause",
              "else_statement",
              "elseif_statement",
              "for_statement",
              "while_statement",
              "switch_statement",
            })
          end,
          "Go to Statement",
        },
      },
    },

    ["]"] = {
      f = "Next function start",
      x = "Next class start",
      F = "Next function end",
      X = "Next class end",
    },

    ["["] = {
      f = "Previous function start",
      x = "Previous class start",
      F = "Previous function end",
      X = "Previous class end",
    },
  },

  i = {
    ["<c-d>"] = {
      n = { "<c-r>=strftime('%Y-%m-%d')<cr>", "Y-m-d" },
      x = { "<c-r>=strftime('%m/%d/%y')<cr>", "m/d/y" },
      f = { "<c-r>=strftime('%B %d, %Y')<cr>", "B d, Y" },
      X = { "<c-r>=strftime('%H:%M')<cr>", "H:M" },
      F = { "<c-r>=strftime('%H:%M:%S')<cr>", "H:M:S" },
      d = { "<c-r>=strftime('%Y/%m/%d %H:%M:%S -')<cr>", "Y/m/d H:M:S -" },
    },
  },
}
