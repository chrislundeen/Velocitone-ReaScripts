-- @description Velocitone: Color Selected Media Items Variation Of Parent Track Color
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Colors media items with randomized variations of parent track color.
-- inspired by X-Raym Color selected items according to their MIDI content

console = false


local function rgbToHsv(r, g, b)
  --r, g, b = r / 255, g / 255, b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local d = max - min
  local h, s, v
  v = max/255

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

  v = v * 255
  
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


function Msg(value)
  if console then
    reaper.ShowConsoleMsg(tostring(value) .. "\n")
    -- reaper.ShowMessageBox(tostring(value), "NEW", 0)
  end
end


function HexToRGB( hex )
  local hex = hex:gsub("#","")
  local R = tonumber("0x"..hex:sub(1,2))
  local G = tonumber("0x"..hex:sub(3,4))
  local B = tonumber("0x"..hex:sub(5,6))
  return R, G, B
end

function HexToInt( hex )
  local r, g, b = HexToRGB( hex )
  local int =  reaper.ColorToNative( r, g, b )|16777216
  return int
end

local function getTopParentTrack(track)
  while true do
    local parent = reaper.GetParentTrack(track)
    if parent then
      track = parent
    else
      return track
    end
  end
end

local function rand(value, tolerance);
    
    Msg("value(" .. tostring(value) .. ", tolerance(" .. tostring(tolerance) .. ")")
    -- allow for passing in tolerance, reuse for RBG so we can get shades and value
    local x = math.random(1,9);
    for i = 1,16 do;
        x = x..math.random(0,9); 
    end;
    math.randomseed(x);
    
    local minVal = 0;
    local maxVal = 1;
    
    local minRange = math.floor(100*(value - tolerance))
    local maxRange = math.floor(100*(value + tolerance))
    
    Msg("Range(" .. tostring(minRange) .. ", " .. tostring(maxRange) .. ")")
    local rval = math.random(minRange,maxRange)/100;
    
    Msg("init rval(" .. tostring(rval) .. ")")
    
      if rval > maxVal then
        rval = maxVal
      end

      if rval < minVal then
        rval = minVal
      end
      
      Msg("rval(" .. tostring(rval) .. ")")
    return rval;
end;
          
function Main()
  for i = 0, count_sel_items do
    local item = reaper.GetSelectedMediaItem(0,i)
    if item then
      -- Get track
      local track = reaper.GetMediaItemTrack(item) 
      local init_track_color = reaper.GetMediaTrackInfo_Value( track, "I_CUSTOMCOLOR" )
      
      local topTrack = getTopParentTrack(track)
      local track_color = reaper.GetMediaTrackInfo_Value( topTrack, "I_CUSTOMCOLOR" )
      
      -- Msg("init_track_color(" .. init_track_color .. "), track_color(" .. track_color .. ")")
      
      local r, g, b
      local h, s, vv
      local rand_h, rand_s, rand_v
      
      if track_color == 0 then
        r, g, b = 255, 255, 254
      else
        r, g, b = reaper.ColorFromNative( track_color )
      end
      
      h, s, v = rgbToHsv(r, g, b)
      
      rand_h = rand(h, .01)
      rand_s = rand(s, .25)
      rand_v = rand(v, .25)
      
      Msg("r(" .. r .. "), g(" .. g .. "), b(" .. b .. ")")
      Msg("h(" .. h .. "), s(" .. s .. "), v(" .. v .. ")")
      
      Msg("rand_h(" .. rand_h .. "), rand_s(" .. rand_s .. "), rand_v(" .. rand_v .. ")")
      
      new_r, new_g, new_b = hsvToRgb(rand_h, rand_s, rand_v)
      
      Msg("new_r(" .. new_r .. "), new_g(" .. new_g .. "), new_b(" .. new_b .. ")")
      
      Msg(" ")
      
      -- reaper.ShowMessageBox("old HSV(" .. h .. ", " .. s .. ", " .. v .. "), old RGB(" .. r .. ", " .. g .. ", " .. b .. "), new  RGB(" .. new_r .. ", " .. new_g .. ", " .. new_b .. ")" , "NEW", 0)
      
      local item_color = reaper.ColorToNative(math.floor(new_r), math.floor(new_g), math.floor(new_b))|0x1000000
      reaper.SetMediaItemInfo_Value(item, "I_CUSTOMCOLOR", item_color)
      
    end
    
  end
  
  
end



-- See if there is items selected
count_sel_items = reaper.CountSelectedMediaItems(0)

if count_sel_items > 0 then

  reaper.PreventUIRefresh(1)

  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

  reaper.ClearConsole()

  Main()

  reaper.Undo_EndBlock("Color selected takes according to their MIDI content", -1) -- End of the undo block. Leave it at the bottom of your main function.

  reaper.UpdateArrange()

  reaper.PreventUIRefresh(-1)

end
