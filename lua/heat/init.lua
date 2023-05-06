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
end

return M
