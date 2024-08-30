MainCollect = {}

MainCollect._collectionID = nil -- 采集物ID

MainCollect._isCollecting = false

-- 是否显示采集列表
local IsShowCollectList = tonumber(SL:GetValue("GAME_DATA", "Hide_Select_Collection")) == 1
-- 查找的采集范围
local findCollectRange  = tonumber(SL:GetValue("GAME_DATA", "FindRange_Collection")) or 0

function MainCollect.main()
    local parent = GUI:Attach_Center()
    GUI:LoadExport(parent, "main/collect/collect")

    MainCollect._root = GUI:getChildByName(parent, "Main_Collect")
    MainCollect._ui = GUI:ui_delegate(MainCollect._root)
    if not MainCollect._ui then
        return false
    end

    local screenW = SL:GetValue("SCREEN_WIDTH")
    GUI:setPositionX(MainCollect._root, screenW / 2, 200)

    -- 采集列表底图
    MainCollect._listBg = MainCollect._ui["Layout_BG"]
    -- 采集列表
    MainCollect._list = MainCollect._ui["List_Collect_Select"]

    -- 开始采集
    GUI:addOnClickEvent(MainCollect._root, function()
        MainCollect.GoToAutoFindCollection()
    end)
    
    MainCollect.CollectHide(true)

    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_ACTION_ENDED, "MainCollect", MainCollect.OnMainPlayerActionEnded)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, "MainCollect", MainCollect.OnRefreshCollect)

    SL:RegisterLUAEvent(LUA_EVENT_COLLECT_VISIBLE, "MainCollect", MainCollect.OnCollectVisible)
    SL:RegisterLUAEvent(LUA_EVENT_COLLECT_BEGIN, "MainCollect", MainCollect.OnCollectBegin)
    SL:RegisterLUAEvent(LUA_EVENT_COLLECT_COMPLETED, "MainCollect", MainCollect.OnCollectCompleted)
end

-- 查找采集物
function MainCollect.GoToAutoFindCollection()
    if MainCollect._collectionID then
        SL:SetValue("SELECT_TARGET_ID", MainCollect._collectionID)
    end
    SL:AutoFindCollection()
end

function MainCollect.CreateItemCell(collectID)
    local ui = GUI:LoadExportEx2("main/collect/collect_cell", "collect_cell")
    GUI:ui_IterChilds(ui, ui)
    GUI:setVisible(ui, true)

    GUI:setName(ui, collectID)

    GUI:Text_setString(ui["Text_Name"], SL:GetValue("ACTOR_NAME", collectID))

    GUI:addOnClickEvent(ui, function()
        MainCollect._collectionID = collectID
        MainCollect.GoToAutoFindCollection()
    end)

    return ui
end

function MainCollect.CollectShow(collections)
    local targetID     = SL:GetValue("SELECT_TARGET_ID")
    local collectionID = MainCollect._collectionID

    local tempID = {}
    local items  = GUI:ListView_getItems(MainCollect._list)
    for _, item in ipairs(items) do
        local collectID = GUI:getName(item)
        if collections[collectID] then
            tempID[collectID] = collectID
        else
            if collectID == collectionID then
                collectionID = nil
            end
            local index = GUI:ListView_getItemIndex(MainCollect._list, item)
            GUI:ListView_removeItemByIndex(index)
        end
    end

    for collectID, value in pairs(collections) do
        if not tempID[collectID] then
            if value then
                collectionID = collectionID or value

                if collectID == targetID then
                    collectionID = value
                end

                if not IsShowCollectList then
                    GUI:ListView_pushBackCustomItem(MainCollect._list, MainCollect.CreateItemCell(collectID))
                end
            end
        end
    end

    if not collectionID then
        return false
    end

    MainCollect._collectionID = collectionID

    -- 显示
    GUI:setVisible(MainCollect._root, true)
    GUI:Text_setString(MainCollect._ui["Text_1"], "可采集")

    local listIsShow = tonumber(SL:GetValue("GAME_DATA", "Hide_Select_Collection")) ~= 1
    GUI:setVisible(MainCollect._list, listIsShow)
    GUI:setVisible(MainCollect._listBg, listIsShow)
end

function MainCollect.CollectHide(init)
    if not MainCollect._collectionID and not init then
        return false
    end
    MainCollect._collectionID = nil

    -- 隐藏
    GUI:setVisible(MainCollect._root, false)
    GUI:ListView_removeAllItems(MainCollect._list)
end

-- 检查采集物
function MainCollect.CheckCollection()
    -- 采集中
    if MainCollect._isCollecting then
        return false
    end

    -- 数量不够
    if SL:GetValue("COLLECTION_NUMS") < 1 then
        return false
    end

    -- 采集物列表
    local collectVec, nCollect = SL:GetValue("FIND_IN_VIEW_COLLECT_LIST")

    local collections = {}
    if nCollect > 0 then
        local myUID = SL:GetValue("USER_ID")
        local pX = SL:GetValue("X", myUID)
        local pY = SL:GetValue("Y", myUID)

        for i = 1, nCollect do
            local collectID = collectVec[i]
            local dX = SL:GetValue("ACTOR_MAP_X", collectID)
            local dY = SL:GetValue("ACTOR_MAP_Y", collectID)

            if not SL:GetValue("ACTOR_IS_DIE", collectID) and SL:GetPointDistance({x = dX, y = dY}, {x = pX, y = pY}) <= findCollectRange then
                collections[collectID] = 1

                if IsShowCollectList then
                    break
                end
            end
        end
    end

    if next(collections) then
        MainCollect.CollectShow(collections)
    else
        MainCollect.CollectHide()
    end
end

------------------------------------------------------------------------------------------------------------------------
function MainCollect.OnMainPlayerActionEnded(act)
    if not (act == GUIDefine.Action.WALK or act == GUIDefine.Action.RUN or act == GUIDefine.Action.RIDE_RUN) then
        return false
    end
    MainCollect.CheckCollection()
end

function MainCollect.OnCollectVisible(visible)
    if visible then
        MainCollect.CheckCollection()
    else
        MainCollect.CollectHide()
    end
end

function MainCollect.OnCollectBegin()
    MainCollect._isCollecting = true
end

function MainCollect.OnCollectCompleted()
    MainCollect._isCollecting = false
end

function MainCollect.OnRefreshCollect(data)
    local actorID = data.actorID
    if not SL:GetValue("ACTOR_IS_COLLECTION", actorID) then
        return false
    end

    local item = GUI:getChildByName(MainCollect._list, actorID)
    if item then
        GUI:ListView_removeChild(MainCollect._list, item)
        item = nil
    end

    local items = GUI:ListView_getItems(MainCollect._list)
    if items[1] then
        MainCollect._collectionID = GUI:getName(items[1])
    else
        MainCollect.OnCollectCompleted()
        SL:RequestCompletedCollect()
        MainCollect.CollectHide()
    end
end

MainCollect.main()