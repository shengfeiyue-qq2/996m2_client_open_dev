AutoUsePop = {}
AutoUsePop._remainTimeStr = "(%s)" -- 剩余时间展示格式

function AutoUsePop.main(data)
    local parent = GUI:Attach_Parent()
    local id = data and data.id or 0
    local node = GUI:Node_Create(parent, "Node_" .. id, 0, 0)
    GUI:LoadExport(node, "auto_use_pop")
    GUI:setTag(node, id)
    
    AutoUsePop._data = data
    AutoUsePop._Node = node
    AutoUsePop._ui = GUI:ui_delegate(node)
    -- 显示适配
    local posY     = 140
    local baseOffX = 350
    local screenH  = SL:GetMetaValue("SCREEN_HEIGHT")
    local PPopUI   = AutoUsePop._ui["PPopUI"]
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:setMouseEnabled(PPopUI, true)
        baseOffX = 220
        posY = screenH - 330 - GUI:getContentSize(PPopUI).height
    end

    local notch, rect = SL:GetMetaValue("NOTCH_PHONE_INFO")
    if notch then
        baseOffX = baseOffX + rect.x
    end

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(AutoUsePop._Node, screenW - baseOffX, posY)
    GUI:setVisible(PPopUI, true)

    AutoUsePop.InitUI()
end

function AutoUsePop.InitUI()
    if not AutoUsePop._data then
        return
    end

    local id        = AutoUsePop._data.id
    local item      = AutoUsePop._data.item
    local isHero    = AutoUsePop._data.isHero
    local isBook    = AutoUsePop._data.skillBook
    -- 英雄
    if isHero then
        GUI:Text_setString(AutoUsePop._ui.TextTitle, "快捷使用(英雄)")
    end

    GUI:Text_setString(AutoUsePop._ui.TextName, item.Name)
    if SL:GetMetaValue("GAME_DATA", "AutoUseScrollWidth") then
        local scrollWidth = tonumber(SL:GetMetaValue("GAME_DATA", "AutoUseScrollWidth")) or 140
        GUI:removeAllChildren(AutoUsePop._ui.TextName)
        GUI:Text_setString(AutoUsePop._ui.TextName, "")
        local label = GUI:ScrollText_Create(AutoUsePop._ui.TextName, "scrollText", 0, 0, scrollWidth, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", item.Name)
        GUI:setAnchorPoint(label, 0.5, 0.5)
    end

    -- 技能书
    if isBook then
        GUI:Button_setTitleText(AutoUsePop._ui.BtnUse, "使用")
    end

    -- 道具图标
    GUI:removeAllChildren(AutoUsePop._ui.ItemNode)
    local item = GUI:ItemShow_Create(AutoUsePop._ui.ItemNode, "ItemShow", 0, 0, {
        look = true,
        index = item.Index,
        itemData = item
    })
    GUI:setAnchorPoint(item, 0.5, 0.5)

end
