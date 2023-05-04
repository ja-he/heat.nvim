-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- basic plugin infrastructure
local augroup = vim.api.nvim_create_augroup("fugitive-blame-heatmap", {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'fugitiveblame',
  callback = function()
    require('fugitive-blame-heatmap').get_timestamps_in_blame()
  end,
})
vim.api.nvim_create_user_command(
  "FugitiveBlameRegenerateHeatmap",
  require('fugitive-blame-heatmap').get_timestamps_in_blame,
  {
  }
)
