Bag = {}

function Bag.Init()
    -- 网格配置
    Bag._ScrollHeight   = GUIShare.BagGridSet.ScrollHeight      -- 容器滚动区域的高度
    Bag._PWidth         = GUIShare.BagGridSet.VisibleWidth      -- 容器可见区域 宽
    Bag._PHeight        = GUIShare.BagGridSet.VisibleHeight     -- 容器可见区域 高
    Bag._IWidth         = GUIShare.BagGridSet.ItemWidth         -- item 宽
    Bag._IHeight        = GUIShare.BagGridSet.ItemWHeight       -- item 高
    Bag._Row            = GUIShare.BagGridSet.Row               -- 行数
    Bag._Col            = GUIShare.BagGridSet.Col               -- 列数
    Bag._PerPageNum     = GUIShare.BagGridSet.PerPageNum        -- 每页的数量（Row * Col）
    Bag._MaxPage        = GUIShare.BagGridSet.MaxPage           -- 最大的页数

    Bag._changeMode = false
    Bag._bagPage    = 1     -- 开放到几页（默认1）
    Bag._selPage    = 0     -- 当前选中的页签
    Bag._openNum    = SL:GetMetaValue("MAX_BAG")
end

function Bag.main( page )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    Bag._parent   = parent

    -- 初始化数据
    Bag.Init()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)
    -- GUI:setTouchEnabled(Layout, true)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 87, 194, 565, 409)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:Win_SetDrag(parent, PMainUI)

    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 283, 175, "res/private/bag_ui/bg_beibao_01.png")
    GUI:setAnchorPoint(FrameBG, 0.5, 0.5)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 540, 367, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function ()
        GUI:Win_Close(parent)
        SL:PlayAudio(28)
    end)

    local posY = 315
    local distance = 75

    -- 包裹一
    local Page1 = GUI:Button_Create(PMainUI, "Page1", 5, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page1, 180)
    GUI:setTouchEnabled(Page1, true)
    GUI:addOnClickEvent(Page1, function()
        Bag.PageTo(1)
    end)
    posY = posY - distance
    local PageText1 = GUI:Text_Create(Page1, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n一")
    GUI:setAnchorPoint(PageText1, 0.5, 0.5)
    GUI:setRotationSkewY(PageText1, -180)

    -- 包裹二
    local Page2 = GUI:Button_Create(PMainUI, "Page2", 5, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page2, 180)
    GUI:setTouchEnabled(Page2, true)
    GUI:addOnClickEvent(Page2, function()
        Bag.PageTo(2)
    end)
    posY = posY - distance
    local PageText2 = GUI:Text_Create(Page2, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n二")
    GUI:setAnchorPoint(PageText2, 0.5, 0.5)
    GUI:setRotationSkewY(PageText2, -180)

    -- 包裹三
    local Page3 = GUI:Button_Create(PMainUI, "Page3", 5, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page3, 180)
    GUI:setTouchEnabled(Page3, true)
    GUI:addOnClickEvent(Page3, function()
        Bag.PageTo(3)
    end)
    posY = posY - distance
    local PageText3 = GUI:Text_Create(Page3, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n三")
    GUI:setAnchorPoint(PageText3, 0.5, 0.5)
    GUI:setRotationSkewY(PageText3, -180)

    -- 包裹四
    local Page4 = GUI:Button_Create(PMainUI, "Page4", 5, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page4, 180)
    GUI:setTouchEnabled(Page4, true)
    GUI:addOnClickEvent(Page4, function()
        Bag.PageTo(4)
    end)
    posY = posY - distance
    local PageText4 = GUI:Text_Create(Page4, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n四")
    GUI:setAnchorPoint(PageText4, 0.5, 0.5)
    GUI:setRotationSkewY(PageText4, -180)

    -- 包裹五
    local Page5 = GUI:Button_Create(PMainUI, "Page5", 5, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page5, 180)
    GUI:setTouchEnabled(Page5, true)
    GUI:addOnClickEvent(Page5, function()
        Bag.PageTo(5)
    end)
    posY = posY - distance
    local PageText5 = GUI:Text_Create(Page5, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n五")
    GUI:setAnchorPoint(PageText5, 0.5, 0.5)
    GUI:setRotationSkewY(PageText5, -180)

    -- 金币
    local ImageGold = GUI:Image_Create(PMainUI, "ImageGold", 29, 42, "res/private/bag_ui/1900015220.png")
    GUI:setAnchorPoint(ImageGold, 0.5, 0.5)
    GUI:setTouchEnabled(ImageGold, true)
    -- 设置金币拖动时弹窗的文本
    -- Bag.SetImgGoldMoveDesc("请输入数量？")

    local goldNum = SL:GetItemNumberByIndex(1)
    local TextGold = GUI:Text_Create(PMainUI, "TextGold", 65, 49, 18, "#FFFFFF", goldNum)
    GUI:setAnchorPoint(TextGold, 0, 0.5)

    local Button_1 = GUI:Button_Create(PMainUI, "Button_1", 115, 47, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(Button_1, "res/public/1900000652_1.png")
    GUI:setContentSize(Button_1, {width = 134, height = 29})
    GUI:setAnchorPoint(Button_1, 0.5, 0.5)
    GUI:Button_setTitleText(Button_1, "存入英雄背包")
    GUI:Button_setTitleFontSize(Button_1, 18)
    GUI:Button_setTitleColor(Button_1, "#FFFFFF")
    GUI:setVisible(Button_1, SL:GetMetaValue("USEHERO"))    -- 具体配置在 game_data 表 syshero 字段
    GUI:Button_setGrey(Button_1, Bag._changeMode)
    GUI:addOnClickEvent(Button_1, Bag.onButton_1_Event)

    local Button_reset = GUI:Button_Create(PMainUI, "Button_reset", 300, 50, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(Button_reset, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(Button_reset, "res/public/1900000652_1.png")
    GUI:setContentSize(Button_reset, {width = 80, height = 29})
    GUI:setAnchorPoint(Button_reset, 0.5, 0.5)
    GUI:Button_setTitleText(Button_reset, "整理")
    GUI:Button_setTitleFontSize(Button_reset, 18)
    GUI:Button_setTitleColor(Button_reset, "#FFFFFF")
    GUI:addOnClickEvent(Button_reset, function () SL:ResetBagPos() end)

    local Button_baitan = GUI:Button_Create(PMainUI, "Button_baitan", 395, 50, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(Button_baitan, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(Button_baitan, "res/public/1900000652_1.png")
    GUI:setContentSize(Button_baitan, {width = 80, height = 29})
    GUI:setAnchorPoint(Button_baitan, 0.5, 0.5)
    GUI:Button_setTitleText(Button_baitan, "摆摊")
    GUI:Button_setTitleFontSize(Button_baitan, 18)
    GUI:Button_setTitleColor(Button_baitan, "#FFFFFF")
    GUI:addOnClickEvent(Button_baitan, function () SL:OpenAutoTradeUI() end)

    local Button_depot = GUI:Button_Create(PMainUI, "Button_depot", 490, 50, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(Button_depot, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(Button_depot, "res/public/1900000652_1.png")
    GUI:setContentSize(Button_depot, {width = 80, height = 29})
    GUI:setAnchorPoint(Button_depot, 0.5, 0.5)
    GUI:Button_setTitleText(Button_depot, "仓库")
    GUI:Button_setTitleFontSize(Button_depot, 18)
    GUI:Button_setTitleColor(Button_depot, "#FFFFFF")
    GUI:addOnClickEvent(Button_depot, function () SL:OpenStorageUI() end)

    -- 触摸层， 防穿透
    local TouchBg = GUI:Layout_Create(PMainUI, "TouchBg", 22.5, 392, Bag._PWidth, Bag._PHeight, true)
    GUI:setTouchEnabled(TouchBg, true)
    GUI:setAnchorPoint(TouchBg, 0, 1)

    local ScrollView = GUI:ScrollView_Create(PMainUI, "ScrollView", 22.5, 392, Bag._PWidth, Bag._PHeight, 1)
    GUI:setAnchorPoint(ScrollView, 0, 1)
    GUI:setTouchEnabled(ScrollView, true)
    GUI:setSwallowTouches(ScrollView, true)
    Bag._UI_ScrollView = ScrollView
    GUI:ScrollView_setInnerContainerSize(ScrollView, Bag._PWidth, Bag._ScrollHeight)

    local PanelTouch = GUI:Layout_Create(PMainUI, "PanelTouch", 22.5, 392, Bag._PWidth, Bag._PHeight, true)
    GUI:setAnchorPoint(PanelTouch, 0, 1)

    -- 初始化背包格子
    Bag.InitGird()

    -- 初始化背包页签
    Bag.InitPage(parent)

    Bag._first = true
    Bag.PageTo(page)
    Bag._first = false

    SL:RegisterLUAEvent(LUA_EVENT_REF_ITEM_LIST, "Bag", Bag.RefreshItemList)
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_POS_CHANGE, "Bag", Bag.ItemPosChange)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "Bag", Bag.RefItemBeStrongMask)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "Bag", Bag.BagItemChange)
    
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVING, "Bag", Bag.OnItemMoving)
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVE_END, "Bag", Bag.OnItemMoveEnd)

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Bag", Bag.rmvEvent)
end

function Bag.rmvEvent(ID)
    if ID == "BagLayerGUI" then
        SL:UnRegisterLUAEvent(LUA_EVENT_REF_ITEM_LIST, "Bag")
        SL:UnRegisterLUAEvent(LUA_EVENT_ITEM_POS_CHANGE, "Bag")
        SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "Bag")
        SL:UnRegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "Bag")

        SL:UnRegisterLUAEvent(LUA_EVENT_ITEM_MOVING, "Bag")
        SL:UnRegisterLUAEvent(LUA_EVENT_ITEM_MOVE_END, "Bag")

        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Bag")

        if SL:IsWinMode() then
            for k,item in pairs(GUI:getChildren(Bag._UI_ScrollView)) do
                local itemName = GUI:getName(item)
                if item and not string.find(tostring(itemName), "Grid_") then
                    SL:UnRegisterWndEvent(item, "Bag")
                end
            end
        end
    end
end

function Bag.InitPage(parent)
    SL:Print("背包最大格子数量：", Bag._openNum)

    -- 当前最大显示几页
    Bag._bagPage = math.ceil(Bag._openNum / Bag._PerPageNum)
    Bag._bagPage = math.max(Bag._bagPage, 1)

    -- 隐藏多余的 page 页签
    for i=Bag._bagPage+1,Bag._MaxPage do
        local page = GUI:GetWindow(parent, "PMainUI/Page"..i)
        if page then
            page:setVisible(false)
        end
    end
    if Bag._bagPage == 1 then
        local Page1 = GUI:GetWindow(parent, "PMainUI/Page1")
        if Page1 then
            Page1:setVisible(false)
        end
    end
end

function Bag.SetButtonStatus()
    for i=1,Bag._bagPage do
        local btnPage = GUI:GetWindow(Bag._parent, "PMainUI/Page"..i)
        if btnPage then
            local isPress = i == Bag._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and 1 or 0)

            local colorID = isPress and GUIShare.PageStyle.Bag_Press_ColorID or GUIShare.PageStyle.Bag_Normal_ColorID
            SL:SetColorStyle(GUI:getChildByName(btnPage, "PageText"), colorID)
        end
    end
end

function Bag.PageTo(page)
    if Bag._selPage == page then
        return false
    end
    SL:SetBagCurPage(page)

    Bag._selPage = page
    Bag.SetButtonStatus()

    Bag.RefreshItemList()
end

function Bag.InitGird()
    for i=1,Bag._Row do
        for j=1,Bag._Col do
            local k = Bag._Col * (i-1) + j
            
            local x = j * Bag._IWidth
            local y = Bag._ScrollHeight - i * Bag._IHeight
            if k%Bag._Col ~= 0 then
                -- 竖线
                local pGird1 = GUI:getChildByName(Bag._UI_ScrollView, "Gird_1_"..k)
                if not pGird1 then
                    pGird1 = GUI:Image_Create(Bag._UI_ScrollView, "Grid_1_"..k, x, y, "res/public/bag_gezi.png")
                    GUI:setAnchorPoint(pGird1, 1, 0.5)
                    GUI:setRotation(pGird1, 90)
                end
            end
            if math.ceil(k/Bag._Col) ~= Bag._Row then
                -- 横线
                local pGird2 = GUI:getChildByName(Bag._UI_ScrollView, "Gird_2_"..k)
                if not pGird2 then
                    pGird2 = GUI:Image_Create(Bag._UI_ScrollView, "Grid_2_"..k, x, y, "res/public/bag_gezi.png")
                    GUI:setAnchorPoint(pGird2, 1, 1)
                end
            end
        end
    end
end

function Bag.LoadUnOpenGrid(lockNum)
    local noOpen = math.floor(lockNum / Bag._PerPageNum)
    local clockPos = noOpen > 0 and 1 or (Bag._PerPageNum - lockNum + 1)
    for i=clockPos, Bag._PerPageNum do
        local YPos = math.floor((clockPos-1) / Bag._Col)
        local XPos = (clockPos-1) % Bag._Col
        local posX = XPos * Bag._IWidth + Bag._IWidth/2
        local posY = Bag._ScrollHeight - Bag._IHeight/2 - Bag._IHeight * YPos
        
        -- 锁
        local ImageLock = GUI:Image_Create(Bag._UI_ScrollView, "ImageLock"..i, 0, 0, "res/public/icon_tyzys_01.png")
        GUI:setAnchorPoint(ImageLock, 0.5, 0.5)
        GUI:setPosition(ImageLock, posX, posY)
        GUI:setVisible(ImageLock, true)

        clockPos = clockPos + 1
    end
end

function Bag.RefreshItemList()
    local childrens = GUI:getChildren(Bag._UI_ScrollView)
    for k,item in pairs(childrens) do
        local itemName = GUI:getName(item)
        if item and not string.find(tostring(itemName), "Grid_") then
            GUI:removeFromParent(item)
            item = nil
        end
    end

    GUI:stopAllActions(Bag._UI_ScrollView)

    -- startPos: 开始的位置
    local startPos = Bag._PerPageNum * (Bag._selPage - 1) + 1
    -- endPos: 结束的位置
    local endPos   = startPos + Bag._PerPageNum - 1

    -- 加载未开启的格子
    local totalNum = Bag._selPage * Bag._PerPageNum

    -- 格子数量及时刷新
    if SL:GetMetaValue("MAX_BAG") > Bag._openNum then 
        Bag._openNum = SL:GetMetaValue("MAX_BAG")
    end 
    local openNum  = Bag._openNum

    local lockNum  = totalNum - openNum
    if lockNum and lockNum > 0 then
        endPos = endPos - lockNum
        Bag.LoadUnOpenGrid(lockNum)
    end

    Bag._startPos  = startPos
    Bag._endPos    = endPos

    local bagData = SL:GetBagDataByPage(Bag._selPage)
    if not bagData or not next(bagData) then
        return
    end

    local function _Schedule( )
        if Bag._first then
            local showData = {}
            for pos=startPos,endPos do
                local makeIndex = SL:GetBagItemMakeIndexByPos(pos)
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

            Bag.CreateItem( showData[1].data, showData[1].pos )
            local i = 1
            GUI:schedule(Bag._UI_ScrollView, function ()
                i = i + 1
                if i > #showData or not showData[i] then
                    return GUI:unSchedule(Bag._UI_ScrollView)
                end
                Bag.CreateItem( showData[i].data, showData[i].pos )
            end, 1/60)
        else
            for pos=startPos,endPos do
                local makeIndex = SL:GetBagItemMakeIndexByPos(pos)
                local data = bagData[makeIndex]
                if data then
                    Bag.CreateItem( data, pos )
                end
            end
        end
    end
    _Schedule( )
end

function Bag.CreateItem(data, pos)
    local YPos = math.floor((pos - (Bag._selPage-1) * Bag._PerPageNum -1) / Bag._Col)
    local XPos = (pos-1) % Bag._Col
    local posX = XPos * Bag._IWidth + Bag._IWidth/2
    local posY = Bag._ScrollHeight - Bag._IHeight/2 - Bag._IHeight * YPos
    local ItemShow = GUI:ItemShow_Create(Bag._UI_ScrollView, tostring(data.MakeIndex), posX, posY, {
        itemData = data,
        index = data.Index,
        look = true,
        noSwallow = true,
        movable = true, 
        from = SL:GetItemForm().BAG,
        checkPower = true,
        starLv = true
    })

    -- 背包是否滚动
    -- local isScroll = Bag._ScrollHeight > Bag._PHeight
    -- if isScroll then
    --     GUI:ItemShow_addPressEvent(ItemShow, function ()
    --         GUI:ItemShow_setMoveEable(ItemShow, true)
    --         GUI:setScale(ItemShow, 1.2)
    --     end)
    -- else
    --     GUI:ItemShow_setMoveEable(ItemShow, true)
    -- end

    local function OnUseItem()
        SL:UseItem(SL:GetItemDataByMakeIndex(data.MakeIndex))
        return -1
    end

    GUI:ItemShow_addReplaceClickEvent(ItemShow, function ()
        -- 人物和英雄背包互取
        if Bag._changeMode then
            SL:HumBagToHeroBag(data)
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
            return false
        end
        return true
    end)

    if SL:IsWinMode() then
        -- 注册左键双击和右键单击使用事件
        GUI:addMouseButtonEvent(ItemShow, {onLeftDoubleFunc = OnUseItem, onRightDownFunc = OnUseItem})
        
        -- 鼠标停留在Item上滚动ItemTips
        SL:RegisterWndEvent(ItemShow, "Bag", WND_EVENT_MOUSE_WHEEL, function (data)
            if ItemTips and ItemTips.OnMouseScroll then
                ItemTips.OnMouseScroll(data)
            end
        end)
    else
        GUI:ItemShow_addDoubleEvent(ItemShow, function ()
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
    if Bag._first then
        GUI:setOpacity(ItemShow, 0)
        GUI:runAction(ItemShow, GUI:ActionSpawn(GUI:ActionFadeIn(0.1), GUI:ActionEaseSineInOut(GUI:ActionMoveTo(0.1, posX, posY))))
    else
        GUI:setVisible(ItemShow, true)
    end
end

function Bag.onButton_1_Event(ref, eventType)
    local changeMode = not Bag._changeMode
    if changeMode then
        local isActiveHero = SL:GetMetaValue("ACTIVEHERO")
        if not isActiveHero then
            return SL:ShowSystemTips("英雄还未激活")
        end
        local isCallHero = SL:GetMetaValue("CALLHERO")
        if not isCallHero then
            return SL:ShowSystemTips("英雄还未召唤")
        end
    end
    Bag._changeMode = changeMode
    GUI:Button_setGrey( ref, changeMode )
end

function Bag.RvmItemByMakeIndex(makeIndex)
    local item = GUI:getChildByName(Bag._UI_ScrollView, tostring(makeIndex))
    if item then
        if SL:IsWinMode() then
            SL:UnRegisterWndEvent(item, "Bag")
        end 
        GUI:stopAllActions(item)
        GUI:removeFromParent(item)
        item = nil
    end
end

-- 背包道具位置发生变化时
function Bag.ItemPosChange(data)
    if not data or not next(data) then
        return false
    end
    for k,MakeIndex in pairs(data) do
        -- 移除 item
        Bag.RvmItemByMakeIndex(MakeIndex)
        -- 重新添加
        local itemData = SL:GetItemDataByMakeIndex(MakeIndex)
        if itemData then
            local pos = SL:GetBagItemPosByMakeIndex(MakeIndex)
            Bag.CreateItem(itemData, pos)
        end
    end
end

-- 人物装备发生变化时刷新道具变强标记
function Bag.RefItemBeStrongMask()
    local bagData  = SL:GetBagDataByPage(Bag._selPage)
    for k,v in pairs(bagData or {}) do
        if v then
            local itemShow = GUI:getChildByName(Bag._UI_ScrollView, tostring(v.MakeIndex))
            if itemShow then
                GUI:ItemShow_setItemPowerTag(itemShow)
            end
        end
    end
end

-- 背包道具发生变化
function Bag.BagItemChange(data)
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
            Bag.RvmItemByMakeIndex(v.MakeIndex)
        end
    elseif optType == 3 then
        for k,v in pairs(itemData) do
            local item = GUI:getChildByName(Bag._UI_ScrollView, tostring(v.MakeIndex))
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
        local startPos = Bag._startPos - 1
        local endPos   = Bag._endPos + 1
        for k,v in pairs(itemData) do
            local pos = SL:GetBagItemPosByMakeIndex(v.MakeIndex)
            if pos and pos > startPos and pos < endPos then
                Bag.CreateItem(v.item, pos)
            end
        end
    end
end

function Bag.OnItemMoving()
    if Bag._UI_ScrollView and not tolua.isnull(Bag._UI_ScrollView) then
        GUI:setTouchEnabled(Bag._UI_ScrollView, false)
    end
end

function Bag.OnItemMoveEnd(moveItem)
    if Bag._UI_ScrollView and not tolua.isnull(Bag._UI_ScrollView) then
        GUI:setTouchEnabled(Bag._UI_ScrollView, true)
    end
    if moveItem then
        GUI:ItemShow_setMoveEable(moveItem, false)
        GUI:setScale(moveItem, 1)
    end
end