-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- core plugin logic

local hl_ns = vim.api.nvim_create_namespace('fugitive-blame-heatmap')

local timestamp_regex = "(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d) ([+-]%d%d%d%d)"

local function to_seconds(timestamp_str)
  local year, month, day, hour, minute, second, timezone = timestamp_str:match(timestamp_regex)

  local datetime_tbl = {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(minute),
    sec = tonumber(second),
    isdst = false
  }

  local timezone_offset = tonumber(timezone:sub(1, 3)) * 3600 + tonumber(timezone:sub(4, 5)) * 60
  if timezone:sub(1, 1) == "-" then
    timezone_offset = -timezone_offset
  end

  local timestamp_seconds = os.time(datetime_tbl) + timezone_offset

  return timestamp_seconds
end

local function sort_and_filter_for_unique(timestamps_in_buffer)
  local unique_timestamps = {}
  local timestamp_set = {}

  for _, result in ipairs(timestamps_in_buffer) do
    local timestamp = result.timestamp_seconds
    if not timestamp_set[timestamp] then
      timestamp_set[timestamp] = true
      table.insert(unique_timestamps, { timestamp = timestamp })
    end
  end

  local cmp = function(a, b)
    return a.timestamp < b.timestamp
  end
  table.sort(unique_timestamps, cmp)

  return unique_timestamps
end

local function find_timestamps(buffer_contents)
  local results = {}
  for line_nr, line in ipairs(buffer_contents) do
    local timestamp_start, timestamp_end, timestamp = line:find("(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d [+-]%d%d%d%d)")
    if timestamp_start then
      table.insert(results, {
        line_nr = line_nr - 1,
        timestamp_start = timestamp_start-1,
        timestamp_end = timestamp_end,
        timestamp_seconds = to_seconds(timestamp),
      })
    end
  end
  return results
end

local function create_highlight_groups(timestamps)
  local unique_sorted_timestamps = sort_and_filter_for_unique(timestamps)


  local oldest = unique_sorted_timestamps[1].timestamp
  local newest = unique_sorted_timestamps[#unique_sorted_timestamps].timestamp

  local mapper = require("fugitive-blame-heatmap.mappings.linear").new(oldest, newest, 0, 255)

  local result = {}
  for i, v in ipairs(unique_sorted_timestamps) do
    local mapped_value = mapper:map(v.timestamp)
    local hlgroup = string.format("fugitiveBlameHeatmap%04x", i)
    result[v.timestamp] = { mapped_value = mapped_value, hlgroup = hlgroup }
    vim.cmd(string.format("highlight %s guifg=#ffffff guibg=#%02x0000", hlgroup, mapped_value))
  end
  return result
end

local function highlight_timestamps()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, hl_ns, 0, -1)

  local buffer_contents = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local timestamps_in_buffer = find_timestamps(buffer_contents)
  local highlight_groups_for_timestamps = create_highlight_groups(timestamps_in_buffer)

  -- set the generated highlight groups for the located timestamps
  for _, found_timestamp in ipairs(timestamps_in_buffer) do
    vim.api.nvim_buf_add_highlight(
      bufnr,
      hl_ns,
      highlight_groups_for_timestamps[found_timestamp.timestamp_seconds].hlgroup,
      found_timestamp.line_nr,
      found_timestamp.timestamp_start,
      found_timestamp.timestamp_end
    )
  end
end

return {
  highlight_timestamps = highlight_timestamps,
}
