local attach_node = {
	type = "pwa-node",
	request = "attach",
	name = "Attach",
	processId = function(...)
		return require("dap.utils").pick_process(...)
	end,
	cwd = "${workspaceFolder}",
}

return {
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			})
			for _, language in ipairs({ "javascript", "javascriptreact" }) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					attach_node,
				}
			end

			for _, language in ipairs({ "typescript", "typescriptreact" }) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						runtimeExecutable = "ts-node",
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
						resolveSourceMapLocations = {
							"${workspaceFolder}/dist/**/*.js",
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
					attach_node,
				}
			end
		end,
		ft = { "javascript", "typescript" },
	},
	{
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npm run compile",
		version = "v1.74.1",
	},
}
