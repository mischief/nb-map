require "posix"

require "xavante"
require "xavante.filehandler"
require "xavante.cgiluahandler"
require "xavante.redirecthandler"

-- Define here where Xavante HTTP documents scripts are located
local rootDir = posix.getcwd()
local webDir = 'www'

package.path = package.path .. ";" .. rootDir .. "/?.lua"

local simplerules = {

    { -- URI remapping example
      match = "^[^%./]*/$",
      with = xavante.redirecthandler,
      params = {"index.lp"}
    }, 

    { -- cgiluahandler example
      match = {"%.lp$", "%.lp/.*$", "%.lua$", "%.lua/.*$" },
      with = xavante.cgiluahandler.makeHandler (webDir)
    },
    
    { -- filehandler example
      match = ".",
      with = xavante.filehandler,
      params = {baseDir = webDir}
    },
} 

xavante.HTTP{
    server = {host = "*", port = 8080},
    
    defaultHost = {
    	rules = simplerules
    },
}

xavante.start()
