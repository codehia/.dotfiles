return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    require('mini.animate').setup()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin

    local starter = require 'mini.starter'
    starter.setup {
      items = {
        starter.sections.recent_files(5, true, false),
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning('center', 'center'),
        starter.gen_hook.indexing('all', { 'Builtin actions' }),
        starter.gen_hook.padding(3, 2),
      },
      header = function()
        local handle = assert(io.popen('fortune -s | cowsay', 'r'))
        local output = handle:read '*all'
        handle:close()
        return output
      end,
      footer = '',
    }

    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    statusline.active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = 20000 }
      local git = statusline.section_git { trunc_width = 40 }
      local filename = statusline.section_filename { trunc_width = 20000 }
      local fileinfo = statusline.section_fileinfo { trunc_width = 20000 }
      local location = statusline.section_location()
      -- Check why the LSP is showing ++ and add to fileinfo
      -- local lsp = statusline.section_lsp { trunc_width = 20, icon = '󰿘 ' }

      return statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { location } },
      }
    end
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
