-- @description Velocitone: Library: Tracks: Tag Track Name
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @provides [nomain] .
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Core logic to toggle tags on track names.

--[[
  Library Function: Manages Tags on Tracks via Track Name
  Tags follow format [tag] or {customtag}
  Tags are added at the end of track name
  Manages tags via toggle in track name
  Adds tag if not on selected track, otherwise removes desired tag from track name
  You can associate any FXChain with a tag
]]

function InitTrackTagName(tagName, FXChainName)
  -- Global Parameter Defaults:
  tagName = tagName or ''
  FXChainName = FXChainName or false
  local isCustomTag = false
  local deleteTag = false
  local track
  local tags = {}
  local customTags = {}
  local tagCount = 0
  local newTags = ''
  local newCustomTags = ''

  if string.sub(tagName, 1, 1) == "{" then
    isCustomTag = true
  end

  SCRIPT_NAME = "Velocitone: Tag Track Name (_helper)"

  -- Get number of selected tracks
  local selNum = reaper.CountSelectedTracks(0)

  -- Begin undo-block
  reaper.Undo_BeginBlock2(0)

  -- Loop through selected tracks
  for i = 0, selNum - 1 do
    -- Get track
    track = reaper.GetSelectedTrack(0, i)

    if track then
      -- Get old name
      retval, content = reaper.GetTrackName(track, "")

      local newDescription = content

      tags = {}
      for tag in content:gmatch('(%[%w+%])') do
        tags[string.lower(tag)] = 1
        local removeTag = tag
        removeTag = removeTag:gsub("%[", "%%["):gsub("%]", "%%]")
        newDescription = newDescription:gsub(removeTag, "")
      end

      customTags = {}
      for ctag in content:gmatch('({%w+})') do
        customTags[string.lower(ctag)] = 1
        local removeCTag = ctag
        newDescription = newDescription:gsub(removeCTag, "")
      end

      if isCustomTag then
        if customTags[string.lower(tagName)] == 1 then
          customTags[string.lower(tagName)] = nil
          deleteTag = true
        else
          customTags[string.lower(tagName)] = 1
        end
      else
        if tags[string.lower(tagName)] == 1 then
          tags[string.lower(tagName)] = nil
          deleteTag = true
        else
          tags[string.lower(tagName)] = 1
        end
      end

      tagCount = 0
      newTags = ''
      newCustomTags = ''
      for j, _ in pairs(tags) do
        newTags = newTags .. j
        tagCount = tagCount + 1
      end
      for k, _ in pairs(customTags) do
        newCustomTags = newCustomTags .. k
        tagCount = tagCount + 1
      end

      newDescription = newDescription:gsub("^%s*(.-)%s*$", "%1")

      if FXChainName then
        InitFXChainToSelectedTrack(track, FXChainName, deleteTag)
      end

      -- Set new name
      retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String(track, "P_NAME",
        newDescription .. " " .. newCustomTags .. newTags, true)
    end
  end
  -- End undo-block
  reaper.Undo_EndBlock2(0, SCRIPT_NAME, -1)
end
