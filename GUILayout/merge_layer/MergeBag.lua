MergeBag = {}

MergeBagInfo = MergeBagInfo or {}

function MergeBag.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    local bagType = data and data.bagType or GUIDefine.BagType.BAG
    local pos = data and data.pos
    local bag_page = data and data.bag_page
    if bagType == GUIDefine.BagType.HEROBAG and SL:GetValue("HERO_IS_ALIVE") then
        SL:ShowSystemTips("英雄还未召唤")
        return 
    end
    local layer = GUI:GetWindow(nil, UIConst.LAYERID.MergeBagLayerGUI)
    MergeBag._layer = layer
    if not MergeBag._layer then 
        -- 初始化数据
        MergeBag.InitData()
        MergeBag.InitUI(bagType)
        MergeBag.AddSUI()
        MergeBag.RegisterEvent()
    end
    if pos then
        MergeBag.OnPositionChange(pos)
    end
    if bag_page then 
        MergeBag.ChangeBagPageEvent(bag_page)
    end
    
end

function MergeBag.InitData()
    -- 网格配置
    MergeBagInfo._scrollHeight = 320     -- 容器滚动区域的高度
    MergeBagInfo._pWidth       = 500     -- 容器可见区域 宽
    MergeBagInfo._pHeight      = 320     -- 容器可见区域 高
    MergeBagInfo._iWidth       = 62.5    -- item 宽
    MergeBagInfo._iHeight      = 64      -- item 高
    MergeBagInfo._row          = 5       -- 行数
    MergeBagInfo._col          = 8       -- 列数
    MergeBagInfo._perPageNum   = 40      -- 每页的数量（Row * Col）
    MergeBagInfo._maxPage      = 5       -- 最大的页数
    MergeBagInfo._codeInitGrid = false   -- 是否需要代码生成格子，对于背景没有格子线和滚动容器没有格子线的情况
    MergeBagInfo._changeStoreMode = false
    MergeBagInfo._bagPage    = 1     -- 开放到几页（默认1）
    MergeBagInfo._selPage    = 0     -- 当前选中的页签
    MergeBagInfo._selType    = 0     -- 1: 人物背包; 2: 英雄背包
    MergeBagInfo._openNum    = BagData.GetMaxBag()

    MergeBagInfo._lockImg   = "res/public/icon_tyzys_01.png"
    MergeBagInfo._baiTanImg = "res/public/word_bqzy_09.png"
    MergeBagInfo._bagPageBtns = {}

    MergeBagInfo._is_load_finish    = false     -- 背包是否加载完成
    MergeBagInfo._is_retrieve_finsh = true      -- 是否回收加载完成
    MergeBagInfo._powerScheduleTime = 0         -- 战力对比延迟时间
    MergeBagInfo._chooseTagList     = {}        -- 设定勾选的物品
end

function MergeBag.InitUI(bagType)
    local parent = GUI:Win_Create(UIConst.LAYERID.MergeBagLayerGUI, 0, 0, 0, 0, false, false, true, true)
    MergeBag._layer = parent
    GUI:LoadExport(parent, "bag_merge/mergebag_panel")
    MergeBagInfo._ui = GUI:ui_delegate(parent)
    -- 适配
    GUI:setPositionY(MergeBagInfo._ui.Panel_1, SL:GetValue("SCREEN_HEIGHT") / 2)

    -- 界面拖动
    GUI:Win_SetDrag(parent, MergeBagInfo._ui.Image_bg)

    -- 界面浮起
    GUI:Win_SetZPanel(parent, MergeBagInfo._ui.Image_bg)

    GUI:addOnClickEvent(MergeBagInfo._ui.Button_close, function()
        UIOperator:CloseBagUI()
        UIOperator:CloseHeroBagUI()
    end)

    -- 右侧页签 主角
    local BtnPlayer = MergeBagInfo._ui.BtnPlayer
    MergeBag._BtnPlayer = BtnPlayer
    GUI:addOnClickEvent(GUI:getChildByName(BtnPlayer, "TouchSize"), function()
        MergeBag.OnSelType(GUIDefine.BagType.BAG)
    end)

    -- 右侧页签 英雄
    local BtnHero = MergeBagInfo._ui.BtnHero
    MergeBag._BtnHero = BtnHero
    GUI:addOnClickEvent(GUI:getChildByName(BtnHero, "TouchSize"), function()
        MergeBag.OnSelType(GUIDefine.BagType.HEROBAG)
    end)

    -- 存入英雄背包
    GUI:addOnClickEvent(MergeBagInfo._ui.Button_store_mode, MergeBag.OnChangeStoreMode)
    GUI:setVisible(MergeBagInfo._ui.Button_store_mode, SL:GetValue("USEHERO"))

    GUI:setSwallowTouches(MergeBagInfo._ui.Panel_addItems, false)

    MergeBag.OnSelType(bagType, 1, true)
    MergeBag.InitMouseEvent()
    MergeBag.UpdateItems()

    -- 代码初始化背包格子
    if MergeBagInfo._codeInitGrid then
        MergeBag.InitGird()
    end

    SL:scheduleOnce(MergeBag._layer, function()
        if MergeBag.IsHeroBag() then
            return
        end

        MergeBagInfo._is_load_finish = true
        if not MergeBagInfo._is_retrieve_finsh then
            MergeBag.UpdateEquipRetrieveState()
        end
    end, 0.5)

    -- 交易行 截图节点 请勿删除 
    MergeBagInfo._screenshotRootNode = MergeBagInfo._ui.Panel_1
end

-- 位置改变
function MergeBag.OnPositionChange(pos)
    if MergeBag._layer then 
        GUI:setPosition(MergeBag._layer, pos.x, pos.y)
    end
end

function MergeBag.AddSUI()
    -- 自定义组件挂接
    local componentData = {
        root = MergeBagInfo._ui.Panel_1,
        index = SLDefine.SUIComponentTable.Bag
    }
    SL:AttachTXTSUI(componentData)
    local bagPageBtns = MergeBagInfo._bagPageBtns
    if bagPageBtns and next(bagPageBtns) then
        for index, btn in ipairs(bagPageBtns) do
            if index > 4 then
                break
            end
            if btn and not GUI:Widget_IsNull(btn) then
                local componentData = {
                    root = btn,
                    index = SLDefine.SUIComponentTable.BagPageBtn1 + index - 1
                }
                SL:AttachTXTSUI(componentData)
            end
        end
    end
end

function MergeBag.RemoveSui() 
    -- 自定义组件挂接
    local componentData = {
        index = SLDefine.SUIComponentTable.Bag
    }
    SL:UnAttachTXTSUI(componentData)

    if MergeBagInfo._ui and MergeBagInfo._ui._bagPageBtn and next(MergeBagInfo._ui._bagPageBtn) then
        for index, btn in ipairs(MergeBagInfo._ui._bagPageBtn) do
            if index > 4 then
                break
            end
            local componentData = {
                index = SLDefine.SUIComponentTable.BagPageBtn1 + index - 1
            }
            SL:UnAttachTXTSUI(componentData)
        end
    end
end

function MergeBag.OnSelType(type, page, init)
    if MergeBagInfo._selType == type then
        return
    end
    -- 英雄未激活/未召唤
    if type == GUIDefine.BagType.HEROBAG and not MergeBag.CheckHeroState()then
        return
    end
    MergeBagInfo._selType = type
    
    local btns = {MergeBag._BtnPlayer, MergeBag._BtnHero}
    for i = 1, 2 do
        local isPress = i == MergeBagInfo._selType and true or false
        GUI:Button_setBright(btns[i], not isPress)
        GUI:setLocalZOrder(btns[i], isPress and 1 or 0)
        local BtnText = GUI:getChildByName(btns[i], "BtnText")
        GUI:Text_setTextColor(BtnText, isPress and "#f8e6c6" or "#807256")
    end
    
    MergeBagInfo._changeStoreMode = false
    GUI:Button_setGrey(MergeBagInfo._ui.Button_store_mode, MergeBagInfo._changeStoreMode)
    if type == 1 then
        GUI:Button_setTitleText(MergeBagInfo._ui.Button_store_mode, "存入英雄背包")
    else
        GUI:Button_setTitleText(MergeBagInfo._ui.Button_store_mode, "存入人物背包")
    end

    MergeBag.InitPage()
    MergeBag.PageTo(page or 1, true)  
    if not init then
        MergeBag.UpdateItems()
    end  
end

function MergeBag.InitPage()   
    local openNum = MergeBag.IsHumBag() and BagData.GetMaxBag() or HeroBagData.GetMaxBag()

    -- 当前最大显示几页
    MergeBagInfo._bagPage = math.ceil(openNum / MergeBagInfo._perPageNum)
    MergeBagInfo._bagPage = math.max(MergeBagInfo._bagPage, 1)
    MergeBagInfo._bagPage = math.min(MergeBagInfo._bagPage, MergeBagInfo._maxPage)
    for i = 1, MergeBagInfo._maxPage do
        local pageBtn = MergeBagInfo._ui["Button_page" .. i]
        GUI:setVisible(pageBtn, false)
        if MergeBagInfo._bagPage ~= 1 and i <= MergeBagInfo._bagPage then
            GUI:setVisible(pageBtn, true)
            GUI:setTag(pageBtn, i)
            MergeBagInfo._bagPageBtns[i] = pageBtn
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                if MergeBagInfo._selPage == i then
                    return
                end
                MergeBag.PageTo(i)
                MergeBag.UpdateItems()
            end)
        end
    end
end

function MergeBag.PageTo(page, isChange)
    if not isChange and MergeBagInfo._selPage == page then
        return false
    end
    BagData.SetCurPage(page)
    MergeBagInfo._selPage = page
    MergeBag.SetPageBtnStatus()
end

function MergeBag.SetPageBtnStatus()
    for i = 1, MergeBagInfo._bagPage do
        local btnPage = MergeBagInfo._bagPageBtns[i]
        if btnPage then
            local isPress = i == MergeBagInfo._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and MergeBagInfo._bagPage + 1 or GUI:getTag(btnPage))
            local pageText = GUI:getChildByName(btnPage, "PageText")
            GUI:Text_setTextColor(pageText, isPress and "#f8e6c6" or "#807256")
            GUI:setScale(pageText, isPress and 1 or 0.9)
        end
    end
end

function MergeBag.OnChangeStoreMode()
    local changeStoreMode = not MergeBagInfo._changeStoreMode
    if changeStoreMode and MergeBag.IsHumBag() and not MergeBag.CheckHeroState() then
        return
    end

    MergeBagInfo._changeStoreMode = changeStoreMode
    GUI:Button_setGrey(MergeBagInfo._ui.Button_store_mode, changeStoreMode)
end

function MergeBag.CheckHeroState()
    if not SL:GetValue("HERO_IS_ACTIVE") then
        SL:ShowSystemTips("英雄还未激活")
        return false
    end
    if not SL:GetValue("HERO_IS_ALIVE") then
        SL:ShowSystemTips("英雄还未召唤")
        return false
    end
    return true
end

function MergeBag.InitGird()   
    local index = 0
    for i = 1, MergeBagInfo._row + 1 do
        for j = 1, MergeBagInfo._col + 1 do
            local x = (j-1) * MergeBagInfo._iWidth
            local y = MergeBagInfo._scrollHeight - (i-1) * MergeBagInfo._iHeight

            -- 竖线
            if i <= MergeBagInfo._row then
                local pGird1 = GUI:Image_Create(MergeBagInfo._ui.Panel_items, "Grid_1_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird1, 0, j == 1 and 0 or 1)
                GUI:setRotation(pGird1, 90)
                index = index + 1
            end

            -- 横线
            if j <= MergeBagInfo._col then
                local pGird2 = GUI:Image_Create(MergeBagInfo._ui.Panel_items, "Grid_2_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird2, 0, i == 1 and 1 or 0)
                index = index + 1
            end
        end
    end
end

function MergeBag.GetSelectPage()
    return MergeBagInfo._selPage
end

function MergeBag.IsHumBag()
    return MergeBagInfo._selType == GUIDefine.BagType.BAG
end

function MergeBag.IsHeroBag()
    return MergeBagInfo._selType == GUIDefine.BagType.HEROBAG
end

function MergeBag.SetShowType(type)
    MergeBag.OnSelType(type)
end

function MergeBag.InitMouseEvent()
    local function addItemIntoBag(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        local pos = MergeBag.GetItemBagEmptyPos(touchPos)
        if state and pos then
            local data = {}
            data.target = MergeBag.IsHumBag() and GUIDefine.ItemGoTo.BAG or GUIDefine.ItemGoTo.HERO_BAG
            data.pos = touchPos
            data.itemPosInbag = pos + (MergeBagInfo._selPage - 1) * MergeBagInfo._perPageNum
            if MergeBag.IsHeroBag() and data.itemPosInbag > HeroBagData.GetMaxBag() then  -- 上锁
                return -1
            end

            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    local function setNoSwallowMouse()
        return -1
    end

    GUI:addMouseButtonEvent(MergeBagInfo._ui.Panel_addItems, {
        onRightDownFunc = setNoSwallowMouse,
        onSpecialRFunc = addItemIntoBag
    })


    local function addGoldIntoTrade(touchPos)
        if MergeBag.IsHeroBag() then
            return
        end

        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local data = {}
            data.target = GUIDefine.ItemGoTo.BAG_GOLD
            data.pos = touchPos
            data.isGold = true
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    GUI:addMouseButtonEvent(MergeBagInfo._ui.Image_gold, {
        onRightDownFunc = setNoSwallowMouse,
        onSpecialRFunc = addGoldIntoTrade
    })

    local param = {}
    param.nodeFrom = GUIDefine.ItemFrom.BAG_GOLD
    param.moveNode = MergeBagInfo._ui.Image_gold
    param.cancelMoveCall = function()
        if MergeBagInfo._ui.Image_gold and not GUI:Widget_IsNull(MergeBagInfo._ui.Image_gold) then
            MergeBagInfo._ui.Image_gold._movingState = false
        end
    end
    GUI:RegisterNodeMovaEvent(MergeBagInfo._ui.Image_gold, param)
end

function MergeBag.GetItemBagEmptyPos(touchPos)
    local x = touchPos.x
    local y = touchPos.y
    local panelWorldPos = GUI:getWorldPosition(MergeBagInfo._ui.Panel_addItems)
    local posXInPanel = x - panelWorldPos.x
    local posYInPanel = panelWorldPos.y - y
    if posXInPanel >= MergeBagInfo._pWidth or posXInPanel <= 0 then
        return nil
    end

    if posYInPanel >= MergeBagInfo._scrollHeight or posYInPanel <= 0 then
        return nil
    end

    local indexX = math.ceil(posXInPanel / MergeBagInfo._iWidth)
    local indexY = math.floor(posYInPanel / MergeBagInfo._iHeight)

    local posIndex = indexY * MergeBagInfo._col + indexX
    if posIndex > MergeBagInfo._perPageNum then
        return nil
    end

    return posIndex
end

function MergeBag.UpdateItems()
    -- 在道具移动中
    local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
    local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
    if itemMoving and itemMovingData then
        SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL, { MakeIndex = itemMovingData.MakeIndex })
    end

    local children = GUI:getChildren(MergeBagInfo._ui.Panel_items)
    for _, item in pairs(children) do
        local name = GUI:getName(item)
        if not string.find(tostring(name), "Grid_") then
            GUI:removeFromParent(item)
        end
    end
    GUI:stopAllActions(MergeBagInfo._ui.Panel_items)

    local startPos = MergeBag.IsHumBag() and MergeBagInfo._perPageNum * (MergeBagInfo._selPage - 1) + 1 or 1
    local endPos = MergeBag.IsHumBag() and startPos + (MergeBagInfo._perPageNum - 1) or MergeBagInfo._perPageNum
    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    local maxOpen = bagDataDispose.GetMaxBag() 
    local bagData = MergeBag.IsHumBag() and BagData.GetBagDataByBagPos(startPos, endPos) or HeroBagData.GetBagData()
    for index = startPos, endPos do
        local pos = MergeBag.IsHumBag() and index - MergeBagInfo._perPageNum * (MergeBagInfo._selPage - 1) or index
        if index > maxOpen then
            local gridY = math.floor((pos - 1) / MergeBagInfo._col)
            local gridX = (pos - 1) % MergeBagInfo._col
            local posX = gridX * MergeBagInfo._iWidth + MergeBagInfo._iWidth / 2
            local posY = MergeBagInfo._scrollHeight - MergeBagInfo._iHeight / 2 - MergeBagInfo._iHeight * gridY
            MergeBag.SetClockImag(MergeBagInfo._ui.Panel_items, posX, posY)
        else
            local itemMakeIndex = bagDataDispose.GetMakeIndexByBagPos(index)
            if itemMakeIndex and bagData[itemMakeIndex] then
                MergeBag.CreateBagItem(bagData[itemMakeIndex])
            end
        end
    end

    MergeBag.OnRefreshBagRedDot()
    MergeBag.OnRefreshChooseList()
    MergeBag.InitStallTag(startPos, endPos)
    if MergeBag.IsHumBag() then
        SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_BEGAN, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.BAG].start })
    else
        SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_BEGAN, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.HEROBAG].start })
    end
end

function MergeBag.SetClockImag(panelItems, posX, posY)
    local clockImage = GUI:Image_Create(panelItems, "ClockImag", posX, posY, MergeBagInfo._lockImg)
    GUI:setAnchorPoint(clockImage, 0.5, 0.5)
    GUI:setScale(clockImage, MergeBagInfo._isWin32 and 0.5 or 1)
    GUI:setTouchEnabled(clockImage, true)
    GUI:addOnClickEvent(clockImage, function()
        GUI:delayTouchEnabled(clockImage, 0.5)
        -- 请求解锁背包
        SL:RequestUnlockBagSize()
    end)
end

function MergeBag.InitStallTag(startPos, endPos)
    local sellData = SL:GetValue("STALL_MYSELL_DATA")
    for _, v in pairs(sellData) do
        local item = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, v.MakeIndex)
        local inPage = v.bagPos and v.bagPos >= startPos and v.bagPos <= endPos
        local pos = v.bagPos
        if pos % MergeBagInfo._perPageNum == 0 then
            pos = MergeBagInfo._perPageNum
        else
            local posPage = math.floor(pos / MergeBagInfo._perPageNum)
            pos = pos - posPage * MergeBagInfo._perPageNum
        end
        if inPage and not item then
            local gridY = math.floor((pos - 1) / MergeBagInfo._col)
            local gridX = (pos - 1) % MergeBagInfo._col
            local posX = gridX * MergeBagInfo._iWidth + MergeBagInfo._iWidth / 2
            local posY = MergeBagInfo._scrollHeight - MergeBagInfo._iHeight / 2 - MergeBagInfo._iHeight * gridY

            local imgBt = GUI:Image_Create(MergeBagInfo._ui.Panel_items, "BAITAN_" .. (v.MakeIndex or ""), posX, posY, MergeBagInfo._baiTanImg)
            GUI:setAnchorPoint(imgBt, 0.5, 0.5)
        end
    end
end

function MergeBag.CreateBagItem(data)
    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    local pos = bagDataDispose.GetBagPosByMakeIndex(data.MakeIndex)
    if not pos then
        pos = bagDataDispose.GetEmptyPos()
    end

    local maxOpen = bagDataDispose.GetMaxBag()
    if pos and pos <= maxOpen then
        local info = {}
        info.itemData = data
        info.index = data.Index
        info.look = true
        info.movable = true
        info.noMouseTips = true
        info.from = MergeBag.IsHumBag() and GUIDefine.ItemFrom.BAG or GUIDefine.ItemFrom.HERO_BAG
        info.checkPower = true
        info.starLv = true

        if pos % MergeBagInfo._perPageNum == 0 then
            pos = MergeBagInfo._perPageNum
        else
            local posPage = math.floor(pos / MergeBagInfo._perPageNum)
            pos = pos - posPage * MergeBagInfo._perPageNum
        end

        local gridY = math.floor((pos - 1) / MergeBagInfo._col)
        local gridX = (pos - 1) % MergeBagInfo._col
        local posX = gridX * MergeBagInfo._iWidth
        local posY = MergeBagInfo._scrollHeight  - MergeBagInfo._iHeight * (gridY + 1)

        local goodItem = GUI:ItemShow_Create(MergeBagInfo._ui.Panel_items, data.MakeIndex, posX, posY, info)
        GUI:setStrTag(goodItem, data.MakeIndex)


        -- 单击
        GUI:ItemShow_addReplaceClickEvent(goodItem, function()
            if MergeBagInfo._changeStoreMode then  -- 人物和英雄背包互取
                if MergeBag.IsHeroBag() then
                    SL:RequestHeroBagToHumBag({ itemData = data })
                else
                    SL:RequestHumBagToHeroBag({ itemData = data })
                end
                return
            end

            -- 单击快速存取
            local stroageType = SL:GetValue("STORAGE_TOUCH_TYPE")
            local state = stroageType > 1
            if state then
                SL:RequestSaveItemToNpcStorage(data)
            end
            return not state
        end)

        local function useThisItem()
            local useState = BagData.GetOnBagItemUseState(data)
            if useState == 0 then  -- 正常双击
                UIOperator:CloseItemTips()
                local stroageType = SL:GetValue("STORAGE_TOUCH_TYPE")
                local state = stroageType > 0
                if state then
                    SL:RequestSaveItemToNpcStorage(data)
                else
                    if MergeBag.IsHeroBag() then
                        local newData = clone(data)
                        newData._from = GUIDefine.ItemFrom.HERO_BAG
                        SL:RequestUseHeroItem(newData)
                    else  -- 人物
                        data.from = GUIDefine.ItemFrom.BAG
                        SL:RequestUseItem(data)
                    end
                end

            elseif useState == 1 then  -- 使用准星道具
                SL:RequestUseCollimator(data.MakeIndex)
                if BagData.GetBagCollimator() then
                    BagData.ClearBagCollimator()
                end
                SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)

            elseif useState == 2 then  -- 取消准星
                if BagData.GetBagCollimator()  then
                    BagData.ClearBagCollimator()
                    SL:RequestCancelCollimator()
                end
                SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
            end
        end

        -- 双击
        GUI:ItemShow_addDoubleEvent(goodItem, useThisItem)

        -- 长按
        GUI:ItemShow_addPressEvent(goodItem, function()
            local itemOverLapCount = data.OverLap and data.OverLap > 1
            if itemOverLapCount then
                if bagDataDispose.isToBeFull(true) then
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
                            if MergeBag.IsHumBag() then 
                                SL:RequestSplitItem(data.MakeIndex, num)
                            else
                                SL:RequestSplitHeroItem(data.MakeIndex, num)
                            end
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
        end)


        -- 移动中处理
        local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
        local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
        if itemMoving and itemMovingData then
            if data.MakeIndex == itemMovingData.MakeIndex then
                SL:ItemMoveUpdate({ goodItem = goodItem })
                GUI:ItemShow_resetMoveState(goodItem, true)
            end
        end

        local itemState = MergeBag.CheckItemOnSomeState(data.MakeIndex)
        if not itemState then
            GUI:setVisible(goodItem, itemState)
        end
    end
end

function MergeBag.CheckItemOnSomeState(MakeIndex)
    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    local onSellOrRepaireMakeIndex = bagDataDispose.GetOnSellOrRepaire()
    if onSellOrRepaireMakeIndex == MakeIndex then
        return false
    end

    local onTradingData = SL:GetValue("TRADE_MY_ITEMS")
    if onTradingData[MakeIndex] then
        return false
    end

    return true
end

function MergeBag.ItemDataChange(data)
    if not data or not next(data) then
        return
    end

    local itemData = data.operID
    if not itemData or not next(itemData) then
        return
    end
    local isBaitan = data.isBaitan
    local type = data.opera
    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    if type == GUIDefine.OprateType.ADD or type == GUIDefine.OprateType.INIT then
        for _, v in pairs(itemData) do
            local pos = bagDataDispose.GetBagPosByMakeIndex(v.item.MakeIndex)
            local startPos = MergeBagInfo._perPageNum * (MergeBagInfo._selPage - 1) + 1
            local endPos = startPos + (MergeBagInfo._perPageNum - 1)
            if pos and pos >= startPos and pos <= endPos then
                MergeBag.CreateBagItem(v.item)
                MergeBag.OnRemoveBaiTanTag(v.item)
            end
        end

    elseif type == GUIDefine.OprateType.DEL then
        for _, v in pairs(itemData) do
            local item = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, v.MakeIndex)

            if isBaitan then
                local pos = GUI:getPosition(item)
                GUI:Image_Create(MergeBagInfo._ui.Panel_items, "BAITAN_" .. (v.MakeIndex or ""), pos.x, pos.y, MergeBagInfo._baiTanImg)
            end

            if item then
                GUI:stopAllActions(item)
                GUI:removeFromParent(item)
            end
        end

    elseif type == GUIDefine.OprateType.CHANGE then
        for _, v in pairs(itemData) do
            local item = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, v.MakeIndex)
            local thisItemData = bagDataDispose.GetItemDataByMakeIndex(v.MakeIndex)
            if item and thisItemData then
                GUI:ItemShow_updateItemCount(item, thisItemData)
            end
        end
    end
end

function MergeBag.OnRemoveBaiTanTag(data)
    if data and next(data) and data.MakeIndex then
        local baitanTag = GUI:getChildByName(MergeBagInfo._ui.Panel_items, "BAITAN_" .. data.MakeIndex)
        if baitanTag then
            GUI:removeFromParent(baitanTag)
        end
    end
end

function MergeBag.ItemPosChange(data)
    if not data or next(data) == nil then
        return
    end

    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    for _, MakeIndex in pairs(data) do
        local item = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, MakeIndex)
        local reddot
        if item then
            reddot = item:getChildByName("_RedDot_")
            if reddot then
                GUI:Retain(reddot)
                GUI:removeFromParent(reddot)
            end
            GUI:stopAllActions(item)
            GUI:removeFromParent(item)
        end

        local itemData = bagDataDispose.GetItemDataByMakeIndex(MakeIndex)
        if itemData then
            MergeBag.CreateBagItem(itemData)
            -- 红点
            if reddot then
                local item = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, MakeIndex)
                if item then
                    if reddot.sfxID then  -- 是特效 
                        local pos = GUI:getPosition(reddot)
                        local sfxID = reddot.sfxID
                        GUI:Release(reddot)
                        reddot = GUI:Effect_Create(item, "_RedDot_", pos.x, pos.y, 0, sfxID) 

                        if reddot then
                            reddot.sfxID = sfxID
                        end
                    else
                        GUI:addChild(item, reddot)
                        GUI:Release(reddot)
                    end
                end
            end
        end
    end
end

function MergeBag.RefreshBagData(data)
    if data then
        MergeBag.ItemPosChange(data)
    else
        MergeBag.UpdateItems()
    end
end

-- 主动勾选背包物品 传唯一ID 当前页
function MergeBag.UpdateBagItemChooseState(dataList)
    dataList = dataList or {}

    local curPage = BagData.GetCurPage()
    local startPos = MergeBagInfo._perPageNum * (curPage - 1) + 1
    local endPos = startPos + (MergeBagInfo._perPageNum - 1)

    local retrieveList = {}
    for _, makeIndex in ipairs(dataList) do
        retrieveList[makeIndex] = makeIndex
    end

    local bagData = BagData.GetBagDataByBagPos(startPos, endPos)
    for _, data in pairs(bagData) do
        local showTag = false
        if retrieveList and retrieveList[data.MakeIndex] then
            showTag = true
            MergeBagInfo._chooseTagList[data.MakeIndex] = true
        else
            MergeBagInfo._chooseTagList[data.MakeIndex] = nil
        end

        local goodsItem = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, data.MakeIndex)
        if goodsItem then
            GUI:ItemShow_setItemShowChooseState(goodsItem, showTag)
        end
    end
end

function MergeBag.BeginMove(data)
    local MakeIndex = data.MakeIndex
    local pos = data.pos
    if not MakeIndex then
        return
    end

    local pos = data.pos
    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    local isOnSelling = bagDataDispose.GetOnSellOrRepaire() == MakeIndex

    local gooditem = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, MakeIndex)
    if gooditem and not GUI:Widget_IsNull(gooditem) and not isOnSelling then
        GUI:ItemShow_showIteminfo(gooditem, nil, pos)
    end
end

function MergeBag.UpdateBagState(data)
    if not data then
        return
    end

    if data.goldState then
        MergeBagInfo._ui.Image_gold._movingState = data.goldState < 1
    elseif data.trading then
        MergeBag.UpdateMovingData(data.trading)
    elseif data.storage then
        MergeBag.UpdateMovingData(data.storage)
    elseif data.dropping then
        MergeBag.UpdateMovingData(data.dropping)
    end
end

function MergeBag.UpdateMovingData(data)
    if not data or not next(data) then
        return
    end

    local onMovingNode = GUI:getChildByTag(MergeBagInfo._ui.Panel_items, data.MakeIndex)
    if onMovingNode then
        GUI:setVisible(onMovingNode, data.state and data.state > 0)
        onMovingNode._movingState = not (data.state and data.state > 0)
    end
end

function MergeBag.UpdateItemPowerCheckState(data)
    local function CheckPow()
        for i, goodItem in ipairs(GUI:getChildren(MergeBagInfo._ui.Panel_items)) do
            if goodItem and goodItem.SetItemPowerTag then
                GUI:ItemShow_setItemPowerTag(goodItem)
            end
        end
    end

    if data and data.bagDelayUpdate then
        if not MergeBagInfo._powerScheduleTime or MergeBagInfo._powerScheduleTime == 0 then
            MergeBagInfo._powerScheduleTime = 3
            SL:scheduleOnce(MergeBag._layer, function()
                CheckPow()
                MergeBagInfo._powerScheduleTime = 0
            end, MergeBagInfo._powerScheduleTime)
        end
    else
        CheckPow()
    end
end

--更新背包回收勾选
function MergeBag.UpdateEquipRetrieveState(retrive_data)
    MergeBagInfo._is_retrieve_finsh = false

    if not MergeBagInfo._is_load_finish then
        return
    end

    local bagDataDispose = MergeBag.IsHumBag() and BagData or HeroBagData
    local startPos = MergeBag.IsHumBag() and MergeBagInfo._perPageNum * (MergeBagInfo._selPage - 1) + 1 or 1
    local bagData = MergeBag.IsHumBag() and bagDataDispose.GetBagDataByBagPos(startPos, startPos + MergeBagInfo._perPageNum - 1) or bagDataDispose.GetBagData()
    local retrieveList = SL:GetValue("RETRIEVE_LIST")

    for _, data in pairs(bagData) do
        local showTag = false
        if retrieveList[data.MakeIndex] then
            showTag = true
            MergeBagInfo._chooseTagList[data.MakeIndex] = true
        else
            MergeBagInfo._chooseTagList[data.MakeIndex] = nil
        end
        local goodsItem = GUI:getChildByTag(MergeBagInfo._ui.Panel_items, data.MakeIndex)
        if goodsItem then
            GUI:ItemShow_setItemShowChooseState(goodsItem, showTag)
        end
    end

    MergeBagInfo._is_retrieve_finsh = true
end

function MergeBag.OnRefreshChooseList()
    for makeIndex, _ in pairs(MergeBagInfo._chooseTagList or {}) do
        local goodsItem = GUI:getChildByTag(MergeBagInfo._ui.Panel_items, makeIndex)
        if goodsItem then
            GUI:ItemShow_setItemShowChooseState(goodsItem, true)
        end
    end
end

-- 显示准星
function MergeBag.OnBagItemCollimator(MakeIndex)
    if MakeIndex then
        local gooditem = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, MakeIndex)
        if gooditem then
            SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_SHOW, {pos = GUI:getWorldPosition(gooditem)})
        end
    end
end

function MergeBag.OnRefreshBagRedDot()
    local redDotData = SL:GetValue("BAG_RED_DOTS") or {}
    for id, data in pairs(redDotData) do
        UIOperator:RefreshRedDot(data)
    end
end

-- 背包切页事件
function MergeBag.ChangeBagPageEvent(page)
    local selectPage = BagData.GetCurPage()
    if page and page ~= selectPage then
        if MergeBag and MergeBagInfo._bagPageBtns and MergeBagInfo._bagPageBtns[page] then
            local widget = GUI:getChildByName(MergeBagInfo._bagPageBtns[page], "TouchSize")
            if widget then
                SL:WinClick(widget)
            end
        end
    end
end

-- 显示准星
function MergeBag.OnBatItemCollimator(MakeIndex)
    if MakeIndex then
        local gooditem = GUI:getChildByStrTag(MergeBagInfo._ui.Panel_items, MakeIndex)
        if gooditem then
            SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_SHOW, {pos = GUI:getWorldPosition(gooditem)})
        end
    end
end

-- 背包操作
function MergeBag.OnBagOper(data)
    if MergeBag.IsHumBag() then
        MergeBag.ItemDataChange(data)
    end
end

-- 英雄背包操作
function MergeBag.OnHeroBagOper(data)
    if MergeBag.IsHeroBag() then
        MergeBag.ItemDataChange(data)
    end
end

-- 背包位置改变
function MergeBag.OnPosChange(data)
    if MergeBag.IsHumBag() then
        MergeBag.RefreshBagData(data)
    end
end

-- 英雄背包位置改变
function MergeBag.OnHeroPosChange(data)
    if MergeBag.IsHeroBag() then
        MergeBag.RefreshBagData(data)
    end
end

-- 英雄背包道具换位后开始拖动
function MergeBag.OnBeginMove(data)
    if MergeBag.IsHumBag() then
        MergeBag.BeginMove(data)
    end
end

-- 英雄背包道具换位后开始拖动
function MergeBag.OnHeroBeginMove(data)
    if MergeBag.IsHeroBag() then
        MergeBag.BeginMove(data)
    end
end

-- 背包道具状态改变
function MergeBag.OnStateChange(data)
    if MergeBag.IsHumBag() then
        MergeBag.UpdateBagState(data)
    end
end

-- 英雄背包道具状态改变
function MergeBag.OnHeroStateChange(data)
    if MergeBag.IsHeroBag() then
        MergeBag.UpdateBagState(data)
    end
end

-- 检测提升提示
function MergeBag.OnEquipChange(data)
    if MergeBag.IsHumBag() then
        MergeBag.UpdateItemPowerCheckState(data)
    end
end

-- 检测提升提示
function MergeBag.OnHeroEquipChange(data)
    if MergeBag.IsHeroBag() then
        MergeBag.UpdateItemPowerCheckState(data)
    end
end

-- 背包刷新
function MergeBag.OnRefBag(data)
    if MergeBag.IsHumBag() then
        MergeBag.UpdateItems(data)
    end
end

-- 英雄背包刷新
function MergeBag.OnRefHeroBag(data)
    if MergeBag.IsHeroBag() then
        MergeBag.UpdateItems(data)
    end
end

-- 英雄退出
function MergeBag.OnHeroLoginOut(data)
    if MergeBag.IsHeroBag() then
        MergeBag.SetShowType(1)
    end
    
end
--------------------------- 注册事件 -----------------------------
function MergeBag.RegisterEvent()
    local layer = MergeBag._layer
    SL:RegisterLUAEvent(LUA_EVENT_BAGLAYER_POS_CHANGE, "MergeBag", MergeBag.OnPositionChange, layer)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "MergeBag", MergeBag.OnBagOper, layer) --背包操作
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, "MergeBag", MergeBag.OnPosChange, layer) --位置改变
    SL:RegisterLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, "MergeBag", MergeBag.OnStateChange, layer) --状态改变
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_LIST_REFRESH, "MergeBag", MergeBag.OnRefBag, layer) --背包刷新
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "MergeBag", MergeBag.OnEquipChange, layer) --检测提升提示
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHOOSE_STATE, "MergeBag", MergeBag.UpdateBagItemChooseState, layer) --勾选背包物品
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVE_BEGIN_BAG_POS_CHANGE, "MergeBag", MergeBag.OnBeginMove, layer) --道具换位后开始拖动
    SL:RegisterLUAEvent(LUA_EVENT_STALL_SELF_ITEM_CHANGE, "MergeBag", MergeBag.OnRemoveBaiTanTag, layer) --摆摊自己的物品改变

    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, "MergeBag", MergeBag.OnHeroBagOper, layer) --英雄背包操作
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE, "MergeBag", MergeBag.OnHeroPosChange, layer) --英雄背包位置改变
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVE_BEGIN_HERO_BAG_POS_CHANGE, "MergeBag", MergeBag.OnHeroBeginMove, layer) --英雄背包道具换位后开始拖动
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_STATE_CHANGE, "MergeBag", MergeBag.OnHeroStateChange, layer) --状态改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "MergeBag", MergeBag.OnHeroEquipChange, layer) --检测提升提示
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_LIST_REFRESH, "MergeBag", MergeBag.OnRefHeroBag, layer) --英雄背包刷新
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGOUT, "HeroBag", MergeBag.OnHeroLoginOut, layer) --英雄退出

    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_COLLIMATOR, "MergeBag", MergeBag.OnBatItemCollimator, layer) --显示准星
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_RETRIEVE_STATE_CHANGE, "MergeBag", MergeBag.UpdateEquipRetrieveState, layer) --更新背包回收勾选
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "MergeBag", MergeBag.OnCloseLayer) --关闭界面
end
-------------------------------------------------------------------
-- 关闭监听
function MergeBag.OnCloseLayer(id)
    if UIConst.LAYERID.MergeBagLayerGUI == id and MergeBagInfo then 
        MergeBag.RemoveSui()
        if BagData.GetBagCollimator() then
            BagData.ClearBagCollimator()
            SL:RequestCancelCollimator()
        end
        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "MergeBag")
        SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_ENDED, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.BAG].close, bag_page = MergeBagInfo._selPage or 1 })
        SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
        MergeBagInfo = nil
    end
end

MergeBag.main()