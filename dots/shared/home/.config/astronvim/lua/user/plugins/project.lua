return {
  "ahmedkhalf/project.nvim",
  config = function()
    local telescope = require("telescope")

    require("project_nvim").setup({ show_hidden = true })

    telescope.load_extension("projects")
  end,
  dependencies = { "nvim-telescope/telescope.nvim" },
}
