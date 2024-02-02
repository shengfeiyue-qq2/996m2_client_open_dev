ItemSplitPop = {}

function ItemSplitPop.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "item/item_split")

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    ItemSplitPop._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(ItemSplitPop._ui.Panel_touch, screenW, screenH)
    GUI:setPosition(ItemSplitPop._ui.Panel_1, screenW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    ItemSplitPop._itemData  = data.itemData
    ItemSplitPop._closeCB   = data.closeCB
    ItemSplitPop._count     = 1

    ItemSplitPop.InitUI()

end

function ItemSplitPop.InitUI()
    -- 全屏关闭
    GUI:addOnClickEvent(ItemSplitPop._ui.Panel_touch, function()
        SL:CloseItemSplitPop()
    end)

    local itemData = ItemSplitPop._itemData
    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255
    GUI:Text_setString(ItemSplitPop._ui.Text_name, itemData.Name)
    GUI:Text_setTextColor(ItemSplitPop._ui.Text_name, SL:GetHexColorByStyleId(color))

    local item = GUI:ItemShow_Create(ItemSplitPop._ui.Node_goods, "item", 0, 0, {index = itemData.Index, bgVisible = true})
    GUI:setAnchorPoint(item, 0.5, 0.5)

    local maxCount = itemData.OverLap - 1
    -- 输入数量
    ItemSplitPop._inputText = ItemSplitPop._ui.Text_input
    GUI:TextInput_setInputMode(ItemSplitPop._inputText, 2)
    GUI:TextInput_addOnEvent(ItemSplitPop._inputText, function(_, eventType)
        if eventType == 2 then
            local count = tonumber(GUI:TextInput_getString(ItemSplitPop._inputText)) or 1
            ItemSplitPop._count = math.min(count, maxCount)
            ItemSplitPop._count = math.max(ItemSplitPop._count, 1)
            ItemSplitPop.RefreshCount()
        end
    end)

    GUI:addOnClickEvent(ItemSplitPop._ui.Button_add, function()
        if ItemSplitPop._count < maxCount then
            ItemSplitPop._count = ItemSplitPop._count + 1
            ItemSplitPop.RefreshCount()
        end
    end)

    GUI:addOnClickEvent(ItemSplitPop._ui.Button_reduce, function()
        if ItemSplitPop._count > 1 then
            ItemSplitPop._count = ItemSplitPop._count - 1
            ItemSplitPop.RefreshCount()
        end
    end)

    -- 确认拆分
    GUI:addOnClickEvent(ItemSplitPop._ui.Button_ok, function()
        if not SL:GetMetaValue("BAG_IS_FULL", true) then 
            SL:RequestSplitItem(itemData, ItemSplitPop._count)

            if ItemSplitPop._count == maxCount and ItemSplitPop._closeCB then
                ItemSplitPop._closeCB()
            end

            SL:CloseItemSplitPop()
        end
    end)
    
    ItemSplitPop.RefreshCount()

end

function ItemSplitPop.RefreshCount()
    GUI:TextInput_setString(ItemSplitPop._inputText, ItemSplitPop._count)
end