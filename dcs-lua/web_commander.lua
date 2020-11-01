dofile('D:/code/github.com/celsodantas/dcs-web-commander/dcs-lua/command_server.lua')

if JSONLib == nil then
    JSONLib = dofile('D:/code/github.com/celsodantas/dcs-web-commander/dcs-lua/json.lua')
end

-- TODO enable commander
-- WebCommanderServer.Start()

WebExporter = {}
WebExporter.ActiveGroups = SET_GROUP:New():FilterActive():FilterStart()
WebExporter.ExportPath = nil
WebExporter.UpdateDBScheduler = nil

function WebExporter.UpdateExport () 
    -- MESSAGE:New("Scheduler tick"):ToAll()
    local ExportData = {}

    ExportData.units = {}

    WebExporter.ActiveGroups:ForEachGroup(
        function (Group)
            local Units = Group:GetUnits()
            -- MESSAGE:New("Processing group: " .. tostring(Group.GroupName)):ToAll()

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
                UnitData.heading = unit:GetHeading()
                UnitData.category = unit:GetUnitCategory()
                UnitData.coalition = unit:GetCoalition()
                UnitData.objectTypeName = unit:GetDCSObject():getTypeName()
                UnitData.inAir = unit:InAir()
                UnitData.isAir = unit:IsAir()
                
                local key = Group.GroupName .. "-" .. UnitData.callsign
                ExportData.units[key] = UnitData

                -- MESSAGE:New("UNIT :: " .. tostring(unit:GetCallsign()) .. " " .. tostring(unit:GetHeight()) ):ToAll()
            end
        end
    )

    WebExporter.ExportToFile(ExportData)
end

function WebExporter.ExportToFile(data)
    local jsonData = JSONLib.encode(data)

    if jsonData == nil then 
        MESSAGE:New("FILE EMPTY")
    end

    saveFile(WebExporter.ExportPath, jsonData)
end

function WebExporter.Start(path)
    MESSAGE:New("WebExporter Started --"):ToAll()

    if (path == nil) then
        MESSAGE:New("WebExporter.ExportPath NOT SET. Not Exporting."):ToAll()
        return
    end

    WebExporter.ExportPath = path
    WebExporter.UpdateDBScheduler = SCHEDULER:New(nil, WebExporter.UpdateExport, {}, 1, 5 )
end