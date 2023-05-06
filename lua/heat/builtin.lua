-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local util = require 'heat.util'

local function find_timestamps(buf_nr)
  local buffer_contents = vim.api.nvim_buf_get_lines(buf_nr, 0, -1, false)
  local results = {}
  for line_nr, line in ipairs(buffer_contents) do
    local timestamp_start, timestamp_end, timestamp = line:find(util.timestamp_full_regex)
    if timestamp_start then
      table.insert(results, {
        line_nr = line_nr - 1,
        col_start = timestamp_start - 1,
        col_end = timestamp_end,
        value = util.to_seconds(timestamp),
        buf_nr = buf_nr,
      })
    end
  end
  return results
end


local function highlight_timestamps_in_buffer(buf_nr, palette)
  if buf_nr == -1 then
    buf_nr = vim.api.nvim_get_current_buf()
  end
  if palette == nil then
    if vim.o.background == 'dark' then
      palette = require 'heat.palettes'.red_black
    else
      palette = require 'heat.palettes'.red_white
    end
  end

  local data = find_timestamps(buf_nr)
  local generate_mapping_fn = require 'heat.mappings.linear'.generate_mapping_fn

  require 'heat.interface'.highlight(data, generate_mapping_fn, palette, 'heatTimestampsRecency')
end

return {
  highlight_timestamps_in_buffer = highlight_timestamps_in_buffer,
}
