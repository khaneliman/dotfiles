return {
	"lvimuser/lsp-inlayhints.nvim",
	config = function()
		require("lsp-inlayhints").setup()
	end,
	event = "BufEnter",
}
