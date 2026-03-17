-- @description Velocitone: Toolbar Sync Track Tags
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Syncs toolbar button states with track tag status.

--[[
  Initializes Velocitone Toolbar (on startup as called in __startup.lua)
]]

--------------------------------------------
local library_files = {
  'Toolbars/helpers/Get Track Tags.lua'
}
function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);
-- End Init Velocitone ----------------------------------------

function SyncVelocitoneToolbarTrackTags()

  local totalTags = getTrackTags()
  if (totalTags.isChanged) then -- only do this looping if filter text changed

    for index, tagname in ipairs(velocitone_config.tags) do
      local isFound = false
      for i, _ in pairs(totalTags.tags) do
        local filterTag = totalTags.tags[i]
        if (filterTag == "[" .. tagname .. "]") then
          isFound = true
        end
      end

      if (isFound) then
        reaper.SetToggleCommandState(0, reaper.NamedCommandLookup(velocitone_config.scriptCommandIDs.tagTrackName[tagname]),
          1)
      else
        reaper.SetToggleCommandState(0, reaper.NamedCommandLookup(velocitone_config.scriptCommandIDs.tagTrackName[tagname]),
          -1)
      end
    end
  end
end

