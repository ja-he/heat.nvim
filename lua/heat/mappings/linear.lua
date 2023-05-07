-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local function generate_mapping_fn(min_input, max_input)
  -- TODO: bounds checking?

  local min_output = 0.0
  local max_output = 1.0

  return function(value)
    return (
      (value - min_input) * (max_output - min_output)
      / (max_input - min_input)
    ) + min_output
  end
end

return {
  generate_mapping_fn = generate_mapping_fn,
}
