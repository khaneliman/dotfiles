return {
  opt = {
    conceallevel = 2, -- enable conceal
    foldenable = false,
    foldexpr = "nvim_treesitter#foldexpr()", -- set Treesitter based folding
    foldmethod = "expr",
    linebreak = true, -- linebreak soft wrap at words
    list = true, -- show whitespace characters
    listchars = {
      tab = "│→",
      extends = "⟩",
      precedes = "⟨",
      trail = "·",
      nbsp = "␣",
    },
    showbreak = "↪ ",
    spellfile = vim.fn.expand("~/.config/nvim/lua/user/spell/en.utf-8.add"),
    swapfile = false,
    thesaurus = vim.fn.expand("~/.config/nvim/lua/user/spell/mthesaur.txt"),
    wrap = true, -- soft wrap lines
  },
  g = {
    matchup_matchparen_deferred = 1,
    heirline_bufferline = true,
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    mapleader = " ", -- sets vim.g.mapleader
    diagnostics_enabled = true, -- enable diagnostics at start
    status_diagnostics_enabled = true, -- enable diagnostics in statusline
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
  },
}
