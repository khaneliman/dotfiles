return {
	"ziontee113/syntax-tree-surfer",
	config = function()
		require("syntax-tree-surfer").setup({ highlight_group = "HopNextKey" })
	end,
	cmd = {
		"STSSelectMasterNode",
		"STSSelectCurrentNode",
		"STSSelectNextSiblingNode",
		"STSSelectPrevSiblingNode",
		"STSSelectParentNode",
		"STSSelectChildNode",
		"STSSwapNextVisual",
		"STSSwapPrevVisuaiw",
	},
}
