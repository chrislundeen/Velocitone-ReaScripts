-- @description Velocitone: Select Visible MCP Track
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @provides [nomain] .
-- @noindex
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Core logic for MCP visible track selection.

--[[
  Selects Visible Track in MCP
]]

function SelectVisibleMCPTrack(direction)
  local CountTrack = reaper.CountTracks(0);
  if CountTrack == 0 then return; end

  local function isTrackVisible(track)
    if reaper.GetMediaTrackInfo_Value(track, 'B_SHOWINMIXER') > 0 then
      return true;
    end
    return false;
  end

  reaper.Undo_BeginBlock();
  reaper.PreventUIRefresh(1);
  local visibleTracks = {}
  local selectedTrack
  local iVisible = 0

  for i = 1, CountTrack do
    local track = reaper.GetTrack(0, i - 1);
    local sel = reaper.GetMediaTrackInfo_Value(track, 'I_SELECTED');
    if sel > 0 then
      selectedTrack = track;
    end
    reaper.SetTrackSelected(track, false)
    local isVisible = isTrackVisible(track);
    if isVisible then
      iVisible = iVisible + 1
      visibleTracks[iVisible] = track;
    end
  end

  local MasterTrack = reaper.GetMasterTrack(0);

  if iVisible > 0 then
    local iSelected = 0
    local iPrev = 0
    local iNext = 0
    local PrevTrack
    local NextTrack
    for j, _ in pairs(visibleTracks) do
      local checkTrack = visibleTracks[j];
      if checkTrack == selectedTrack then
        iSelected = j
        iPrev = j - 1
        iNext = j + 1
      end
    end
    reaper.SetTrackSelected(MasterTrack, false)

    if selectedTrack == MasterTrack then
      -- On master track, keep PrevTrack as Master, set NextTrack as first visible
      PrevTrack = MasterTrack
      NextTrack = visibleTracks[1]
    else
      if iPrev < 1 then
        -- prev track before beginning, select master track
        PrevTrack = MasterTrack
      else
        PrevTrack = visibleTracks[iPrev]
        retval, prevTrackName = reaper.GetTrackName(PrevTrack, "")
      end
      if iNext > iVisible then
        -- next track after end, select last track
        iNext = iVisible
      end
      if iNext == 0 then
        -- Master track selected, set iNext to first visible track
        iNext = 1
      end
      NextTrack = visibleTracks[iNext]
      retval, nextTrackName = reaper.GetTrackName(NextTrack, "")
    end

    if direction == 'previous' then
      reaper.SetTrackSelected(PrevTrack, true)
      reaper.SetMixerScroll(PrevTrack)
    else
      reaper.SetTrackSelected(NextTrack, true)
      reaper.SetMixerScroll(NextTrack)
    end
  else
    -- no visible tracks, we should select master track!
    reaper.SetTrackSelected(MasterTrack, true)
  end

-- Center selected track in Mixer
-- Requires: REAPER v6.x, js_ReaScriptAPI, Multiple rows disabled in Mixer.
-- https://forums.cockos.com/showthread.php?p=2204180
-- TODO: refactor this into helper

    local NumberOfTracks = reaper.CountSelectedTracks(0) / 2 -- gets added later
    local sel_track = reaper.GetSelectedTrack(0,0)
    if sel_track == nil then return end
    if not reaper.IsTrackVisible(sel_track, true) then return end
    local mixer = reaper.JS_Window_Find("Mixer", true)
    if not mixer then return end
    local retval, list = reaper.JS_Window_ListAllChild(mixer)
    for adr in list:gmatch("[^,]+") do -- get child with horiz scrollbar.
      local hwnd = reaper.JS_Window_HandleFromAddress(adr)
      local retval = reaper.JS_Window_GetScrollInfo(hwnd, "SB_HORZ")
      if retval then container = hwnd break end
    end
    if container then
      local _,left,_,right,_ = reaper.JS_Window_GetClientRect(container)
      local mixer_width = (right-left) 
      local track_width = reaper.GetMediaTrackInfo_Value(sel_track, 'I_MCPW')
      local track_number = reaper.CSurf_TrackToID(sel_track, true)
      local _, pos = reaper.JS_Window_GetScrollInfo(container, "SB_HORZ")
      local hVal = (track_width * (track_number+NumberOfTracks-1)) - (mixer_width / 2 - (track_width / 2))
      if pos < hVal then newpos = pos + (hVal - pos) else newpos = pos - (pos - hVal) end
      if newpos < 0 then newpos = 0 end
      reaper.JS_Window_SetScrollPos(container, "SB_HORZ", math.floor(newpos))
    end
-- finish centering


  reaper.PreventUIRefresh(-1);
  reaper.Undo_EndBlock('Reset height unselected tracks MCP by master track', -1);
end
