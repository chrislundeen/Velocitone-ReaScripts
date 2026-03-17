-- @description Velocitone: Hardware: MIDIFighter Twister: (Select Bank 3)
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Switches MIDIFighter Twister to bank 3.

--[[
  Selects Bank 3 for DJ TechTools MidiFighter Twister
]]

-- Init Velocitone --------------------------------------------
local library_files = {
  'Hardware Control/MidiFighter/Twister/Select Bank.lua'
}
function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);
-- End Init Velocitone ----------------------------------------

InitMidiFighterTwisterSelectBank(3)
