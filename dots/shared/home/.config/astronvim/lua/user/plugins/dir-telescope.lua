return {
	"princejoogie/dir-telescope.nvim",
	config = function()
		require("telescope").load_extension("dir")

		require("dir-telescope").setup({
			hidden = true,
			respect_gitignore = true,
		})
	end,
	dependencies = "telescope.nvim",
	cmd = {
		"Telescope dir",
	},
}
