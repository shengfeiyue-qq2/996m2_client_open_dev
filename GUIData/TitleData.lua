TitleData = TitleData or {}

local PLAYER = GUIDefine.TitleType.PLAYER
local HERO   = GUIDefine.TitleType.HERO

function TitleData.Init()
    -- 激活的称号
    TitleData._activeTitle = {
        [PLAYER] = nil,
        [HERO]   = nil
    }

    TitleData._titleData = {
        [PLAYER] = {},
        [HERO]   = {}
    }
    TitleData._titleList = {
        [PLAYER] = {},
        [HERO]   = {}
    }
end

-- 获取已激活的称号ID
function TitleData.GetActiveTitle(type)
    return TitleData._activeTitle[type]
end

-- 获取称号列表
function TitleData.GetTitleList(type)
    return TitleData._titleList[type]
end

-- 获取称号数据
function TitleData.GetTitleData(type)
    return TitleData._titleData[type]
end

-- 获取称号Looks
function TitleData.GetTitleIdByIndex(id)
    local itemData = SL:GetValue("ITEM_DATA", id)
    return itemData and itemData.Looks or -1
end

-- 获取称号剩余时间
function TitleData.GetTitleTime(type, id)
    local data = TitleData.GetTitleData(type)
    return data[id] and data[id].time
end

-- 称号界面已激活的图片
local TitleActivateImageCache = {}
function TitleData.GetTitleActivateImage(id)
    local picID  = TitleData.GetTitleIdByIndex(id)
    local showID = SL:GetValue("IS_PC_OPER_MODE") and picID + 2 or picID + 3
    if not TitleActivateImageCache[showID] then
        TitleActivateImageCache[showID] = string.format("%s%s%s.png", GUIDefine.PATH_RES_PRIVATE, "title_icon/", showID)
    end
    return TitleActivateImageCache[showID]
end

-- 称号列表的图片
local TitleListImageCache = {}
function TitleData.GetTitleListImage(id)
    local picID  = TitleData.GetTitleIdByIndex(id)
    local showID = SL:GetValue("IS_PC_OPER_MODE") and picID + 1 or picID + 2
    if not TitleListImageCache[showID] then
        TitleListImageCache[showID] = string.format("%s%s%s.png", GUIDefine.PATH_RES_PRIVATE, "title_icon/", showID)
    end
    return TitleListImageCache[showID]
end

-- 场景中的图片
local SceneTitleImageCache = {}
function TitleData.GetSceneTitleImage(id)
    local picID = TitleData.GetTitleIdByIndex(id)
    if not SceneTitleImageCache[picID] then
        SceneTitleImageCache[picID] = string.format("%s%s%s.png", GUIDefine.PATH_RES_PRIVATE, "title_icon/", picID)
    end
    return SceneTitleImageCache[picID]
end

--------------------------------------------------------------------------------------------------------------------------------
-- 数据处理
function TitleData.handle_MSG_SC_TITLE_REPONSE(header, jsonData, type)
    if header.recog == 1 then
        -- 称号列表
        local activeTitle = nil
        local titleList = {}
        local titleData = {}

        if jsonData then
            activeTitle = jsonData.active

            for _, v in pairs(jsonData.data or {}) do
                local id   = v[1]
                local time = v[2]

                local index = #titleList + 1
                local data  = {id = id, time = time, index = index}

                titleList[index] = data
                titleData[id] = data
            end
        end

        TitleData._activeTitle[type] = activeTitle
        TitleData._titleList[type] = titleList
        TitleData._titleData[type] = titleData
    elseif header.recog == 2 then
        -- 增加称号
        local id = header.param1
        if id and id > 0 then
            local time = header.param2

            if TitleData._titleData[type][id] then
                TitleData._titleData[type][id].time = time
            else
                local index = #TitleData._titleList[type] + 1
                local data  = {id = id, time = time, index = index}
                TitleData._titleList[type][index] = data
                TitleData._titleData[type][id] = data
            end
        end
    elseif header.recog == 3 then
        -- 删除称号
        local id = header.param1
        local data = TitleData._titleData[type][id]
        if data then
            local index = data.index
            if index and TitleData._titleList[type][index] then
                TitleData._titleList[type][index] = nil
            end
        end
        TitleData._titleData[type][id] = nil
    elseif header.recog == 4 then
        -- 激活
        if header.param1 and header.param1 > 0 then
            TitleData._activeTitle[type] = header.param1
        end
    elseif header.recog == 5 then
        -- 卸下
        TitleData._activeTitle[type] = nil
    elseif header.recog == 6 then
        -- 清理全部称号
        TitleData._activeTitle[type] = nil
        TitleData._titleList[type] = {}
        TitleData._titleData[type] = {}
    end

    local LUAEventEnum = {
        [PLAYER] = LUA_EVENT_TITLE_REFRESH,
        [HERO]   = LUA_EVENT_HERO_TITLE_REFRESH
    }
    SL:onLUAEvent(LUAEventEnum[type])
end

return TitleData
