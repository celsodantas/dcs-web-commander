dofile('D:/code/github.com/celsodantas/dcs-web-commander/dcs-lua/command_server.lua')

if JSONLib == nil then
    JSONLib = dofile('D:/code/github.com/celsodantas/dcs-web-commander/dcs-lua/json.lua')
end

WebCommanderServer.Start()

local ActiveGroups = SET_GROUP:New():FilterActive():FilterStart()
function UpdateUnitDatabase () 
    MESSAGE:New("Scheduler tick"):ToAll()
    local UnitsDatabase = {}

    ActiveGroups:ForEachGroup(
        function (Group)
            local Units = Group:GetUnits()

            MESSAGE:New("Processing group: " .. tostring(Group.GroupName)):ToAll()

            for i = 1, #Units do 
                local unit = Group:GetUnit(i)

                
                local UnitData = {}
                UnitData.callsign = unit:GetCallsign()
                local coordinate = unit:GetCoordinate()

                if coordinate then
                    local lat, lon = coord.LOtoLL(unit:GetCoordinate():GetVec3())
                    UnitData.lat = lat
                    UnitData.lon = lon
                end

                UnitData.height = unit:GetHeight()
                
                local key = Group.GroupName .. "-" .. UnitData.Callsign
                UnitsDatabase[key] = UnitData

                MESSAGE:New("UNIT :: " .. tostring(unit:GetCallsign()) .. " " .. tostring(unit:GetHeight()) ):ToAll()
            end
        end
    )

    ExportToFile(UnitsDatabase)
end

function ExportToFile(data)
    local jsonData = JSONLib.encode(data)

    if jsonData == nil then 
        MESSAGE:New("FILE EMPTY")
    end
    saveFile("D:\\code\\github.com\\celsodantas\\dcs-web-commander\\tmp\\units-export.json", jsonData)
end

UpdateDB = SCHEDULER:New(nil, UpdateUnitDatabase, {}, 1, 5 )