local secret = require "secret"
ADDRESS,PORT = secret.ADDRESS, secret.PORT
print(ADDRESS,PORT)
function love.conf(t)
  t.window.width = 640
  t.window.height = 240
end
