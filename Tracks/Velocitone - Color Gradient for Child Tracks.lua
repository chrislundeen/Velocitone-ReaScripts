-- @description Velocitone: Color Gradient for Child Tracks
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Applies color gradient across child tracks based on parent track color.

--[[ 
  Reset color for all children tracks to a gradient of their parent track
]]

for key in pairs(reaper) do _G[key] = reaper[key] end

local function rgbToHsv(r, g, b)
  --r, g, b = r / 255, g / 255, b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local d = max - min
  local h, s, v
  v = max

  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end

    h = h / 6
  end

  return h, s, v
end

local function hsvToRgb(h, s, v)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r, g, b
end

local function getMaxDepth(currentTrack)

  local nm, xtname = reaper.GetTrackName(reaper.GetTrack(0, currentTrack), "")
  -- reaper.ShowMessageBox("currentTrack: " .. currentTrack .. ", NAME: " .. xtname, "DETAILS", 0)

  local tr
  local depth
  local initialDepth
  local maxDepth = 0
  tr = reaper.GetTrack(0, currentTrack)
  initialDepth = reaper.GetTrackDepth(tr)

  for j = currentTrack, reaper.CountTracks() - 1 do
    tr = reaper.GetTrack(0, j)
    depth = reaper.GetTrackDepth(tr)
    if depth >= maxDepth then
      maxDepth = depth
    end
  end
  return maxDepth
end

local function main()
  local tr
  local depth
  local col
  local maxDepth
  local firstcolor_r, firstcolor_g, firstcolor_b
  local r_step, g_step, b_step
  local value_r, value_g, value_b
  local gradientAdjustment = .7

  -- reaper.ShowMessageBox("NUMBER OF TRACKS: " .. CountTracks(), "NUM", 0)

  for i = 0, reaper.CountTracks() - 1 do
    tr = reaper.GetTrack(0, i)

    depth = reaper.GetTrackDepth(tr)
    col = reaper.GetTrackColor(tr)
    firstcolor_r, firstcolor_g, firstcolor_b = reaper.ColorFromNative(col)

    if depth == 0 then
      col = reaper.GetTrackColor(tr)
      firstcolor_r, firstcolor_g, firstcolor_b = reaper.ColorFromNative(col)
      maxDepth = getMaxDepth(i);

      h, s, v = rgbToHsv(firstcolor_r, firstcolor_g, firstcolor_b)
      new_r, new_g, new_b = hsvToRgb(h, s, v)
      v_step = math.floor(v / (maxDepth + 1))

      -- reaper.ShowMessageBox("Track " .. i .. ", depth " .. depth .. ", RBG(" .. firstcolor_r .. ", " .. firstcolor_g .. ", " .. firstcolor_b .. "), HSV(" .. h .. ", " .. s .. ", " .. v .. "), new RBG(" .. new_r .. ", " .. new_g .. ", " .. new_b .. "), Max Depth: " .. getMaxDepth(i) .. " v_step(" .. v_step .. ")" , "DETAILS", 0)

    else
      stepped_v = math.floor(v - (v_step * depth) * gradientAdjustment)
      new_r, new_g, new_b = hsvToRgb(h, s, stepped_v)

      -- reaper.ShowMessageBox("NEW  RBG(" .. math.floor(new_r) .. ", " .. math.floor(new_g) .. ", " .. math.floor(new_b) .. ")" , "NEW", 0)
      reaper.SetTrackColor(tr, reaper.ColorToNative(math.floor(new_r), math.floor(new_g), math.floor(new_b)))
    end
  end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Reset color for all children tracks to a gradient of their parent track", 0)
