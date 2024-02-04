HeroBag = {}

function HeroBag.Init()
    HeroBag._PWidth  = 314      -- 容器的宽
    HeroBag._PHeight = 126      -- 容器的高
    HeroBag._IWidth  = 63       -- 单个道具框的宽
    HeroBag._IHeight = 63       -- 单个道具框的高
    HeroBag._Row     = 2        -- 几行
    HeroBag._Col     = 5        -- 几列
    HeroBag._MaxNum  = 10       -- 总格子数量
    HeroBag._changeMode = false
end

function HeroBag.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    HeroBag.Init()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 260, 545, 381, 252)
    GUI:setAnchorPoint(PMainUI, 0, 1)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:Win_SetDrag(parent, PMainUI)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 5, 251, "res/private/bag_ui_hero/bg1.png")
    GUI:setAnchorPoint(FrameBG, 0, 1)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 352, 207, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function() GUI:Win_Close(parent) end)

    local PanelItems = GUI:Layout_Create(PMainUI, "PanelItems", 24, 234, HeroBag._PWidth, HeroBag._PHeight, true)
    GUI:setAnchorPoint(PanelItems, 0, 1)
    GUI:setTouchEnabled(PanelItems, true)
    HeroBag._UI_PanelItems = PanelItems

    -- 触摸层
    local PanelTouch = GUI:Layout_Create(PMainUI, "PanelTouch", 24, 234, HeroBag._PWidth, HeroBag._PHeight, true)
    GUI:setAnchorPoint(PanelTouch, 0, 1)

    local Button_1 = GUI:Button_Create(PMainUI, "Button_1", 115, 47, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(Button_1, "res/public/1900000652_1.png")
    GUI:setContentSize(Button_1, {width = 134, height = 29})
    GUI:setAnchorPoint(Button_1, 0.5, 0.5)
    GUI:Button_setTitleText(Button_1, "存入人物背包")
    GUI:Button_setTitleFontSize(Button_1, 18)
    GUI:Button_setTitleColor(Button_1, "#FFFFFF")
    GUI:Button_setGrey(Button_1, HeroBag._changeMode)
    GUI:addOnClickEvent(Button_1, HeroBag.onButton_1_Event)
    
    HeroBag._first = true
    HeroBag.RefreshItemList()
    HeroBag._first = false

    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroBag", HeroBag.RefItemBeStrongMask)
    SL:RegisterLUAEvent(LUA_EVENT_REF_HERO_ITEM_LIST, "HeroBag", HeroBag.RefreshItemList)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ITEM_POS_CHANGE, "HeroBag", HeroBag.ItemPosChange)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CAHNGE, "HeroBag", HeroBag.BagItemChange)

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroBag", HeroBag.rmvEvent)
end

function HeroBag.rmvEvent(ID)
    if ID == "HeroBagLayerGUI" then
        SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_REF_HERO_ITEM_LIST, "HeroBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_HERO_ITEM_POS_CHANGE, "HeroBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CAHNGE, "HeroBag")

        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroBag")

        if SL:IsWinMode() then
            for k,item in pairs(GUI:getChildren(Bag._UI_PanelItems)) do
                if item then
                    SL:UnRegisterWndEvent(item, "HeroBag")
                end
            end
        end
    end
end

function HeroBag.RefreshItemList()
    GUI:removeAllChildren(HeroBag._UI_PanelItems)
    GUI:stopAllActions(HeroBag._UI_PanelItems)

    local bagData = SL:GetHeroBagData()
    if not bagData or not next(bagData) then
        return
    end

    local startPos = 1
    local endPos   = HeroBag._MaxNum

    local function _Schedule( )
        if HeroBag._first then
            local showData = {}
            for pos=startPos,endPos do
                local makeIndex = SL:GetHeroBagItemMakeIndexByPos(pos)
                local data = bagData[makeIndex]
                if data then
                    table.insert(showData, {
                        data = data, pos = pos
                    })
                end
            end
            if not next(showData) then
                return false
            end

            HeroBag.CreateItem( showData[1].data, showData[1].pos )
            local i = 1
            GUI:schedule(HeroBag._UI_PanelItems, function ()
                i = i + 1
                if i > #showData or not showData[i] then
                    return GUI:unSchedule(HeroBag._UI_PanelItems)
                end
                HeroBag.CreateItem( showData[i].data, showData[i].pos )
            end, 1/60)
        else
            for pos=startPos,endPos do
                local makeIndex = SL:GetHeroBagItemMakeIndexByPos(pos)
                local data = bagData[makeIndex]
                if data then
                    HeroBag.CreateItem( data, pos )
                end
            end
        end
    end
    _Schedule( )
end

function HeroBag.CreateItem(data, pos)
    local YPos = math.floor((pos-1) / HeroBag._Col)
    local XPos = (pos-1) % HeroBag._Col
    local posX = XPos * HeroBag._IWidth + HeroBag._IWidth/2
    local posY = HeroBag._PHeight - HeroBag._IHeight/2 - HeroBag._IHeight * YPos
    local ItemShow = GUI:ItemShow_Create(HeroBag._UI_PanelItems, tostring(data.MakeIndex), posX, posY, {
        itemData = data,
        index = data.Index,
        look = true,
        noSwallow = true,
        movable = true, 
        from = SL:GetItemForm().HERO_BAG,
        checkPower = true,
        starLv = true
    })

    local function OnUseItem()
        SL:UseHeroItem(SL:GetItemDataByMakeIndex(data.MakeIndex))
        return -1
    end
    
    GUI:ItemShow_addReplaceClickEvent(ItemShow, function ()
        -- 人物和英雄背包互取
        if HeroBag._changeMode then
            SL:HeroBagToHumBag(data)
            return false
        end

        if SL:IsWinMode() and SL:GetMetaValue("IS_PRESS_SHIFT") then
            local OverLap = data.OverLap and data.OverLap > 1
            if not OverLap then
                return false
            end
            if SL:IsBagFull(true) then
                return false
            end

            -- 叠加道具批量使用
            local function callback(btnType, editparam)
                if editparam.editStr and editparam.editStr ~= "" then
                    if type(editparam.editStr) == "string" then
                        local num  = tonumber(editparam.editStr)
                        if not num or num > data.OverLap or num <= 0 then
                            return SL:ShowSystemTips("请输入正确数量!")
                        end
                        SL:SplitItem(data, num)
                    end
                end
            end

            SL:OpenCommonTipsPop({
                str = "请输入要拆分的数量：",
                callback = callback,
                btnType = 1,
                showEdit = true,
                editParams = {
                    inputMode = 2, str = "", add = true, max = data.OverLap
                }
            })

            return false
        end

        local status = SL:GetNpcStorageStatus()
        if status == 2 then
            SL:Print("-----单击--快速存取--------")
            SL:SaveItemToNpcStorage(data)
        end

        return true
    end)

    if SL:IsWinMode() then
        -- 注册左键双击和右键单击使用事件
        GUI:addMouseButtonEvent(ItemShow, {onLeftDoubleFunc = OnUseItem, onRightDownFunc = OnUseItem})
        
        -- 鼠标停留在Item上滚动ItemTips
        SL:RegisterWndEvent(ItemShow, "HeroBag", WND_EVENT_MOUSE_WHEEL, function (data)
            if ItemTips and ItemTips.OnMouseScroll then
                ItemTips.OnMouseScroll(data)
            end
        end)
    else
        GUI:ItemShow_addDoubleEvent(ItemShow, function ()
            SL:Print("ItemShow_addDoubleEvent...")
            SL:CloseItemTips()
            local status = SL:GetNpcStorageStatus()
            if status > 0 then
                SL:Print("-----双击--正常存取--------")
                SL:SaveItemToNpcStorage(data)
            else
                -- 使用道具
                OnUseItem()
            end
        end)
    end

    GUI:setAnchorPoint(ItemShow, 0.5, 0.5)
    if HeroBag._first then
        GUI:setOpacity(ItemShow, 0)
        GUI:runAction(ItemShow, GUI:ActionSpawn(GUI:ActionFadeIn(0.1), GUI:ActionEaseSineInOut(GUI:ActionMoveTo(0.1, posX, posY))))
    else
        GUI:setVisible(ItemShow, true)
    end
end

function HeroBag.onButton_1_Event(ref, eventType)
    local changeMode = not HeroBag._changeMode
    HeroBag._changeMode = changeMode
    GUI:Button_setGrey( ref, changeMode )
end

function HeroBag.RvmItemByMakeIndex(makeIndex)
    local item = GUI:getChildByName(HeroBag._UI_PanelItems, tostring(makeIndex))
    if item then
        GUI:stopAllActions(item)
        GUI:removeFromParent(item)
        item = nil
    end
end

-- 背包道具位置发生变化时
function HeroBag.ItemPosChange(data)
    if not data or not next(data) then
        return false
    end
    for k,MakeIndex in pairs(data) do
        -- 移除 item
        HeroBag.RvmItemByMakeIndex(MakeIndex)
        -- 重新添加
        local itemData = SL:GetItemDataByMakeIndex(MakeIndex)
        if itemData then
            local pos = SL:GetHeroBagItemPosByMakeIndex(MakeIndex)
            HeroBag.CreateItem(itemData, pos)
        end
    end
end

-- 人物装备发生变化时刷新道具变强标记
function HeroBag.RefItemBeStrongMask()
    local bagData  = SL:GetHeroBagData()
    for k,v in pairs(bagData or {}) do
        if v then
            local itemShow = GUI:getChildByName(HeroBag._UI_PanelItems, tostring(v.MakeIndex))
            if itemShow then
                GUI:ItemShow_setItemPowerTag(itemShow)
            end
        end
    end
end

-- 背包道具发生变化
function HeroBag.BagItemChange(data)
    if not data or not next(data) then
        return false
    end
    
    local itemData = data.operID
    if not itemData or not next(itemData) then
        return false
    end

    -- 操作类型（0：初始；1：增加；2：删除；3：改变）
    local optType = data.opera

    if optType == 2 then
        for k,v in pairs(itemData) do
            -- 移除 item
            HeroBag.RvmItemByMakeIndex(v.MakeIndex)
        end
    elseif optType == 3 then
        for k,v in pairs(itemData) do
            local item = GUI:getChildByName(HeroBag._UI_PanelItems, tostring(v.MakeIndex))
            if item then
                GUI:ItemShow_updateItemCount(item, v.item)
                item:setVisible(false)
                SL:performWithDelay(item, function()
                    if item and not tolua.isnull(item) then
                        item:setVisible(true)
                    end
                end, 0.15)
            end
        end
    else
        local startPos = 0
        local endPos   = HeroBag._MaxNum
        for k,v in pairs(itemData) do
            local pos = SL:GetHeroBagItemPosByMakeIndex(v.MakeIndex)
            if pos and pos > startPos and pos < endPos then
                HeroBag.CreateItem(v.item, pos)
            end
        end
    end
end