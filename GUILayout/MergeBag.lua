MergeBag = {}

function MergeBag.Init()
    -- 网格配置
    MergeBag._ScrollHeight   = GUIShare.BagGridSet.ScrollHeight      -- 容器滚动区域的高度
    MergeBag._PWidth         = GUIShare.BagGridSet.VisibleWidth      -- 容器可见区域 宽
    MergeBag._PHeight        = GUIShare.BagGridSet.VisibleHeight     -- 容器可见区域 高
    MergeBag._IWidth         = GUIShare.BagGridSet.ItemWidth         -- item 宽
    MergeBag._IHeight        = GUIShare.BagGridSet.ItemWHeight       -- item 高
    MergeBag._Row            = GUIShare.BagGridSet.Row               -- 行数
    MergeBag._Col            = GUIShare.BagGridSet.Col               -- 列数
    MergeBag._PerPageNum     = GUIShare.BagGridSet.PerPageNum        -- 每页的数量（Row * Col）
    MergeBag._MaxPage        = GUIShare.BagGridSet.MaxPage           -- 最大的页数

    MergeBag._changeMode = false
    MergeBag._bagPage    = 1     -- 开放到几页（默认1）
    MergeBag._selPage    = 0     -- 当前选中的页签
    MergeBag._selType    = 0     -- 1: 人物背包; 2: 英雄背包 
    MergeBag._openNum    = SL:GetMetaValue("MAX_BAG")
end

function MergeBag.main( type,page )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    MergeBag._parent   = parent

    -- 初始化数据
    MergeBag.Init()

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

    -- 锁
    local ImageLock = GUI:Image_Create(PMainUI, "ImageLock", 0, 0, "res/public/icon_tyzys_01.png")
    GUI:setAnchorPoint(ImageLock, 0.5, 0.5)
    GUI:setVisible(ImageLock, false)
    MergeBag._UI_ImageLock = ImageLock

    local rPosY = 260    -- 右侧页签
    local lPosY = 315    -- 左侧页签
    local distance = 75

    ------------------------------------------------- 右侧页签 --------------------------------------
    -- 主角
    local BtnPlayer = GUI:Button_Create(PMainUI, "BtnPlayer", 540, rPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(BtnPlayer, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(BtnPlayer, "res/public/1900000640.png")
    GUI:setTouchEnabled(BtnPlayer, true)
    GUI:addOnClickEvent(BtnPlayer, function()
        MergeBag.ButtonTo(1)
    end)
    rPosY = rPosY - distance
    local BtnText1 = GUI:Text_Create(BtnPlayer, "BtnText1", 13, 60, 14, "#ffffff", "主\n角")
    GUI:setAnchorPoint(BtnText1, 0.5, 0.5)
    MergeBag._UI_BtnPlayer = BtnPlayer

    -- 英雄
    local BtnHero = GUI:Button_Create(PMainUI, "BtnHero", 540, rPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(BtnHero, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(BtnHero, "res/public/1900000640.png")
    GUI:setTouchEnabled(BtnHero, true)
    GUI:addOnClickEvent(BtnHero, function()
        MergeBag.ButtonTo(2)
    end)
    rPosY = rPosY - distance
    local BtnText2 = GUI:Text_Create(BtnHero, "BtnText2", 13, 60, 14, "#ffffff", "英\n雄")
    GUI:setAnchorPoint(BtnText2, 0.5, 0.5)
    MergeBag._UI_BtnHero = BtnHero

    ------------------------------------------------- 左侧页签 --------------------------------------
    -- 包裹一
    local Page1 = GUI:Button_Create(PMainUI, "Page1", 5, lPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page1, 180)
    GUI:setTouchEnabled(Page1, true)
    GUI:addOnClickEvent(Page1, function()
        MergeBag.PageTo(1)
    end)
    lPosY = lPosY - distance
    local PageText1 = GUI:Text_Create(Page1, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n一")
    GUI:setAnchorPoint(PageText1, 0.5, 0.5)
    GUI:setRotationSkewY(PageText1, -180)

    -- 包裹二
    local Page2 = GUI:Button_Create(PMainUI, "Page2", 5, lPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page2, 180)
    GUI:setTouchEnabled(Page2, true)
    GUI:addOnClickEvent(Page2, function()
        MergeBag.PageTo(2)
    end)
    lPosY = lPosY - distance
    local PageText2 = GUI:Text_Create(Page2, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n二")
    GUI:setAnchorPoint(PageText2, 0.5, 0.5)
    GUI:setRotationSkewY(PageText2, -180)

    -- 包裹三
    local Page3 = GUI:Button_Create(PMainUI, "Page3", 5, lPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page3, 180)
    GUI:setTouchEnabled(Page3, true)
    GUI:addOnClickEvent(Page3, function()
        MergeBag.PageTo(3)
    end)
    lPosY = lPosY - distance
    local PageText3 = GUI:Text_Create(Page3, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n三")
    GUI:setAnchorPoint(PageText3, 0.5, 0.5)
    GUI:setRotationSkewY(PageText3, -180)

    -- 包裹四
    local Page4 = GUI:Button_Create(PMainUI, "Page4", 5, lPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page4, 180)
    GUI:setTouchEnabled(Page4, true)
    GUI:addOnClickEvent(Page4, function()
        MergeBag.PageTo(4)
    end)
    lPosY = lPosY - distance
    local PageText4 = GUI:Text_Create(Page4, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n四")
    GUI:setAnchorPoint(PageText4, 0.5, 0.5)
    GUI:setRotationSkewY(PageText4, -180)

    -- 包裹五
    local Page5 = GUI:Button_Create(PMainUI, "Page5", 5, lPosY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
    GUI:setRotationSkewY(Page5, 180)
    GUI:setTouchEnabled(Page5, true)
    GUI:addOnClickEvent(Page5, function()
        MergeBag.PageTo(5)
    end)
    lPosY = lPosY - distance
    local PageText5 = GUI:Text_Create(Page5, "PageText", 13, 60, 14, "#ffffff", "包\n裹\n五")
    GUI:setAnchorPoint(PageText5, 0.5, 0.5)
    GUI:setRotationSkewY(PageText5, -180)

    -- 金币
    local ImageGold = GUI:Image_Create(PMainUI, "ImageGold", 29, 42, "res/private/bag_ui/1900015220.png")
    GUI:setAnchorPoint(ImageGold, 0.5, 0.5)
    GUI:setTouchEnabled(ImageGold, true)
    -- 设置金币拖动时弹窗的文本
    -- MergeBag.SetImgGoldMoveDesc("请输入数量？")

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
    GUI:Button_setGrey(Button_1, MergeBag._changeMode)
    GUI:addOnClickEvent(Button_1, MergeBag.onButton_1_Event)
    MergeBag._UI_Button_1 = Button_1

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
    local TouchBg = GUI:Layout_Create(PMainUI, "TouchBg", 22.5, 392, MergeBag._PWidth, MergeBag._PHeight, true)
    GUI:setTouchEnabled(TouchBg, true)
    GUI:setAnchorPoint(TouchBg, 0, 1)

    local ScrollView = GUI:ScrollView_Create(PMainUI, "ScrollView", 22.5, 392, MergeBag._PWidth, MergeBag._PHeight, 1)
    GUI:setAnchorPoint(ScrollView, 0, 1)
    GUI:setTouchEnabled(ScrollView, true)
    GUI:setSwallowTouches(ScrollView, true)
    MergeBag._UI_ScrollView = ScrollView
    GUI:ScrollView_setInnerContainerSize(ScrollView, MergeBag._PWidth, MergeBag._ScrollHeight)

    local PanelTouch = GUI:Layout_Create(PMainUI, "PanelTouch", 22.5, 392, MergeBag._PWidth, MergeBag._PHeight, true)
    GUI:setAnchorPoint(PanelTouch, 0, 1)

    MergeBag.SetOpenGird()

    -- 初始化背包格子
    MergeBag.InitGird()

    -- 初始化背包页签
    MergeBag.InitPage(parent)

    MergeBag._first = true
    MergeBag.ButtonTo(type, page)
    MergeBag._first = false

    SL:RegisterLUAEvent(LUA_EVENT_REF_ITEM_LIST, "MergeBag", function ()
        if MergeBag._selType == 1 then
            MergeBag.RefreshItemList()
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_POS_CHANGE, "MergeBag", function (data)
        if MergeBag._selType == 1 then
            MergeBag.ItemPosChange(data)
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "MergeBag", function ()
        if MergeBag._selType == 1 then
            MergeBag.RefItemBeStrongMask()
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "MergeBag", function (data)
        if MergeBag._selType == 1 then
            MergeBag.BagItemChange(data)
        end
    end)

    SL:RegisterLUAEvent(LUA_EVENT_REF_HERO_ITEM_LIST, "MergeBag", function ()
        if MergeBag._selType == 2 then
            MergeBag.RefreshItemList()
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ITEM_POS_CHANGE, "MergeBag", function (data)
        if MergeBag._selType == 2 then
            MergeBag.ItemPosChange(data)
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "MergeBag", function ()
        if MergeBag._selType == 2 then
            MergeBag.RefItemBeStrongMask()
        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CAHNGE, "MergeBag", function (data)
        if MergeBag._selType == 2 then
            MergeBag.BagItemChange(data)
        end
    end)

    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVING, "MergeBag", MergeBag.OnItemMoving)
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVE_END, "MergeBag", MergeBag.OnItemMoveEnd)

    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "MergeBag", MergeBag.rmvEvent)
end

function MergeBag.rmvEvent(ID)
    if ID == "MergeBagLayerGUI" then
        SL:UnRegisterLUAEvent(LUA_EVENT_REF_ITEM_LIST, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_ITEM_POS_CHANGE, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "MergeBag")

        SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_REF_HERO_ITEM_LIST, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_HERO_ITEM_POS_CHANGE, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CAHNGE, "MergeBag")

        SL:UnRegisterLUAEvent(LUA_EVENT_ITEM_MOVING, "MergeBag")
        SL:UnRegisterLUAEvent(LUA_EVENT_ITEM_MOVE_END, "MergeBag")

        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "MergeBag")

        if SL:IsWinMode() then
            for k,item in pairs(GUI:getChildren(Bag._UI_ScrollView)) do
                local itemName = GUI:getName(item)
                if item and not string.find(tostring(itemName), "Grid_") then
                    SL:UnRegisterWndEvent(item, "MergeBag")
                end
            end
        end
    end
end

function MergeBag.IsHeroType()
    return MergeBag._selType == 2
end

function MergeBag.SetOpenGird()
    MergeBag._openNum = MergeBag.IsHeroType() and SL:GetMetaValue("H_MAX_BAG") or SL:GetMetaValue("MAX_BAG")
end

function MergeBag.InitPage(parent)
    SL:Print("背包最大格子数量：", MergeBag._openNum)

    -- 当前最大显示几页
    MergeBag._bagPage = math.ceil(MergeBag._openNum / MergeBag._PerPageNum)
    MergeBag._bagPage = math.max(MergeBag._bagPage, 1)

    -- 隐藏多余的 page 页签
    for i=MergeBag._bagPage+1,MergeBag._MaxPage do
        local page = GUI:GetWindow(parent, "PMainUI/Page"..i)
        if page then
            page:setVisible(false)
        end
    end
    if MergeBag._bagPage == 1 then
        local Page1 = GUI:GetWindow(parent, "PMainUI/Page1")
        if Page1 then
            Page1:setVisible(false)
        end
    end
end

function MergeBag.SetButtonStatus()
    for i=1,MergeBag._bagPage do
        local btnPage = GUI:GetWindow(MergeBag._parent, "PMainUI/Page"..i)
        if btnPage then
            local isPress = i == MergeBag._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and 1 or 0)

            local colorID = isPress and GUIShare.PageStyle.MergeBag_Press_ColorID or GUIShare.PageStyle.MergeBag_Normal_ColorID
            SL:SetColorStyle(GUI:getChildByName(btnPage, "PageText"), colorID)
        end
    end
end

function MergeBag.PageTo(page, isChange)
    if not isChange and MergeBag._selPage == page then
        return false
    end
    SL:SetBagCurPage(page)

    MergeBag._selPage = page
    MergeBag.SetButtonStatus()

    MergeBag.SetOpenGird()

    MergeBag.RefreshItemList()
end

function MergeBag.ButtonTo(type, page)
    if MergeBag._selType == type then
        return false
    end

    if type == 2 then
        if not MergeBag.CheckHeroState() then
            return false
        end
    end

    MergeBag._selType = type
    
    MergeBag.PageTo(page or 1, true)

    local btns = {MergeBag._UI_BtnPlayer, MergeBag._UI_BtnHero}
    for i=1,2 do
        local isPress = i == MergeBag._selType and true or false
        GUI:Button_setBright(btns[i], not isPress)
    end
    
    MergeBag._changeMode = false
    GUI:Button_setGrey(MergeBag._UI_Button_1, MergeBag._changeMode)

    if type == 1 then
        GUI:Button_setTitleText(MergeBag._UI_Button_1, "存入英雄背包")
    else
        GUI:Button_setTitleText(MergeBag._UI_Button_1, "存入人物背包")
    end
end

function MergeBag.InitGird()
    for i=1,MergeBag._Row do
        for j=1,MergeBag._Col do
            local k = MergeBag._Col * (i-1) + j
            
            local x = j * MergeBag._IWidth
            local y = MergeBag._ScrollHeight - i * MergeBag._IHeight
            if k%MergeBag._Col ~= 0 then
                -- 竖线
                local pGird1 = GUI:getChildByName(MergeBag._UI_ScrollView, "Gird_1_"..k)
                if not pGird1 then
                    pGird1 = GUI:Image_Create(MergeBag._UI_ScrollView, "Grid_1_"..k, x, y, "res/public/bag_gezi.png")
                    GUI:setAnchorPoint(pGird1, 1, 0.5)
                    GUI:setRotation(pGird1, 90)
                end
            end
            if math.ceil(k/MergeBag._Col) ~= MergeBag._Row then
                -- 横线
                local pGird2 = GUI:getChildByName(MergeBag._UI_ScrollView, "Gird_2_"..k)
                if not pGird2 then
                    pGird2 = GUI:Image_Create(MergeBag._UI_ScrollView, "Grid_2_"..k, x, y, "res/public/bag_gezi.png")
                    GUI:setAnchorPoint(pGird2, 1, 1)
                end
            end
        end
    end
end

function MergeBag.LoadUnOpenGrid(lockNum)
    local noOpen = math.floor(lockNum / MergeBag._PerPageNum)
    local clockPos = noOpen > 0 and 1 or (MergeBag._PerPageNum - lockNum + 1)
    for i=clockPos, MergeBag._PerPageNum do
        local YPos = math.floor((clockPos-1) / MergeBag._Col)
        local XPos = (clockPos-1) % MergeBag._Col
        local posX = XPos * MergeBag._IWidth + MergeBag._IWidth/2
        local posY = MergeBag._ScrollHeight - MergeBag._IHeight/2 - MergeBag._IHeight * YPos

        -- 锁
        local ImageLock = GUI:Image_Create(MergeBag._UI_ScrollView, "ImageLock"..i, 0, 0, "res/public/icon_tyzys_01.png")
        GUI:setAnchorPoint(ImageLock, 0.5, 0.5)
        GUI:setPosition(ImageLock, posX, posY)
        GUI:setVisible(ImageLock, true)

        clockPos = clockPos + 1
    end
end

function MergeBag.RefreshItemList()
    local childrens = GUI:getChildren(MergeBag._UI_ScrollView)
    for k,item in pairs(childrens) do
        local itemName = GUI:getName(item)
        if item and not string.find(tostring(itemName), "Grid_") then
            GUI:removeFromParent(item)
            item = nil
        end
    end

    GUI:stopAllActions(MergeBag._UI_ScrollView)

    local startPos = 1
    local endPos   = MergeBag._openNum

    -- startPos: 开始的位置
    local startPos = MergeBag._PerPageNum * (MergeBag._selPage - 1) + 1
    -- endPos: 结束的位置
    local endPos   = startPos + MergeBag._PerPageNum - 1

    -- 加载未开启的格子
    local totalNum = MergeBag._selPage * MergeBag._PerPageNum
    local openNum  = MergeBag._openNum
    local lockNum  = totalNum - openNum
    if lockNum and lockNum > 0 then
        endPos = endPos - lockNum
        MergeBag.LoadUnOpenGrid(lockNum)
    end

    MergeBag._startPos = startPos
    MergeBag._endPos   = endPos

    local bagData = MergeBag.IsHeroType() and SL:GetHeroBagData() or SL:GetBagDataByPage(MergeBag._selPage)
    if not bagData or not next(bagData) then
        return
    end

    local function _Schedule( )
        if MergeBag._first then
            local showData = {}
            for pos=startPos,endPos do
                local makeIndex =  MergeBag.IsHeroType() and SL:GetHeroBagItemMakeIndexByPos(pos) or SL:GetBagItemMakeIndexByPos(pos)
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

            MergeBag.CreateItem( showData[1].data, showData[1].pos )
            local i = 1
            GUI:schedule(MergeBag._UI_ScrollView, function ()
                i = i + 1
                if i > #showData or not showData[i] then
                    return GUI:unSchedule(MergeBag._UI_ScrollView)
                end
                MergeBag.CreateItem( showData[i].data, showData[i].pos )
            end, 1/60)
        else
            for pos=startPos,endPos do
                local makeIndex = MergeBag.IsHeroType() and SL:GetHeroBagItemMakeIndexByPos(pos) or SL:GetBagItemMakeIndexByPos(pos)
                local data = bagData[makeIndex]
                if data then
                    MergeBag.CreateItem( data, pos )
                end
            end
        end
    end
    _Schedule( )
end

function MergeBag.CreateItem(data, pos)
    local from = MergeBag.IsHeroType() and SL:GetItemForm().HERO_BAG or SL:GetItemForm().BAG

    local YPos = math.floor((pos - (MergeBag._selPage-1) * MergeBag._PerPageNum -1) / MergeBag._Col)
    local XPos = (pos-1) % MergeBag._Col
    local posX = XPos * MergeBag._IWidth + MergeBag._IWidth/2
    local posY = MergeBag._ScrollHeight - MergeBag._IHeight/2 - MergeBag._IHeight * YPos
    local ItemShow = GUI:ItemShow_Create(MergeBag._UI_ScrollView, tostring(data.MakeIndex), posX, posY, {
        itemData = data,
        index = data.Index,
        look = true,
        noSwallow = true,
        movable = true, 
        from = from,
        checkPower = true,
        starLv = true
    })

    local function OnUseItem()
        local newData = SL:CopyData(data)
        if MergeBag.IsHeroType() then  -- 英雄
            newData.from = SL:GetItemForm().HERO_BAG
            SL:UseHeroItem(newData)
        else--人物
            newData.from = SL:GetItemForm().BAG
            SL:UseItem(newData)
        end
        return -1
    end

    GUI:ItemShow_addReplaceClickEvent(ItemShow, function ()
        -- 人物和英雄背包互取
        if MergeBag._changeMode then
            if MergeBag.IsHeroType() then
                SL:HeroBagToHumBag(data)
            else
                SL:HumBagToHeroBag(data)
            end
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
        return status
    end)

    if SL:IsWinMode() then
        -- 注册左键双击和右键单击使用事件
        GUI:addMouseButtonEvent(ItemShow, {onLeftDoubleFunc = OnUseItem, onRightDownFunc = OnUseItem})
        
        SL:RegisterWndEvent(ItemShow, "MergeBag", WND_EVENT_MOUSE_WHEEL, function (data) 
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

    -- GUI:ItemShow_addPressEvent(ItemShow, function ()
    --     SL:Print("-----长按--拖动--------")
    --     GUI:ItemShow_setMoveEable(ItemShow, true)
    --     GUI:setScale(ItemShow, 1.2)
    -- end)

    GUI:setAnchorPoint(ItemShow, 0.5, 0.5)
    if MergeBag._first then
        GUI:setOpacity(ItemShow, 0)
        GUI:runAction(ItemShow, GUI:ActionSpawn(GUI:ActionFadeIn(0.1), GUI:ActionEaseSineInOut(GUI:ActionMoveTo(0.1, posX, posY))))
    else
        GUI:setVisible(ItemShow, true)
    end
end

function MergeBag.CheckHeroState()
    -- local isActiveHero = SL:GetMetaValue("ACTIVEHERO")
    -- if not isActiveHero then
    --     SL:ShowSystemTips("英雄还未激活")
    --     return false
    -- end
    -- local isCallHero = SL:GetMetaValue("CALLHERO")
    -- if not isCallHero then
    --     SL:ShowSystemTips("英雄还未召唤")
    --     return false
    -- end
    return true
end

function MergeBag.onButton_1_Event(ref, eventType)
    local changeMode = not MergeBag._changeMode
    if changeMode and MergeBag._selType == 1 then
        if not MergeBag.CheckHeroState() then
            return false
        end
    end
    MergeBag._changeMode = changeMode
    GUI:Button_setGrey( ref, changeMode )
end

function MergeBag.RvmItemByMakeIndex(makeIndex)
    local item = GUI:getChildByName(MergeBag._UI_ScrollView, tostring(makeIndex))
    if item then
        GUI:stopAllActions(item)
        GUI:removeFromParent(item)
        item = nil
    end
end

-- 背包道具位置发生变化时
function MergeBag.ItemPosChange(data)
    if not data or not next(data) then
        return false
    end
    for k,MakeIndex in pairs(data) do
        -- 移除 item
        MergeBag.RvmItemByMakeIndex(MakeIndex)
        -- 重新添加
        local itemData = SL:GetItemDataByMakeIndex(MakeIndex)
        if itemData then
            local pos = MergeBag.IsHeroType() and SL:GetHeroBagItemPosByMakeIndex(MakeIndex) or SL:GetBagItemPosByMakeIndex(MakeIndex)
            MergeBag.CreateItem(itemData, pos)
        end
    end
end

-- 装备发生变化时刷新道具变强标记
function MergeBag.RefItemBeStrongMask()
    local bagData = MergeBag.IsHeroType() and SL:GetHeroBagData() or SL:GetBagDataByPage(MergeBag._selPage)
    for k,v in pairs(bagData or {}) do
        if v then
            local itemShow = GUI:getChildByName(MergeBag._UI_ScrollView, tostring(v.MakeIndex))
            if itemShow then
                GUI:ItemShow_setItemPowerTag(itemShow)
            end
        end
    end
end

-- 背包道具发生变化
function MergeBag.BagItemChange(data)
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
            MergeBag.RvmItemByMakeIndex(v.MakeIndex)
        end
    elseif optType == 3 then
        for k,v in pairs(itemData) do
            local item = GUI:getChildByName(MergeBag._UI_ScrollView, tostring(v.MakeIndex))
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
        local startPos = MergeBag._startPos - 1
        local endPos   = MergeBag._endPos + 1
        for k,v in pairs(itemData) do
            local pos = MergeBag.IsHeroType() and SL:GetHeroBagItemPosByMakeIndex(v.MakeIndex) or SL:GetBagItemPosByMakeIndex(v.MakeIndex)
            if pos and pos > startPos and pos < endPos then
                MergeBag.CreateItem(v.item, pos)
            end
        end
    end
end

function MergeBag.OnItemMoving()
    if MergeBag._UI_ScrollView and not tolua.isnull(MergeBag._UI_ScrollView) then
        GUI:setTouchEnabled(MergeBag._UI_ScrollView, false)
    end
end

function MergeBag.OnItemMoveEnd(moveItem)
    if MergeBag._UI_ScrollView and not tolua.isnull(MergeBag._UI_ScrollView) then
        GUI:setTouchEnabled(MergeBag._UI_ScrollView, true)
    end
    if moveItem then
        GUI:ItemShow_setMoveEable(moveItem, false)
        GUI:setScale(moveItem, 1)
    end
end