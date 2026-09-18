return {
    {
        "uhs-robert/oasis.nvim",
        lazy = false,
        priority = 1000,
        config = function()
        require("oasis").setup()      -- (see Configuration below for all customization options)
            vim.cmd.colorscheme("oasis-mirage")  -- After setup, apply theme (or any style like "oasis-night")
        end
    },

      -- Lualine: Enhanced statusline with time display and file manager integration
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options = opts.options or {}

            opts.options.theme = "oasis"
            opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
                lualine_z = {
                    {
                        function()
                            return os.date("%I:%M:%S %p")
                        end,
                        icon = "󰥔",
                    },
                },
            })
            if opts.sections and opts.sections.lualine_c then
                for _, section in ipairs(opts.sections.lualine_c) do
                    section.on_click = function()
                        local file_path = vim.fn.expand("%:p:h") -- Get file's directory
                        vim.fn.jobstart({ "thunar", file_path }, { detach = true }) -- Open Thunar
                    end
                end
            end
        end,
    },
}
