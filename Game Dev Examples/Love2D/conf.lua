--[[
This is the file love looks for that configures things like the size of the
window, or file icon. Not something that needs to be changed much, but good
to know
]]

--[[
"t" in this situation can be anything, I'm just using it because it's the
standard, the only really important thing is making sure that what I put
in the peramiter is consistent with the first function before calling
on windows and heights and all that
]]
function love.conf(t)
  -- Gives the top of my window a little title
  t.window.title = "First Game"
  -- Width of the window
  t.window.width = 640
  -- Height of the window
  t.window.height = 480

  -- Here's a good one for debugging, it will run a console showing what the
  -- game is doing along with the actual game window
  t.console = true

  --[[
  Lua always assumes we want every control module enabled, like this one for
  touch screen controls, we're going to turn it off so our game is slightly
  more optimized and runs a little faster.
  ]]
  t.modules.tough = false
end

-- Go to https://love2d.org/wiki/Config_Files for more config modules.
