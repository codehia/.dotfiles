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
