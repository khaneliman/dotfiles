local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local utils = require("utils")

-- require("lsp-format").setup {}

local custom_attach = function(client, bufnr)

  -- Auto format on save
  -- require("lsp-format").on_attach(client)

  -- Mappings.
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
  map("n", "<C-]>", vim.lsp.buf.definition)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "<C-k>", vim.lsp.buf.signature_help)
  map("n", "<space>rn", vim.lsp.buf.rename, { desc = "variable rename" })
  map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
  map("n", "[d", diagnostic.goto_prev, { desc = "previous diagnostic" })
  map("n", "]d", diagnostic.goto_next, { desc = "next diagnostic" })
  map("n", "<space>q", diagnostic.setqflist, { desc = "put diagnostic to qf" })
  map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
  map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
  map("n", "<space>wl", function()
    inspect(lsp.buf.list_workspace_folders())
  end, { desc = "list workspace folder" })

  -- Set some key bindings conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<space>f", lsp.buf.format, { desc = "format code" })
  end


  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always", -- show source in diagnostic popup window
        prefix = " ",
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
          and #diagnostic.get() > 0
      then
        diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end,
  })

  -- The below command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.document_highlight()
      end
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.clear_references()
      end
    })
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require("lspconfig")


if utils.executable("pylsp") then
  lspconfig.pylsp.setup {
    on_attach = custom_attach,
    filetypes = { "py", "pyi", "pyc", "pyd", "pyo", "pyw", "pyz" },
    settings = {
      pylsp = {
        plugins = {
          pylint = { enabled = true, executable = "pylint" },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          jedi_completion = { fuzzy = true },
          pyls_isort = { enabled = true },
          pylsp_mypy = { enabled = true },
        },
      },
    },
    flags = {
      debounce_text_changes = 200,
    },
    capabilities = capabilities,
  }
else
  vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("efm-langserver") then
  lspconfig.efm.setup {
    on_attach = custom_attach,
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        lua = {
          { formatCommand = "lua-format -i", formatStdin = true }
        },
        css = {
          formatCommand = "prettier ${--tab-width:tabWidth} ${--single-quote:singleQuote} --parser css",
          formatStdin = true
        },
        html = {
          formatCommand = "prettier ${--tab-width:tabWidth} ${--single-quote:singleQuote} --parser html",
          formatStdin = true
        },
        json = {
          formatCommand = "prettier ${--tab-width:tabWidth} --parser json",
          formatStdin = true
        },
        sh = {
          formatCommand = "shfmt -ci -s -bn",
          formatStdin = true
        }
      }
    },
    filetypes = {
      'lua', "css", "html", "json", "sh"
    },
    single_file_support = false
  }
end

if utils.executable("ltex-ls") then
  lspconfig.ltex.setup {
    on_attach = custom_attach,
    cmd = { "ltex-ls" },
    filetypes = { "text", "plaintex", "tex", "markdown" },
    settings = {
      ltex = {
        language = "en"
      },
    },
    flags = { debounce_text_changes = 300 },
  }
end

if utils.executable("clangd") then
  lspconfig.clangd.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "cc" },
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("clangd not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up vim-language-server
if utils.executable("vim-language-server") then
  lspconfig.vimls.setup {
    on_attach = custom_attach,
    filetypes = { "vim" },
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  }
else
  vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up bash-language-server
if utils.executable("bash-language-server") then
  lspconfig.bashls.setup {
    on_attach = custom_attach,
    filetypes = { "sh" },
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("bash-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up angular language server
if utils.executable("ngserver") then
  lspconfig.angularls.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "ts", "html" },
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("ngserver not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end


-- set up typescript language server
if utils.executable("typescript-language-server") then
  lspconfig.tsserver.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "ts" },
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("typescript-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end


-- set up eslint language server
if utils.executable("vscode-eslint-language-server") then
  lspconfig.eslint.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("vscode-eslint-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end


-- set up cmake language server
if utils.executable("cmake-language-server") then
  lspconfig.cmake.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "cmake" },
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("cmake-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end


-- set up lua language server
if utils.executable("lua-language-server") then
  -- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
  lspconfig.sumneko_lua.setup {
    on_attach = custom_attach,
    filetypes = { "lua" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files,
          -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
          -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
          library = {
            fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
            fn.stdpath("config"),
          },
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
      },
    },
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("lua-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end


-- Change diagnostic signs.
fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
diagnostic.config {
  underline = false,
  virtual_text = false,
  signs = true,
  severity_sort = true,
}

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
