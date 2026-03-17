-- @description Velocitone: Library: Tracks: Tag Filter Reset
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @provides [nomain] .
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Core logic to reset all tag filters.

--[[
  Library Function: Resets Filter For Visible Tracks
  Tags follow format [tag] or {customtag}
  Tags are added at the end of track name
  Manages visibility of tags via Track Manager filter field
]]

function InitTagFilterReset()
  -- Global Parameter Defaults:

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

      -- Set track manager filter
      reaper.JS_Window_SetTitle(filter, '')
      -- Set focus on track manager filter
      reaper.JS_Window_SetFocus(filter)
    end
  end
end
