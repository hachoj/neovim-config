return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- lua
                null_ls.builtins.formatting.stylua,

                -- python
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.diagnostics.pylint,

                -- c++
                null_ls.builtins.formatting.clang_format.with({
                    extra_args = { "--style", "{IndentWidth: 4}" },
                }),

                -- null_ls.builtins.diagnostics.cpplint,
            },
        })

        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}
