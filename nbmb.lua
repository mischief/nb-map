local modname = ...
local M = {}

M.dofile = dofile

_G[modname] = M
package.loaded[modname] = M
setfenv(1, M)

local EMAILS = dofile("/home/ubuntu/luaweb/mbox.data.lua")

function M.get_email(num)
--  if not num or not num > 0 or num >= #EMAILS then return nil end
  return EMAILS[num]
end

return M
