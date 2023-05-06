-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local timestamp_parts_regex = "(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d) ([+-]%d%d%d%d)"
local timestamp_full_regex = "(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d [+-]%d%d%d%d)"

local function find_palette_range(palette, value)
  local lower_bound, upper_bound

  for _, entry in ipairs(palette) do
    local k = entry.value
    if k <= value and (lower_bound == nil or k > lower_bound.value) then
      lower_bound = entry
    end

    if k >= value and (upper_bound == nil or k < upper_bound.value) then
      upper_bound = entry
    end
  end

  local result = {}
  if lower_bound ~= nil then table.insert(result, lower_bound) end
  if upper_bound ~= nil and upper_bound ~= lower_bound then table.insert(result, upper_bound) end

  return result
end

local function to_seconds(timestamp_str)
  local year, month, day, hour, minute, second, timezone = timestamp_str:match(timestamp_parts_regex)

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

local function sort_and_filter_for_unique_by_value(data)
  local unique_result = {}
  local unique_helper = {}

  for _, datum in ipairs(data) do
    local value = datum.value
    if not unique_helper[value] then
      unique_helper[value] = true
      table.insert(unique_result, { value = value })
    end
  end

  local cmp = function(a, b)
    return a.value < b.value
  end
  table.sort(unique_result, cmp)

  return unique_result
end

return {
  find_palette_range = find_palette_range,
  to_seconds = to_seconds,
  timestamp_parts_regex = timestamp_parts_regex,
  timestamp_full_regex = timestamp_full_regex,
  sort_and_filter_for_unique_by_value = sort_and_filter_for_unique_by_value,
}
