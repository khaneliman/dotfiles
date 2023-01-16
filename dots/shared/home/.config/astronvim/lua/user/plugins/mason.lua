return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = {
				"angularls",
				"bashls",
				"clangd",
				"csharp_ls",
				"cssls",
				"dockerls",
				"eslint",
				"grammarly",
				"html",
				"intelephense",
				"jsonls",
				"lemminx",
				"marksman",
				"neocmake",
				"omnisharp",
				"pyright",
				"sqls",
				"sumneko_lua",
				"tsserver",
				"yamlls",
			}
			return opts
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			opts.ensure_installed = {
				"black",
				"cbfmt",
				"clang_format",
				"csharpier",
				"eslint_d",
				"gitlint",
				"hadolint",
				"isort",
				"jq",
				"markdownlint",
				"prettierd",
				"shellcheck",
				"shfmt",
				"sql_formatter",
				"stylua",
			}
			return opts
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			opts.ensure_installed = {
				"bash",
				"codelldb",
				"coreclr",
				"cppdbg",
				"firefox",
				"node2",
				"python",
			}
			return opts
		end,
	},
}
