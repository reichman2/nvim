local headers = {
    NEOVIM_BLOCK = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]
}

local function color_squares()
    -- { normal, bright } fallbacks, used only if the colorscheme doesn't set terminal colors
    local palette = {
        { "Red",    "#cd3131", "#f14c4c" },
        { "Green",  "#0dbc79", "#23d18b" },
        { "Yellow", "#e5e510", "#f5f543" },
        { "Blue",   "#2472c8", "#3b8eea" },
        { "Purple", "#bc3fbc", "#d670d6" },
        { "Cyan",   "#11a8cd", "#29b8db" },
    }

    -- ANSI 1-6 are the normal colors, 9-14 the bright ones
    for i, c in ipairs(palette) do
        vim.api.nvim_set_hl(0, "DashSq" .. c[1], {
            fg = vim.g["terminal_color_" .. i] or c[2],
            ctermfg = i,
        })
        vim.api.nvim_set_hl(0, "DashSq" .. c[1] .. "Bright", {
            fg = vim.g["terminal_color_" .. (i + 8)] or c[3],
            ctermfg = i + 8,
            bold = true,
        })
    end

    local rows = {
        { "▀ █", "█ ▀" },
        { "██ ", " ██" },
        { "▄ █", "█ ▄" },
    }

    local text = {}
    for r, row in ipairs(rows) do
        for i, c in ipairs(palette) do
            table.insert(text, { row[1], hl = "DashSq" .. c[1] })
            table.insert(text, { " " })
            table.insert(text, { row[2], hl = "DashSq" .. c[1] .. "Bright" })
            if i < #palette then
                table.insert(text, { "   " })
            end
        end
        if r < #rows then
            table.insert(text, { "\n" })
        end
    end

    return { pane = 2, text = text, align = "center", padding = 1 }
end

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    keys = {
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>`", function() Snacks.explorer() end, desc = "File Explorer" },
    },

    ---@type snacks.Config
    opts = {
        ---@class snacks.dashboard.Config
        ---@field enabled? boolean
        ---@field sections snacks.dashboard.Section
        ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
        dashboard = {
            width = 60,
            row = nil, -- dashboard position. nil for center
            col = nil, -- dashboard position. nil for center
            pane_gap = 4, -- empty columns between vertical panes
            autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence

            preset = {
                -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
                ---@type fun(cmd:string, opts:table)|nil
                pick = nil,

                ---@type snacks.dashboard.Item[]
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = function() Snacks.dashboard.pick('files') end },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = function() Snacks.dashboard.pick('live_grep') end },
                    { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.dashboard.pick('oldfiles') end },
                    { icon = " ", key = "c", desc = "Config", action = function() Snacks.dashboard.pick('files', { cwd = vim.fn.stdpack('config')}) end },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" }
                },

                header = headers.NEOVIM_BLOCK,
            },
            
            formats = {
                icon = function(item)
                    if item.file and item.icon == "file" or item.icon == "directory" then
                        return Snacks.dashboard.icon(item.file, item.icon)
                    end

                    return { item.icon, width = 2, hl = "icon" }
                end,

                header = { "%s", align = "center" },
                footer = { "%s", align = "center" },

                file = function(item, ctx)
                    local fname = vim.fn.fnamemodify(item.file, ":~")
                    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                    if #fname > ctx.width then
                        local dir = vim.fn.fnamemodify(fname, ":h")
                        local file = vim.fn.fnamemodify(fname, ":t")
                        if dir and file then
                            file = file:sub(-(ctx.width - #dir - 2))
                            fname = dir .. "/…" .. file
                        end
                    end

                    local dir, file = fname:match("^(.*)/(.+)$")
                    return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
                end
            },

            sections = {
                { section = "header" },
                
                color_squares,
                { section = "keys", gap = 1, padding = 1 },

                {
                    pane = 2,
                    icon = " ",
                    title = "Recent Files",
                    section = "recent_files",
                    indent = 2,
                    padding = 1
                },

                {
                    pane = 2,
                    icon = " ",
                    title = "Projects",
                    section = "projects",
                    indent = 2,
                    padding = 1
                },

                {
                    pane = 2,
                    icon = " ",
                    title = "Git Status",
                    section = "terminal",
                    enabled = function()
                        return Snacks.git.get_root() ~= nil
                    end,
                    cmd = "git status --short --branch --renames",
                    height = 5,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                },

                { section = "startup" }
            }
        },

        git = { enabled = true },
        bigfile = { enabled = true },
        explorer = {
            enabled = true,
            ---@class snacks.explorer.Config
            replace_netrw = true, -- Replace netrw with the snacks explorer
            trash = true, -- Use the system trash when deleting files
        },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
}
