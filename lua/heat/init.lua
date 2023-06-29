-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local M = {
  config = {
  },
}

function M.setup(user_config)
  user_config = user_config or {}

  if user_config.colors ~= nil then
    for i, color_info in ipairs(user_config.colors) do
      if type(color_info.color) == "string" then
        user_config.colors[i].color = require'heat.colors'.rgb_from_hex_string(color_info.color)
      elseif type(color_info.color) == "table" then
        user_config.colors[i].color = color_info.color
      else
        error("Invalid input for colors entry: must be a hex string or RGB tuple.")
      end
    end
  end

  local default_config = {}
  if vim.o.background == 'light' then
    default_config.colors = require 'heat.palettes'.red_white
  else
    default_config.colors = require 'heat.palettes'.red_black
  end

  M.config = setmetatable(user_config, { __index = default_config })

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
end

return M
