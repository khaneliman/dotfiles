local attach_node = {
  type = "pwa-node",
  request = "attach",
  name = "Attach",
  processId = function(...) return require("dap.utils").pick_process(...) end,
  cwd = "${workspaceFolder}",
}

return {
  javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    attach_node,
  },
  typescript = {
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
  },
}
