-- @description Velocitone: Tag Filter: [output]
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Toggles track visibility filter for [output] tagged tracks.

--[[
  Filters Visible Tracks by Selected Tags
  Tags follow format [tag] or {customtag}
  Tags are found at the end of track name
  Manages visibility of tags via Track Manager filter field
]]

-- Init Velocitone --------------------------------------------
local library_files = {
  'Tracks/Tag Manager/Tag Filter.lua'
}
function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);
-- End Init Velocitone ----------------------------------------

is_new, name, sec, cmd, rel, res, val = reaper.get_action_context()
reaper.SetToggleCommandState(sec, cmd, InitTagFilter('[output]', false))
