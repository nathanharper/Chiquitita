local secret = require "secret"

ADDRESS,PORT = secret.ADDRESS, secret.PORT
print(ADDRESS,PORT)

-- enabled keys
ENABLED = {
  ["x"] = true,
  ["z"] = true,
  ["s"] = true,
  ["a"] = true,
  ["return"] = true,
  ["rshift"] = true,
  ["left"] = true,
  ["right"] = true,
  ["up"] = true,
  ["down"] = true
}

function love.conf(t)
  t.window.width = 640
  t.window.height = 240
end
