return {
	{
		"nvim-telescope/telescope.nvim",
		config = function(plugin, opts)
			plugin.default_config(opts)
			local telescope = require("telescope")

			astronvim.conditional_func(telescope.load_extension, astronvim.is_available("project.nvim"), "projects")
			astronvim.conditional_func(
				telescope.load_extension,
				astronvim.is_available("telescope-file-browser.nvim"),
				"file_browser"
			)
			astronvim.conditional_func(telescope.load_extension, astronvim.is_available("telescope-hop.nvim"), "hop")
			astronvim.conditional_func(
				telescope.load_extension,
				astronvim.is_available("telescope-media-files.nvim"),
				"media_files"
			)
			return opts
		end,
	},
	{
		"nvim-telescope/telescope-media-files.nvim",
		config = function()
			local telescope = require("telescope")

			telescope.load_extension("media_files")
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		"nvim-telescope/telescope-hop.nvim",
		config = function()
			local telescope = require("telescope")

			telescope.load_extension("hop")
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				extensions = {
					file_browser = {
						hidden = true,
						no_ignore = true,
					},
				},
			})

			telescope.load_extension("file_browser")
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
