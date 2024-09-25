MiniMapData = MiniMapData or {}

function MiniMapData.Init()
    MiniMapData._portalConfig = {}
    MiniMapData.LoadConfig()
end

function MiniMapData.LoadConfig()
    MiniMapData._portalConfig = requireGameConfig("cfg_mapdesc")
end

function MiniMapData.GetPortals()
    local mapID = SL:GetValue("MAP_ID")
    local items = {}
    for _, v in pairs(MiniMapData._portalConfig) do
        if tostring(v.mapid) == mapID then
            table.insert(items, v)
        end
    end
    return items
end