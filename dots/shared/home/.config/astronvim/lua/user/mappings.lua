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
		["<leader>fe"] = { "<cmd>Telescope file_browser<cr>", desc = "Find in Explorer" },
		["<leader>fd"] = { "<cmd>Telescope dir live_grep<cr>", desc = "Find relative files" },
		["<leader>fM"] = { "<cmd>Telescope media_files<cr>", desc = "Find media" },
		["<leader>fp"] = { "<cmd>Telescope projects<cr>", desc = "Find projects" },
	},
}
-- return {
-- 	n = {
-- 		["<leader>"] = {
--
-- 			u = {
-- 				t = { "<cmd>Telescope colorscheme<cr>", name = "Change Theme" },
-- 			},
--
-- 			n = {
-- 				name = "Navigate",
-- 				s = {
-- 					function()
-- 						require("syntax-tree-surfer").select()
-- 					end,
-- 					name = "Surf",
-- 				},
-- 				S = {
-- 					function()
-- 						require("syntax-tree-surfer").select_current_node()
-- 					end,
-- 					name = "Surf Node",
-- 				},
-- 				v = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({
-- 							"variable_declaration",
-- 						})
-- 					end,
-- 					name = "Go to Variables",
-- 				},
-- 				f = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({ "function" })
-- 					end,
-- 					name = "Go to Functions",
-- 				},
-- 				i = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({
-- 							"if_statement",
-- 							"else_clause",
-- 							"else_statement",
-- 							"elseif_statement",
-- 						})
-- 					end,
-- 					name = "Go to If Statements",
-- 				},
-- 				r = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({
-- 							"for_statement",
-- 						})
-- 					end,
-- 					name = "Go to For Statements",
-- 				},
-- 				w = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({
-- 							"white_statement",
-- 						})
-- 					end,
-- 					name = "Go to While Statements",
-- 				},
-- 				c = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({
-- 							"switch_statement",
-- 						})
-- 					end,
-- 					name = "Go to Switch Statements",
-- 				},
-- 				t = {
-- 					function()
-- 						require("syntax-tree-surfer").targeted_jump({
-- 							"function",
-- 							"if_statement",
-- 							"else_clause",
-- 							"else_statement",
-- 							"elseif_statement",
-- 							"for_statement",
-- 							"while_statement",
-- 							"switch_statement",
-- 						})
-- 					end,
-- 					name = "Go to Statement",
-- 				},
-- 			},
-- 		},
--
-- 		["]"] = {
-- 			f = "Next function start",
-- 			x = "Next class start",
-- 			F = "Next function end",
-- 			X = "Next class end",
-- 		},
--
-- 		["["] = {
-- 			f = "Previous function start",
-- 			x = "Previous class start",
-- 			F = "Previous function end",
-- 			X = "Previous class end",
-- 		},
-- 	},
--
-- 	i = {
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
