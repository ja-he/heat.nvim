-- Copyright 2023 Jan Hensel
-- SPDX-License-Identifier: MIT

local function generate_mapping_fn(min_input, max_input, min_output, max_output)
  -- TODO: bounds checking?

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
