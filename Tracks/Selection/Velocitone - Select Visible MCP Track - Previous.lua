-- @description Velocitone: Select Visible MCP Track - Previous
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Selects the previous visible track in the Mixer Control Panel.

--[[ 
  Select Previous Visible Track in MCP
]]

-- Init Velocitone --------------------------------------------
local library_files = {
  'Tracks/Selection/Select Visible MCP Track.lua'
}
function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);
-- End Init Velocitone ----------------------------------------

SelectVisibleMCPTrack('previous')