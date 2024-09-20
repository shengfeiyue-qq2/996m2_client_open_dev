ItemSplitPop = {}

function ItemSplitPop.main()
    ItemSplitPop._data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if not ItemSplitPop._data or not next(ItemSplitPop._data) then
        return
    end

    if GUI:GetWindow(nil, UIConst.LAYERID.CommonTipsSplitGUI) then
        return
    end
    local parent = GUI:Win_Create(UIConst.LAYERID.CommonTipsSplitGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.TOBOX)
    GUI:LoadExport(parent, "item/item_split")

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    ItemSplitPop._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(ItemSplitPop._ui.Panel_touch, screenW, screenH)
    GUI:setPosition(ItemSplitPop._ui.Panel_1, screenW / 2, isWinMode and SL:GetValue("PC_POS_Y") or screenH / 2)

    ItemSplitPop._itemData  = ItemSplitPop._data.itemData
    ItemSplitPop._closeCB   = ItemSplitPop._data.closeCB
    ItemSplitPop._count     = 1

    ItemSplitPop.InitUI()
end

function ItemSplitPop.InitUI()
    -- 全屏关闭
    GUI:addOnClickEvent(ItemSplitPop._ui.Panel_touch, function()
        UIOperator:CloseTipsSplit()
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
    GUI:addOnClickEvent(ItemSplitPop._ui.Button_ok, function(sender)
        GUI:delayTouchEnabled(sender)
        if not BagData.isToBeFull(true) then 
            SL:RequestSplitItem(itemData, ItemSplitPop._count)
            if ItemSplitPop._count == maxCount and ItemSplitPop._closeCB then
                ItemSplitPop._closeCB()
            end
            UIOperator:CloseTipsSplit()
        end
    end)
    
    ItemSplitPop.RefreshCount()

end

function ItemSplitPop.RefreshCount()
    GUI:TextInput_setString(ItemSplitPop._inputText, ItemSplitPop._count)
end

ItemSplitPop.main()