-- @description Velocitone: Startup ReaScript
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Startup script that loads libraries and runs toolbar sync loop.

--[[
  Collection of Velocitone ReaScripts for Cockos Reaper
  Special thanks for some inspiration:
  helper script inspiration from X-Raym - https://gist.github.com/X-Raym/f7f6328b82fe37e5ecbb3b81aff0b744
  rgbToHsv and hsvToRgb from Airon - Colour Swatch Window  https://forum.cockos.com/member.php?u=62784
]]

-- Init Velocitone --------------------------------------------
local config_file = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/config.lua'

if reaper.file_exists(config_file) then
  dofile(config_file)
else
  reaper.MB("Missing Velocitone config script.\n" .. config_file, "Error", 0)
  return
end
--------------------------------------------
local library_files = {
  'Splash/Splash.lua',
  'Toolbars/Toolbar Init.lua'
}
function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);


-- End Init Velocitone ----------------------------------------

local function Main()
  InitVelocitoneToolbars()
  reaper.defer(Main)
end

-- InitSplash()
Main()

