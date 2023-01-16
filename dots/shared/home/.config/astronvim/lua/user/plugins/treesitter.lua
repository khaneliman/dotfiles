return {
	"nvim-treesitter/nvim-treesitter",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-refactor",
		"nvim-treesitter/nvim-treesitter-context",
		"khaveesh/vim-fish-syntax",
	},

	opts = function(_, opts)
		opts.ensure_installed = {
			"bash",
			"c_sharp",
			"cpp",
			"css",
			"diff",
			"dockerfile",
			"fish",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"html",
			"javascript",
			"jq",
			"json",
			"llvm",
			"lua",
			"markdown",
			"python",
			"rasi",
			"regex",
			"rust",
			"sql",
			"typescript",
			"vim",
			"yaml",
		}

		opts.auto_install = vim.fn.executable("tree-sitter") == 1

		opts.highlight = { disable = { "help" } }

		opts.indent = { enable = true, disable = { "python" } }

		opts.matchup = { enable = true }

		opts.textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					aB = "@block.outer",
					iB = "@block.inner",
					aC = "@conditional.outer",
					iC = "@conditional.inner",
					aF = "@function.outer",
					iF = "@function.inner",
					aL = "@loop.outer",
					iL = "@loop.inner",
					aP = "@parameter.outer",
					iP = "@parameter.inner",
					aX = "@class.outer",
					iX = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]b"] = "@block.outer",
					["]f"] = "@function.outer",
					["]p"] = "@parameter.outer",
					["]x"] = "@class.outer",
				},
				goto_next_end = {
					["]B"] = "@block.outer",
					["]F"] = "@function.outer",
					["]P"] = "@parameter.outer",
					["]X"] = "@class.outer",
				},
				goto_previous_start = {
					["[b"] = "@block.outer",
					["[f"] = "@function.outer",
					["[p"] = "@parameter.outer",
					["[x"] = "@class.outer",
				},
				goto_previous_end = {
					["[B"] = "@block.outer",
					["[F"] = "@function.outer",
					["[P"] = "@parameter.outer",
					["[X"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					[">B"] = "@block.outer",
					[">F"] = "@function.outer",
					[">P"] = "@parameter.inner",
				},
				swap_previous = {
					["<B"] = "@block.outer",
					["<F"] = "@function.outer",
					["<P"] = "@parameter.inner",
				},
			},
			lsp_interop = {
				enable = true,
				border = "single",
				peek_definition_code = {
					["<leader>lp"] = "@function.outer",
					["<leader>lP"] = "@class.outer",
				},
			},
		}
		return opts
	end,
}
