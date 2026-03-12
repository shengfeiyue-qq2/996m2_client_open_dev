ExchangeMain = {}

function ExchangeMain.main()
    ExchangeMain._items = {
        {
            title = "世界购买",
            open  = function() ExchangeMain.OnOpenPage(UIConst.LUAFile.LUA_FILE_EXCHANGE_BUY) end,
            close = function() ExchangeBuy.OnClose() end,
        },
        {
            title = "我的上架",
            open  = function() ExchangeMain.OnOpenPage(UIConst.LUAFile.LUA_FILE_EXCHANGE_PUTLIST) end,
            close = function() ExchangePutList.OnClose() end,
        },
        {
            title = "我的记录",
            open  = function() ExchangeMain.OnOpenPage(UIConst.LUAFile.LUA_FILE_EXCHANGE_RECORD) end,
            close = function() ExchangeRecord.OnClose() end,
        },
    }
    
    ExchangeMain._layer = GUI:Win_Create(UIConst.LAYERID.ExchangeMainGUI, 0, 0, 0, 0, false, false, true, true)
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    GUI:LoadExport(ExchangeMain._layer, isWinMode and "exchange_win32/exchange_main" or "exchange/exchange_main")

    ExchangeMain._ui = GUI:ui_delegate(ExchangeMain._layer)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local FrameLayout = ExchangeMain._ui["FrameLayout"]
    GUI:setPosition(FrameLayout, screenW / 2, isWinMode and SL:GetValue("PC_POS_Y") or screenH / 2)

    local CloseLayout = ExchangeMain._ui["CloseLayout"]
    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        
        -- 点击浮起
        GUI:Win_SetZPanel(ExchangeMain._layer, FrameLayout)
        
        -- 可拖拽
        GUI:Win_SetDrag(ExchangeMain._layer, FrameLayout)
    else
        -- 空白区关闭
        GUI:setVisible(CloseLayout, true)
        GUI:setContentSize(CloseLayout, screenW, screenH)
        GUI:addOnClickEvent(CloseLayout, function()
            UIOperator:CloseExchangeUI()
        end)
    end
    
    ExchangeMain._group = nil
    ExchangeMain._groupCells = {}
    ExchangeMain._itemConfig = SL:GetValue("STD_ITEMS")

    -- 关闭按钮
    GUI:addOnClickEvent(ExchangeMain._ui["CloseButton"], function()
        UIOperator:CloseExchangeUI()
    end)

    ExchangeMain.InitGroupCells()
    ExchangeMain.OnSelectGroup(1)
    ExchangeMain.InitSearchPanel()

    ExchangeMain.RegisterEvent()
end

function ExchangeMain.InitGroupCells()
    local ListView_group = ExchangeMain._ui["ListView_group"]
    GUI:ListView_removeAllItems(ListView_group)
    ExchangeMain._groupCells = {}
    for k, v in ipairs(ExchangeMain._items) do
        local cell = ExchangeMain.CreateGroupCell(v, k)
        ExchangeMain._groupCells[k] = cell
        GUI:ListView_pushBackCustomItem(ListView_group, cell.nativeUI)
    end
end

function ExchangeMain.CreateGroupCell(data, k)
    local root = GUI:Node_Create(-1, "node", 0, 0)
    local cellPath = SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_main_group_cell" or "exchange/exchange_main_group_cell"
    GUI:LoadExport(root, cellPath)
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    local Button_group = ui["Button_group"]
    GUI:Button_setTitleText(Button_group, data.title)
    GUI:addOnClickEvent(Button_group, function()
        ExchangeMain.OnSelectGroup(k)
    end)

    return ui
end

function ExchangeMain.OnSelectGroup(g)
    if ExchangeMain._group == g then
        return nil
    end

    -- reset current
    if ExchangeMain._group then
        -- reset current button
        local cell = ExchangeMain._groupCells[ExchangeMain._group]
        GUI:Button_setBright(cell["Button_group"], true)
        GUI:Button_setTitleColor(cell["Button_group"], "#6c6861")

        -- close current panel
        local item = ExchangeMain._items[ExchangeMain._group]
        item.close()
    end

    -- new group
    ExchangeMain._group = g
    local cell = ExchangeMain._groupCells[ExchangeMain._group]
    GUI:Button_setBright(cell["Button_group"], false)
    GUI:Button_setTitleColor(cell["Button_group"], "#f8e6c6")

    local item = ExchangeMain._items[ExchangeMain._group]
    item.open()

    ExchangeMain.UpdateSearchPanel()
end

function ExchangeMain.OnClose(UID)
    if UID ~= UIConst.LAYERID.ExchangeMainGUI then
        return false
    end

    GUI:removeAllChildren(ExchangeMain._ui["AttachLayout"])

    ExchangeMain.UnRegisterEvent()
    ExchangeMain._layer = nil

    if ExchangeMain._group then
        local item = ExchangeMain._items[ExchangeMain._group]
        item.close()
    end
end

-- 打开子页签
function ExchangeMain.OnOpenPage(file, data)

    -- 设置父节点
    GUI:SetLayerOpenParam(ExchangeMain._ui["AttachLayout"])

    -- 移除上个
    GUI:removeAllChildren(ExchangeMain._ui["AttachLayout"])

    -- 加载Layer
    GUI:Win_Open(file)
end

function ExchangeMain.UpdateSearchPanel()
    if ExchangeMain._group and ExchangeMain._group == 1 or ExchangeMain._group == 3 then
        GUI:setVisible(ExchangeMain._ui["Panel_search"], true)
    else
        GUI:setVisible(ExchangeMain._ui["Panel_search"], false)
    end
end

function ExchangeMain.SearchAllItemsByKeyWord(str)
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

    for _, v  in pairs(ExchangeMain._itemConfig) do
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

function ExchangeMain.InitSearchPanel()
    local function Confirm_Search( )
        local itemName = GUI:Text_getString(ExchangeMain._ui.SearchInput)
        if string.len(itemName) < 1 then
            SL:ShowSystemTips("输入的内容不能为空")
            SL:onLUAEvent(LUA_EVENT_EXCHANGE_SEARCH_ITEM_UPDATE, nil)
            return
        end
        local searchItem = ExchangeMain.SearchAllItemsByKeyWord(itemName)
        SL:onLUAEvent(LUA_EVENT_EXCHANGE_SEARCH_ITEM_UPDATE, searchItem)
    end

    GUI:TextInput_addOnEvent(ExchangeMain._ui.SearchInput, function(sender, eventType)
        if eventType == GUIDefine.TextInputEventType.BEGAN then
            GUI:TextInput_setString(ExchangeMain._ui.SearchInput, "")
        elseif eventType == GUIDefine.TextInputEventType.CHANGE then
            local str = GUI:TextInput_getString(sender)
            if string.find(str, "\n") then
                GUI:TextInput_closeInput(sender)
                GUI:TextInput_setString(sender, string.trim(str))
                SL:scheduleOnce(ExchangeMain._ui.SearchInput, function() Confirm_Search() end, 0.01)
            end
        end
    end)

    GUI:addOnClickEvent(ExchangeMain._ui.Button_confirm, Confirm_Search)
end

function ExchangeMain.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ExchangeMain", ExchangeMain.OnClose)
end

function ExchangeMain.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ExchangeMain")
end

ExchangeMain.main()