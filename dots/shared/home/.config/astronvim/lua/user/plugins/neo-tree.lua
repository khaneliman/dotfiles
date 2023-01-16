return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = function(plugin, opts)
		plugin.default_config(opts)

		opts.filesystem.filtered_items = {
			visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
			hide_dotfiles = false,
			never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
				".DS_Store",
				"thumbs.db",
			},
		}
		return opts
	end,
}
