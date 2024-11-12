return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"lua",
				"html",
				"rust",
				"c",
				"python",
				"latex",
				"bash",
				"json",
				"yaml",
				"toml",
				"cpp",
				"cmake",
				"regex",
				"rust",
			},
			-- autoinstal = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
