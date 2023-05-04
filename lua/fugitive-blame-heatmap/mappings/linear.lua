-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local Mapper = {}
Mapper.__index = Mapper

function Mapper.new(min_input, max_input, min_output, max_output)
  local self = setmetatable({}, Mapper)
  self.min_input = min_input
  self.max_input = max_input
  self.min_output = min_output
  self.max_output = max_output
  return self
end

function Mapper:map(value)
  return math.floor(
    (
      (value - self.min_input) * (self.max_output - self.min_output)
      / (self.max_input - self.min_input)
    )
    + self.min_output
  )
end

return Mapper
