CommonDescTips = {}

function CommonDescTips.main()
    local data = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.CommonDescTipsGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "common_tips/common_desc_tips")

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    CommonDescTips._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonDescTips._ui.Panel_1, screenW, screenH)
    GUI:setTouchEnabled(CommonDescTips._ui.Panel_1, true)
    if data.swallowType and data.swallowType == 1 then 
        GUI:setSwallowTouches(CommonDescTips._ui.Panel_1, false)
    end 
    
    GUI:addOnClickEvent(CommonDescTips._ui.Panel_1, function()
        UIOperator:CloseCommonDescTipsUI()
    end)

    GUI:addOnClickEvent(CommonDescTips._ui.Panel_2, function()
        UIOperator:CloseCommonDescTipsUI()
    end)

    CommonDescTips.RegisterEvent()

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
        local richText = nil
        if CommonDescTips._data.formatWay == 1 then
            richText = GUI:RichText_Create(CommonDescTips._ui.Panel_2, "rich_desc", 0, 0, CommonDescTips._data.str, width, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE"), "#FFFFFF")
        else
            richText = GUI:RichTextFCOLOR_Create(CommonDescTips._ui.Panel_2, "rich_desc", 0, 0, CommonDescTips._data.str, width, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE"), "#FFFFFF")
        end

        local contentSize = GUI:getContentSize(richText)
        local wid = contentSize.width + 10
        local hei = contentSize.height + 10
        GUI:setContentSize(CommonDescTips._ui.Panel_2, wid, hei)
        GUI:setAnchorPoint(richText, 0.5, 0.5)
        GUI:setPosition(richText, wid / 2, hei / 2)

        local screenW = SL:GetValue("SCREEN_WIDTH")
        local screenH = SL:GetValue("SCREEN_HEIGHT")
        local worldPosition = CommonDescTips._data.worldPos or {x = screenW / 2, y = screenH / 2}
        if CommonDescTips._data.isSUI then
            worldPosition.y = worldPosition.y + hei / 2
        end
        GUI:setPosition(CommonDescTips._ui.Panel_2, worldPosition.x, worldPosition.y)
       
        local anchorPoint = CommonDescTips._data.anchorPoint or {x = 0, y = 1}
        GUI:setAnchorPoint(CommonDescTips._ui.Panel_2, anchorPoint.x, anchorPoint.y)

        if CommonDescTips._data.btnShow then
            local param = CommonDescTips._data.btnShow
            local button = GUI:Button_Create(CommonDescTips._ui.Panel_2, "BTN_", 0, 0, param.btnRes)
            GUI:Button_setTitleText(button, param.btnName or "")
            GUI:Button_setTitleFontSize(button, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE"))
            GUI:Button_setTitleColor(button, "#FFFFFF")
            GUI:Button_titleEnableOutline(button, "#111111", 1)
            GUI:setAnchorPoint(button, 1, 1)
            GUI:addOnClickEvent(button, function() 
                if param.clickFunc then
                    param.clickFunc()
                end
                UIOperator:CloseCommonDescTipsUI()
            end)
            local btnSize = GUI:getContentSize(button)
            wid = wid + btnSize.width
            GUI:setContentSize(CommonDescTips._ui.Panel_2, wid, hei)
            GUI:setAnchorPoint(richText, 0, 0.5)
            GUI:setPosition(richText, 5, hei / 2)
            GUI:setPosition(button, wid - 5, hei - 5)
        end

        local anchorPointF, pos = CommonDescTips.GetTipsAnchorPoint(CommonDescTips._ui.Panel_2, worldPosition, anchorPoint)
        GUI:setAnchorPoint(CommonDescTips._ui.Panel_2, anchorPointF.x, anchorPointF.y)
        GUI:setPosition(CommonDescTips._ui.Panel_2, pos.x, pos.y)
    end
end

function CommonDescTips.GetTipsAnchorPoint(widget, pos, ancPoint)
    ancPoint = ancPoint or GUI:getAnchorPoint(widget)
    local size = GUI:getContentSize(widget)
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
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

function CommonDescTips.OnCloseLayer()
    UIOperator:CloseNpcStoreUI()
end

function CommonDescTips.OnClose(UID)
    if UID ~= UIConst.LAYERID.CommonDescTipsGUI then
        return false
    end
    
    CommonDescTips.UnRegisterEvent()
end

function CommonDescTips.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "CommonDescTips", CommonDescTips.OnClose)                                 -- 关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_USERINPUT_EVENT_NOTICE, "CommonDescTips", CommonDescTips.OnCloseLayer)
end

function CommonDescTips.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "CommonDescTips")
    SL:UnRegisterLUAEvent(LUA_EVENT_USERINPUT_EVENT_NOTICE, "CommonDescTips")
end

CommonDescTips.main()