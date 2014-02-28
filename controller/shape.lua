local class = require "middleclass"
local Shape = class "Shape"

-- define shape by relative bounding box
function Shape:initialize(x,y,w,h)
  self.childs = {}
  self.x,self.y = x,y
  self.w,self.h = w,h
end

function Shape:set_child(...)
  for _,chi in ipairs{...} do
    chi.get_absolute_offset = function(s)
      local px,py = self:get_absolute_offset()
      return px+s.x, py+s.y
    end
  end
end

function Shape:get_absolute_offset()
  return self.x, self.y
end

function Shape:draw()
  print "Define this, idiot."
end

local Circle = class("Circle", Shape)
function Circle:draw()
  local x,y = self:get_absolute_offset()
  love.graphics.circle('fill', x, y, self.w/2)
end

local Rectangle = class("Rectangle", Shape)
function Rectangle:draw()
  local x,y = self:get_absolute_offset()
  love.graphics.rectangle('fill', x, y, self.w, self.h)
end

local Triangle = class("Triangle", Shape)

function Triangle:initialize(x,y,w,h,dir)
  assert(dir == 'l' or dir == 'r' or dir == 'u' or dir == 'd',
    "Dir must be l, r, u, or d")
  Shape.initialize(self,x,y,w,h)
  self.dir = dir
end

function Triangle:draw()
  local x,y = self:get_absolute_offset()
  local w,h = self.w,self.h
  if dir == 'u' then
    love.graphics.polygon('fill', x+w/2,y , x,y+h , x+w,y+h)
  elseif dir == 'd' then
    love.graphics.polygon('fill', x+w/2,y+h , x,y , x+w,y)
  elseif dir == 'l' then
    love.graphics.polygon('fill', x,y+h/2 , x+w,y , x+w,y+h)
  else -- 'r'
    love.graphics.polygon('fill', x+w,y+h/2 , x,y , x,y+h)
  end
end

return {
  Circle = Circle,
  Rectangle = Rectangle,
  Triangle = Triangle
}
