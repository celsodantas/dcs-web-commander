--Luasocket experiment
package.path  = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

local socket = require("socket")
-- #################
WebCommander = {}
WebCommander.Connection = nil
WebCommander.uconn = nil

-- local udp = assert( WebCommanderSocket.udp() )

-- udp:settimeout(1)
-- assert(udp:setsockname("*",0))
-- assert(udp:setpeername("localhost",15001))

-- assert( udp:send("ping") )
-- #################


-- MESSAGE:New("Started..."):ToAll()

-- local rat = RAT:New("RAT_A10")
-- rat:SetDeparture("Gudauta")
-- rat:Spawn(3)

function SetupSocket()
    MESSAGE:New("SetupSocket"):ToAll()

    -- WebCommander.Connection = WebCommander.Socket.try(WebCommander.Socket.connect("localhost", 15001))
    WebCommander.uconn = socket.udp()
    WebCommander.uconn:settimeout(0)
    -- WebCommander.Connection:settimeout(1)
    WebCommander.uconn:setsockname("*", 15002)
    -- WebCommander.uconn:setpeername("localhost", 15001)

    -- WebCommander.Connection:setoption("tcp-nodelay",true) -- set immediate transmission mode

    -- WebCommander.uconn:send("ping\n")

    MESSAGE:New("SetupSocket DONE!"):ToAll()
    -- udp:settimeout(1)
    -- assert(udp:setsockname("*",0))
    -- assert(udp:setpeername("localhost",15001))
end

function ReadCommandFromServer()
    if WebCommander.uconn == nil then
        SetupSocket()
    end

    -- MESSAGE:New("Reading command from socket..."):ToAll()
    local data, err = WebCommander.uconn:receive()

    if data ~= nil then
        MESSAGE:New("command: " .. tostring(data)):ToAll()
    else
        if err == "timeout" then
            MESSAGE:New("No command received - TIMEOUT"):ToAll()
        else
            MESSAGE:New("No command received. ERR not timeout"):ToAll()
        end
    end
end

-- function SetupWebCommander()
--     SetupSocket()
--     MESSAGE:New("Works 22!"):ToAll()
-- end

-- SetupScheduler = SCHEDULER:New(nil, SetupWebCommander, {}, 1)
LoopScheduler =  SCHEDULER:New(nil, ReadCommandFromServer, {}, 2, 3)



-- local ActiveGroups = SET_GROUP:New():FilterActive():FilterStart()
-- function UnitsCounter () 
--     MESSAGE:New("Scheduler tick"):ToAll()

--     ActiveGroups:ForEachGroup(
--         function (Group)
--             local Units = Group:GetUnits()

--             for i = 1, #Units do 
--                 local unit = Group:GetUnit(i)
--                 MESSAGE:New("UNIT: " .. tostring(unit:GetCallsign()) .. " " .. tostring(unit:GetHeight()) ):ToAll()
--             end
--         end
--     )
--     -- ActiveUnits:ForEachGroup(
--     --     function (unit)
--     --         MESSAGE:New("UNIT: " .. tostring(unit.GroupName) .. " " .. tostring(unit:GetHeight()) ):ToAll()
--     --     end
--     -- )
-- end

-- SchedulerID = SCHEDULER:New(nil, UnitsCounter, {}, 1, 5 )



-- MESSAGE:New("Done with ActiveGroupInit"):ToAll()

-- function UnitProcessing(unit)
--     MESSAGE:New("UNIT" .. tostring(unit:IsActive()) ):ToAll()
-- end
-- _DATABASE:ForEachUnit(UnitProcessing)