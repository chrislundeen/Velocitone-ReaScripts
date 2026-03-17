-- @description Velocitone: Library: Tracks: Tag Manager: FXChain Toggle for Selected Track
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @provides [nomain] .
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Toggles FX chain bypass for selected track.

--[[
  Library Function: Toggles FXChain for Selected Track
]]

function AddFXChainToTrack(tr, chunk)
  local _, chunk_ch = reaper.GetTrackStateChunk(tr, '', false)
  if not chunk_ch:match('FXCHAIN') then
    chunk_ch = chunk_ch:sub(0, -3) ..
        '<FXCHAIN\nSHOW 0\nLASTSEL 0\n DOCKED 0\n>\n>\n'
  end
  if chunk then chunk_ch = chunk_ch:gsub('DOCKED %d', chunk) end
  reaper.SetTrackStateChunk(tr, chunk_ch, false)
end

function RemoveFXChainFromTrack(tr, chunk)
  local lines = {}
  local fxname
  local match
  for s in chunk:gmatch("[^\r\n]+") do
    if string.sub(s, 1, 1) == "<" then
      fxname = string.match(s, '%b""')
      fxname = string.gsub(fxname, '"', "")
      for fx = reaper.TrackFX_GetCount(tr), 1, -1 do
        local retval, buf = reaper.TrackFX_GetFXName(tr, fx)
        match = buf:lower():match(fxname:lower())
        if not match then
          reaper.TrackFX_Delete(tr, fx - 1)
        end
      end
      table.insert(lines, s)
    end
  end
end

function InitFXChainToSelectedTrack(track, FXChain, deleteFXChain)
  -- Begin undo-block
  reaper.Undo_BeginBlock2(0)

  local FXPath = reaper.GetResourcePath() .. '/FXChains/'
  local FXChainInstance = FXPath .. FXChain .. ".RfxChain"
  local f = io.open(FXChainInstance, 'r')

  if f then
    local chunkContent = f:read('a')
    f:close()

    if deleteFXChain then
      RemoveFXChainFromTrack(track, chunkContent)
    else
      AddFXChainToTrack(track, chunkContent)
    end
  end

  -- End undo-block
  reaper.Undo_EndBlock2(0, SCRIPT_NAME, -1)
end
