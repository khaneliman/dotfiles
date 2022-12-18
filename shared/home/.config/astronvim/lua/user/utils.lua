local function deep_copy(object)
  if type(object) ~= 'table' then return object end

  local result = {}
  for key, value in pairs(object) do result[key] = deep_copy(value) end
  return result
end

local function spread(template, override)
  if not override then
    return function(override) spread(template, override) end
  end

  local mt = getmetatable(template)
  local result = {}
  setmetatable(result, mt)

  for key, value in pairs(template) do result[key] = deep_copy(value) end

  -- No longer wrapped up inside a function
  for key, value in pairs(override) do result[key] = value end

  return result
end
