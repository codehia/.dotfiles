return {
  'kevinhwang91/nvim-bqf',
  dependencies = {
    'ibhagwan/fzf-lua',
  },
  config = function()
    require('bqf').setup {
      -- Your configuration options
      -- Example:
      func_map = {
        -- Map some functions to keys
        ['q'] = 'bqf_qflist_toggle',
        ['<C-j>'] = 'bqf_jump_next',
        ['<C-k>'] = 'bqf_jump_prev',
      },
      -- ... other options
    }
  end,
  -- Optional: Lazy load nvim-bqf when specific events occur
  -- event = 'BufReadPost', -- Or other suitable event
  -- lazy = true, -- Explicitly set lazy loading to true, although it might be the default
}
