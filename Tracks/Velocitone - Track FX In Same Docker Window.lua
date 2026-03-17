-- @description Velocitone: Track FX In Same Docker Window
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Opens track FX in the same docker window (experimental).

--[[
  Track FX In Same Docker Window
]]

-- DO NOT USE

-- This script ensures that the selected track FX always opens in the same docker window.

function OnTrackFXWindowOpen()
  -- Get the selected track.
  local selectedTrack = reaper.GetSelectedTrack(0, 0)

  -- Get the FX window for the selected track.
  local fxWindow = reaper.GetExtState("SWS:TrackFXWindow", selectedTrack, 0)

  -- If the FX window is not already open, open it.
  if not reaper.CountSelectedMediaItems(0) and not fxWindow then
    reaper.ShowConsoleMessage("Opening FX window for selected track...")
    reaper.Main_OnCommand(40108, 0)
  end

  -- Dock the FX window.
  reaper.SetExtState("SWS:TrackFXWindow:Dock", fxWindow, 1)
end

reaper.Register('OnTrackFXWindowOpen', OnTrackFXWindowOpen)
