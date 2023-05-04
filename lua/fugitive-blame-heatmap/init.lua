-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- core plugin logic

local hl_ns = vim.api.nvim_create_namespace('fugitive-blame-heatmap')

local function to_seconds(timestamp_str)
  local year, month, day, hour, minute, second, timezone = timestamp_str:match("(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d) ([+-]%d%d%d%d)")

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

local function unique_sorted_timestamps(results)
  local unique_timestamps = {}
  local timestamp_set = {}

  for _, result in ipairs(results) do
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

local function highlight_timestamps()

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, hl_ns, 0, -1)
  local git_blame_data = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local results = {}
  for line_nr, line in ipairs(git_blame_data) do
    local timestamp_start, timestamp_end, timestamp = line:find("(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d [+-]%d%d%d%d)")
    if timestamp_start then
      table.insert(results, {
        line_nr = line_nr-1,
        timestamp_start = timestamp_start,
        timestamp_end = timestamp_end,
        timestamp_seconds = to_seconds(timestamp),
      })
    end
  end

  local timestamps = unique_sorted_timestamps(results)
  local oldest = timestamps[1].timestamp
  local newest = timestamps[#timestamps].timestamp

  -- build indexable timestamps table
  -- generate mapped values [0..255]
  -- create highlight groups
  local indexable_timestamps = {}
  for i, v in ipairs(timestamps) do
    local mapped_value = math.floor((v.timestamp - oldest) * (255) / (newest - oldest))
    local hlgroup = string.format("fugitiveBlameHeatmap%04x", i)
    indexable_timestamps[v.timestamp] = {mapped_value = mapped_value, hlgroup = hlgroup}
    vim.cmd(string.format("highlight %s guifg=#ffffff guibg=#%02x0000", hlgroup, mapped_value))
  end

  for _, r in ipairs(results) do
    vim.api.nvim_buf_add_highlight(
      bufnr,
      hl_ns,
      indexable_timestamps[r.timestamp_seconds].hlgroup,
      r.line_nr,
      r.timestamp_start-1,
      r.timestamp_end
    )
  end

end

return {
  highlight_timestamps = highlight_timestamps,
}
