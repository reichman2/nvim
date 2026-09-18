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
}
