return {
    --{
    --    "nvim-neo-tree/neo-tree.nvim",
    --    branch = "v3.x",
    --    dependencies = {
    --        "nvim-lua/plenary.nvim",
    --        "MunifTanjim/nui.nvim",
    --        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    --    },
    --    lazy = false, -- neo-tree will lazily load itself
    --},

    -- Rooter: automatic project root detection
    {
        "notjedi/nvim-rooter.lua",
        lazy = true,
        event = "VeryLazy",
        opts = {},
    },

    -- Add some icon support
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        'nvim-mini/mini.nvim',
        version = '*'
    },

    -- Tab line
    {
        'nanozuki/tabby.nvim',
        lazy = true,
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function()
            vim.o.showtabline = 2
            vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
        end,

        ---@type TabbyConfig
        opts = {
            -- configs...
            preset = "active_wins_at_tail",
            option = {
                nerdfont = true,
                buf_name = { mode = "unique" },
            },
        },

        keys = {
            { "<leader><tab>n", "<cmd>$tabnew<cr>", desc = "Previous tab" },
            { "<leader><tab>h", "<cmd>tabprevious<cr>", desc = "Previous tab" },
            { "<leader><tab>l", "<cmd>tabnext<cr>", desc = "Next tab" },
            { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close active tab" },
            { "<leader><tab>L", "<cmd>+tabmove<cr>", desc = "Move active tab right" },
            { "<leader><tab>H", "<cmd>-tabmove<cr>", desc = "Move activ tab left" },
            { "<leader><tab>w", "<cmd>Tabby pick_window<cr>", desc = "Pick tab window" },
            { "<leader><tab>j", "<cmd>Tabby jump_to_tab<cr>", desc = "Jump to tab" },
        }
    },
}
