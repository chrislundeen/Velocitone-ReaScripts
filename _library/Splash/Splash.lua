-- @description Velocitone: Splash
-- @author chrislundeen
-- @website https://github.com/chrislundeen/
-- @noindex
-- @provides [nomain] .
-- @version 1.0.0
-- @changelog
--   Initial Velocitone release. Startup splash screen display.

--[[
  Collection of Velocitone ReaScripts for Cockos Reaper
  Special thanks for some inspiration:
  helper script inspiration from X-Raym - https://gist.github.com/X-Raym/f7f6328b82fe37e5ecbb3b81aff0b744
  rgbToHsv and hsvToRgb from Airon - Colour Swatch Window  https://forum.cockos.com/member.php?u=62784
]]

-- Init Velocitone --------------------------------------------
--local library_files = {}
--function InitVelocitone(library_files) local library_path = reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/_library/'; local library_filename; for library_file in ipairs(library_files) do library_filename = library_path .. library_files[library_file]; if reaper.file_exists(library_filename) then dofile(library_filename); else reaper.MB("Missing Velocitone library.\n" .. library_filename, "Error", 0); return; end end end; InitVelocitone(library_files);
-- End Init Velocitone ----------------------------------------


function InitSplash()
  local timer = 1 -- Time in seconds
  local msg_title = "Welcome!"
  local msg_str = "Thanks for using Velocitone ReaScripts!"
  local wnd_w, wnd_h = 500, 125

  -- Get the screen size
  local __, __, scr_w, scr_h = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, 1)

  -- Reference time to check against
  local time = os.time()

  -- Window background
  gfx.clear = reaper.ColorToNative(50, 50, 50)

  -- Open the window
  --          Name    w       h   dock    x                   y
  gfx.init(msg_title, wnd_w, wnd_h, 0, (scr_w - wnd_w) / 2, (scr_h - wnd_h) / 2)

  gfx.setfont(1, "Monaco", 12)

  -- Black
  gfx.set(255, 255, 255, 1)

  -- Center the text
  local str_w, str_h = gfx.measurestr(msg_str)
  local txt_x, txt_y = (gfx.w - str_w) / 2, (gfx.h - str_h) / 2

  local function Splash()
    -- Get the keyboard/window state
    local char = gfx.getchar()

    -- Reasons to end the script:
    --  Esc           Window closed         Timer is up
    if char == 27 or char == -1 or (os.time() - time) > timer then return end

    -- Center the text
    gfx.x, gfx.y = txt_x, txt_y

    -- https://forum.cockos.com/showpost.php?p=1685011&postcount=61
    -- https://forum.cockos.com/showthread.php?t=184604
    -- https://forum.cockos.com/showthread.php?t=206913

    buffer_id = 0 -- top layer
    gfx.setimgdim(buffer_id, gfx.w, gfx.h)

    gfx.loadimg(buffer_id, reaper.GetResourcePath() .. '/Data/track_icons/Custom/velocitone_tiki.png')
    gfx.drawstr(msg_str)

    gfx.blit(buffer_id, 1, 0)

    -- Maintain the window and keep the script running
    gfx.update()
    reaper.defer(Splash)
  end
  Splash()
end
