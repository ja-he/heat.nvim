-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local function lerp(a, b, v)
  return a + (b - a) * v
end

local function rgb_lerp(color_a, color_b, v)
  local r = lerp(color_a[1], color_b[1], v)
  local g = lerp(color_a[2], color_b[2], v)
  local b = lerp(color_a[3], color_b[3], v)

  return { r, g, b }
end

local function rgb_to_hex_string(color)
  local r, g, b = unpack(color)
  return string.format("#%02x%02x%02x", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

local function rgb_from_hex_string(hex)
  local r = tonumber(hex:sub(2, 3), 16) / 255
  local g = tonumber(hex:sub(4, 5), 16) / 255
  local b = tonumber(hex:sub(6, 7), 16) / 255

  return { r, g, b }
end

local function rgb_get_textcolor(color)
  local r, g, b = unpack(color)
  if r + g + b > 1.5 then
    return { 0.0, 0.0, 0.0 } -- black
  else
    return { 1.0, 1.0, 1.0 } -- white
  end
end

return {
  rgb_lerp = rgb_lerp,
  rgb_to_hex_string = rgb_to_hex_string,
  rgb_from_hex_string = rgb_from_hex_string,
  rgb_get_textcolor = rgb_get_textcolor,
}
