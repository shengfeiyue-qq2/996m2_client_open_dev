PurchaseMain = {}

function PurchaseMain.main()
    PurchaseMain._items = {
        {
            title = "世界求购",
            open  = function() PurchaseMain.OnOpenPage(UIConst.LUAFile.LUA_FILE_PURCHASE_WORLD) end,
            close = function() PurchaseWorld.OnClose() end,
        },
        {
            title = "我的求购",
            open  = function() PurchaseMain.OnOpenPage(UIConst.LUAFile.LUA_FILE_PURCHASE_MY) end,
            close = function() PurchaseMy.OnClose() end,
        },
    }
    
    PurchaseMain._layer = GUI:Win_Create(UIConst.LAYERID.PurchaseMainGUI, 0, 0, 0, 0, false, false, true, true)
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    GUI:LoadExport(PurchaseMain._layer, isWinMode and "purchase_win32/purchase_main" or "purchase/purchase_main")

    PurchaseMain._ui = GUI:ui_delegate(PurchaseMain._layer)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local FrameLayout = PurchaseMain._ui["FrameLayout"]
    GUI:setPosition(FrameLayout, screenW / 2, isWinMode and SL:GetValue("PC_POS_Y") or screenH / 2)

    local CloseLayout = PurchaseMain._ui["CloseLayout"]
    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        
        -- 点击浮起
        GUI:Win_SetZPanel(PurchaseMain._layer, FrameLayout)
        
        -- 可拖拽
        GUI:Win_SetDrag(PurchaseMain._layer, FrameLayout)
    else
        -- 空白区关闭
        GUI:setVisible(CloseLayout, true)
        GUI:setContentSize(CloseLayout, screenW, screenH)
        GUI:addOnClickEvent(CloseLayout, function()
            UIOperator:ClosePurchaseUI()
        end)
    end
    
    PurchaseMain._group = nil
    PurchaseMain._groupCells = {}
    PurchaseMain._itemConfig = SL:GetValue("STD_ITEMS")

    -- 关闭按钮
    GUI:addOnClickEvent(PurchaseMain._ui["CloseButton"], function()
        UIOperator:ClosePurchaseUI()
    end)

    PurchaseMain.InitGroupCells()
    PurchaseMain.OnSelectGroup(1)
    PurchaseMain.InitSearchPanel()

    PurchaseMain.RegisterEvent()
end

function PurchaseMain.InitGroupCells()
    local ListView_group = PurchaseMain._ui["ListView_group"]
    GUI:ListView_removeAllItems(ListView_group)
    PurchaseMain._groupCells = {}
    for k, v in ipairs(PurchaseMain._items) do
        local cell = PurchaseMain.CreateGroupCell(v, k)
        PurchaseMain._groupCells[k] = cell
        GUI:ListView_pushBackCustomItem(ListView_group, cell.nativeUI)
    end
end

function PurchaseMain.CreateGroupCell(data, k)
    local root = GUI:Node_Create(-1, "node", 0, 0)
    local cellPath = SL:GetValue("IS_PC_OPER_MODE") and "purchase_win32/purchase_main_group_cell" or "purchase/purchase_main_group_cell"
    GUI:LoadExport(root, cellPath)
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    local Button_group = ui["Button_group"]
    GUI:Button_setTitleText(Button_group, data.title)
    GUI:addOnClickEvent(Button_group, function()
        PurchaseMain.OnSelectGroup(k)
    end)

    return ui
end

function PurchaseMain.OnSelectGroup(g)
    if PurchaseMain._group == g then
        return nil
    end

    -- reset current
    if PurchaseMain._group then
        -- reset current button
        local cell = PurchaseMain._groupCells[PurchaseMain._group]
        GUI:Button_setBright(cell["Button_group"], true)
        GUI:Button_setTitleColor(cell["Button_group"], "#6c6861")

        -- close current panel
        local item = PurchaseMain._items[PurchaseMain._group]
        item.close()
    end

    -- new group
    PurchaseMain._group = g
    local cell = PurchaseMain._groupCells[PurchaseMain._group]
    GUI:Button_setBright(cell["Button_group"], false)
    GUI:Button_setTitleColor(cell["Button_group"], "#f8e6c6")

    local item = PurchaseMain._items[PurchaseMain._group]
    item.open()

    PurchaseMain.UpdateSearchPanel()
end

function PurchaseMain.OnClose(UID)
    if UID ~= UIConst.LAYERID.PurchaseMainGUI then
        return false
    end

    GUI:removeAllChildren(PurchaseMain._ui["AttachLayout"])

    PurchaseMain.UnRegisterEvent()
    PurchaseMain._layer = nil

    if PurchaseMain._group then
        local item = PurchaseMain._items[PurchaseMain._group]
        item.close()
    end
end

-- 打开子页签
function PurchaseMain.OnOpenPage(file, data)

    -- 设置父节点
    GUI:SetLayerOpenParam(PurchaseMain._ui["AttachLayout"])

    -- 移除上个
    GUI:removeAllChildren(PurchaseMain._ui["AttachLayout"])

    -- 加载Layer
    GUI:Win_Open(file)
end

function PurchaseMain.UpdateSearchPanel()
    if PurchaseMain._group and PurchaseMain._group == 1 then
        GUI:setVisible(PurchaseMain._ui["Panel_search"], true)
    else
        GUI:setVisible(PurchaseMain._ui["Panel_search"], false)
    end
end

function PurchaseMain.SearchAllItemsByKeyWord(str)
    if not str or string.len(str) == 0 then
        SL:ShowSystemTips("无法匹配，自动显示全部内容")
        return nil
    end
   
    local matchItems = {}

    local specialR  = {"%[", "%]", "%(","%)","%*"}
    for _, key in ipairs(specialR) do
        str = string.gsub(str, key, "%"..key)
    end
    
    if string.len(str) > 32 then
        SL:ShowSystemTips("无法匹配，自动显示全部内容")
        return nil
    end

    for _, v  in pairs(PurchaseMain._itemConfig) do
        if #matchItems > 36 then
            break
        end
        if string.find(v.Name, str) then
            table.insert(matchItems, v.Index)
        end
    end

    if #matchItems > 35 then
        SL:ShowSystemTips("相似名称过多，请精确搜索内容")
        return nil
    elseif #matchItems == 0 then
        SL:ShowSystemTips("无法匹配，自动显示全部内容")
        return nil
    end

    local matchIndexStr = table.concat(matchItems, ",")
    return matchIndexStr
end

function PurchaseMain.InitSearchPanel()
    local function Confirm_Search( )
        local itemName = GUI:Text_getString(PurchaseMain._ui.SearchInput)
        if string.len(itemName) < 1 then
            SL:ShowSystemTips("输入的内容不能为空")
            SL:onLUAEvent(LUA_EVENT_PURCHASE_SEARCH_ITEM_UPDATE, nil)
            return
        end
        local searchItem = PurchaseMain.SearchAllItemsByKeyWord(itemName)
        SL:onLUAEvent(LUA_EVENT_PURCHASE_SEARCH_ITEM_UPDATE, searchItem)
    end

    GUI:TextInput_addOnEvent(PurchaseMain._ui.SearchInput, function(sender, eventType)
        if eventType == GUIDefine.TextInputEventType.BEGAN then
            GUI:TextInput_setString(AuctionMain._ui.SearchInput, "")
        elseif eventType == GUIDefine.TextInputEventType.CHANGE then
            local str = GUI:TextInput_getString(sender)
            if string.find(str, "\n") then
                GUI:TextInput_closeInput(sender)
                GUI:TextInput_setString(sender, string.trim(str))
                SL:scheduleOnce(PurchaseMain._ui.SearchInput, function() Confirm_Search() end, 0.01)
            end
        end
    end)

    GUI:addOnClickEvent(PurchaseMain._ui.Button_confirm, Confirm_Search)
end

function PurchaseMain.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "PurchaseMain", PurchaseMain.OnClose)
end

function PurchaseMain.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "PurchaseMain")
end

PurchaseMain.main()