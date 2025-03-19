return {
  'onsails/lspkind.nvim',
  setup = function()
    require('lspkind').setup {
      mode = 'symbol_text',
      preset = 'codicons',
    }
  end,
}
