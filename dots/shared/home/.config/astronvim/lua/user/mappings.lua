return {
	n = {
		["<leader>N"] = { "<cmd>enew<cr>", desc = "New Buffer" },
		["<leader><cr>"] = { '<esc>/<++><cr>"_c4l', desc = "Next Template" },
		["<leader>."] = { "<cmd>Neotree dir=%:p:h<cr>", desc = "Set CWD" },

		["<leader>a"] = { name = "Annotate" },
		["<leader>a<cr>"] = {
			function()
				require("neogen").generate()
			end,
			desc = "Current",
		},
		["<leader>ac"] = {
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Class",
		},
		["<leader>af"] = {
			function()
				require("neogen").generate({ type = "func" })
			end,
			desc = "Function",
		},
		["<leader>at"] = {
			function()
				require("neogen").generate({ type = "type" })
			end,
			desc = "Type",
		},
		["<leader>aF"] = {
			function()
				require("neogen").generate({ type = "file" })
			end,
			desc = "File",
		},

		-- Telescope
		["<leader>fe"] = { "<cmd>Telescope file_browser<cr>", desc = "Find in Explorer" },
		["<leader>fd"] = { "<cmd>Telescope dir live_grep<cr>", desc = "Find relative files" },
		["<leader>fM"] = { "<cmd>Telescope media_files<cr>", desc = "Find media" },
		["<leader>fp"] = { "<cmd>Telescope projects<cr>", desc = "Find projects" },

		-- UI
		["<leader>uz"] = { "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },

		-- Navigate buffer
		["<leader>s"] = { name = "Surf" },
		["<leader>ss"] = {
			function()
				require("syntax-tree-surfer").select()
			end,
			desc = "Surf",
		},
		["<leader>sS"] = {
			function()
				require("syntax-tree-surfer").select_current_node()
			end,
			desc = "Surf Node",
		},
		["<leader>sv"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({
					"variable_declaration",
				})
			end,
			desc = "Go to Variables",
		},
		["<leader>sf"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({ "function" })
			end,
			desc = "Go to Functions",
		},
		["<leader>si"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({
					"if_statement",
					"else_clause",
					"else_statement",
					"elseif_statement",
				})
			end,
			desc = "Go to If Statements",
		},
		["<leader>sr"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({
					"for_statement",
				})
			end,
			desc = "Go to For Statements",
		},
		["<leader>sw"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({
					"white_statement",
				})
			end,
			desc = "Go to While Statements",
		},
		["<leader>sc"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({
					"switch_statement",
				})
			end,
			desc = "Go to Switch Statements",
		},
		["<leader>st"] = {
			function()
				require("syntax-tree-surfer").targeted_jump({
					"function",
					"if_statement",
					"else_clause",
					"else_statement",
					"elseif_statement",
					"for_statement",
					"while_statement",
					"switch_statement",
				})
			end,
			desc = "Go to Statement",
		},
		-- i = {
		-- 		["<c-d>"] = {
		-- 			n = { "<c-r>=strftime('%Y-%m-%d')<cr>", name = "Y-m-d" },
		-- 			x = { "<c-r>=strftime('%m/%d/%y')<cr>", name = "m/d/y" },
		-- 			f = { "<c-r>=strftime('%B %d, %Y')<cr>", name = "B d, Y" },
		-- 			X = { "<c-r>=strftime('%H:%M')<cr>", name = "H:M" },
		-- 			F = { "<c-r>=strftime('%H:%M:%S')<cr>", name = "H:M:S" },
		-- 			d = { "<c-r>=strftime('%Y/%m/%d %H:%M:%S -')<cr>", name = "Y/m/d H:M:S -" },
		-- 		},
		-- 	},
		-- }
	},
}
