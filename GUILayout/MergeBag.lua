MergeBag = {}

function MergeBag.Init()
    -- 网格配置
    MergeBag._ScrollHeight = 320     -- 容器滚动区域的高度
    MergeBag._PWidth       = 500     -- 容器可见区域 宽
    MergeBag._PHeight      = 320     -- 容器可见区域 高
    MergeBag._IWidth       = 62.5    -- item 宽
    MergeBag._IHeight      = 64      -- item 高
    MergeBag._Row          = 5       -- 行数
    MergeBag._Col          = 8       -- 列数
    MergeBag._PerPageNum   = 40      -- 每页的数量（Row * Col）
    MergeBag._MaxPage      = 5       -- 最大的页数
    MergeBag._codeInitGrid = false   -- 是否需要代码生成格子，对于背景没有格子线和滚动容器没有格子线的情况

    MergeBag._changeStoreMode = false
    MergeBag._bagPage    = 1     -- 开放到几页（默认1）
    MergeBag._selPage    = 0     -- 当前选中的页签
    MergeBag._selType    = 0     -- 1: 人物背包; 2: 英雄背包
    MergeBag._openNum    = SL:GetMetaValue("MAX_BAG")

    MergeBag._lockImg   = "res/public/icon_tyzys_01.png"
    MergeBag._baiTanImg = "res/public/word_bqzy_09.png"

    MergeBag._bagPageBtns = {}
end

function MergeBag.main(type, page)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "bag_merge/mergebag_panel")

    MergeBag._ui = GUI:ui_delegate(parent)
    MergeBag._UI_ScrollView = MergeBag._ui["ScrollView_items"]

    -- 初始化数据
    MergeBag.Init()

    -- 适配
    GUI:setPositionY(MergeBag._ui["Panel_1"], SL:GetMetaValue("SCREEN_HEIGHT") / 2)

    -- 界面拖动
    GUI:Win_SetDrag(parent, MergeBag._ui["Image_bg"])

    -- 界面浮起
    GUI:Win_SetZPanel(parent, MergeBag._ui["Image_bg"])

    GUI:addOnClickEvent(MergeBag._ui["Button_close"], function()
        SL:CloseBagUI()
        SL:CloseHeroBagUI()
    end)

    -- 右侧页签 主角
    local BtnPlayer = MergeBag._ui["BtnPlayer"]
    MergeBag._BtnPlayer = BtnPlayer
    GUI:addOnClickEvent(GUI:getChildByName(BtnPlayer, "TouchSize"), function()
        MergeBag.onSelType(1)
    end)

    -- 右侧页签 英雄
    local BtnHero = MergeBag._ui["BtnHero"]
    MergeBag._BtnHero = BtnHero
    GUI:addOnClickEvent(GUI:getChildByName(BtnHero, "TouchSize"), function()
        MergeBag.onSelType(2)
    end)

    -- 存入英雄背包
    local Button_store_mode = MergeBag._ui["Button_store_mode"]
    MergeBag._Button_store_mode = Button_store_mode
    GUI:addOnClickEvent(Button_store_mode, MergeBag.onChangeStoreMode)
    GUI:setVisible(Button_store_mode, SL:GetMetaValue("USEHERO"))

    MergeBag.onSelType(type, page, true)
end

function MergeBag.onSelType(type, page, init)
    if MergeBag._selType == type then
        return
    end

    -- 英雄未激活/未召唤
    if type == 2 and not MergeBag.CheckHeroState()then
        return
    end

    MergeBag._selType = type
    
    local btns = {MergeBag._BtnPlayer, MergeBag._BtnHero}
    for i = 1, 2 do
        local isPress = i == MergeBag._selType and true or false
        GUI:Button_setBright(btns[i], not isPress)
        GUI:setLocalZOrder(btns[i], isPress and 1 or 0)
        local BtnText = GUI:getChildByName(btns[i], "BtnText")
        GUI:Text_setTextColor(BtnText, isPress and "#f8e6c6" or "#807256")
    end
    
    MergeBag._changeStoreMode = false
    GUI:Button_setGrey(MergeBag._Button_store_mode, MergeBag._changeStoreMode)
    if type == 1 then
        GUI:Button_setTitleText(MergeBag._Button_store_mode, "存入英雄背包")
    else
        GUI:Button_setTitleText(MergeBag._Button_store_mode, "存入人物背包")
    end

    MergeBag.InitPage()
    MergeBag.PageTo(page or 1, true)  
    if not init and MergeBag.UpdateItems then
        MergeBag.UpdateItems()
    end  
end

function MergeBag.InitPage()   
    local openNum = MergeBag._selType == 1 and SL:GetMetaValue("MAX_BAG") or SL:GetMetaValue("H_MAX_BAG")

    -- 当前最大显示几页
    MergeBag._bagPage = math.ceil(openNum / MergeBag._PerPageNum)
    MergeBag._bagPage = math.max(MergeBag._bagPage, 1)
    MergeBag._bagPage = math.min(MergeBag._bagPage, MergeBag._MaxPage)

    for i = 1, MergeBag._MaxPage do
        local pageBtn = MergeBag._ui["Button_page" .. i]
        GUI:setVisible(pageBtn, false)
        if MergeBag._bagPage ~= 1 and i <= MergeBag._bagPage then
            GUI:setVisible(pageBtn, true)
            GUI:setTag(pageBtn, i)
            MergeBag._bagPageBtns[i] = pageBtn
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                if MergeBag._selPage == i then
                    return
                end
                MergeBag.PageTo(i)
                if MergeBag.UpdateItems then
                    MergeBag.UpdateItems()
                end
            end)
        end
    end
end

function MergeBag.PageTo(page, isChange)
    if not isChange and MergeBag._selPage == page then
        return false
    end
    SL:SetMetaValue("BAG_PAGE_CUR", page)
    MergeBag._selPage = page
    MergeBag.SetPageBtnStatus()
end

function MergeBag.SetPageBtnStatus()
    for i = 1, MergeBag._bagPage do
        local btnPage = MergeBag._bagPageBtns[i]
        if btnPage then
            local isPress = i == MergeBag._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and MergeBag._bagPage + 1 or GUI:getTag(btnPage))
            local pageText = GUI:getChildByName(btnPage, "PageText")
            GUI:Text_setTextColor(pageText, isPress and "#f8e6c6" or "#807256")
            GUI:setScale(pageText, isPress and 1 or 0.9)
        end
    end
end

function MergeBag.onChangeStoreMode()
    local changeStoreMode = not MergeBag._changeStoreMode
    if changeStoreMode and MergeBag._selType == 1 and not MergeBag.CheckHeroState() then
        return
    end

    MergeBag._changeStoreMode = changeStoreMode
    GUI:Button_setGrey(MergeBag._Button_store_mode, changeStoreMode)
end

function MergeBag.CheckHeroState()
    if not SL:GetMetaValue("HERO_IS_ACTIVE") then
        SL:ShowSystemTips("英雄还未激活")
        return false
    end
    if not SL:GetMetaValue("HERO_IS_ALIVE") then
        SL:ShowSystemTips("英雄还未召唤")
        return false
    end
    return true
end

function MergeBag.InitGird()   
    local index = 0
    for i = 1, MergeBag._Row + 1 do
        for j = 1, MergeBag._Col + 1 do
            local x = (j-1) * MergeBag._IWidth
            local y = MergeBag._ScrollHeight - (i-1) * MergeBag._IHeight

            -- 竖线
            if i <= MergeBag._Row then
                local pGird1 = GUI:Image_Create(MergeBag._UI_ScrollView, "Grid_1_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird1, 0, j == 1 and 0 or 1)
                GUI:setRotation(pGird1, 90)
                index = index + 1
            end

            -- 横线
            if j <= MergeBag._Col then
                local pGird2 = GUI:Image_Create(MergeBag._UI_ScrollView, "Grid_2_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird2, 0, i == 1 and 1 or 0)
                index = index + 1
            end
        end
    end
end

-- 重置初始参数
function MergeBag.ResetInitData( ... )
    local pSize       = GUI:getContentSize(MergeBag._UI_ScrollView)
    GUI:ScrollView_setInnerContainerSize(MergeBag._UI_ScrollView, pSize)
    MergeBag._ScrollHeight = pSize.height
    MergeBag._PWidth       = pSize.width
    MergeBag._PHeight      = pSize.height
    MergeBag._IWidth       = MergeBag._PWidth / MergeBag._Col
    MergeBag._IHeight      = MergeBag._PHeight / MergeBag._Row

    -- 代码初始化背包格子
    if MergeBag._codeInitGrid then
        MergeBag.InitGird()
    end
end