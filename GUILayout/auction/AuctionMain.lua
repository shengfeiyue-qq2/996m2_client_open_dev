AuctionMain = {}

local LuaFile = UIConst.LUAFile

function AuctionMain.main()
    AuctionMain._items = {
        {
            title = "世界拍卖",
            open  = function() AuctionMain.OnOpenPage(LuaFile.LUA_FILE_AUCTION_WORLD, 0) end,
            close = function() AuctionWorld.OnClose() end,
        },
        {
            title = "行会拍卖",
            open  = function() AuctionMain.OnOpenPage(LuaFile.LUA_FILE_AUCTION_WORLD, 1) end,
            close = function() AuctionWorld.OnClose() end,
        },
        {
            title = "我的竞拍",
            open  = function() AuctionMain.OnOpenPage(LuaFile.LUA_FILE_AUCTION_BIDDING) end,
            close = function() AuctionBidding.OnClose() end,
        },
        {
            title = "我的上架",
            open  = function() AuctionMain.OnOpenPage(LuaFile.LUA_FILE_AUCTION_PUT_LIST) end,
            close = function() AuctionPutList.OnClose() end,
        },
    }

    local index = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    
    AuctionMain._layer = GUI:Win_Create(UIConst.LAYERID.AuctionMainGUI, 0, 0, 0, 0, false, false, true, true)
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    GUI:LoadExport(AuctionMain._layer, isWinMode and "auction_win32/auction_main" or "auction/auction_main")

    AuctionMain._ui = GUI:ui_delegate(AuctionMain._layer)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local FrameLayout = AuctionMain._ui["FrameLayout"]
    GUI:setPosition(FrameLayout, screenW / 2, isWinMode and SL:GetValue("PC_POS_Y") or screenH / 2)

    local CloseLayout = AuctionMain._ui["CloseLayout"]
    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        
        -- 点击浮起
        GUI:Win_SetZPanel(AuctionMain._layer, FrameLayout)
        
        -- 可拖拽
        GUI:Win_SetDrag(AuctionMain._layer, FrameLayout)
    else
        -- 空白区关闭
        GUI:setVisible(CloseLayout, true)
        GUI:setContentSize(CloseLayout, screenW, screenH)
        GUI:addOnClickEvent(CloseLayout, function()
            UIOperator:CloseAuctionUI()
        end)
    end
    
    AuctionMain._group = nil
    AuctionMain._groupCells = {}

    -- 关闭按钮
    GUI:addOnClickEvent(AuctionMain._ui["CloseButton"], function()
        UIOperator:CloseAuctionUI()
    end)

    -- 隐藏行会拍卖
    local isHideAuctionGuild = SL:GetValue("GAME_DATA", "isHideAuctionGuild")
    isHideAuctionGuild = (isHideAuctionGuild or 0) == 1
    if isHideAuctionGuild then
        for i = 2, #AuctionMain._items do
            AuctionMain._items[i] = AuctionMain._items[i + 1]
        end
    end

    AuctionMain.InitGroupCells()
    AuctionMain.UpdateGroupCells()

    SL:RequestAuctionPutList(1)
    SL:RequestAuctionPutList(2)

    AuctionMain.OnSelectGroup(math.min(index or 1, #AuctionMain._items))

    AuctionMain.RegisterEvent()

    SL:AttachTXTSUI({
        root  = AuctionMain._ui.AttachLayout,
        index = SLDefine.SUIComponentTable.AuctionMain
    })
end

function AuctionMain.InitGroupCells()
    local ListView_group = AuctionMain._ui["ListView_group"]
    GUI:ListView_removeAllItems(ListView_group)
    AuctionMain._groupCells = {}
    for k, v in ipairs(AuctionMain._items) do
        local cell = AuctionMain.CreateGroupCell(v, k)
        AuctionMain._groupCells[k] = cell
        GUI:ListView_pushBackCustomItem(ListView_group, cell.nativeUI)
    end
end

-- 我的竞拍红点
function AuctionMain.UpdateGroupCells()
    local groupCell = AuctionMain._groupCells[3]
    GUI:setVisible(groupCell["Node_redtips"], SL:GetValue("AUCTION_HAVE_MY_BIDDING"))
end

function AuctionMain.CreateGroupCell(data, k)
    local root = GUI:Node_Create(AuctionMain._ui["nativeUI"], "node", 0, 0)
    local cellPath = SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_main_group_cell" or "auction/auction_main_group_cell"
    GUI:LoadExport(root, cellPath)
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    GUI:removeFromParent(root)

    local ui = GUI:ui_delegate(layout)

    local Button_group = ui["Button_group"]
    GUI:Button_setTitleText(Button_group, data.title)
    GUI:addOnClickEvent(Button_group, function()
        AuctionMain.OnSelectGroup(k)
    end)

    SL:CreateRedPoint(ui["Node_redtips"])
    GUI:setVisible(ui["Node_redtips"], false)

    return ui
end

function AuctionMain.OnSelectGroup(g)
    if AuctionMain._group == g then
        return nil
    end

    -- reset current
    if AuctionMain._group then
        -- reset current button
        local cell = AuctionMain._groupCells[AuctionMain._group]
        GUI:Button_setBright(cell["Button_group"], true)
        GUI:Button_setTitleColor(cell["Button_group"], "#6c6861")

        -- close current panel
        local item = AuctionMain._items[AuctionMain._group]
        item.close()
    end

    -- new group
    AuctionMain._group = g
    local cell = AuctionMain._groupCells[AuctionMain._group]
    GUI:Button_setBright(cell["Button_group"], false)
    GUI:Button_setTitleColor(cell["Button_group"], "#f8e6c6")

    local item = AuctionMain._items[AuctionMain._group]
    item.open()

    AuctionMain.UpdateSearchPanel()
end

-- 打开子页签
function AuctionMain.OnOpenPage(file, data)

    -- 设置父节点
    GUI:SetLayerOpenParam({parent = AuctionMain._ui.AttachLayout, data = data})

    -- 移除上个
    GUI:removeAllChildren(AuctionMain._ui["AttachLayout"])

    -- 加载Layer
    GUI:Win_Open(file)
end

function AuctionMain.OnClose(UID)
    if UID ~= UIConst.LAYERID.AuctionMainGUI then
        return false
    end

    if AuctionMain._group then
        -- close current panel
        local item = AuctionMain._items[AuctionMain._group]
        item.close()
    end
    
    GUI:removeAllChildren(AuctionMain._ui["AttachLayout"])
    
    AuctionMain.UnRegisterEvent()
    AuctionMain._layer = nil

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.AuctionMain
    })
end

function AuctionMain.InitSearchPanel()
    local function Confirm_Search( )
        local itemName = GUI:Text_getString(AuctionMain._ui.SearchInput)
        if string.len(itemName) < 1 then
            return ShowSystemTips("输入的内容不能为空")
        end
        SL:onLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_SEARCH, itemName)
    end

    GUI:TextInput_addOnEvent(AuctionMain._ui.SearchInput, function(sender, eventType)
        if eventType == GUIDefine.TextInputEventType.BEGAN then
            GUI:TextInput_setString(AuctionMain._ui.SearchInput, "")
        elseif eventType == GUIDefine.TextInputEventType.CHANGE then
            local str = GUI:TextInput_getString(sender)
            if sender.closeKeyboard and string.find(str, "\n") then
                GUI:TextInput_closeInput(sender)
                GUI:TextInput_setString(sender, string.trim(str))
                SL:scheduleOnce(AuctionMain._ui.SearchInput, function() Confirm_Search() end, 0.01)
            end
        end
    end)

    GUI:addOnClickEvent(AuctionMain._ui.Button_confirm, Confirm_Search)
end

function AuctionMain.UpdateSearchPanel()
    if AuctionMain._group and AuctionMain._group == 1 then
        GUI:setVisible(AuctionMain._ui["Panel_search"], true)
    else
        GUI:setVisible(AuctionMain._ui["Panel_search"], false)
    end
end

function AuctionMain.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionMain", AuctionMain.OnClose)                                 -- 关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_PUT_IN, "AuctionMain", AuctionMain.UpdateGroupCells)                  -- 更新红点
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_ITEM_UPDATE, "AuctionMain", AuctionMain.UpdateGroupCells)             -- 更新红点
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_PUT_OUT, "AuctionMain", AuctionMain.UpdateGroupCells)                 -- 更新红点
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_PUT_LIST, "AuctionMain", AuctionMain.UpdateGroupCells)                -- 更新红点
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_BIDDING_LIST, "AuctionMain", AuctionMain.UpdateGroupCells)            -- 更新红点
end

function AuctionMain.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_PUT_IN, "AuctionMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_ITEM_UPDATE, "AuctionMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_PUT_OUT, "AuctionMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_PUT_LIST, "AuctionMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_BIDDING_LIST, "AuctionMain")
end

AuctionMain.main()