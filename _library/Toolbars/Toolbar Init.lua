-- @description Velocitone: Toolbar Init
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Toolbar initialization and sync loader.

--[[
  Initializes Velocitone Toolbar (on startup as called in __startup.lua)
]]

--------------------------------------------
local library_files = {
  'Toolbars/sync/Toolbar Sync Filter Tags.lua',
  'Toolbars/sync/Toolbar Sync Track Tags.lua'
}
function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);
-- End Init Velocitone ----------------------------------------

function InitVelocitoneToolbars()

  SyncVelocitoneToolbarFilterTags()
  SyncVelocitoneToolbarTrackTags()

end
