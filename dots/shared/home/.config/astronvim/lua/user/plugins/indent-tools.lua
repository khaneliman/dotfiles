return {
	"arsham/indent-tools.nvim",
	setup = function()
		table.insert(astronvim.file_plugins, "indent-tools.nvim")
	end,
	dependencies = { "arsham/arshlib.nvim" },
	config = true,
	keys = { "]i", "[i", { mode = "v", "ii" }, { mode = "o", "ii" } },
}
