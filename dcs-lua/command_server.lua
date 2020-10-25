--Luasocket experiment
package.path  = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local socket = require("socket")

local _M = {}
_M.Connection = nil
_M.uconn = nil

function _M.SetupSocket()
    MESSAGE:New("SetupSocket"):ToAll()

    _M.uconn = socket.udp()
    _M.uconn:settimeout(0)
    _M.uconn:setsockname("*", 15002)

    MESSAGE:New("SetupSocket DONE!"):ToAll()
end

function _M.ReadCommandFromServer()
    if _M.uconn == nil then
        _M.SetupSocket()
    end

    local command, err = _M.uconn:receive()

    if command ~= nil then
        _M.ProcessCommand(command)
    else
        if err == "timeout" then
            MESSAGE:New("No command received - TIMEOUT"):ToAll()
        else
            MESSAGE:New("No command received. ERR not timeout"):ToAll()
        end
    end
end

function _M.ProcessCommand(command)
    -- TODO: parse the command and execute it
    MESSAGE:New("command: " .. tostring(command)):ToAll()
end

function _M.Start()
    LoopScheduler =  SCHEDULER:New(nil, _M.ReadCommandFromServer, {}, 2, 3)
end

WebCommanderServer = _M