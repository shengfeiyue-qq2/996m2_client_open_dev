PurchaseMain = {}

function PurchaseMain.main()
    PurchaseMain._items = {
        {
            title = "世界求购",
            open  = function(parent) SL:OpenPurchaseWorldUI(parent) end,
            close = function() SL:ClosePurchaseWorldUI() end,
        },
        {
            title = "我的求购",
            open  = function(parent) SL:OpenPurchaseMyUI(parent) end,
            close = function() SL:ClosePurchaseMyUI() end,
        },
    }
    
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "purchase_win32/purchase_main" or "purchase/purchase_main")

    PurchaseMain._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local FrameLayout = PurchaseMain._ui["FrameLayout"]
    GUI:setPosition(FrameLayout, screenW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    local CloseLayout = PurchaseMain._ui["CloseLayout"]
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
            SL:ClosePurchaseUI()
        end)
    end
    
    PurchaseMain._group = nil
    PurchaseMain._groupCells = {}

    -- 关闭按钮
    GUI:addOnClickEvent(PurchaseMain._ui["CloseButton"], function()
        SL:ClosePurchaseUI()
    end)

    PurchaseMain.InitGroupCells()
    PurchaseMain.OnSelectGroup(1)
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
    local cellPath = SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_main_group_cell" or "purchase/purchase_main_group_cell"
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
    item.open(PurchaseMain._ui["AttachLayout"])

    PurchaseMain.UpdateSearchPanel()
end

function PurchaseMain.OnClose()
    if PurchaseMain._group then
        local item = PurchaseMain._items[PurchaseMain._group]
        item.close()
    end
end

function PurchaseMain.UpdateSearchPanel()
    if PurchaseMain._group and PurchaseMain._group == 1 then
        GUI:setVisible(PurchaseMain._ui["Panel_search"], true)
    else
        GUI:setVisible(PurchaseMain._ui["Panel_search"], false)
    end
end