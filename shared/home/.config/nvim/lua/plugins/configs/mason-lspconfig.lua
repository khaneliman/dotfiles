require("mason-lspconfig").setup({
  -- A list of servers to automatically install if they're not already installed. Example: { "rust-analyzer@nightly", "sumneko_lua" }
  -- This setting has no relation with the `automatic_installation` setting.
  ensure_installed = { 'sumneko_lua', 'bashls', 'angularls', 'clangd', 'csharp_ls', 'cmake', 'cssls', 'dockerls', 'dotls',
    'eslint', 'html', 'jsonls', 'tsserver', 'sumneko_lua', 'marksman', 'pylsp', 'sqlls', 'lemminx' },

  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.

  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  automatic_installation = true,
})

local border = {
  { "┌", "FloatBorder" },
  { "─", "FloatBorder" },
  { "┐", "FloatBorder" },
  { "│", "FloatBorder" },
  { "┘", "FloatBorder" },
  { "─", "FloatBorder" },
  { "└", "FloatBorder" },
  { "│", "FloatBorder" },
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      handlers = handlers,
      capabilities = capabilities,
    }
  end,

  -- Next, you can provide targeted overrides for specific servers.
  ["sumneko_lua"] = function()
    require("lspconfig").sumneko_lua.setup {
      handlers = handlers,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    }
  end,
}

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    l = {
      name = "Lsp",
      h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Information" },
      d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation" },
      s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      u = { "<cmd>lua vim.lsp.buf.references()<cr>", "Find Usages" },
      f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
      v = { "<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<cr>", "Preview Problem" },
      n = { "<cmd>lua vim.diagnostic.goto_next({ float =  { border = 'single' }})<cr>", "Go to Next Problem" },
      p = { "<cmd>lua vim.diagnostic.goto_prev({ float =  { border = 'single' }})<cr>", "Go to Previous Problem" },
    },
  },
})
