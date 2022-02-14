require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { 'lua', 'bash', 'markdown', 'cpp', 'vim', 'python', 'typescript', 'rust', 'sql', 'rasi', 'html',
    'json', 'c_sharp', 'gitignore', 'gitcommit', 'gitattributes', 'git_rebase', 'fish', 'dot', 'diff', 'dockerfile', 'css', 'bash' },

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    t = {
      name = "Treesitter",
      i = { "<cmd>TSInstallInfo<cr>", "Info" },
      u = { "<cmd>TSUpdate<cr>", "Update" },
      t = { "<cmd>TSToggle highlight<cr>", "Toggle Highlight" },
    },
  }
})
