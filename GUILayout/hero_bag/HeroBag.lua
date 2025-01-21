HeroBag = {}
HeroBagInfo = HeroBagInfo or {} 
function HeroBag.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    local pos = data and data.pos

    local layer = GUI:GetWindow(nil, UIConst.LAYERID.HeroBagLayerGUI)
    HeroBag._layer = layer
    if not HeroBag._layer then
        HeroBag.InitData(data)
        HeroBag.InitUI()
        HeroBag.AddSUI()
        HeroBag.RegisterEvent()
    end
    if pos then
        HeroBag.OnPositionChange(pos)
    end
end

function HeroBag.InitUI()
    local parent = GUI:Win_Create(UIConst.LAYERID.HeroBagLayerGUI, 0, 0, 0, 0, false, false, true, true)
    HeroBag._layer = parent
    GUI:LoadExport(parent, HeroBagInfo._isWin32 and "bag_hero/herobag_panel_win32" or "bag_hero/herobag_panel")
    HeroBagInfo._ui = GUI:ui_delegate(parent)

    -- 界面拖动
    GUI:Win_SetDrag(parent, HeroBagInfo._ui.Panel_1)
    GUI:addOnClickEvent(HeroBagInfo._ui.Button_close, function()
        HeroBag.Close()
    end)

    -- 存入人物背包
    HeroBagInfo._changeMode = false
    local Button_store_human_bag = HeroBagInfo._ui.Button_store_human_bag
    GUI:addOnClickEvent(Button_store_human_bag, function()
        local changeMode = not HeroBagInfo._changeMode
        HeroBagInfo._changeMode = changeMode
        GUI:Button_setGrey(Button_store_human_bag, changeMode)
    end)
    HeroBag.initMouseEvent()
    HeroBag.UpdateItems()

    -- 交易行 截图节点 请勿删除 
    HeroBag._screenshotRootNode = HeroBagInfo._ui.Panel_1
end

function HeroBag.InitData(data)
    -- 初始化数据
    HeroBagInfo._rowMax = 5
    HeroBagInfo._maxnum = 10
    HeroBagInfo._maxWidth = 186
    HeroBagInfo._maxHeight = 75
    HeroBagInfo._maxnumt = { 10, 20, 30, 35, 40 }
    HeroBagInfo._powerScheduleTime = 0  -- 战力对比延迟时间
    local isWin32 = SL:GetValue("IS_PC_OPER_MODE")
    HeroBagInfo._isWin32 = isWin32
    HeroBagInfo._col    = 5                        -- 列数

    local level = data and data.level
    HeroBagInfo._maxnum = level and maxnumt[level] or HeroBagData.GetMaxBag()
    HeroBagInfo._rowMax = HeroBagInfo._col or HeroBagInfo._rowMax
    HeroBagInfo._itemWidth = isWin32 and 43 or 63
    HeroBagInfo._itemHeight = isWin32 and 43 or 63

    HeroBagInfo._LevelBgImgWithMaxBagNum = {        -- 不同等级的背景图片
        [10] = isWin32 and "res/private/bag_ui_hero_win32/bg1.png" or "res/private/bag_ui_hero/bg1.png",
        [20] = isWin32 and "res/private/bag_ui_hero_win32/bg2.png" or "res/private/bag_ui_hero/bg2.png",
        [30] = isWin32 and "res/private/bag_ui_hero_win32/bg3.png" or "res/private/bag_ui_hero/bg3.png",
        [35] = isWin32 and "res/private/bag_ui_hero_win32/bg4.png" or "res/private/bag_ui_hero/bg4.png",
        [40] = isWin32 and "res/private/bag_ui_hero_win32/bg5.png" or "res/private/bag_ui_hero/bg5.png",
    }
end

function HeroBag.initMouseEvent(data)
    GUI:setSwallowTouches(HeroBagInfo._ui.Panel_addItems, false)

    local function addItemIntoBag(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local goToName = GUIDefine.ItemGoTo.HERO_BAG
            local data = {}
            data.target = goToName
            data.pos = touchPos
            data.itemPosInbag = HeroBag.GetItemBagEmptyPos(touchPos)
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    local function setNoSwallowMouse()
        return -1
    end

    GUI:addMouseButtonEvent(HeroBagInfo._ui.Panel_addItems, {
        onRightDownFunc = setNoSwallowMouse,
        onSpecialRFunc = addItemIntoBag
    })
end

-- 位置改变
function HeroBag.OnPositionChange(pos)
    if HeroBag._layer then
        GUI:setPosition(HeroBag._layer, pos.x, pos.y)
    end
end

function HeroBag.GetItemBagEmptyPos(touchPos)
    local x = touchPos.x
    local y = touchPos.y
    local panelWorldPos = GUI:getWorldPosition(HeroBagInfo._ui.Panel_addItems)
    local posXInPanel = x - panelWorldPos.x
    local posYInPanel = panelWorldPos.y - y
    if posXInPanel >= HeroBagInfo._maxWidth or posXInPanel <= 0 then
        return nil
    end

    if posYInPanel >= HeroBagInfo._maxHeight or posYInPanel <= 0 then
        return nil
    end
    local indexX = math.ceil(posXInPanel / HeroBagInfo._itemWidth)
    local indexY = math.floor(posYInPanel / HeroBagInfo._itemHeight)

    local posIndex = indexY * HeroBagInfo._rowMax + indexX
    if posIndex > HeroBagInfo._maxnum then
        return nil
    end
    return posIndex
end

function HeroBag.UpdateItems()
    HeroBag.ChangeLevel()

    GUI:removeAllChildren(HeroBagInfo._ui.Panel_items)
    HeroBagInfo.initedLayer = nil
    local bagData = HeroBagData.GetBagData()
    local showData = {}
    local max = HeroBagInfo._rowMax

    local function initNoPosData()
        for _, data in pairs(bagData) do
            if not showData[data.MakeIndex] then
                HeroBag.CreateBagItem(data)
            end
        end
    end

    local initTimes = 2
    local initBagItems = nil
    initBagItems = function(beginIndex, endIndex)
        for j = beginIndex, endIndex do
            local itemMakeIndex = HeroBagData.GetMakeIndexByBagPos(j)
            if itemMakeIndex and bagData[itemMakeIndex] then
                HeroBag.CreateBagItem(bagData[itemMakeIndex])
                showData[itemMakeIndex] = 1
            end
        end
        HeroBagInfo.initedLayer = endIndex / max
        if endIndex < HeroBagInfo._maxnum then
            local function createItems()
                local nextBeginIndex = (initTimes - 1) * max + 1
                local nextEndIndex = initTimes * max
                initTimes = initTimes + 1
                initBagItems(nextBeginIndex, nextEndIndex)
            end
            SL:scheduleOnce(HeroBagInfo._ui.Panel_items, createItems, 1 / 60)
        else
            HeroBagInfo.initedLayer = 99
            initNoPosData()
            SL:onLUAEvent(LUA_EVENT_HERO_BAG_LOAD_SUCCESS)
            SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_BEGAN, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.HEROBAG].start })
        end
    end
    initBagItems(1, max)
end

function HeroBag.ChangeLevel()
    local bgPath = HeroBagInfo._LevelBgImgWithMaxBagNum[HeroBagInfo._maxnum]
    if not bgPath then
        bgPath = HeroBagInfo._isWin32 and "res/private/bag_ui_hero_win32/bg5.png" or "res/private/bag_ui_hero/bg5.png"
    end

    local oldBgSize = GUI:getContentSize(HeroBagInfo._ui.Image_bg)

    GUI:Image_loadTexture(HeroBagInfo._ui.Image_bg, bgPath)
    GUI:setIgnoreContentAdaptWithSize(HeroBagInfo._ui.Image_bg, true)

    local newBgSize = GUI:getContentSize(HeroBagInfo._ui.Image_bg)
    local deltaH = newBgSize.height - oldBgSize.height
    local addItemSize = GUI:getContentSize(HeroBagInfo._ui.Panel_addItems)

    GUI:setContentSize(HeroBagInfo._ui.Panel_addItems, addItemSize.width, addItemSize.height + deltaH)
    GUI:setContentSize(HeroBagInfo._ui.Panel_items, addItemSize.width, addItemSize.height + deltaH)

    GUI:setPositionY(HeroBagInfo._ui.Panel_addItems, GUI:getPositionY(HeroBagInfo._ui.Panel_addItems) + deltaH)
    GUI:setPositionY(HeroBagInfo._ui.Panel_items, GUI:getPositionY(HeroBagInfo._ui.Panel_items) + deltaH)
    local Button_close = HeroBagInfo._ui.Button_close
    GUI:setPositionY(Button_close, GUI:getPositionY(Button_close) + deltaH)

    local newAddItemsize = GUI:getContentSize(HeroBagInfo._ui.Panel_addItems)

    GUI:setContentSize(HeroBagInfo._ui.Panel_2, newBgSize)

    local oldPanelSize = GUI:getContentSize(HeroBagInfo._ui.Panel_1)
    GUI:setContentSize(HeroBagInfo._ui.Panel_1, oldPanelSize.width, oldPanelSize.height + deltaH)
    GUI:LayoutComponentRefreshLayout(HeroBagInfo._ui.Panel_1)

    HeroBagInfo._maxWidth = newAddItemsize.width
    HeroBagInfo._maxHeight = newAddItemsize.height

    local visibleSize = SL:GetValue("SCREEN_SIZE")
    if HeroBagInfo._maxnum > 30 then
        GUI:setPositionY(HeroBagInfo._ui.Panel_1, visibleSize.height - 10)
    elseif HeroBagInfo._maxnum >= 40 then
        GUI:setPositionY(HeroBagInfo._ui.Panel_1, visibleSize.height - 5)
    end
end

function HeroBag.RefreshBagData(data)
    if data then
        HeroBag.ItemPosChange(data)
    else
        HeroBag.UpdateItems()
    end
end

function HeroBag.CreateBagItem(data)
    local pos = HeroBagData.GetBagPosByMakeIndex(data.MakeIndex) or HeroBagData.GetEmptyPos()
    if pos and pos <= HeroBagInfo._maxnum then
        local info = {}
        info.itemData = data
        info.index = data.Index
        info.look = true
        info.movable = true
        info.from = GUIDefine.ItemFrom.HERO_BAG
        info.checkPower = true
        info.starLv = true

        local YPos = math.floor((pos - 1) / HeroBagInfo._rowMax)
        local XPos = (pos - 1) % HeroBagInfo._rowMax
        local posX = XPos * HeroBagInfo._itemWidth + HeroBagInfo._itemWidth / 2
        local posY = HeroBagInfo._maxHeight - HeroBagInfo._itemHeight / 2 - HeroBagInfo._itemHeight * YPos

        local goodItem = GUI:ItemShow_Create(HeroBagInfo._ui.Panel_items, data.MakeIndex, posX, posY, info)
        GUI:setAnchorPoint(goodItem, 0.5, 0.5)
        GUI:setStrTag(goodItem, data.MakeIndex)
        GUI:ItemShow_addReplaceClickEvent(goodItem, function()
            GUI:delayTouchEnabled(goodItem)
            if HeroBagInfo._changeMode then -- 人物和英雄背包互取
                SL:RequestHeroBagToHumBag({itemData = data})
                return
            end

            if SL:GetValue("IS_PRESSED_SHIFT") then
                local itemOverLapCount = data.OverLap and data.OverLap > 1
                if itemOverLapCount then
                    if HeroBagData.isToBeFull(true) then
                        return false
                    end
                    -- 叠加道具批量使用
                    local function callback(btnType, editparam)
                        if editparam.editStr and editparam.editStr ~= "" then
                            if type(editparam.editStr) == "string" then
                                local num = tonumber(editparam.editStr)
                                if not num or num > data.OverLap or num <= 0 then
                                    SL:ShowSystemTips("请输入正确数量!")
                                    return
                                end
                                SL:RequestSplitHeroItem(data, num)
                            end
                        end
                    end
                    local commonData = {}
                    commonData.str = "请输入要拆分的数量："
                    commonData.callback = callback
                    commonData.btnType = 1
                    commonData.showEdit = true
                    commonData.editParams = {
                        inputMode = 2,
                        str = "",
                        add = true,
                        max = data.OverLap,
                    }
                    UIOperator:OpenCommonTipsUI(commonData)
                end
                return false
            end

            local stroageType = SL:GetValue("STORAGE_TOUCH_TYPE")
            local state = stroageType > 1
            if state then
                SL:RequestSaveItemToNpcStorage(data.MakeIndex, data.Name)
            end
            return not state
        end)

        local function useThisItem()
            UIOperator:CloseItemTips()
            local stroageType = SL:GetValue("STORAGE_TOUCH_TYPE")
            local state = stroageType > 0
            if state then
                SL:RequestSaveItemToNpcStorage(data.MakeIndex, data.Name)
            else
                local newData = SL:CopyData(data)
                newData.from = GUIDefine.ItemFrom.HERO_BAG
                SL:RequestUseHeroItem(newData)
            end
        end

        if HeroBagInfo._isWin32 then
            --right mouse btn quick use
            GUI:addMouseButtonEvent(goodItem, {
                onRightDownFunc = useThisItem,
                onDoubleLFunc = useThisItem
            })
        else
            GUI:ItemShow_addDoubleEvent(goodItem, useThisItem)
        end

        -- 移动中处理
        local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
        local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
        if itemMoving and itemMovingData then
            if data.MakeIndex == itemMovingData.MakeIndex then
                SL:ItemMoveUpdate({ goodItem = goodItem })
                GUI:ItemShow_resetMoveState(goodItem, true)
            end
        end

        local itemState = HeroBag.CheckItemOnSomeState(data.MakeIndex)
        if not itemState then
            GUI:setVisible(goodItem, itemState)
        end
    end
end

function HeroBag.CheckItemOnSomeState(MakeIndex)
    local onSellOrRepaireMakeIndex = HeroBagData.GetOnSellOrRepaire()
    if onSellOrRepaireMakeIndex == MakeIndex then
        return false
    end

    local onTradingData = SL:GetValue("TRADE_MY_ITEMS")
    if onTradingData[MakeIndex] then
        return false
    end

    return true
end

function HeroBag.ItemDataChange(data)
    if not data or not next(data) then
        return
    end

    local type = data.opera
    local itemData = data.operID
    if not itemData or not next(itemData) then
        return
    end

    if type == GUIDefine.OperateType.ADD or type == GUIDefine.OperateType.INIT then
        if not HeroBagInfo.initedLayer then
            return
        end

        for _, v in pairs(itemData) do
            local pos = HeroBagData.GetBagPosByMakeIndex(v.item.MakeIndex)
            if pos and pos < HeroBagInfo.initedLayer * HeroBagInfo._rowMax then
                HeroBag.CreateBagItem(v.item)
            end
        end

    elseif type == GUIDefine.OperateType.DEL then
        for _, v in pairs(itemData) do
            local item = GUI:getChildByStrTag(HeroBagInfo._ui.Panel_items, v.MakeIndex)
            if item then
                GUI:stopAllActions(item)
                GUI:removeFromParent(item)
            end
        end

    elseif type == GUIDefine.OperateType.CHANGE then
        for _, v in pairs(itemData) do
            local item = GUI:getChildByStrTag(HeroBagInfo._ui.Panel_items, v.MakeIndex)
            local thisItemData = HeroBagData.GetItemDataByMakeIndex(v.MakeIndex)
            if item and thisItemData then
                GUI:ItemShow_updateItemCount(item, thisItemData)
            end
        end
    end
end

function HeroBag.UpdateBagState(data)
    if not data then
        return
    end

    if data.trading then
        HeroBag.UpdateMovingData(data.trading)
    elseif data.storage then
        HeroBag.UpdateMovingData(data.storage)
    elseif data.dropping then
        HeroBag.UpdateMovingData(data.dropping)
    end
end

function HeroBag.UpdateMovingData(data)
    if not data or not next(data) then
        return
    end

    local MakeIndex = data.MakeIndex
    local onMovingNode = GUI:getChildByStrTag(HeroBagInfo._ui.Panel_items, MakeIndex)
    if onMovingNode then
        GUI:setVisible(onMovingNode, data.state and data.state > 0)
        onMovingNode._movingState = not (data.state and data.state > 0)
    end
end

function HeroBag.ItemPosChange(data)
    if not data or next(data) == nil then
        return
    end

    for k, MakeIndex in pairs(data) do
        local item = GUI:getChildByStrTag(HeroBagInfo._ui.Panel_items, MakeIndex)
        if item then
            GUI:stopAllActions(item)
            GUI:removeFromParent(item)
        end
        local itemData = HeroBagData.GetItemDataByMakeIndex(MakeIndex)
        if itemData then
            HeroBag.CreateBagItem(itemData)
        end
    end
end

function HeroBag.UpdateItemPowerCheckState(data)
    local itemPowerFunc = function()
        local childs = GUI:getChildren(HeroBagInfo._ui.Panel_items)
        for _, goodItem in ipairs(childs) do
            if goodItem and goodItem.SetItemPowerTag then
                GUI:ItemShow_setItemPowerTag(goodItem)
            end
        end
    end

    if data and data.bagDelayUpdate then
        if not HeroBagInfo._powerScheduleTime or HeroBagInfo._powerScheduleTime == 0 then
            HeroBagInfo._powerScheduleTime = 3
            SL:scheduleOnce(HeroBag._layer, function()
                itemPowerFunc()
                HeroBagInfo._powerScheduleTime = 0
            end, HeroBagInfo._powerScheduleTime)
        else
            itemPowerFunc()
        end
    end
end
function HeroBag.BeginMove(data)
    local MakeIndex = data.MakeIndex
    local pos = data.pos
    if not MakeIndex then
        return
    end

    local isOnSelling = false
    local onSellOrRepaireMakeIndex = HeroBagData.GetOnSellOrRepaire()
    if onSellOrRepaireMakeIndex == MakeIndex then
        isOnSelling = true
    end

    local gooditem = GUI:getChildByStrTag(HeroBagInfo._ui.Panel_items, MakeIndex)
    if gooditem and not GUI.Widget_IsNull(gooditem) and not isOnSelling then
        GUI:ItemShow_showIteminfo(gooditem, nil, pos)
    end
end

function HeroBag.Close()
    UIOperator:CloseHeroBagUI()
end

function HeroBag.AddSUI()
    -- 自定义组件挂接
    SL:AttachTXTSUI({root = HeroBagInfo._ui.Panel_1, index = SLDefine.SUIComponentTable.Bag_hero})
end

function HeroBag.RemoveSui()
    -- 自定义组件挂接
    local componentData = {
        index = SLDefine.SUIComponentTable.Bag_hero
    }
    SL:UnAttachTXTSUI(componentData)
end

--------------------------- 注册事件 -----------------------------
function HeroBag.RegisterEvent()
    local layer = HeroBag._layer
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGOUT, "HeroBag", HeroBag.Close, layer) --英雄退出
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, "HeroBag", HeroBag.ItemDataChange, layer) --背包操作
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_LIST_REFRESH, "HeroBag", HeroBag.UpdateItems, layer)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_STATE_CHANGE, "HeroBag", HeroBag.UpdateBagState, layer)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE, "HeroBag", HeroBag.RefreshBagData, layer)  --位置改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroBag", HeroBag.UpdateItemPowerCheckState, layer) --装备改变
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVE_BEGIN_HERO_BAG_POS_CHANGE, "HeroBag", HeroBag.BeginMove, layer) --道具换位后开始拖动
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroBag", HeroBag.OnCloseLayer) --关闭界面
end
-------------------------------------------------------------------

-- 关闭监听
function HeroBag.OnCloseLayer(id)
    if UIConst.LAYERID.HeroBagLayerGUI == id and HeroBagInfo then
        HeroBag.RemoveSui()
        HeroBagInfo = nil
        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroBag")
        SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_ENDED, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.HEROBAG].close })
    end
end

HeroBag.main()