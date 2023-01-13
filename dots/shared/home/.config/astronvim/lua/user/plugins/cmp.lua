return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-calc",
		"hrsh7th/cmp-emoji",
		"petertriho/cmp-git",
		"mtoohey31/cmp-fish",
		"tamago324/cmp-zsh",
	},
	config = function(plugin, opts)
		plugin.default_config(opts)
		-- Add bindings which show up as group name
		local cmp = require("cmp")
	end,
}
