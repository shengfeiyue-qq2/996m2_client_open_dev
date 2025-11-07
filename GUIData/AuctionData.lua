AuctionData = AuctionData or {}

function AuctionData.Init()
    AuctionData._config_type = {}

    AuctionData.InitConfigType()
end

function AuctionData.InitConfigType()
    AuctionData._config_type = SL:RequireFile("game_config/cfg_auction_type")
end

function AuctionData.GetCTypeByID(id)
    return AuctionData._config_type[id]
end

function AuctionData.GetCTypeInGroup()
    local items = {}
    for i, v in pairs(AuctionData._config_type) do
        if not items[v.firstlevel] then
            items[v.firstlevel] = {}
        end
        table.insert(items[v.firstlevel], v)
    end

    for i, v in pairs(items) do
        table.sort(v, function(a, b) return a.id < b.id end)
    end
    return items
end

function AuctionData.GetCTypeItemsByGroup(g)
    local items = {}
    for i, v in pairs(AuctionData._config_type) do
        if v.secondlevel and v.firstlevel == g then
            table.insert(items, v)
        end
    end

    table.sort(items, function(a, b) return a.id < b.id end)
    return items
end

function AuctionData.GetStdModeByID(id)
    local config = AuctionData.GetCTypeByID(id)
    if not config then
        return {}
    end
    local slices = string.split(tostring(config.stdmode), "#")
    local stdmode = {}
    for key, value in ipairs(slices) do
        table.insert(stdmode, tonumber(value))
    end
    return stdmode
end