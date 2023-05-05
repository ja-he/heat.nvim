-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

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

return {
  find_palette_range = find_palette_range,
}
