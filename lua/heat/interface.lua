-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local colors = require("heat.colors")
local util = require("heat.util")
local linear = require("heat.mappings.linear")
local palettes = require("heat.palettes")

local function create_highlight_groups(data, mapping_fn_creator, palette, highlight_namespace_name)
  local unique_sorted_data_by_value = util.sort_and_filter_for_unique_by_value(data)

  local min = unique_sorted_data_by_value[1].value
  local max = unique_sorted_data_by_value[#unique_sorted_data_by_value].value

  local mapping_fn = mapping_fn_creator(min, max, 0.0, 1.0)

  local map_to_hexrgb = function(mapped_value)
    local range = util.find_palette_range(palette, mapped_value)
    local color_for_value
    local range_lb, range_ub = unpack(range)
    if range_lb == nil then
      error("unable to get range_lb for value, expected 1 or 2 values, got none")
    end
    if range_ub == nil then
      color_for_value = range_lb.color
    else
      local range_width = range_ub.value - range_lb.value
      local normalized_mapped_value = (mapped_value - range_lb.value) / range_width
      color_for_value = colors.rgb_lerp(range_lb.color, range_ub.color, normalized_mapped_value)
    end
    if color_for_value == nil then
      error("unable to assign color_for_value")
    end
    return {
      fg_color = colors.rgb_to_hex_string(colors.rgb_get_textcolor(color_for_value)),
      bg_color = colors.rgb_to_hex_string(color_for_value),
    }
  end

  local results = {}
  for i, v in ipairs(unique_sorted_data_by_value) do
    local mapped_value = mapping_fn(v.value)
    local hlgroup = string.format(highlight_namespace_name .. "%04x", i)
    results[v.value] = { mapped_value = mapped_value, hlgroup = hlgroup }
    local mapped_colors = map_to_hexrgb(mapped_value)
    vim.cmd(string.format("highlight %s guifg=%s guibg=%s", hlgroup, mapped_colors.fg_color, mapped_colors.bg_color))
  end
  return results
end

local function highlight(data, generate_mapping_fn, palette, highlight_namespace_name)
  -- verify and unify input
  if data == nil then
    error("data must not be nil")
  elseif #data == 0 then
    return
  end
  if generate_mapping_fn == nil then
    generate_mapping_fn = linear.generate_mapping_fn
  end
  if palette == nil then
    if vim.o.background == "light" then
      palette = palettes.red_white
    else
      palette = palettes.red_black
    end
  end
  if highlight_namespace_name == nil or highlight_namespace_name == "" then
    error("must pass a name for the highlight-namespace")
  else
  end

  local hl_ns = vim.api.nvim_create_namespace(highlight_namespace_name)
  local highlight_groups = create_highlight_groups(data, generate_mapping_fn, palette, highlight_namespace_name)

  -- set the generated highlight groups each datum
  for _, datum in ipairs(data) do
    if (datum.buf_nr == nil or datum.line_nr == nil or datum.col_start == nil or datum.col_end == nil or datum.value == nil) then
      error("data must have format {buf_nr=I,line_nr=I,col_start=I,col_end=I,value=I}")
    end
    vim.api.nvim_buf_add_highlight(
      datum.buf_nr,
      hl_ns,
      highlight_groups[datum.value].hlgroup,
      datum.line_nr,
      datum.col_start,
      datum.col_end
    )
  end
end

return {
  highlight = highlight,
}
