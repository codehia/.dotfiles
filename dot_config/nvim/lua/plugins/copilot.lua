local copilot_keys = {
  {
    '<leader>as',
    function()
      require('copilot.suggestion').toggle_auto_trigger()
    end,
    desc = 'Copilot: Toggle auto suggestion',
  },
}

return {
  'zbirenbaum/copilot-cmp',
  dependencies = {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { 'InsertEnter', 'LspAttach' },
    keys = copilot_keys,
    config = function()
      require('copilot').setup {}
    end,
  },
  config = function()
    require('copilot_cmp').setup()
  end,
}
