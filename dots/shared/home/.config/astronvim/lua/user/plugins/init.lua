return {
        ["arsham/indent-tools.nvim"] = {
                opt = true,
                setup = function()
                        table.insert(astronvim.file_plugins, "indent-tools.nvim")
                end,
                requires = { "arsham/arshlib.nvim", module = "arshlib" },
                config = function()
                        require("user.plugins.indent-tools")
                end,
        },
        ["danymat/neogen"] = {
                requires = "nvim-treesitter/nvim-treesitter",
                module = "neogen",
                cmd = "Neogen",
                config = function()
                        require("user.plugins.neogen")
                end,
        }, -- Annotation
        ["wakatime/vim-wakatime"] = {
                setup = function()
                        table.insert(astronvim.file_plugins, "vim-wakatime")
                end,
        }, -- Analytics
        ["catppuccin/nvim"] = {
                as = "catppuccin",
                config = function()
                        require("catppuccin").setup({})
                end,
        }, -- Theme
        ["hrsh7th/cmp-calc"] = {
                after = "nvim-cmp",
                config = function()
                        require("user.plugins.cmp-calc")
                end,
        },
        ["hrsh7th/cmp-emoji"] = {
                after = "nvim-cmp",
                config = function()
                        require("user.plugins.cmp-emoji")
                end,
        },
        ["iamcco/markdown-preview.nvim"] = {
                run = "cd app && npm install",
                setup = function()
                        vim.g.mkdp_filetypes = { "markdown" }
                end,
                ft = { "markdown" },
        },
        ["lvimuser/lsp-inlayhints.nvim"] = {
                module = "lsp-inlayhints",
                config = function()
                        require("user.plugins.lsp-inlayhints")
                end,
        },
        ["machakann/vim-sandwich"] = {
                opt = true,
                setup = function()
                        table.insert(astronvim.file_plugins, "vim-sandwich")
                end,
        },
        ["mxsdev/nvim-dap-vscode-js"] = {
                after = "mason-nvim-dap.nvim",
                config = function()
                        require("user.plugins.nvim-dap-vscode-js")
                end,
        },
        ["gelguy/wilder.nvim"] = {
                config = function()
                        require("user.plugins.wilder")
                end,
        }, -- Wildmenu customization
        ["nanotee/sqls.nvim"] = { module = "sqls" },
        ["nvim-telescope/telescope-file-browser.nvim"] = {
                after = "telescope.nvim",
                config = function()
                        require("user.plugins.telescope-file-browser")
                end,
        },
        ["nvim-telescope/telescope-hop.nvim"] = {
                after = "telescope.nvim",
                config = function()
                        require("user.plugins.telescope-hop")
                end,
        },
        ["nvim-telescope/telescope-media-files.nvim"] = {
                after = "telescope.nvim",
                config = function()
                        require("user.plugins.telescope-media-files")
                end,
        },
        ["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },
        { "romgrk/fzy-lua-native" }, -- Fuzzy search
        ["ahmedkhalf/project.nvim"] = {
                config = function()
                        require("user.plugins.project_nvim")
                end,
        },
        ["ziontee113/syntax-tree-surfer"] = {
                module = "syntax-tree-surfer",
                config = function()
                        require("user.plugins.syntax-tree-surfer")
                end,
        },
}
