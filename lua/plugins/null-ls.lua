return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- lua
                null_ls.builtins.formatting.stylua,

                -- python
                null_ls.builtins.formatting.black.with({
                    command = vim.fn.exepath("black"),
                }),
                null_ls.builtins.formatting.isort.with({
                    command = vim.fn.exepath("isort"),
                }),
                -- null_ls.builtins.diagnostics.pylint.with({
                -- 	command = vim.fn.exepath("pylint"),
                -- }),

                -- c++
                null_ls.builtins.formatting.clang_format.with({
                    extra_args = { "--style", "{IndentWidth: 4}" }
                }),
                null_ls.builtins.diagnostics.cmakelang,
                null_ls.builtins.formatting.cmake_format,

                -- null_ls.builtins.diagnostics.cpplint,
            },
        })

        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}
