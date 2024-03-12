NpcStorage = {}

function NpcStorage.Init()
    -- 网格配置
    NpcStorage._ScrollHeight   = GUIShare.NpcStorageGridSet.ScrollHeight      -- 容器滚动区域的高度
    NpcStorage._PWidth         = GUIShare.NpcStorageGridSet.VisibleWidth      -- 容器可见区域 宽
    NpcStorage._PHeight        = GUIShare.NpcStorageGridSet.VisibleHeight     -- 容器可见区域 高
    NpcStorage._IWidth         = GUIShare.NpcStorageGridSet.ItemWidth         -- item 宽
    NpcStorage._IHeight        = GUIShare.NpcStorageGridSet.ItemWHeight       -- item 高
    NpcStorage._Row            = GUIShare.NpcStorageGridSet.Row               -- 行数
    NpcStorage._Col            = GUIShare.NpcStorageGridSet.Col               -- 列数
    NpcStorage._PerPageNum     = GUIShare.NpcStorageGridSet.PerPageNum        -- 每页的数量（Row * Col）
    NpcStorage._MaxPage        = GUIShare.NpcStorageGridSet.MaxPage           -- 最大的页数

    NpcStorage._changeMode = false
    NpcStorage._bagPage    = 1     -- 开放到几页（默认1）
    NpcStorage._selPage    = 0     -- 当前选中的页签
    NpcStorage._openNum    = SL:GetMetaValue("N_MAX_BAG")
end


function NpcStorage.main( page )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local pSizeWid = 539
    local pSizeHgt = 444
    NpcStorage._parent = parent

    -- 初始化数据
    NpcStorage.Init()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local touch = GUI:Layout_Create(parent, "touch", 0, 185, pSizeWid+30, pSizeHgt)
    GUI:setTouchEnabled(touch, true)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 185, pSizeWid, pSizeHgt)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:Win_SetDrag(parent, PMainUI)
    
    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0, 0, "res/private/npc_storage/bg.png")

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", pSizeWid, pSizeHgt, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setAnchorPoint(CloseButton, 0, 1)
    GUI:addOnClickEvent(CloseButton, function ()
        GUI:Win_Close(parent) 
    end)

    local BtnQuick = GUI:Button_Create(PMainUI, "BtnQuick", 300, 20, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(BtnQuick, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(BtnQuick, "res/public/1900000652_1.png")
    GUI:setContentSize(BtnQuick, {width = 82, height = 29})
    GUI:setAnchorPoint(BtnQuick, 0.5, 0.5)
    GUI:Button_setTitleText(BtnQuick, "快速存取")
    GUI:Button_setTitleFontSize(BtnQuick, 18)
    GUI:Button_setTitleColor(BtnQuick, "#FFFFFF")
    GUI:addOnClickEvent(BtnQuick, NpcStorage.onQuickEvent)
    NpcStorage.BtnQuick = BtnQuick

    local BtnReset = GUI:Button_Create(PMainUI, "BtnReset", 450, 20, "res/public/1900000652.png")
    GUI:Button_loadTextureDisabled(BtnReset, "res/public/1900000652_1.png")
    GUI:Button_loadTexturePressed(BtnReset, "res/public/1900000652_1.png")
    GUI:setContentSize(BtnReset, {width = 82, height = 29})
    GUI:setAnchorPoint(BtnReset, 0.5, 0.5)
    GUI:Button_setTitleText(BtnReset, "仓库整理")
    GUI:Button_setTitleFontSize(BtnReset, 18)
    GUI:Button_setTitleColor(BtnReset, "#FFFFFF")
    GUI:addOnClickEvent(BtnReset, function () SL:OpenStorageUI() end)

    local posY = pSizeHgt - 150
    local distance = 75

    -- 包裹一
    local Page1 = GUI:Button_Create(PMainUI, "Page1", pSizeWid, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page1, true)
    GUI:addOnClickEvent(Page1, function()
        NpcStorage.PageTo(1)
    end)
    posY = posY - distance
    local PageText1 = GUI:Text_Create(Page1, "PageText", 13, 60, 14, "#ffffff", "一")
    GUI:setAnchorPoint(PageText1, 0.5, 0.5)

    -- 包裹二
    local Page2 = GUI:Button_Create(PMainUI, "Page2", pSizeWid, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page2, true)
    GUI:addOnClickEvent(Page2, function()
        NpcStorage.PageTo(2)
    end)
    posY = posY - distance
    local PageText2 = GUI:Text_Create(Page2, "PageText", 13, 60, 14, "#ffffff", "二")
    GUI:setAnchorPoint(PageText2, 0.5, 0.5)
    -- 包裹三
    local Page3 = GUI:Button_Create(PMainUI, "Page3", pSizeWid, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page3, true)
    GUI:addOnClickEvent(Page3, function()
        NpcStorage.PageTo(3)
    end)
    posY = posY - distance
    local PageText3 = GUI:Text_Create(Page3, "PageText", 13, 60, 14, "#ffffff", "三")
    GUI:setAnchorPoint(PageText3, 0.5, 0.5)

    -- 包裹四
    local Page4 = GUI:Button_Create(PMainUI, "Page4", pSizeWid, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page4, true)
    GUI:addOnClickEvent(Page4, function()
        NpcStorage.PageTo(4)
    end)
    posY = posY - distance
    local PageText4 = GUI:Text_Create(Page4, "PageText", 13, 60, 14, "#ffffff", "四")
    GUI:setAnchorPoint(PageText4, 0.5, 0.5)

    -- 包裹五
    local Page5 = GUI:Button_Create(PMainUI, "Page5", pSizeWid, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page5, true)
    GUI:addOnClickEvent(Page5, function()
        NpcStorage.PageTo(5)
    end)
    posY = posY - distance
    local PageText5 = GUI:Text_Create(Page5, "PageText", 13, 60, 14, "#ffffff", "五")
    GUI:setAnchorPoint(PageText5, 0.5, 0.5)

    -- 触摸层， 防穿透
    local TouchBg = GUI:Layout_Create(PMainUI, "TouchBg", 15, 427, NpcStorage._PWidth, NpcStorage._PHeight, true)
    GUI:setTouchEnabled(TouchBg, true)
    GUI:setAnchorPoint(TouchBg, 0, 1)

    local ScrollView = GUI:ScrollView_Create(PMainUI, "ScrollView", 15, 427, NpcStorage._PWidth, NpcStorage._PHeight, 1)
    GUI:setAnchorPoint(ScrollView, 0, 1)
    GUI:setTouchEnabled(ScrollView, true)
    GUI:setSwallowTouches(ScrollView, true)
    NpcStorage._UI_ScrollView = ScrollView
    GUI:ScrollView_setInnerContainerSize(ScrollView, NpcStorage._PWidth, NpcStorage._ScrollHeight)

    local PanelTouch = GUI:Layout_Create(PMainUI, "PanelTouch", 15, 427, NpcStorage._PWidth, NpcStorage._PHeight, true)
    GUI:setAnchorPoint(PanelTouch, 0, 1)
    
    -- 初始化背包格子
    NpcStorage.InitGird()

    -- 初始化背包页签
    NpcStorage.InitPage(parent)

    SL:SetNpcStorageStatus(1)

    NpcStorage._first = true
    NpcStorage.PageTo(page)
    NpcStorage._first = false

    SL:RegisterLUAEvent(LUA_EVENT_NPC_STORAGE_PUTOUT_FAIL, "NpcStorage", NpcStorage.onPutOutFail)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_STORAGE_UPDATE, "NpcStorage", NpcStorage.onUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NpcStorage", NpcStorage.removeEvent)
end

function NpcStorage.removeEvent(ID)
    if ID ~= "NPCStorageGUI" then
        return false
    end
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_STORAGE_UPDATE, "NpcStorage")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_STORAGE_PUTOUT_FAIL, "NpcStorage")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NpcStorage")
end

function NpcStorage.InitPage(parent)
    SL:Print("仓库最大格子数量：", NpcStorage._openNum)

    -- 当前最大显示几页
    NpcStorage._bagPage = math.ceil(NpcStorage._openNum / NpcStorage._PerPageNum)
    NpcStorage._bagPage = math.max(NpcStorage._bagPage, 1)

    -- 隐藏多余的 page 页签
    for i=NpcStorage._bagPage+1,NpcStorage._MaxPage do
        local page = GUI:GetWindow(parent, "PMainUI/Page"..i)
        if page then
            page:setVisible(false)
        end
    end
    if NpcStorage._bagPage == 1 then
        local Page1 = GUI:GetWindow(parent, "PMainUI/Page1")
        if Page1 then
            Page1:setVisible(false)
        end
    end
end

function NpcStorage.SetButtonStatus()
    for i=1,NpcStorage._bagPage do
        local btnPage = GUI:GetWindow(NpcStorage._parent, "PMainUI/Page"..i)
        if btnPage then
            local isPress = i == NpcStorage._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and 1 or 0)

            local colorID = isPress and GUIShare.PageStyle.Bag_Press_ColorID or GUIShare.PageStyle.Bag_Normal_ColorID
            SL:SetColorStyle(GUI:getChildByName(btnPage, "PageText"), colorID)
        end
    end
end

function NpcStorage.PageTo(page)
    if NpcStorage._selPage == page then
        return false
    end
    SL:SetStorageCurPage(page)

    NpcStorage._selPage = page
    NpcStorage.SetButtonStatus()

    NpcStorage.RefreshItemList()
end

function NpcStorage.InitGird()
    for i=1,NpcStorage._Row do
        for j=1,NpcStorage._Col do
            local k = NpcStorage._Col * (i-1) + j
            
            local x = j * NpcStorage._IWidth
            local y = NpcStorage._ScrollHeight - i * NpcStorage._IHeight
            if k%NpcStorage._Col ~= 0 then
                -- 竖线
                local pGird1 = GUI:getChildByName(NpcStorage._UI_ScrollView, "Gird_1_"..k)
                if not pGird1 then
                    pGird1 = GUI:Image_Create(NpcStorage._UI_ScrollView, "Grid_1_"..k, x, y, "res/public/bag_gezi.png")
                    GUI:setAnchorPoint(pGird1, 1, 0.5)
                    GUI:setRotation(pGird1, 90)
                end
            end
            if math.ceil(k/NpcStorage._Col) ~= NpcStorage._Row then
                -- 横线
                local pGird2 = GUI:getChildByName(NpcStorage._UI_ScrollView, "Gird_2_"..k)
                if not pGird2 then
                    pGird2 = GUI:Image_Create(NpcStorage._UI_ScrollView, "Grid_2_"..k, x, y, "res/public/bag_gezi.png")
                    GUI:setAnchorPoint(pGird2, 1, 1)
                end
            end
        end
    end
end

function NpcStorage.LoadUnOpenGrid(lockNum)
    local noOpen = math.floor(lockNum / NpcStorage._PerPageNum)
    local clockPos = noOpen > 0 and 1 or (NpcStorage._PerPageNum - lockNum + 1)
    for i=clockPos, NpcStorage._PerPageNum do
        local YPos = math.floor((clockPos-1) / NpcStorage._Col)
        local XPos = (clockPos-1) % NpcStorage._Col
        local posX = XPos * NpcStorage._IWidth + NpcStorage._IWidth/2
        local posY = NpcStorage._ScrollHeight - NpcStorage._IHeight/2 - NpcStorage._IHeight * YPos
        
        -- 锁
        local ImageLock = GUI:Image_Create(NpcStorage._UI_ScrollView, "ImageLock"..i, 0, 0, "res/public/icon_tyzys_01.png")
        GUI:setAnchorPoint(ImageLock, 0.5, 0.5)
        GUI:setPosition(ImageLock, posX, posY)
        GUI:setVisible(ImageLock, true)

        clockPos = clockPos + 1
    end
end

function NpcStorage.RefreshItemList()
    local childrens = GUI:getChildren(NpcStorage._UI_ScrollView)
    for k,item in pairs(childrens) do
        local itemName = GUI:getName(item)
        if item and not string.find(tostring(itemName), "Grid_") then
            GUI:removeFromParent(item)
            item = nil
        end
    end

    GUI:stopAllActions(NpcStorage._UI_ScrollView)

    -- startPos: 开始的位置
    local startPos = NpcStorage._PerPageNum * (NpcStorage._selPage - 1) + 1
    -- endPos: 结束的位置
    local endPos   = startPos + NpcStorage._PerPageNum - 1

    -- 加载未开启的格子
    local totalNum = NpcStorage._selPage * NpcStorage._PerPageNum

    -- 格子数量及时刷新
    if SL:GetMetaValue("N_MAX_BAG") > NpcStorage._openNum then 
        NpcStorage._openNum = SL:GetMetaValue("N_MAX_BAG")
    end 
    local openNum  = NpcStorage._openNum

    local lockNum  = totalNum - openNum
    if lockNum and lockNum > 0 then
        endPos = endPos - lockNum
        NpcStorage.LoadUnOpenGrid(lockNum)
    end

    local showData = SL:GetStorageDataByPage(NpcStorage._selPage)
    if not showData or not next(showData) then
        return
    end

    local function _Schedule( )
        if NpcStorage._first then
            local i = 1 
            NpcStorage.CreateItem(showData[i], i)
            GUI:schedule(NpcStorage._UI_ScrollView, function ()
                i = i + 1
                if i > #showData or not showData[i] then
                    return GUI:unSchedule(NpcStorage._UI_ScrollView)
                end
                NpcStorage.CreateItem(showData[i], i)
            end, 1/60)
        else
            for i,data in ipairs(showData) do
                NpcStorage.CreateItem( data, i )
            end
        end
    end
    _Schedule( )
end

function NpcStorage.CreateItem(data, pos)
    local YPos = math.floor((pos-1) / NpcStorage._Col)
    local XPos = (pos-1) % NpcStorage._Col
    local posX = XPos * NpcStorage._IWidth + NpcStorage._IWidth/2
    local posY = NpcStorage._ScrollHeight - NpcStorage._IHeight/2 - NpcStorage._IHeight * YPos
    local ItemShow = GUI:ItemShow_Create(NpcStorage._UI_ScrollView, tostring(data.MakeIndex), posX, posY, {
        itemData = data,
        index = data.Index,
        look = true,
        movable = true, 
        checkPower = true,
        from = SL:GetItemForm().STORAGE
    })

    local function onPutOut()
        SL:CloseItemTips()
        SL:PutOutStorageData(data)
    end

    GUI:ItemShow_addReplaceClickEvent(ItemShow, function ()
        local status = SL:GetNpcStorageStatus()
        if status == 2 then
            onPutOut()
            return false
        end
        return true
    end)

    GUI:ItemShow_addDoubleEvent(ItemShow, function ()
        SL:CloseItemTips()
        local status = SL:GetNpcStorageStatus()
        if status > 0 then
            onPutOut()
        end
    end)

    GUI:setAnchorPoint(ItemShow, 0.5, 0.5)
    if NpcStorage._first then
        GUI:setOpacity(ItemShow, 0)
        GUI:runAction(ItemShow, GUI:ActionSpawn(GUI:ActionFadeIn(0.1), GUI:ActionEaseSineInOut(GUI:ActionMoveTo(0.1, posX, posY))))
    else
        GUI:setVisible(ItemShow, true)
    end
end

function NpcStorage.onQuickEvent()
    local status = SL:GetNpcStorageStatus()
    local str = ""
    if status == 1 then
        status = 2
        str = "取消选中"
    else
        status = 1
        str = "快速存取"
    end
    SL:SetNpcStorageStatus(status)

    GUI:Button_setTitleText(NpcStorage.BtnQuick, str)
end

function NpcStorage.onPutOutFail(data)
    if not (data and data.MakeIndex) then
        return false
    end
    local item = GUI:getChildByName(NpcStorage._UI_ScrollView, data.MakeIndex)
    if item then
        GUI:setVisible(item, true)
    end
end

function NpcStorage.onUpdate(page)
    NpcStorage.RefreshItemList()
end

