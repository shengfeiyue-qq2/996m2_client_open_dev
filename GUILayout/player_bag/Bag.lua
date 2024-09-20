Bag = {}

BagInfo = BagInfo or {}
BagInfo._isWin32 = SL:GetValue("IS_PC_OPER_MODE")

function Bag.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    
    local pos = data and data.pos 
    local page = data and data.bag_page or 1
    local layer = GUI:GetWindow(nil, UIConst.LAYERID.BagLayerGUI)
    Bag._layer = layer
    if not Bag._layer then 
        -- 初始化数据
        Bag.InitData()
        Bag.InitUI(page)
        Bag.AddSUI()
        Bag.RegisterEvent()
    end

    if pos then
        Bag.OnPositionChange(pos)
    end
end

function Bag.InitData()
    -- 网格配置
    BagInfo._scrollHeight       = BagInfo._isWin32 and 214 or 320     -- 容器滚动区域的高度
    BagInfo._pWidth             = BagInfo._isWin32 and 338 or 500     -- 容器可见区域 宽
    BagInfo._pHeight            = BagInfo._isWin32 and 214 or 320     -- 容器可见区域 高
    BagInfo._iWidth             = BagInfo._isWin32 and 42  or 62      -- item 宽
    BagInfo._iHeight            = BagInfo._isWin32 and 42  or 64      -- item 高
    BagInfo._row                = 5       -- 行数
    BagInfo._col                = 8       -- 列数
    BagInfo._perPageNum         = 40      -- 每页的数量（Row * Col）
    BagInfo._defaultNum         = 40      -- 默认官方每页格子数量
    BagInfo._maxPage            = 5       -- 最大的页数
    BagInfo._codeInitGrid       = false   -- 是否需要代码生成格子，对于背景没有格子线和滚动容器没有格子线的情况

    BagInfo._changeStoreMode    = false
    BagInfo._bagPage            = 1     -- 开放到几页（默认1）
    BagInfo._selPage            = 0     -- 当前选中的页签
    BagInfo._openNum            = BagData.GetMaxBag()

    BagInfo._lockImg            = "res/public/icon_tyzys_01.png"
    BagInfo._baiTanImg          = BagInfo._isWin32 and "res/public/word_bqzy_09_1.png" or "res/public/word_bqzy_09.png"

    BagInfo._bagPageBtns        = {}
    BagInfo._chooseTagList      = {} -- 回收设定勾选的物品
end

function Bag.InitUI(page)
    local parent = GUI:Win_Create(UIConst.LAYERID.BagLayerGUI, 0, 0, 0, 0, false, false, true, true)
    Bag._layer = parent
    GUI:LoadExport(parent, BagInfo._isWin32 and "bag/bag_panel_win32" or "bag/bag_panel")
    BagInfo._ui = GUI:ui_delegate(parent)
    
    -- 界面拖动
    GUI:Win_SetDrag(parent, BagInfo._ui.Image_bg)
    GUI:Win_SetZPanel(parent, BagInfo._ui.Image_bg)

    GUI:addOnClickEvent(BagInfo._ui.Button_close, function()
        UIOperator:CloseBagUI()
    end)

    -- 存入英雄背包
    local Button_store_hero_bag = BagInfo._ui.Button_store_hero_bag
    GUI:addOnClickEvent(Button_store_hero_bag, function()
        local changeStoreMode = not BagInfo._changeStoreMode
        if changeStoreMode then
            local isActiveHero = SL:GetValue("HERO_IS_ACTIVE")
            if not isActiveHero then
                return SL:ShowSystemTips("英雄还未激活")
            end
            local isCallHero = SL:GetValue("HERO_IS_ALIVE")
            if not isCallHero then
                return SL:ShowSystemTips("英雄还未召唤")
            end
        end
        BagInfo._changeStoreMode = changeStoreMode
        GUI:Button_setGrey(Button_store_hero_bag, changeStoreMode)
    end)
    GUI:setVisible(Button_store_hero_bag, SL:GetValue("USEHERO"))

    Bag.InitMouseEvent()

    -- 初始化左侧背包页签
    Bag.InitPage()

    Bag.PageTo(page or 1)
    
    Bag.OnUpdateGold()
    Bag.InitBigBag()
    
    Bag.UpdateItems()
    -- 代码初始化背包格子
    if BagInfo._codeInitGrid then
        Bag.InitGird()
    end

    -- 适配
    GUI:setPositionY(BagInfo._ui.Panel_1, BagInfo._isWin32 and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2)

    -- 交易行 截图节点 请勿删除 
    BagInfo._screenshotRootNode = BagInfo._ui.Panel_1
end

function Bag.ItemDataChange(data)
    if not data or not next(data) then
        return
    end
    local itemData = data.operID
    if not itemData or not next(itemData) then
        return
    end

    local isBaitan = data.isBaitan
    local type = data.opera
    if type == GUIDefine.OprateType.ADD or type == GUIDefine.OprateType.INIT then
        for _, v in pairs(itemData) do
            local pos = BagData.GetBagPosByMakeIndex(v.item.MakeIndex) 
            local startPos = BagInfo._perPageNum * (BagData.GetCurPage() - 1) + 1
            local endPos = startPos + BagInfo._perPageNum - 1
            if pos and pos >= startPos and pos <= endPos then
                Bag.CreateBagItem(v.item)
                Bag.OnRemoveBaiTanTag(v.item)
            end
        end

    elseif type == GUIDefine.OprateType.DEL then
        for _, v in pairs(itemData) do
            local item = GUI:getChildByStrTag(BagInfo._ui.Panel_items, v.MakeIndex)
            if isBaitan then
                local pos = GUI:getPosition(item)
                GUI:Image_Create(BagInfo._ui.Panel_items, "BAITAN_" .. (v.MakeIndex or ""), pos.x, pos.y, Bag._baiTanImg)
            end           

            if item then
                GUI:stopAllActions(item)
                GUI:removeFromParent(item)
            end
        end

    elseif type == GUIDefine.OprateType.CHANGE then
        for _, v in pairs(itemData) do
            local thisItemData = BagData.GetItemDataByMakeIndex(v.MakeIndex)
            local buifenlei = thisItemData.buifenlei and tonumber(thisItemData.buifenlei) or nil

            local item = GUI:getChildByStrTag(BagInfo._ui.Panel_items, v.MakeIndex)
            if item and thisItemData then
                GUI:ItemShow_updateItemCount(item, thisItemData)
            end
        end
    end
end

function Bag.InitPage()
    -- 当前最大显示几页
    BagInfo._bagPage = math.ceil(BagInfo._openNum / BagInfo._perPageNum)
    BagInfo._bagPage = math.max(BagInfo._bagPage, 1)
    BagInfo._bagPage = math.min(BagInfo._bagPage, BagInfo._maxPage)

    for i = 1, BagInfo._maxPage do
        local pageBtn = BagInfo._ui["Button_page" .. i]
        GUI:setVisible(pageBtn, false)
        if BagInfo._bagPage ~= 1 and i <= BagInfo._bagPage then
            GUI:setVisible(pageBtn, true)
            GUI:setTag(pageBtn, i)
            BagInfo._bagPageBtns[i] = pageBtn
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                if BagInfo._selPage == i then
                    return false
                end
                Bag.PageTo(i)
                Bag.UpdateItems()
            end)
        end
    end
end

function Bag.UpdateItems()
    local children = GUI:getChildren(BagInfo._ui.Panel_items)
    for _, item in pairs(children) do
        local name = GUI:getName(item)
        if not string.find(tostring(name), "Grid_") then
            GUI:removeFromParent(item)
        end
    end

    local curPage = BagData.GetCurPage()  
    local sIndex = BagInfo._perPageNum * (curPage - 1) + 1
    local eIndex = sIndex + (BagInfo._perPageNum - 1)
    local bagData = BagData.GetBagDataByBagPos(sIndex, eIndex)
    local maxOpen = BagData.GetMaxBag() 

    local showData = {}
    for i = sIndex, eIndex do
        local makeIndex = BagData.GetMakeIndexByBagPos(i)   
        local data = bagData[makeIndex]
        if data then
            table.insert(showData, data)
        end
    end

    local idx = 0
    local function showBagItemsUI()
        local loadNum = BagInfo._col
        local posStart = idx * loadNum + 1
        local posEnd = idx * loadNum + loadNum
        
        if posStart > BagInfo._perPageNum then
            GUI:stopAllActions(BagInfo._ui.Panel_items)

            -- 加载完处理
            Bag.OnRefreshBagRedDot()
            Bag.OnRefreshChooseList()
            Bag.InitStallTag(sIndex, eIndex)
            SL:onLUAEvent(LUA_EVENT_BAG_LOAD_SUCCESS)
            SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_BEGAN, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.BAG].start })
            return
        end
        
        for i = posStart, posEnd do
            local gridY = math.floor((i - 1) / BagInfo._col)
            local gridX = (i - 1) % BagInfo._col
            local posX = gridX * BagInfo._iWidth + BagInfo._iWidth / 2
            local posY = BagInfo._scrollHeight - BagInfo._iHeight / 2 - BagInfo._iHeight * gridY
            local bShowLock = i + (curPage - 1) * BagInfo._perPageNum > maxOpen
            if bShowLock then 
                Bag.SetClockImag(BagInfo._ui.Panel_items, posX, posY)    
            else 
                if showData[i] then
                    Bag.CreateBagItem(showData[i])
                end
            end 
        end

        idx = idx + 1
        SL:scheduleOnce(BagInfo._ui.Panel_items, showBagItemsUI, 0.01)
    end

    GUI:stopAllActions(BagInfo._ui.Panel_items)
    showBagItemsUI()
end

function Bag.ResetItemPos(item)
    local worldPos  = GUI:convertToWorldSpace(item, GUI:p(0,0))
    local newPos    = GUI:p(math.floor(worldPos.x), math.floor(worldPos.y))
    local pos       = GUI:p(GUI:getPosition(item))
    local size      = GUI:getContentSize(item)
    local posVec    = GUI:pAdd(pos,GUI:pSub(newPos, worldPos))     
    GUI:setPosition(item, posVec.x+size.width/2, posVec.y+size.height/2)
end

function Bag.OnRemoveBaiTanTag(data)
    if data and next(data) and data.MakeIndex then
        local baitanTag = GUI:getChildByName(BagInfo._ui.Panel_items, "BAITAN_" .. data.MakeIndex)
        if baitanTag then
            GUI:removeFromParent(baitanTag)
        end
    end
end

function Bag.PageTo(page)
    if BagInfo._selPage == page then
        return false
    end
    BagData.SetCurPage(page)
    BagInfo._selPage = page
    Bag.SetPageBtnStatus()
end

function Bag.SetPageBtnStatus()
    for i = 1, BagInfo._bagPage do
        local btnPage = BagInfo._bagPageBtns[i]
        if btnPage then
            local isPress = i == BagInfo._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and BagInfo._bagPage + 1 or GUI:getTag(btnPage))
            local pageText = GUI:getChildByName(btnPage, "PageText")
            GUI:Text_setTextColor(pageText, isPress and "#f8e6c6" or "#807256")
            GUI:setScale(pageText, isPress and 1 or 0.9)
        end
    end
end

function Bag.InitGird()
    local index = 0
    for i = 1, BagInfo._row + 1 do
        for j = 1, BagInfo._col + 1 do
            local x = (j-1) * BagInfo._iWidth
            local y = BagInfo._scrollHeight - (i-1) * BagInfo._iHeight

            -- 竖线
            if i <= BagInfo._row then
                local pGird1 = GUI:Image_Create(BagInfo._ui.Panel_items, "Grid_1_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird1, 0, j == 1 and 0 or 1)
                GUI:setRotation(pGird1, 90)
                index = index + 1
            end

            -- 横线
            if j <= BagInfo._col then
                local pGird2 = GUI:Image_Create(BagInfo._ui.Panel_items, "Grid_2_" .. index, x, y, "res/public/bag_gezi.png")
                GUI:setAnchorPoint(pGird2, 0, i == 1 and 1 or 0)
                index = index + 1
            end
        end
    end
end

-- 大背包
function Bag.InitBigBag()
    local bag_row_col = SL:GetValue("GAME_DATA", "bag_row_col_max")
    if BagInfo._isWin32 and bag_row_col then 
        local slices = string.split(bag_row_col, "|") 
        BagInfo._row = tonumber(slices[2]) or 5
        BagInfo._col = tonumber(slices[1]) or 8
        BagInfo._perPageNum   = BagInfo._row * BagInfo._col

        -- 隐藏页签
        if BagInfo._perPageNum > BagInfo._defaultNum then 
            for i = 1, BagInfo._maxPage do
                local pageBtn = BagInfo._ui["Button_page"..i]
                GUI:setVisible(pageBtn, false)
            end
        end 

        local pSize       = GUI:getContentSize(BagInfo._ui.Panel_items)
        GUI:ScrollView_setInnerContainerSize(BagInfo._ui.Panel_items, pSize)
        BagInfo._scrollHeight = pSize.height
        BagInfo._pWidth       = pSize.width
        BagInfo._pHeight      = pSize.height
        BagInfo._iWidth       = BagInfo._pWidth / BagInfo._col
        BagInfo._iHeight      = BagInfo._pHeight / BagInfo._row
    end 
end

-- PC背包金币数量刷新
function Bag.OnUpdateGold(data)
    if BagInfo._isWin32 then
        if not data or (data.id == 1) then
            local goldNum = SL:GetValue("ITEM_COUNT", 1)
            if BagInfo._ui.Text_goldNum then
                GUI:Text_setString(BagInfo._ui.Text_goldNum, goldNum)
            end
        end
    end
end

function Bag.AddSUI()
    -- 自定义组件挂接
    local componentData = {
        root = BagInfo._ui.Panel_1,
        index = SLDefine.SUIComponentTable.Bag
    }
    SL:AttachTXTSUI(componentData)
    local bagPageBtns = BagInfo._bagPageBtns
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

function Bag.RemoveSui() 
    -- 自定义组件挂接
    local componentData = {
        index = SLDefine.SUIComponentTable.Bag
    }
    SL:UnAttachTXTSUI(componentData)

    if BagInfo._ui and BagInfo._ui._bagPageBtn and next(BagInfo._ui._bagPageBtn) then
        for index, btn in ipairs(BagInfo._ui._bagPageBtn) do
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

-- 位置改变
function Bag.OnPositionChange(pos)
    if Bag._layer then 
        GUI:setPosition(Bag._layer, pos.x, pos.y)
    end
end

-- 刷新红点
function Bag.OnRefreshBagRedDot()
    local redDotData = SL:GetValue("BAG_RED_DOTS") or {}
    for id, data in pairs(redDotData) do
        UIOperator:RefreshRedDot(data)
    end
end

-- 初始化摆摊数据
function Bag.InitStallTag(startPos, endPos)
    local sellData = SL:GetValue("STALL_MYSELL_DATA")
    for _, v in pairs(sellData) do
        local pos = v.bagPos
        if pos % BagInfo._perPageNum == 0 then
            pos = BagInfo._perPageNum
        else
            local posPage = math.floor(pos / BagInfo._perPageNum)
            pos = pos - posPage * BagInfo._perPageNum
        end

        local inPage = v.bagPos and v.bagPos >= startPos and v.bagPos <= endPos
        local item = GUI:getChildByStrTag(BagInfo._ui.Panel_items, v.MakeIndex)
        if inPage and not item then
            local gridY = math.floor((pos - 1) / BagInfo._col)
            local gridX = (pos - 1) % BagInfo._col
            local posX = gridX * BagInfo._iWidth + BagInfo._iWidth / 2
            local posY = BagInfo._scrollHeight - BagInfo._iHeight / 2 - BagInfo._iHeight * gridY
            local imgBt = GUI:Image_Create(BagInfo._ui.Panel_items, "BAITAN_" .. (v.MakeIndex or ""), posX, posY, BagInfo._baiTanImg)
            GUI:setAnchorPoint(imgBt, 0.5, 0.5)
        end
    end
end

-- 设置 锁
function Bag.SetClockImag(panelItems, posX, posY)
    local clockImage = GUI:Image_Create(panelItems, string.format("ClockImag_%s_%s",posX, posY), posX, posY, BagInfo._lockImg)
    GUI:setAnchorPoint(clockImage, 0.5, 0.5)
    GUI:setScale(clockImage, BagInfo._isWin32 and 0.5 or 1)
    GUI:setTouchEnabled(clockImage, true)
    GUI:addOnClickEvent(clockImage, function()
        GUI:delayTouchEnabled(clockImage, 0.5)
        -- 请求解锁背包
        SL:RequestUnlockBagSize()
    end)
end

function Bag.OnRefreshChooseList()
    for makeIndex, _ in pairs(BagInfo._chooseTagList or {}) do
        local goodsItem = GUI:getChildByStrTag(BagInfo._ui.Panel_items, makeIndex)
        if goodsItem then
            GUI:ItemShow_setItemShowChooseState(goodsItem, true)
        end
    end
end

function Bag.CreateBagItem(data)
    local index = BagData.GetBagPosByMakeIndex(data.MakeIndex) or BagData.GetEmptyPos()
    local info = {}
    info.itemData = data
    info.index = data.Index
    info.look = true
    info.movable = true
    info.noMouseTips = not BagInfo._isWin32
    info.from = GUIDefine.ItemFrom.BAG
    info.checkPower = true

    local pos = Bag.GetItemPosByIndex(index)
    if not pos then 
        return 
    end 

    local goodItem = GUI:ItemShow_Create(BagInfo._ui.Panel_items, data.MakeIndex, pos.x, pos.y, info)
    GUI:setAnchorPoint(goodItem, 0.5, 0.5)
    GUI:setStrTag(goodItem, data.MakeIndex)
    Bag.ResetItemPos(goodItem)
    -- 单击
    GUI:ItemShow_addReplaceClickEvent(goodItem, function()
        -- 人物和英雄背包互取
        if BagInfo._changeStoreMode then
            SL:RequestHumBagToHeroBag({ itemData = data })
            return false
        end

        if BagInfo._isWin32 and SL:GetValue("IS_PRESSED_SHIFT") then
            local itemOverLapCount = data.OverLap and data.OverLap > 1
            if itemOverLapCount then
                if BagData.isToBeFull(true)  then
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
                            SL:RequestSplitItem(data, num)
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
                    max = data.OverLap
                }
                UIOperator:OpenCommonTipsUI(commonData)
            end
            return false
        end

        -- 单击快速存取
        local stroageType = SL:GetValue("STORAGE_TOUCH_TYPE")  --normal = 1, -- 普通的双击存取  quick  = 2, -- 快速存取
        local state = stroageType > 1
        if state then
            SL:RequestSaveItemToNpcStorage(data)
        end

        return not state
    end)

    local function useThisItem()
        local useState = BagData.GetOnBagItemUseState(data) --获取背包道具的使用状态(0：使用 1：使用准星道具 2：取消准星 3：不可使用)
        if useState == 0 then -- 正常双击
            UIOperator:CloseItemTips()
            local stroageType = SL:GetValue("STORAGE_TOUCH_TYPE")
            local state = stroageType > 0
            if state then
                SL:RequestSaveItemToNpcStorage(data)
            else
                local nowItemData = BagData.GetItemDataByMakeIndex(data.MakeIndex ) 
                SL:RequestUseItem(nowItemData)
            end

        elseif useState == 1 then -- 使用准星道具
            SL:RequestUseCollimator(data.MakeIndex)
            if BagData.GetBagCollimator()then
                BagData.ClearBagCollimator()
            end
            SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
        elseif useState == 2 then -- 取消准星
            if BagData.GetBagCollimator() then
                BagData.ClearBagCollimator()
                SL:RequestCancelCollimator()
            end
            SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
        end
    end
    
    if BagInfo._isWin32 then
        local function RUseThisItem()
            if BagData.GetBagCollimator() then -- 准星   取消
                BagData.ClearBagCollimator()
                SL:RequestCancelCollimator()
                SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
                return
            end
            useThisItem()
        end

        local function LClickThisItem()
            local useState = BagData.GetOnBagItemUseState(data)
            if useState ~= 0 then -- 准星物品
                if useState == 1 then -- 使用准星道具
                    SL:RequestUseCollimator(data.MakeIndex)
                    if BagData.GetBagCollimator() then
                        BagData.ClearBagCollimator()
                    end
                    SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
                end
            end

            return -1
        end

        -- right mouse btn quick use
        GUI:addMouseButtonEvent(goodItem, { 
            onRightDownFunc = RUseThisItem,
            onDoubleLFunc = useThisItem,
            onSpecialRFunc = LClickThisItem,
        })
    else
        -- 双击
        GUI:ItemShow_addDoubleEvent(goodItem, useThisItem)

        -- 长按
        GUI:ItemShow_addPressEvent(goodItem, function()
            local itemOverLapCount = data.OverLap and data.OverLap > 1
            if itemOverLapCount then
                if BagData.isToBeFull(true) then
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

                            SL:RequestSplitItem(data, num)
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
                    max = data.OverLap
                }
                UIOperator:OpenCommonTipsUI(commonData)
            else
                GUI:ItemShow_setMoveEable(goodItem, true)
            end
        end)
    end

    -- 移动中处理 买卖 
    local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
    local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
    if itemMoving and itemMovingData then
        if data.MakeIndex == itemMovingData.MakeIndex then
            SL:ItemMoveUpdate({
                goodItem = goodItem
            })
            GUI:ItemShow_resetMoveState(goodItem, true)
        end
    end

    local onSomeState = Bag.CheckItemOnSomeState(data.MakeIndex)
    if onSomeState then
        GUI:setVisible(goodItem, false)
    end   
end

function Bag.CheckItemOnSomeState(MakeIndex)
    local onSellOrRepaireMakeIndex = BagData.GetOnSellOrRepaire() 
    if onSellOrRepaireMakeIndex == MakeIndex then
        return true
    end

    local onTradingData = SL:GetValue("TRADE_MY_ITEMS")
    if onTradingData[MakeIndex] then
        return true
    end

    return false
end

function Bag.GetItemPosByIndex(index)
    local pos = {}
    if not index then 
        return 
    end 

    if index % BagInfo._perPageNum == 0 then
        index = BagInfo._perPageNum
    else
        local posPage = math.floor(index / BagInfo._perPageNum)
        index = index - posPage * BagInfo._perPageNum
    end

    local gridY = math.floor((index - 1) / BagInfo._col)
    local gridX = (index - 1) % BagInfo._col
    pos.x = gridX * BagInfo._iWidth
    pos.y = BagInfo._scrollHeight - BagInfo._iHeight * (gridY + 1)

    local newPos = {}
    newPos.x = math.floor(pos.x)
    newPos.y = math.floor(pos.y)

    return newPos
end 

function Bag.InitMouseEvent()
    GUI:setSwallowTouches(BagInfo._ui.Panel_addItems, false)

    local function setNoswallowMouse()
        return -1
    end

    local function addItemIntoBag(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE") 
        local pos = Bag.GetItemBagEmptyPos(touchPos)
        if state and pos then
            local goToName = GUIDefine.ItemGoTo.BAG
            local data = {}
            data.target = goToName
            data.pos = touchPos
            data.itemPosInbag = pos + (BagData.GetCurPage() - 1) * BagInfo._perPageNum
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    GUI:addMouseButtonEvent(BagInfo._ui.Panel_addItems, {
        onRightDownFunc = setNoswallowMouse,
        onSpecialRFunc = addItemIntoBag
    })

    local function addGoldIntoTrade(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE") 
        if state then
            local goToName = GUIDefine.ItemGoTo.BAG_GOLD
            local data = {}
            data.target = goToName
            data.pos = touchPos
            data.isGold = true
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    GUI:addMouseButtonEvent(BagInfo._ui.Image_gold, {
        onRightDownFunc = setNoswallowMouse,
        onSpecialRFunc = addGoldIntoTrade
    })

    local param = {}
    param.nodeFrom = GUIDefine.ItemFrom.BAG_GOLD
    param.moveNode = BagInfo._ui.Image_gold
    param.cancelMoveCall = function()
        if BagInfo._ui.Image_gold and not GUI:Widget_IsNull(BagInfo._ui.Image_gold) then
            BagInfo._ui.Image_gold._movingState = false
        end
    end
    GUI:RegisterNodeMovaEvent(BagInfo._ui.Image_gold, param)
end


function Bag.GetItemBagEmptyPos(touchPos)
    local x = touchPos.x
    local y = touchPos.y
    local panelWorldPos = GUI:getWorldPosition(BagInfo._ui.Panel_addItems)

    local posXInPanel = x - panelWorldPos.x
    if posXInPanel >= BagInfo._pWidth or posXInPanel <= 0 then
        return nil
    end

    local posYInPanel = panelWorldPos.y - y
    if posYInPanel >= BagInfo._scrollHeight or posYInPanel <= 0 then
        return nil
    end

    local indexX = math.ceil(posXInPanel / BagInfo._iHeight)
    local indexY = math.floor(posYInPanel / BagInfo._iHeight)
    local posIndex = indexY * BagInfo._col + indexX
    if posIndex > BagInfo._perPageNum then
        return nil
    end

    return posIndex
end


function Bag.RefreshBagData(data)
    if data then
        Bag.ItemPosChange(data)
    else
        Bag.UpdateItems()
    end
end

-- 背包位置改变
function Bag.ItemPosChange(data)
    if not data or next(data) == nil then
        return
    end
    for _, MakeIndex in pairs(data) do
        -- 清空原位置内容
        local item = GUI:getChildByStrTag(BagInfo._ui.Panel_items, MakeIndex)
        local reddot
        if item then
            reddot = GUI:getChildByName(item, "_RedDot_")
            if reddot then
                GUI:Retain(reddot)
                GUI:removeFromParent(reddot)
            end
            GUI:stopAllActions(item)
            GUI:removeFromParent(item)
        end

        -- 创建现位置内容
        local itemData = BagData.GetItemDataByMakeIndex(MakeIndex)
        if itemData then
            Bag.CreateBagItem(itemData)
            -- 红点
            if reddot then
                local item = GUI:getChildByStrTag(BagInfo._ui.Panel_items, MakeIndex)
                if item then
                    if reddot.sfxID then -- 是特效
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

function Bag.UpdateBagState(data)
    if not data then
        return
    end

    if data.goldState then
        BagInfo._ui.Image_gold._movingState = data.goldState < 1

    elseif data.trading then
        Bag.UpdateMovingData(data.trading)

    elseif data.storage then
        Bag.UpdateMovingData(data.storage)

    elseif data.dropping then -- 丢弃失败
        Bag.UpdateMovingData(data.dropping)
    end
end

function Bag.UpdateMovingData(data)
    if not data or not next(data) then
        return
    end

    local movingNode = GUI:getChildByStrTag(BagInfo._ui.Panel_items, data.MakeIndex)
    if movingNode then
        GUI:setVisible(movingNode, data.state and data.state > 0)
        movingNode._movingState = not (data.state and data.state > 0)
    end
end

function Bag.UpdateItemPowerCheckState(data)
    local function CheckPow()
        local chs = GUI:getChildren(BagInfo._ui.Panel_items)
        for _, goodItem in ipairs(chs) do
            if goodItem then
                GUI:ItemShow_setItemPowerTag(goodItem)
            end
        end
    end

    if data and data.bagDelayUpdate then
        if not BagInfo._powerScheduleTime or BagInfo._powerScheduleTime == 0 then
            BagInfo._powerScheduleTime = 3
            SL:scheduleOnce(Bag._layer, function()
                CheckPow()
                BagInfo._powerScheduleTime = 0
            end, BagInfo._powerScheduleTime)
        end
    else
        CheckPow()
    end
end

-- 更新背包回收勾选
function Bag.UpdateEquipRetrieveState(retrive_data)
    BagInfo._is_retrieve_finsh = false

    if not BagInfo._is_load_finish then
        return
    end

    local curPage = BagData.GetCurPage()
    local startPos = BagInfo._perPageNum * (curPage - 1) + 1
    local endPos = startPos + (BagInfo._perPageNum - 1)
    local bagData = BagData.GetBagDataByBagPos(startPos, endPos)

    local retrieveList = SL:GetValue("RETRIEVE_LIST")

    for _, data in pairs(bagData) do
        local showTag = false
        if retrieveList[data.MakeIndex] then
            showTag = true
            BagInfo._chooseTagList[data.MakeIndex] = true
        else
            BagInfo._chooseTagList[data.MakeIndex] = nil
        end
        local goodsItem = GUI:getChildByStrTag(BagInfo._ui.Panel_items, data.MakeIndex)
        if goodsItem then
            GUI:ItemShow_setItemShowChooseState(goodsItem, showTag)
        end
    end

    BagInfo._is_retrieve_finsh = true
end

-- 显示准星
function Bag.OnBatItemCollimator(MakeIndex)
    if MakeIndex then
        local gooditem = GUI:getChildByStrTag(BagInfo._ui.Panel_items, MakeIndex)
        if gooditem then
            SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_SHOW, {pos = GUI:getWorldPosition(gooditem)})
        end
    end
end

-- 主动勾选背包物品 传唯一ID 当前页
function Bag.UpdateBagItemChooseState(dataList)
    dataList = dataList or {}

    local curPage = BagData.GetCurPage()
    local startPos = BagInfo._perPageNum * (curPage - 1) + 1
    local endPos = startPos + (BagInfo._perPageNum - 1)

    local retrieveList = {}
    for _, makeIndex in ipairs(dataList) do
        retrieveList[makeIndex] = makeIndex
    end

    local bagData = BagData.GetBagDataByBagPos(startPos, endPos)
    for _, data in pairs(bagData) do
        local showTag = false
        if retrieveList and retrieveList[data.MakeIndex] then
            showTag = true
            BagInfo._chooseTagList[data.MakeIndex] = true
        else
            BagInfo._chooseTagList[data.MakeIndex] = nil
        end

        local goodsItem = GUI:getChildByStrTag(BagInfo._ui.Panel_items, data.MakeIndex)
        if goodsItem then
            GUI:ItemShow_setItemShowChooseState(goodsItem, showTag)
        end
    end
end

function Bag.BeginMove(data)
    local MakeIndex = data.MakeIndex
    local pos = data.pos
    if not MakeIndex then
        return
    end

    local isOnSelling = BagData.GetOnSellOrRepaire() == MakeIndex
    local goodsItem = GUI:getChildByStrTag(BagInfo._ui.Panel_items, MakeIndex)
    if goodsItem and not GUI:Widget_IsNull(goodsItem) and not isOnSelling then
        GUI:ItemShow_showIteminfo(goodsItem, nil, pos)
    end
end

--------------------------- 注册事件 -----------------------------
function Bag.RegisterEvent()
    local layer = Bag._layer
    SL:RegisterLUAEvent(LUA_EVENT_MONEY_CHANGE, "Bag", Bag.OnUpdateGold, layer)
    SL:RegisterLUAEvent(LUA_EVENT_BAGLAYER_POS_CHANGE, "Bag", Bag.OnPositionChange, layer)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "Bag", Bag.ItemDataChange, layer) --背包操作
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, "Bag", Bag.RefreshBagData, layer) --位置改变
    SL:RegisterLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, "Bag", Bag.UpdateBagState, layer) --状态改变
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_LIST_REFRESH, "Bag", Bag.UpdateItems, layer) --背包刷新
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "Bag", Bag.UpdateItemPowerCheckState, layer) --检测提升提示
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_RETRIEVE_STATE_CHANGE, "Bag", Bag.UpdateEquipRetrieveState, layer) --更新背包回收勾选
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_COLLIMATOR, "Bag", Bag.OnBatItemCollimator, layer) --显示准星
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHOOSE_STATE, "Bag", Bag.UpdateBagItemChooseState, layer) --勾选背包物品
    SL:RegisterLUAEvent(LUA_EVENT_ITEM_MOVE_BEGIN_BAG_POS_CHANGE, "Bag", Bag.BeginMove, layer) --道具换位后开始拖动
    SL:RegisterLUAEvent(LUA_EVENT_STALL_SELF_ITEM_CHANGE, "Bag", Bag.OnRemoveBaiTanTag, layer) --摆摊自己的物品改变
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Bag", Bag.OnCloseLayer) --关闭界面
end
-------------------------------------------------------------------

-- 关闭监听
function Bag.OnCloseLayer(id)
    if UIConst.LAYERID.BagLayerGUI == id and BagInfo then 
        if BagData.GetBagCollimator() then
            BagData.ClearBagCollimator()
            SL:RequestCancelCollimator()
        end

        Bag.RemoveSui()
        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Bag")
        SL:onLUAEvent(LUA_EVENT_GUIDE_EVENT_ENDED, { name = GUIDefine.GuideEvent[GUIDefine.GuideType.BAG].close, bag_page = BagInfo._selPage or 1 })
        SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
        BagInfo = nil
    end
end

Bag.main()