MiniMapData = MiniMapData or {}

function MiniMapData.Init()
    MiniMapData._portalConfig = {}
    MiniMapData._mapPortalsTab = {}
    MiniMapData.LoadConfig()
end

function MiniMapData.LoadConfig()
    MiniMapData._portalConfig = SL:RequireFile("game_config/cfg_mapdesc")
end

function MiniMapData.GetPortals(sMapID)
    local mapID = sMapID or SL:GetValue("MAP_ID")
    if not mapID then
        return {}
    end
    if MiniMapData._mapPortalsTab[mapID] then
        return MiniMapData._mapPortalsTab[mapID]
    end
    local items = {}
    for _, v in pairs(MiniMapData._portalConfig) do
        if tostring(v.mapid) == mapID then
            table.insert(items, v)
        end
    end
    MiniMapData._mapPortalsTab[mapID] = items
    return items
end