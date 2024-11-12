return {
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("quarto").setup()
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.qmd",
                command = "set filetype=latex",
            })
            -- Corrected keybinding for inserting a Python code block
            vim.keymap.set({ "n", "i" }, "<C-M-i>", "<Esc>i```{python}<CR>```<Esc>O", { noremap = true, silent = true })

            -- Corrected OpenIPython function
            vim.api.nvim_create_user_command("OpenIPython", function()
                -- Open a new split below and move into it
                vim.cmd("belowright split")
                vim.cmd("resize 15") -- Optional: Adjust the terminal height
                vim.cmd("term ipython") -- Open IPython in the terminal

                -- Get the terminal buffer
                local buf = vim.api.nvim_get_current_buf()
                vim.api.nvim_buf_set_name(buf, "IPythonTerminal")

                -- Get the job ID
                local job_id = vim.b.terminal_job_id

                if job_id then
                    vim.g.slime_default_config = { jobid = job_id }
                    print("Job ID set to:", job_id)
                else
                    print("Failed to set Job ID: terminal_job_id not found")
                end

                -- Return focus to the original window
                vim.cmd("wincmd p")
            end, {})

            vim.keymap.set(
                "n",
                "<leader>ci",
                ":OpenIPython<CR>",
                { noremap = true, silent = true, desc = "Open IPython terminal split" }
            )
        end,
    },

    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_target = "neovim"
            vim.g.slime_python_ipython = 1
            vim.g.slime_dispatch_ipython_pause = 100
            vim.g.slime_cell_delimiter = "# %%"

            -- Corrected send_python_block function
            local function send_python_block()
                -- Get the current cursor position
                local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-based indexing

                local bufnr = vim.api.nvim_get_current_buf()
                local total_lines = vim.api.nvim_buf_line_count(bufnr)

                local start_line = nil
                local end_line = nil

                -- Scan upwards to find ```{python}
                for i = cursor_line, 0, -1 do
                    local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
                    if line:match("^```{python}") then
                        start_line = i + 1 -- Exclude the ```{python} line
                        break
                    end
                end

                if not start_line then
                    print("No starting code block delimiter found.")
                    return
                end

                -- Scan downwards to find ```
                for i = cursor_line, total_lines - 1 do
                    local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
                    if line:match("^```$") then
                        end_line = i - 1 -- Exclude the ``` line
                        break
                    end
                end

                if not end_line then
                    print("No ending code block delimiter found.")
                    return
                end

                if start_line > end_line then
                    print("Invalid code block boundaries.")
                    return
                end

                -- Extract code between start_line and end_line
                local code_lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)

                -- Send each line using slime#send
                for _, line in ipairs(code_lines) do
                    vim.fn["slime#send"](line .. "\n")
                end
                -- Send an extra newline to execute the code block
                vim.fn["slime#send"]("\n")

                print("Sent Python code block from lines", start_line + 1, "to", end_line + 1)
            end

            -- Keybinding to send the Python code block to IPython terminal
            vim.keymap.set("n", "<leader>cs", send_python_block, { noremap = true, silent = true })
        end,
    },
}
