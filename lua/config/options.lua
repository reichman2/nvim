local opt = vim.opt

opt.syntax = "enable"
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true -- use spaces instead of tabs.
opt.smarttab = true -- let's tab key insert 'tab stops', and bksp deletes tabs.
opt.shiftround = true -- tab / shifting moves to closest tabstop.
opt.autoindent = true -- Match indents on new lines.
opt.smartindent = true -- Intellegently dedent / indent new lines based on rules.

-- Make search more sane
opt.ignorecase = true -- case insensitive search
opt.smartcase = true -- If there are uppercase letters, become case-sensitive.
opt.incsearch = true -- live incremental searching
opt.showmatch = true -- live match highlighting
opt.hlsearch = true -- highlight matches
opt.gdefault = true -- use the `g` flag by default.

opt.virtualedit:append("block")

opt.wrap = false -- do not wrap lines
