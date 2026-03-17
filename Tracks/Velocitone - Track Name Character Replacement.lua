-- @description Velocitone: Track Name Character Replacement
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Find-and-replace characters in selected track names.

--[[ 
  Track Name Character Replacement
]]

function Init()

  local retval_inputs, retvals_csv = reaper.GetUserInputs("Track Name Character Replacement", 2, "Search:,Replace:",
    'search,replace')

  if retval_inputs then

    searchVal, replaceVal = string.match(retvals_csv, "([^,]+),([^,]+)")

    SCRIPT_NAME = "Velocitone: Custom Tag Character Replacement"

    -- Get number of selected tracks
    selNum = reaper.CountSelectedTracks(0)

    -- Begin undo-block
    reaper.Undo_BeginBlock2(0)

    -- Loop through selected tracks
    renameNum = 0
    for i = 0, selNum - 1 do
      -- Get track
      track = reaper.GetSelectedTrack(0, i)

      if track then
        -- Get old name
        retval, oldTrackName = reaper.GetTrackName(track, "")

        trackName = oldTrackName
        if trackName:find(searchVal) then
          trackName = trackName:gsub(searchVal, replaceVal)
        end

        -- Set new name
        retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", trackName, true)

      end

      renameNum = i + 1

    end

    -- Notify how many tracks were renamed
    -- str = renameNum .. " track(s) were renamed to " .. newTags .. " from " .. trackDesc .. ".\n"
    -- reaper.ShowMessageBox(str, SCRIPT_NAME, 0)

    -- End undo-block
    reaper.Undo_EndBlock2(0, SCRIPT_NAME, -1)

  end

end

Init()
