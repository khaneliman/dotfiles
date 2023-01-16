return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"chrisgrieser/cmp-nerdfont",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "emoji" },
					{ name = "calc" },
					{ name = "nerdfont" },
				}),
			})
		end,
	},
	{
		"mtoohey31/cmp-fish",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			-- Add bindings which show up as group name
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "fish" },
				}),
			})
		end,
		ft = "fish",
	},
	{
		"tamago324/cmp-zsh",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			-- Add bindings which show up as group name
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "zsh" },
				}),
			})
		end,
		ft = "zsh",
	},
	{
		"petertriho/cmp-git",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			-- Add bindings which show up as group name
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "git" },
				}),
			})
		end,
		ft = "gitcommit",
	},
	{
		"David-Kunz/cmp-npm",
		dependencies = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
		config = function()
			-- Add bindings which show up as group name
			require("cmp-npm").setup({})
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "npm", keyword_length = 4 },
				}),
			})
		end,
		ft = "json",
	},
}
