CommonBubbleInfo = {}

function CommonBubbleInfo.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_bubble_info")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    CommonBubbleInfo._data = data or {}
    CommonBubbleInfo._ui = GUI:ui_delegate(parent)
    CommonBubbleInfo._list = CommonBubbleInfo._ui.ListView
    GUI:setContentSize(CommonBubbleInfo._ui.Panel_1, screenW, screenH)

    CommonBubbleInfo.InitUI()
end

function CommonBubbleInfo.InitUI(data)
    local data = data or CommonBubbleInfo._data
    GUI:ListView_removeAllItems(CommonBubbleInfo._list)
    GUI:addOnClickEvent(CommonBubbleInfo._ui.Panel_1, function()
       SL:CloseCommonBubbleInfo() 
    end)

    if data.pos then
        GUI:setPosition(CommonBubbleInfo._list, data.pos.x, data.pos.y)
    end
    
    CommonBubbleInfo.RefreshList(data.list)
end

function CommonBubbleInfo.RefreshList(list)
    local index = 0
    for i, info in ipairs(list) do
        index = index + 1
        local cell = CommonBubbleInfo.CreateListCell(index)
        GUI:ListView_pushBackCustomItem(CommonBubbleInfo._list, cell)

        local ui = GUI:ui_delegate(cell)
        GUI:Text_setString(ui.Text_info, info.str or "")
        GUI:addOnClickEvent(ui.Button_agree, function()
            if info.agreeCall then
                info.agreeCall()
            end
            SL:CloseCommonBubbleInfo()
        end)

        GUI:addOnClickEvent(ui.Button_disAgree, function()
            if info.disAgreeCall then
                info.disAgreeCall()
            end
            local id = GUI:ListView_getItemIndex(CommonBubbleInfo._list, cell)
            GUI:ListView_removeItemByIndex(CommonBubbleInfo._list, id)
            CommonBubbleInfo.RefreshSize()
        end)
    end

    CommonBubbleInfo.RefreshSize()
end

function CommonBubbleInfo.CreateListCell(index)
    local widget = GUI:Widget_Create(-1, "Widget_" .. index, 0, 0, 0, 0)
    GUI:LoadExport(widget, "common_tips/common_bubble_info_cell")

    local cell = GUI:getChildByName(widget, "Panel_cell")
    local line = GUI:getChildByName(cell, "Image_line")
    GUI:setVisible(line, index ~= 1)

    if not CommonBubbleInfo._cellSize then
        CommonBubbleInfo._cellSize = GUI:getContentSize(cell)
    end
    
    GUI:removeFromParent(cell)
    return cell
end

function CommonBubbleInfo.RefreshSize()
    local cellW = CommonBubbleInfo._cellSize and CommonBubbleInfo._cellSize.width or 0
    local cellH = CommonBubbleInfo._cellSize and CommonBubbleInfo._cellSize.height or 0
    local count = GUI:ListView_getItemCount(CommonBubbleInfo._list)
    local margin = GUI:ListView_getItemsMargin(CommonBubbleInfo._list)
    local sizeH = cellH * count + margin * (count - 1)
    GUI:setContentSize(CommonBubbleInfo._list, cellW, sizeH)
end