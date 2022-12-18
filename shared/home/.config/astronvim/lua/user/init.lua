--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below
-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {

        -- Configure AstroNvim updates
        updater = {
                remote = "origin", -- remote to use
                channel = "nightly", -- "stable" or "nightly"
                version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
                branch = "main", -- branch name (NIGHTLY ONLY)
                commit = nil, -- commit hash (NIGHTLY ONLY)
                pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
                skip_prompts = false, -- skip prompts about breaking changes
                show_changelog = true, -- show the changelog after performing an update
                auto_reload = true, -- automatically reload and sync packer after a successful update
                auto_quit = false, -- automatically quit the current session after a successful update
                -- remotes = { -- easily add new remotes to track
                --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
                --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
                --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
                -- },
        },

        -- Set colorscheme to use
        colorscheme = "catppuccin",

        -- set vim options here (vim.<first_key>.<second_key> = value)
        options = {
                opt = {
                        -- set to true or false etc.
                        relativenumber = true, -- sets vim.opt.relativenumber
                        number = true, -- sets vim.opt.number
                        spell = false, -- sets vim.opt.spell
                        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
                        wrap = true, -- sets vim.opt.wrap
                },
                g = {
                        mapleader = " ", -- sets vim.g.mapleader
                        autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
                        cmp_enabled = true, -- enable completion at start
                        autopairs_enabled = true, -- enable autopairs at start
                        diagnostics_enabled = true, -- enable diagnostics at start
                        status_diagnostics_enabled = true, -- enable diagnostics in statusline
                        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
                        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
                },
        },
        -- If you need more control, you can use the function()...end notation
        -- options = function(local_vim)
        --   local_vim.opt.relativenumber = true
        --   local_vim.g.mapleader = " "
        --   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
        --   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
        --
        --   return local_vim
        -- end,

        -- Set dashboard header
        header = {
                "                                                       ",
                "                                                       ",
                "                                                       ",
                " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
                " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
                " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
                " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
                " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
                " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
                "                                                       ",
                "                                                       ",
                "                                                       ",
                "                                                       ",
        },

        -- Default theme configuration
        default_theme = {
                -- enable or disable highlighting for extra plugins
                plugins = {
                        aerial = true,
                        beacon = false,
                        bufferline = true,
                        cmp = true,
                        dashboard = true,
                        highlighturl = true,
                        hop = false,
                        indent_blankline = true,
                        lightspeed = false,
                        ["neo-tree"] = true,
                        notify = true,
                        ["nvim-tree"] = false,
                        ["nvim-web-devicons"] = true,
                        rainbow = true,
                        symbols_outline = false,
                        telescope = true,
                        treesitter = true,
                        vimwiki = false,
                        ["which-key"] = true,
                },
        },

        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        diagnostics = { virtual_text = true, underline = true },

        -- Extend LSP configuration
        lsp = {
                -- enable servers that you already have installed without mason
                -- servers = {
                --   -- "pyright"
                -- },
                formatting = {
                        -- control auto formatting on save
                        format_on_save = {
                                enabled = true, -- enable or disable format on save globally
                                -- allow_filetypes = { -- enable format on save for specified filetypes only
                                --   -- "go",
                                -- },
                                -- ignore_filetypes = { -- disable format on save for specified filetypes
                                --   -- "python",
                                -- },
                        },
                        -- disabled = { -- disable formatting capabilities for the listed language servers
                        --   -- "sumneko_lua",
                        -- },
                        timeout_ms = 1000, -- default format timeout
                        -- filter = function(client) -- fully override the default formatting function
                        --   return true
                        -- end
                },
        },

        -- Configure plugins
        plugins = {
                init = {
                        { "wakatime/vim-wakatime" }, -- Analytics
                        {
                                "catppuccin/nvim",
                                as = "catppuccin",
                                config = function()
                                        require("catppuccin").setup({})
                                end,
                        }, -- Theme
                        {
                                "ellisonleao/glow.nvim",
                                config = function()
                                        require("glow").setup({})
                                end,
                        }, -- Markdown preview
                        -- { "romgrk/fzy-lua-native" }, -- Fuzzy search
                        -- ["gelguy/wilder.nvim"] = {
                        --         config = function() require "configs.wilder" end
                        -- }
                        -- You can disable default plugins as follows:
                        -- ["goolord/alpha-nvim"] = { disable = true },
                        {
                                "ahmedkhalf/project.nvim",
                                config = function()
                                        require("project_nvim").setup({ show_hidden = true })
                                end,
                        },
                },
                -- All other entries override the require("<key>").setup({...}) call for default plugins
                ["neo-tree"] = {
                        filesystem = {
                                filtered_items = {
                                        visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
                                        hide_dotfiles = false,
                                        hide_gitignored = true,
                                },
                        },
                },
                ["mason-lspconfig"] = {
                        ensure_installed = {
                                "sumneko_lua",
                                "bashls",
                                "angularls",
                                "clangd",
                                "csharp_ls",
                                "cmake",
                                "cssls",
                                "dockerls",
                                "dotls",
                                "eslint",
                                "html",
                                "jsonls",
                                "tsserver",
                                "sumneko_lua",
                                "marksman",
                                "pylsp",
                                "sqlls",
                                "lemminx",
                        },
                },
                treesitter = { -- overrides `require("treesitter").setup(...)`
                        ensure_installed = {
                                "lua",
                                "bash",
                                "markdown",
                                "cpp",
                                "vim",
                                "python",
                                "typescript",
                                "rust",
                                "sql",
                                "rasi",
                                "html",
                                "json",
                                "c_sharp",
                                "gitignore",
                                "gitcommit",
                                "gitattributes",
                                "git_rebase",
                                "fish",
                                "dot",
                                "diff",
                                "dockerfile",
                                "css",
                                "bash",
                        },
                },
                ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
                        -- config variable is the default configuration table for the setup function call
                        local null_ls = require("null-ls")

                        -- Check supported formatters and linters
                        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
                        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
                        config.sources = {
                                -- Set a formatter
                                null_ls.builtins.formatting.lua_format,
                                null_ls.builtins.formatting.prettier,
                        }
                        return config -- return final config table
                end,
                ["telescope"] = {
                        after = { "ahmedkhalf/project.nvim" },
                        require("telescope").load_extension("projects"),
                },
        },

        -- Modify which-key registration (Use this with mappings table in the above.)
        ["which-key"] = {
                -- Add bindings which show up as group name
                register = {
                        -- first key is the mode, n == normal mode
                        n = {
                                -- second key is the prefix, <leader> prefixes
                                ["<leader>"] = {
                                        -- third key is the key to bring up next level and its displayed
                                        -- group name in which-key top level menu
                                        ["f"] = {
                                                name = "File",
                                                p = { "<cmd>Telescope projects<cr>", "Projects" },
                                        },
                                },
                        },
                },
        },
}

return config
