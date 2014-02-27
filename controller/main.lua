local socket = require "socket"
local address,port,tcp = "localhost",12345
local pressed = {}
local down = {}
local isDown = love.keyboard.isDown
local setColor = love.graphics.setColor
local circle = love.graphics.circle
local rectangle = love.graphics.rectangle
local polygon = love.graphics.polygon
local draw_controller

function love.load()
  tcp = socket.tcp()
  tcp:settimeout(0)
  tcp:setpeername(address, port)
  love.graphics.setBackgroundColor(0,0,0)
  load_shape_coords()
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
  draw_controller()
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

-- TODO: clean up. find/write a lib that draws objects relative to others
function load_shape_coords()
  local x_off,y_off = 20,20
  local pad_radius = 100
  local body_width = 200
  local body_height = 60
  local but_radius = 20
  local but_off = 5
  local but_width = but_radius*2

  local left_pad_x = pad_radius*3+body_width+x_off
  local left_pad_y = pad_radius+y_off

  local lpx = pad_radius+x_off
  local lpy = pad_radius+y_off
  local bx = pad_radius*2+x_off
  local by = left_pad_y-body_height/2
  local upty = left_pad_y-but_width-but_off
  local upby = left_pad_y-but_radius
  local upbr = left_pad_x+but_radius
  local upbl = left_pad_x-but_radius
  local xl = pad_radius+x_off+but_off+but_radius
  local xr = pad_radius+y_off
  local zl = pad_radius+x_off-but_off-but_radius
  local zr = pad_radius+y_off
  local dby = left_pad_y+but_width+but_off
  local flarg = left_pad_y+but_radius
  draw_controller = function()
    -- draw controller
    setColor(255,255,255)
    circle('fill', lpx, lpy, pad_radius) -- left pad
    circle('fill', left_pad_x, left_pad_y, pad_radius) -- right pad
    rectangle('fill', bx, by, body_width, body_height)

    setColor(0,0,0)

    -- draw arrows
    draw(polygon, 'up', 'fill', left_pad_x, upty,
                                upbl, upby,
                                upbr, upby)
    draw(polygon, 'down', 'fill', left_pad_x, dby,
                                left_pad_x-but_radius, left_pad_y+but_radius,
                                left_pad_x+but_radius, left_pad_y+but_radius)
    draw(polygon, 'left', 'fill', left_pad_x-but_width-but_off, left_pad_y,
                                left_pad_x-but_radius, left_pad_y-but_radius,
                                left_pad_x-but_radius, flarg)
    draw(polygon, 'right', 'fill', left_pad_x+but_width+but_off, left_pad_y,
                                left_pad_x+but_radius, left_pad_y-but_radius,
                                left_pad_x+but_radius, flarg)

    -- a and b buttons
    draw(circle, 'x', 'fill', xl, xr, but_radius)
    draw(circle, 'z', 'fill', zl, zr, but_radius)
  end
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

function draw(method, key, ...)
  if pressed[key] or down[key] then
    setColor(255,0,0)
    method(...)
    setColor(0,0,0)
  else method(...) end
end
