local socket = require "socket"
local address,port,tcp = "localhost",12345
local pressed = {}
local down = {}
local isDown = love.keyboard.isDown
local setColor = love.graphics.setColor

function love.load()
  tcp = socket.tcp()
  tcp:settimeout(0)
  tcp:setpeername(address, port)
  love.graphics.setBackgroundColor(0,0,0)
    -- love.graphics.setColor(255,255,255)
end

function love.update(dt)
  local wait = 0.2 -- wait time for a key to be considered "down"
  local now = love.timer.getTime()
  pressed = filter(pressed, function(key, val)
    if isDown(key) and now - val >= wait then
      down[key] = true
      send_down_event(key)
      return false
    end
    return true
  end)
end

function love.draw()
  -- love.graphics.circle(
end

function love.keypressed(key)
  if not pressed[key] then
    pressed[key] = love.timer.getTime()
  end
end

function love.keyreleased(key)
  if down[key] then
    down[key] = nil
    send_release_event(key)
  else
    pressed[key] = nil
    send_press_event(key)
  end
end

-- equivalent of xdotool's "keyup"
function send_release_event(key)
  tcp:send(key.." up")
end

-- equivalent of xdotool's "keydown"
function send_down_event(key)
  tcp:send(key.." down")
end

-- equivalent of xdotool's "key"
function send_press_event(key)
  tcp:send(key.." press")
end

-- operates on unordered tables, provides key and val to func.
function filter(tab, func)
  local res = {}
  for i,v in pairs(tab) do
    if func(i, v) then
      res[i] = v
    end
  end
  return res
end
