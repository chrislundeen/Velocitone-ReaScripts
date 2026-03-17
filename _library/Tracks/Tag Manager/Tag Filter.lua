-- @description Velocitone: Library: Tracks: Tag Filter
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @provides [nomain] .
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Core tag-based track visibility filtering logic.

--[[
  Library Function: Filters Visible Tracks by Selected Tags
  Tags follow format [tag] or {customtag}
  Tags are added at the end of track name
  Manages visibility of tags via Track Manager filter field
]]

function InitTagFilter(tagName, isCustomTag)
  local tagFilterToggleState = -1

  -- Global Parameter Defaults:
  tagName = tagName or ''
  isCustomTag = isCustomTag or false

  local tm = reaper.JS_Window_Find('Track Manager', true)

  if not tm or not reaper.JS_Window_IsVisible(tm) then
    reaper.Main_OnCommand(40906, 0) -- View: Show track manager window
    tm = reaper.JS_Window_Find('Track Manager', true)
  end

  if tm then
    local filter = reaper.JS_Window_FindChildByID(tm, 0x3EF)
    local content = ''

    if filter then
      -- Get Contents of track manager filter
      content = reaper.JS_Window_GetTitle(filter)

      newDescription = content
      newDescription = newDescription:gsub(" OR ", ""):gsub("^%s*(.-)%s*$", "%1")

      tags = {}
      for tag in content:gmatch('(%[%w+%])') do
        tags[string.lower(tag)] = 1
        removeTag = tag
        removeTag = removeTag:gsub("%[", "%%["):gsub("%]", "%%]")
        newDescription = newDescription:gsub(removeTag, "")
      end

      customTags = {}
      for ctag in content:gmatch('({%w+})') do
        customTags[string.lower(ctag)] = 1
        removeCTag = ctag
        newDescription = newDescription:gsub(removeCTag, "")
      end

      if isCustomTag then
        if customTags[string.lower(tagName)] == 1 then
          customTags[string.lower(tagName)] = nil
          tagFilterToggleState = -1
        else
          customTags[string.lower(tagName)] = 1
          tagFilterToggleState = 1
        end
      else
        if tags[string.lower(tagName)] == 1 then
          tags[string.lower(tagName)] = nil
          tagFilterToggleState = -1
        else
          tags[string.lower(tagName)] = 1
          tagFilterToggleState = 1
        end
      end

      tagCount = 0
      newTags = ''
      newCustomTags = ''
      for j, _ in pairs(tags) do
        if tagCount > 0 or not (newDescription == nil or newDescription == '') then
          newTags = newTags .. ' OR '
        end
        newTags = newTags .. j
        tagCount = tagCount + 1
      end
      for k, _ in pairs(customTags) do
        if tagCount > 0 or not (newDescription == nil or newDescription == '') then
          newCustomTags = newCustomTags .. ' OR '
        end
        newCustomTags = newCustomTags .. k
        tagCount = tagCount + 1
      end

      -- Set track manager filter
      reaper.JS_Window_SetTitle(filter, newDescription .. newCustomTags .. newTags)
      -- Set focus on track manager filter
      reaper.JS_Window_SetFocus(filter)
    end
  end

  return tagFilterToggleState
end
