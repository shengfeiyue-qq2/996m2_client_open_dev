AuctionMain = {}

function AuctionMain.main()
    AuctionMain._items = {
        {
            title = "世界拍卖",
            open  = function(parent) SL:OpenAuctionWorldUI(parent, 0) end,
            close = function() SL:CloseAuctionWorldUI() end,
        },
        {
            title = "行会拍卖",
            open  = function(parent) SL:OpenAuctionWorldUI(parent, 1) end,
            close = function() SL:CloseAuctionWorldUI() end,
        },
        {
            title = "我的竞拍",
            open  = function(parent) SL:OpenAuctionBiddingUI(parent) end,
            close = function() SL:CloseAuctionBiddingUI() end,
        },
        {
            title = "我的上架",
            open  = function(parent) SL:OpenAuctionPutListUI(parent) end,
            close = function() SL:CloseAuctionPutListUI() end,
        },
    }
    
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "auction_win32/auction_main" or "auction/auction_main")

    AuctionMain._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local FrameLayout = AuctionMain._ui["FrameLayout"]
    GUI:setPosition(FrameLayout, screenW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    local CloseLayout = AuctionMain._ui["CloseLayout"]
    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        
        -- 点击浮起
        GUI:Win_SetZPanel(parent, FrameLayout)
        
        -- 可拖拽
        GUI:Win_SetDrag(parent, FrameLayout)
    else
        -- 空白区关闭
        GUI:setVisible(CloseLayout, true)
        GUI:setContentSize(CloseLayout, screenW, screenH)
        GUI:addOnClickEvent(CloseLayout, function()
            SL:CloseAuctionUI()
        end)
    end
    
    AuctionMain._group = nil
    AuctionMain._groupCells = {}

    -- 关闭按钮
    GUI:addOnClickEvent(AuctionMain._ui["CloseButton"], function()
        SL:CloseAuctionUI()
    end)

    -- 隐藏行会拍卖
    local isHideAuctionGuild = SL:GetMetaValue("GAME_DATA", "isHideAuctionGuild")
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

    AuctionMain.OnSelectGroup(1)
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
    GUI:setVisible(groupCell["Node_redtips"], SL:GetMetaValue("AUCTION_HAVE_MY_BIDDING"))
end

function AuctionMain.CreateGroupCell(data, k)
    local root = GUI:Node_Create(AuctionMain._ui["nativeUI"], "node", 0, 0)
    local cellPath = SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_main_group_cell" or "auction/auction_main_group_cell"
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
    item.open(AuctionMain._ui["AttachLayout"])

    AuctionMain.UpdateSearchPanel()
end

function AuctionMain.OnClose()
    if AuctionMain._group then
        local item = AuctionMain._items[AuctionMain._group]
        item.close()
    end
end

function AuctionMain.UpdateSearchPanel()
    if AuctionMain._group and AuctionMain._group == 1 then
        GUI:setVisible(AuctionMain._ui["Panel_search"], true)
    else
        GUI:setVisible(AuctionMain._ui["Panel_search"], false)
    end
end