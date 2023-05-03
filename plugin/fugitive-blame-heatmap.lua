-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- basic plugin infrastructure
vim.api.nvim_create_user_command(
  "FugitiveBlameHeatmapDummyCommand",
  require('fugitive-blame-heatmap').dummy_func,
  {
  }
)
vim.api.nvim_create_user_command(
  "FugitiveBlameHeatmap",
  require('fugitive-blame-heatmap').get_timestamps_in_blame,
  {
  }
)
