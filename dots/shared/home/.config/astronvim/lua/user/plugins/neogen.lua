return {
	"danymat/neogen",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	cmd = "Neogen",
	config = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
			languages = {
				lua = { template = { annotation_convention = "ldoc" } },
				typescript = { template = { annotation_convention = "tsdoc" } },
				typescriptreact = { template = { annotation_convention = "tsdoc" } },
			},
		})
	end,
}
