local Addon = select(2, ...) ---@type Addon

--- @class MessageBuilder
local MessageBuilder = Addon:GetModule("MessageBuilder")

--- @class MessageBuilderInstance
--- @field builder string[]

-- ============================================================================
-- Mixins
-- ============================================================================

--- @class MessageBuilderInstance
local MessageBuilderMixins = {}

--- Resets the builder.
function MessageBuilderMixins:Reset()
  for k in pairs(self.builder) do self.builder[k] = nil end
end

--- Appends the given `obj` to the builder as a string.
--- @param obj any
function MessageBuilderMixins:Append(obj)
  self.builder[#self.builder + 1] = tostring(obj)
end

--- Builds and returns the resulting string.
--- @param sep string? defaults to `" "`
--- @return string
function MessageBuilderMixins:Build(sep)
  sep = sep or " "

  -- Trim entries and remove blanks.
  for i = #self.builder, 1, -1 do
    local s = self.builder[i]:trim()
    if s ~= "" then
      self.builder[i] = s
    else
      table.remove(self.builder, i)
    end
  end

  return table.concat(self.builder, sep):trim()
end

-- ============================================================================
-- Functions
-- ============================================================================

--- Creates a new MessageBuilder instance.
--- @return MessageBuilderInstance
function MessageBuilder:New()
  local t = { builder = {} }
  for k, v in pairs(MessageBuilderMixins) do t[k] = v end
  return t
end
