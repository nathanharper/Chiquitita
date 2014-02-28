local socket = require "socket"
local shape = require "shape"
local pressed = {}
local down = {}
local tcp

local isDown = love.keyboard.isDown
local setColor = love.graphics.setColor

function love.load()
  tcp = socket.tcp()
  tcp:settimeout(0)
  tcp:setpeername(ADDRESS, PORT)
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

function load_shape_coords()
  local x_off,y_off = 20,20
  local pad_radius = 100
  local pad_width = pad_radius*2
  local body_width = 200
  local body_height = 60
  local but_radius = 20
  local but_off = 5
  local but_width = but_radius*2

  local lpad = shape.Circle:new(x_off, y_off, pad_width)
  local rpad = shape.Circle:new(pad_radius*2+body_width+x_off, y_off, pad_width)
  local body = shape.Rectangle:new(pad_radius*2+x_off, pad_radius+y_off-body_height/2, body_width, body_height)

  local up = shape.Triangle:new(pad_radius-but_radius, pad_radius-but_width-but_radius, but_width, but_width, 'u')
  local down = shape.Triangle:new(pad_radius-but_radius, pad_radius+but_radius, but_width, but_width, 'd')
  local left = shape.Triangle:new(pad_radius-but_width-but_radius, pad_radius-but_radius, but_width, but_width, 'l')
  local right = shape.Triangle:new(pad_radius+but_radius, pad_radius-but_radius, but_width, but_width, 'r')
  rpad:set_child(up, down, left, right)

  local x = shape.Circle:new(pad_radius+but_radius, pad_radius-but_radius, but_width)
  local a = shape.Circle:new(pad_radius-but_width-but_radius, pad_radius-but_radius, but_width)
  local s = shape.Circle:new(pad_radius-but_radius, pad_radius-but_radius*3, but_width)
  local z = shape.Circle:new(pad_radius-but_radius, pad_radius+but_radius, but_width)
  lpad:set_child(x, z, s, a)

  local start = shape.Rectangle:new(body_width/2-but_width-but_off-15, body_height/2-but_radius, but_width+15, but_width-10)
  local slct = shape.Rectangle:new(body_width/2+but_off, body_height/2-but_radius, but_width+15, but_width-10)
  body:set_child(start, slct)

  love.draw = function()

    -- draw controller
    setColor(255,255,255)
    lpad:draw()
    rpad:draw()
    body:draw()

    setColor(0,0,0)

    -- draw arrows
    draw('up', up)
    draw('down', down)
    draw('left', left)
    draw('right', right)

    -- a and b buttons
    draw('x', x)
    x:with_offset(tprint"a")
    draw('z', z)
    z:with_offset(tprint"b")
    draw('s', s)
    s:with_offset(tprint"x")
    draw('a', a)
    a:with_offset(tprint"y")

    draw('return', start)
    start:with_offset(tprint("start", 1))
    draw('rshift', slct)
    slct:with_offset(tprint("select", 1))
  end
end

function tprint(text, scale)
  scale = scale or 2
  return function(x, y)
    setColor(255,255,255)
    love.graphics.print(text, x+15, y+5, 0, scale, scale)
    setColor(0,0,0)
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

function draw(key, the_shape)
  if pressed[key] or down[key] then
    setColor(255,0,0)
    the_shape:draw()
    setColor(0,0,0)
  else the_shape:draw() end
end