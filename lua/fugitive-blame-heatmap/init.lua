-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

-- core plugin logic

local hl_ns = vim.api.nvim_create_namespace('fugitive-blame-heatmap')

local function get_timestamps_in_blame()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, hl_ns, 0, -1)
  local git_blame_data = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for line_nr, line in ipairs(git_blame_data) do
    local timestamp_start, timestamp_end, timestamp = line:find("(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d [+-]%d%d%d%d)")
    if timestamp_start then
      vim.api.nvim_buf_add_highlight(bufnr, hl_ns, 'DiffAdd', line_nr, timestamp_start-1, timestamp_end)
    end
  end
end

return {
  get_timestamps_in_blame = get_timestamps_in_blame,
}
