return {
	"folke/twilight.nvim",
	config = function()
		require("twilight").setup()
	end,
	cmd = {
		"Twilight",
		"TwilightEnable",
		"TwilightDisable",
	},
}
