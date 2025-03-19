return {
  'folke/zen-mode.nvim',
  opts = {
    plugins = {
      gitsigns = { enabled = false },
      tmux = { enabled = true },
      kitty = {
        enabled = true,
        font = '+4',
      },
    },
    window = {
      width = 0.85,
    },
  },
}
