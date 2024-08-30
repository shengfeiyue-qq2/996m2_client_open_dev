GuildWarAlly = {}

function GuildWarAlly.main()
    GuildWarAlly._data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    if GUI:GetWindow(nil, UIConst.LAYERID.GuildWarAllyGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.GuildWarAllyGUI, 0, 0, 0, 0, false, false, true, true)
    GuildWarAlly._layer = parent

    GuildWarAlly._type = GuildWarAlly._data.type -- 1:宣战 2:结盟
    GuildWarAlly._costCfg = {}
    GuildWarAlly._timeCfg = {}
    GuildWarAlly._config = {}
    GuildWarAlly._select = 1
    GuildWarAlly._maxShowNum = 5

    GUI:LoadExport(parent, "guild/guild_war_sponsor")
    GuildWarAlly._ui = GUI:ui_delegate(parent)

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    local mainPanel = GuildWarAlly._ui["PMainUI"]
    local closeLayout = GuildWarAlly._ui["CloseLayout"]
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(closeLayout, winSizeW, winSizeH)
    GUI:setPosition(mainPanel, winSizeW / 2, winSizeH / 2)

    if isWinMode then
        GUI:setVisible(closeLayout, false)
        GUI:setPosition(mainPanel, winSizeW / 2, SL:GetValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, mainPanel)
        GUI:Win_SetZPanel(parent, mainPanel)
    else
        -- 全屏关闭
        GUI:setVisible(closeLayout, true)
        GUI:addOnClickEvent(closeLayout, function()
            UIOperator:CloseGuildWarAllyUI()
        end)
    end
    
    GuildWarAlly.InitData()
    GuildWarAlly.InitUI()
end

function GuildWarAlly.InitData()
    local tempList = {}
    if GuildWarAlly._type == 1 then
        tempList = string.split(SL:GetValue("GAME_DATA", "GuildWar") or "", "&")
    elseif GuildWarAlly._type == 2 then
        tempList = string.split(SL:GetValue("GAME_DATA", "GuildAlli") or "", "&")
    end
    for i, v in ipairs(tempList) do
        if i > GuildWarAlly._maxShowNum then
            break
        end
        if string.len(v) > 0 then
            local data = string.split(v, "#")
            GuildWarAlly._config[i] = {
                time = tonumber(data[1]),   
                costID = tonumber(data[2]),
                costNum = tonumber(data[3]),
            }
        end
    end
end

function GuildWarAlly.InitUI()

    GUI:Button_setTitleFontSize(GuildWarAlly._ui["BtnCancel"], SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Button_setTitleFontSize(GuildWarAlly._ui["BtnOk"], SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))

    GUI:Text_setFontSize(GuildWarAlly._ui["TextTime"], SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Text_setFontSize(GuildWarAlly._ui["labCost"], SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Text_setFontSize(GuildWarAlly._ui["TextCost"], SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Text_setFontSize(GuildWarAlly._ui["Time"], SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))

    -- 关闭按钮
    GUI:addOnClickEvent(GuildWarAlly._ui["CloseButton"], function()
        UIOperator:CloseGuildWarAllyUI()
    end)

    GUI:addOnClickEvent(GuildWarAlly._ui["BtnCancel"], function()
        UIOperator:CloseGuildWarAllyUI()
    end)

    -- 下拉选择
    GUI:addOnClickEvent(GuildWarAlly._ui["TimeBg"], function()
        GuildWarAlly.ShowFilterPanel()
    end)

    GUI:addOnClickEvent(GuildWarAlly._ui["BtnArrow"], function()
        GuildWarAlly.ShowFilterPanel()
    end)

    GUI:addOnClickEvent(GuildWarAlly._ui["BtnOk"], function()
        local config = GuildWarAlly._config[GuildWarAlly._select]
        if not config then
            SL:ShowSystemTips("数据未配置")
            return
        end
        local time = config.time or 0
        if GuildWarAlly._type == 1 then
            SL:RequestGuildDeclareWar(GuildWarAlly._data.guildId, time)
        elseif GuildWarAlly._type == 2 then
            SL:RequestGuildAllyApply(GuildWarAlly._data.guildId, time)
        end
        UIOperator:CloseGuildWarAllyUI()
    end)

    GuildWarAlly.InitWarSponsorUI()
end

function GuildWarAlly.InitWarSponsorUI()
    -- title
    GUI:removeAllChildren(GuildWarAlly._ui["NodeTitle"])
    local info = ""
    if GuildWarAlly._type == 1 then 
        GUI:Text_setString(GuildWarAlly._ui["TextTime"], "宣战时长: ")
        GUI:Text_setString(GuildWarAlly._ui["labCost"], "宣战将花费: ")
        info = string.format("是否对 <font color='#ebf291' size = '%s'>%s</font> 行会发起宣战？", SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), GuildWarAlly._data.guildName)
    elseif GuildWarAlly._type == 2 then
        GUI:Text_setString(GuildWarAlly._ui["TextTime"], "结盟时长: ")
        GUI:Text_setString(GuildWarAlly._ui["labCost"], "结盟将花费: ")
        info = string.format("是否对 <font color='#ebf291' size = '%s'>%s</font> 行会发起结盟？", SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), GuildWarAlly._data.guildName)
    end
    local ui_rich = GUI:RichText_Create(GuildWarAlly._ui["NodeTitle"], "title", 0, 0, info, 400, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#ffffff")
    GUI:setAnchorPoint(ui_rich, 0.5, 0.5)

    -- cost
    GuildWarAlly.RefreshCost()
end

function GuildWarAlly.RefreshCost()
    local data = GuildWarAlly._config[GuildWarAlly._select]
    if not data then
        SL:ShowSystemTips("数据未配置")
        return
    end
    local time      = data.time or 0
    local id        = data.costID or 1
    local count     = data.costNum or 0
    local itemName  = SL:GetValue("ITEM_NAME", id)
    GUI:Text_setString(GuildWarAlly._ui["Time"], string.format("%s分钟", time))
    GUI:Text_setString(GuildWarAlly._ui["TextCost"], count .. itemName)
end 

function GuildWarAlly.RefreshFilterState(bShow)
    GUI:ListView_removeAllItems(GuildWarAlly._ui["ListView"])
    GUI:setVisible(GuildWarAlly._ui["ListBg"], bShow)
    GUI:setRotation(GuildWarAlly._ui["BtnArrow"], bShow and 180 or 0)
end 

function GuildWarAlly.ShowFilterPanel()
    GuildWarAlly.RefreshFilterState(true)
    local cellHei = nil
    for i, var in pairs(GuildWarAlly._config) do
        local cell = GuildWarAlly.CreateCell(i)
        GUI:ListView_pushBackCustomItem(GuildWarAlly._ui["ListView"], cell)
        if not cellHei then
            cellHei = GUI:getContentSize(cell).height
        end

        local ui_text = GUI:getChildByName(cell, "Text")
        GUI:Text_setString(ui_text, string.format("%s分钟", var.time))
        GUI:Text_setFontSize(ui_text, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))

        local ui_imgSel = GUI:getChildByName(cell, "ImageSel")
        GUI:setVisible(ui_imgSel, i == GuildWarAlly._select)

        GUI:addOnClickEvent(cell, function()
            GuildWarAlly._select = i
            GuildWarAlly.RefreshFilterState(false)
            GuildWarAlly.RefreshCost()
        end)
    end
    local childNum = GUI:ListView_getItemCount(GuildWarAlly._ui["ListView"])
    local interval = GUI:ListView_getItemsMargin(GuildWarAlly._ui["ListView"])
    local listHei = childNum * cellHei + (childNum - 1) * interval
    local listWid = GUI:getContentSize(GuildWarAlly._ui["ListView"]).width
    GUI:setContentSize(GuildWarAlly._ui["ListView"], listWid, listHei)
    GUI:setContentSize(GuildWarAlly._ui["ListBg"], listWid + 10, listHei + 10)

end

function GuildWarAlly.CreateCell(i)
    local parent = GUI:Widget_Create(-1, "widget" .. i, 0, 0)
    GUI:LoadExport(parent, "guild/guild_war_sponsor_cell")
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(cell)
    return cell
end


GuildWarAlly.main()