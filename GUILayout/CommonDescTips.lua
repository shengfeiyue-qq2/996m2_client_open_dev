CommonDescTips = {}

function CommonDescTips.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_desc_tips")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    CommonDescTips._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonDescTips._ui.Panel_1, screenW, screenH)

    GUI:setTouchEnabled(CommonDescTips._ui.Panel_1, true)
    GUI:setSwallowTouches(CommonDescTips._ui.Panel_1, false)
    GUI:addOnClickEvent(CommonDescTips._ui.Panel_1, function()
        SL:CloseCommonDescTipsPop()
    end)

    GUI:addOnClickEvent(CommonDescTips._ui.Panel_2, function()
        SL:CloseCommonDescTipsPop()
    end)

    CommonDescTips._data = data
    CommonDescTips.InitUI()
end

function CommonDescTips.InitUI()
    if not CommonDescTips._data then
        return
    end

    GUI:removeAllChildren(CommonDescTips._ui.Panel_2)

    local width = CommonDescTips._data.width or 1136

    if CommonDescTips._data.str then
        local richText = GUI:RichTextFCOLOR_Create(CommonDescTips._ui.Panel_2, "rich_desc", 0, 0, CommonDescTips._data.str, width, SL:GetMetaValue("GAME_DATA","DEFAULT_FONT_SIZE"), "#FFFFFF")
        
        local contentSize = GUI:getContentSize(richText)
        local wid = contentSize.width + 10
        local hei = contentSize.height + 10
        GUI:setContentSize(CommonDescTips._ui.Panel_2, wid, hei)
        GUI:setAnchorPoint(richText, 0.5, 0.5)
        GUI:setPosition(richText, wid / 2, hei / 2)

        local screenW = SL:GetMetaValue("SCREEN_WIDTH")
        local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
        local worldPosition = CommonDescTips._data.worldPos or {x = screenW / 2, y = screenH / 2}
        if CommonDescTips._data.isSUI then
            worldPosition.y = worldPosition.y + hei / 2
        end
        GUI:setPosition(CommonDescTips._ui.Panel_2, worldPosition.x, worldPosition.y)
       
        local anchorPoint = CommonDescTips._data.anchorPoint or {x = 0, y = 1}
        GUI:setAnchorPoint(CommonDescTips._ui.Panel_2, anchorPoint.x, anchorPoint.y)

        local anchorPointF, pos = CommonDescTips.GetTipsAnchorPoint(CommonDescTips._ui.Panel_2, worldPosition, anchorPoint)
        GUI:setAnchorPoint(CommonDescTips._ui.Panel_2, anchorPointF.x, anchorPointF.y)
        GUI:setPosition(CommonDescTips._ui.Panel_2, pos.x, pos.y)
    end
end

function CommonDescTips.GetTipsAnchorPoint(widget, pos, ancPoint)
    ancPoint = ancPoint or GUI:getAnchorPoint(widget)
    local size = GUI:getContentSize(widget)
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local outScreenX = false
    local outScreenY = false
    if pos.y + size.height * ancPoint.y > screenH then
        ancPoint.y = 1
        outScreenY = true
    end
    if pos.y - size.height * ancPoint.y < 0 then
        if outScreenY then
            ancPoint.y = 0.5
            pos.y = screenH / 2
        else
            ancPoint.y = 0
        end
    end
    
    if pos.x + size.width * (1 - ancPoint.x) > screenW then
        ancPoint.x = 1
        outScreenX = true
    end
    if pos.x - size.width * ancPoint.x < 0 then
        if outScreenX then
            ancPoint.x = 0.5
            pos.x = screenW / 2
        else
            ancPoint.x = 0
        end
    end
    return ancPoint, pos
end