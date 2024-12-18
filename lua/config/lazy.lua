-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
---------------------------------------------------------------------------
--- IMPORTANT VIM OPTIONS ---
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- changed tabs to spaces
vim.cmd("set expandtab")

-- changes tab length 
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.cmd("set number relativenumber")

vim.cmd("set autoindent")
vim.cmd("set smartindent")

vim.g.python3_host_prog = '/usr/bin/python3'

-- nvim terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    desc = "remove line numbers from terminal",
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})
---------------------------------------------------------------------------

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
