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
				"html",
				"intelephense",
				"jsonls",
				"lemminx",
				"marksman",
				"neocmake",
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
				"shellcheck",
				"stylua",
				"black",
				"isort",
				"prettierd",
				"shfmt",
			}
			return opts
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			opts.ensure_installed = { "bash", "cppdbg", "delve", "js", "php", "python" }
			return opts
		end,
	},
}
