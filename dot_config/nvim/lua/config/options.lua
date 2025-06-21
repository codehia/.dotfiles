local opt = vim.opt
local wo = vim.wo
local g = vim.g

local function set_options(scope, options)
  for key, value in pairs(options) do
    scope[key] = value
  end
end

local options = {
  number = true,
  relativenumber = true,
  mouse = '',
  showmode = false,
  clipboard = 'unnamedplus',
  breakindent = true,
  undofile = true,
  ignorecase = true,
  smartcase = true,
  signcolumn = 'yes',
  updatetime = 250,
  timeoutlen = 300,
  splitright = true,
  splitbelow = true,
  list = true,
  listchars = {
    eol = '↲', -- End of line
    tab = '▏·', -- Tab character (Arrow followed by a dot)
    trail = '·', -- Trailing spaces
    extends = '⟩', -- Character when text extends beyond the window
    precedes = '⟨', -- Character when text precedes the window
    nbsp = '␣', -- Non-breaking space
  },
  inccommand = 'split',
  cursorline = true,
  scrolloff = 10,
  hlsearch = true,
  laststatus = 3,
  splitkeep = 'screen',
  smoothscroll = true,
  fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
  },
}
set_options(g, { mapleader = ' ', maplocalleader = ' ' })
set_options(opt, options)
set_options(wo, { wrap = false })

vim.opt.foldcolumn = '0'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''

vim.opt.foldnestmax = 3
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local function close_all_folds()
  vim.api.nvim_exec2('%foldc!', { output = false })
end
local function open_all_folds()
  vim.api.nvim_exec2('%foldo!', { output = false })
end

vim.keymap.set('n', '<leader>zs', close_all_folds, { desc = '[s]hut all folds' })
vim.keymap.set('n', '<leader>zo', open_all_folds, { desc = '[o]pen all folds' })
