local slow_format_filetypes = {}
return { -- Autoformat

  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_after_save = function(bufnr)
      if not slow_format_filetypes[vim.bo[bufnr].filetype] then
        require('conform').format { bufnr = bufnr, async = true }
      end
      return { lsp_fallback = true }
    end,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
      end

      local function on_format(err)
        if err and err:match 'timeout$' then
          slow_format_filetypes[vim.bo[bufnr].filetype] = true
        end
      end

      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        on_format,
      }
    end,
    formatters_by_ft = {
      python = { 'isort', 'autopep8' },
      lua = { 'stylua' },
      bash = { 'shfmt' },
      sql = { 'sqlformat' },
      go = { 'gofmt' },
      haskell = { 'ormolu' },
      javascript = { 'prettierd', 'prettier' },
      yaml = { 'yamlfix', args = { '--in-place', '--quiet' } },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      elixir = { 'mix format' },
    },
  },
}
