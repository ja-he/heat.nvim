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

return {
  rgb_lerp = rgb_lerp,
  rgb_to_hex_string = rgb_to_hex_string,
}
