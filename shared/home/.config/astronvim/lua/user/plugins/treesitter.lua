return {
  ensure_installed = {
    "lua", "bash", "markdown", "cpp", "vim", "python", "typescript",
    "rust", "sql", "rasi", "html", "json", "c_sharp", "gitignore",
    "gitcommit", "gitattributes", "git_rebase", "fish", "diff",
    "dockerfile", "css", "bash"
  },
  auto_install = vim.fn.executable "tree-sitter" == 1,
  highlight = { disable = { "help" } },
  indent = { enable = true, disable = { "python" } },
  matchup = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        aB = "@block.outer",
        iB = "@block.inner",
        aC = "@conditional.outer",
        iC = "@conditional.inner",
        aF = "@function.outer",
        iF = "@function.inner",
        aL = "@loop.outer",
        iL = "@loop.inner",
        aP = "@parameter.outer",
        iP = "@parameter.inner",
        aX = "@class.outer",
        iX = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]b"] = "@block.outer",
        ["]f"] = "@function.outer",
        ["]p"] = "@parameter.outer",
        ["]x"] = "@class.outer",
      },
      goto_next_end = {
        ["]B"] = "@block.outer",
        ["]F"] = "@function.outer",
        ["]P"] = "@parameter.outer",
        ["]X"] = "@class.outer",
      },
      goto_previous_start = {
        ["[b"] = "@block.outer",
        ["[f"] = "@function.outer",
        ["[p"] = "@parameter.outer",
        ["[x"] = "@class.outer",
      },
      goto_previous_end = {
        ["[B"] = "@block.outer",
        ["[F"] = "@function.outer",
        ["[P"] = "@parameter.outer",
        ["[X"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        [">B"] = "@block.outer",
        [">F"] = "@function.outer",
        [">P"] = "@parameter.inner",
      },
      swap_previous = {
        ["<B"] = "@block.outer",
        ["<F"] = "@function.outer",
        ["<P"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
      border = "single",
      peek_definition_code = {
        ["<leader>lp"] = "@function.outer",
        ["<leader>lP"] = "@class.outer",
      },
    },
  },
}
