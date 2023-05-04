-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- basic plugin infrastructure

-- register for 'fugitiveblame'-FT buffers to generate the heatmap
local augroup = vim.api.nvim_create_augroup("fugitive-blame-heatmap", {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'fugitiveblame',
  callback = function()
    require('fugitive-blame-heatmap').highlight_timestamps()
  end,
})

-- add user commands
vim.api.nvim_create_user_command(
  "FugitiveBlameRegenerateHeatmap",
  require('fugitive-blame-heatmap').highlight_timestamps,
  {
  }
)
