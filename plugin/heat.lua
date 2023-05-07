-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- basic plugin infrastructure

-- register for 'fugitiveblame'-FT buffers to generate the heatmap
local augroup = vim.api.nvim_create_augroup("fugitive-blame-heatmap", { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'fugitiveblame',
  callback = function()
    require('heat.builtin').highlight_timestamps_in_buffer(-1, require 'heat'.config.colors)
  end,
})

-- add user commands
vim.api.nvim_create_user_command(
  "HeatHighlightTimestamps",
  function()
    require('heat.builtin').highlight_timestamps_in_buffer(-1, require 'heat'.config.colors)
  end,
  {
  }
)
