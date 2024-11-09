return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      --      ensure_installed = {"lua", "html", "rust", "c", "python"},
      autoinstal = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
