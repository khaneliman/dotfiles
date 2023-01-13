return {
	"mtoohey31/cmp-fish",
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
}
