-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- core plugin logic

local function get_timestamps_in_blame(git_blame_data)
  local result = {}
  for _, line in ipairs(git_blame_data) do
    local timestamp_start, timestamp_end, timestamp = line:find("(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d [+-]%d%d%d%d)")
    if timestamp_start then
    end
  end
  return result
end

return {
  get_timestamps_in_blame = get_timestamps_in_blame,
  dummy_func = function() print("fugitive-blame-heatmap 😎") end,
}
