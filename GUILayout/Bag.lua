Bag = {}

function Bag.Init(isWin32)
    -- 网格配置
    Bag._ScrollHeight = isWin32 and 214 or 320     -- 容器滚动区域的高度
    Bag._PWidth       = isWin32 and 338 or 500     -- 容器可见区域 宽
    Bag._PHeight      = isWin32 and 214 or 320     -- 容器可见区域 高
    Bag._IWidth       = isWin32 and 42.8 or 62.5     -- item 宽
    Bag._IHeight      = isWin32 and 40.6 or 64       -- item 高
    Bag._Row          = 5       -- 行数
    Bag._Col          = 8       -- 列数
    Bag._PerPageNum   = 40      -- 每页的数量（Row * Col）
    Bag._defaultNum   = 40      -- 默认官方每页格子数量
    Bag._MaxPage      = 5       -- 最大的页数
    Bag._codeInitGrid = false   -- 是否需要代码生成格子，对于背景没有格子线和滚动容器没有格子线的情况

    Bag._changeStoreMode = false
    Bag._bagPage    = 1     -- 开放到几页（默认1）
    Bag._selPage    = 0     -- 当前选中的页签
    Bag._openNum    = SL:GetMetaValue("MAX_BAG")

    Bag._lockImg   = "res/public/icon_tyzys_01.png"
    Bag._baiTanImg = isWin32 and "res/public/word_bqzy_09_1.png" or "res/public/word_bqzy_09.png"

    Bag._bagPageBtns = {}
end

function Bag.main(page)
    local parent = GUI:Attach_Parent()
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWin32 and "bag/bag_panel_win32" or "bag/bag_panel")

    Bag._ui = GUI:ui_delegate(parent)
    Bag._UI_ScrollView = Bag._ui["ScrollView_items"]

    -- 初始化数据
    Bag.Init(isWin32)

    -- 适配
    GUI:setPositionY(Bag._ui["Panel_1"], isWin32 and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2)

    -- 界面拖动
    GUI:Win_SetDrag(parent, Bag._ui["Image_bg"])

    -- 界面浮起
    GUI:Win_SetZPanel(parent, Bag._ui["Image_bg"])

    GUI:addOnClickEvent(Bag._ui["Button_close"], function()
        SL:CloseBagUI()
    end)

    -- 存入英雄背包
    local Button_store_hero_bag = Bag._ui["Button_store_hero_bag"]
    GUI:addOnClickEvent(Button_store_hero_bag, function()
        local changeStoreMode = not Bag._changeStoreMode
        if changeStoreMode then
            local isActiveHero = SL:GetMetaValue("HERO_IS_ACTIVE")
            if not isActiveHero then
                return SL:ShowSystemTips("英雄还未激活")
            end
            local isCallHero = SL:GetMetaValue("HERO_IS_ALIVE")
            if not isCallHero then
                return SL:ShowSystemTips("英雄还未召唤")
            end
        end
        Bag._changeStoreMode = changeStoreMode
        GUI:Button_setGrey(Button_store_hero_bag, changeStoreMode)
    end)
    GUI:setVisible(Button_store_hero_bag, SL:GetMetaValue("USEHERO"))

    -- 初始化左侧背包页签
    Bag.InitPage()

    Bag.PageTo(page or 1)

    Bag.OnUpdateGold()

    Bag.RegisterEvent()
end

function Bag.InitPage()
    -- 当前最大显示几页
    Bag._bagPage = math.ceil(Bag._openNum / Bag._PerPageNum)
    Bag._bagPage = math.max(Bag._bagPage, 1)
    Bag._bagPage = math.min(Bag._bagPage, Bag._MaxPage)

    for i = 1, Bag._MaxPage do
        local pageBtn = Bag._ui["Button_page" .. i]
        GUI:setVisible(pageBtn, false)
        if Bag._bagPage ~= 1 and i <= Bag._bagPage then
            GUI:setVisible(pageBtn, true)
            GUI:setTag(pageBtn, i)
            Bag._bagPageBtns[i] = pageBtn
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                if Bag._selPage == i then
                    return false
                end
                Bag.PageTo(i)
                if Bag.UpdateItems then
                    Bag.UpdateItems()
                end
            end)
        end
    end
end

function Bag.PageTo(page)
    if Bag._selPage == page then
        return false
    end
    SL:SetMetaValue("BAG_PAGE_CUR", page)
    Bag._selPage = page
    Bag.SetPageBtnStatus()
end

function Bag.SetPageBtnStatus()
    for i = 1, Bag._bagPage do
        local btnPage = Bag._bagPageBtns[i]
        if btnPage then
            local isPress = i == Bag._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and Bag._bagPage + 1 or GUI:getTag(btnPage))
            local pageText = GUI:getChildByName(btnPage, "PageText")
            GUI:Text_setTextColor(pageText, isPress and "#f8e6c6" or "#807256")
            GUI:setScale(pageText, isPress and 1 or 0.9)
        end
    end
end

function Bag.InitGird()
    local index = 0
    for i = 1, Bag._Row + 1 do
        for j = 1, Bag._Col + 1 do
            local x = (j-1) * Bag._IWidth
            local y = Bag._ScrollHeight - (i-1) * Bag._IHeight

            -- 竖线
            if i <= Bag._Row then
                local pGird1 = GUI:Image_Create(Bag._UI_ScrollView, "Grid_1_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird1, 0, j == 1 and 0 or 1)
                GUI:setRotation(pGird1, 90)
                index = index + 1
            end

            -- 横线
            if j <= Bag._Col then
                local pGird2 = GUI:Image_Create(Bag._UI_ScrollView, "Grid_2_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird2, 0, i == 1 and 1 or 0)
                index = index + 1
            end
        end
    end
end

-- 重置初始参数
function Bag.ResetInitData( ... )
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    local bag_row_col = SL:GetMetaValue("GAME_DATA", "bag_row_col_max")
    if isWinMode and bag_row_col then 
        local slices = string.split(bag_row_col, "|") 
        Bag._Row = tonumber(slices[2]) or 5
        Bag._Col = tonumber(slices[1]) or 8
        Bag._PerPageNum   = Bag._Row * Bag._Col

        -- 隐藏页签
        if Bag._PerPageNum > Bag._defaultNum then 
            for i = 1, Bag._MaxPage do
                local pageBtn = Bag._ui["Button_page"..i]
                GUI:setVisible(pageBtn, false)
            end
        end 
    end 

    local pSize       = GUI:getContentSize(Bag._UI_ScrollView)
    GUI:ScrollView_setInnerContainerSize(Bag._UI_ScrollView, pSize)
    Bag._ScrollHeight = pSize.height
    Bag._PWidth       = pSize.width
    Bag._PHeight      = pSize.height
    Bag._IWidth       = Bag._PWidth / Bag._Col
    Bag._IHeight      = Bag._PHeight / Bag._Row

    -- 代码初始化背包格子
    if Bag._codeInitGrid then
        Bag.InitGird()
    end
end

-- PC背包金币数量刷新
function Bag.OnUpdateGold(data)
    if SL:GetMetaValue("WINPLAYMODE") then
        if not data or (data.id == 1) then
            local goldNum = SL:GetMetaValue("ITEM_COUNT", 1)
            if Bag._ui.Text_goldNum then
                GUI:Text_setString(Bag._ui.Text_goldNum, goldNum)
            end
        end
    end
end

-- 是否可单击  这里可以拦截背包单击事件
function Bag.IsCanSingle(data)
    return true
end

-- 是否可以双击  这里可以拦截背包双击事件
function Bag.IsCanDouble(data)
    return true
end

-- 关闭事件
function Bag.OnClose(winID)
    if winID and winID == "BagLayerGUI" then
        Bag.UnRegisterEvent()
    end
end
--------------------------- 注册事件 -----------------------------
function Bag.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, "Bag", Bag.OnUpdateGold)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Bag", Bag.OnClose)
end

function Bag.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MONEYCHANGE, "Bag")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Bag")
end
