GuildWarSponsor = {}
GuildWarSponsor._costCfg = {}
GuildWarSponsor._timeCfg = {}
GuildWarSponsor._select = 1

function GuildWarSponsor.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_war_sponsor")
    GuildWarSponsor._ui = GUI:ui_delegate(parent)

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    local PMainUI = GuildWarSponsor._ui["PMainUI"]
    local CloseLayout = GuildWarSponsor._ui["CloseLayout"]
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)
    GUI:setPosition(PMainUI, winSizeW / 2, winSizeH / 2)

    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        GUI:setPosition(PMainUI, winSizeW / 2, SL:GetMetaValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:Win_SetZPanel(parent, PMainUI)
    else
        -- 全屏关闭
        GUI:setVisible(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(parent)
        end)
    end
    GUI:Button_setTitleFontSize(GuildWarSponsor._ui["BtnCancel"], SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Button_setTitleFontSize(GuildWarSponsor._ui["BtnOk"], SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))

    -- 关闭按钮
    GUI:addOnClickEvent(GuildWarSponsor._ui["CloseButton"], function()
        SL:CloseGuildWarSponsorUI()
    end)

    GUI:addOnClickEvent(GuildWarSponsor._ui["BtnCancel"], function()
        SL:CloseGuildWarSponsorUI()
    end)

    GUI:addOnClickEvent(GuildWarSponsor._ui["TimeBg"], function()
        GuildWarSponsor.showFilterPanel()
    end)

    GUI:addOnClickEvent(GuildWarSponsor._ui["BtnArrow"], function()
        GuildWarSponsor.showFilterPanel()
    end)
end


function GuildWarSponsor.InitWarSponsorUI(data)
    -- title
    GUI:removeAllChildren(GuildWarSponsor._ui["NodeTitle"])
    local info = ""
    if data.type == 1 then 
        local costStr = SL:GetMetaValue("GAME_DATA", "declareWar")
        GuildWarSponsor._costCfg = string.split(costStr, "&")
        local timeStr = SL:GetMetaValue("GAME_DATA", "declareWar_time")
        GuildWarSponsor._timeCfg = string.split(timeStr, "#")

        GUI:Text_setString(GuildWarSponsor._ui["TextTime"], "宣战时长: ")
        GUI:Text_setString(GuildWarSponsor._ui["labCost"], "宣战将花费: ")
        info = string.format("是否对 <font color='#ebf291' size = '%s'>%s</font> 行会发起宣战？", SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), data.guildName)
    else
        local costStr = SL:GetMetaValue("GAME_DATA", "alliance")
        GuildWarSponsor._costCfg = string.split(costStr, "&")
        local timeStr = SL:GetMetaValue("GAME_DATA", "alliance_time")
        GuildWarSponsor._timeCfg = string.split(timeStr, "#")

        GUI:Text_setString(GuildWarSponsor._ui["TextTime"],"结盟时长: ")
        GUI:Text_setString(GuildWarSponsor._ui["labCost"],"结盟将花费: ")
        info = string.format("是否对 <font color='#ebf291' size = '%s'>%s</font> 行会发起结盟？", SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), data.guildName)
    end 
    GUI:Text_setFontSize(GuildWarSponsor._ui["TextTime"], SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Text_setFontSize(GuildWarSponsor._ui["labCost"], SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Text_setFontSize(GuildWarSponsor._ui["TextCost"], SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
    GUI:Text_setFontSize(GuildWarSponsor._ui["Time"], SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))

    -- title
    local ui_rich = GUI:RichText_Create(GuildWarSponsor._ui["NodeTitle"], "title", 0, 0, info, 400, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#ffffff")
    GUI:setAnchorPoint(ui_rich, 0.5, 0.5)

    -- cost
    GuildWarSponsor.refreshCost()
end

function GuildWarSponsor.refreshCost()
    GUI:Text_setString(GuildWarSponsor._ui["Time"], string.format("%s小时", GuildWarSponsor._timeCfg[GuildWarSponsor._select]))
    local costStr  = string.split(GuildWarSponsor._costCfg[GuildWarSponsor._select], "#")
    local ID       = tonumber(costStr[2])
    local count    = tonumber(costStr[3])
    local itemName = SL:GetMetaValue("ITEM_NAME", ID)
    GUI:Text_setString(GuildWarSponsor._ui["TextCost"], count .. itemName)
end 

function GuildWarSponsor.refreshState(bShow)
    GUI:ListView_removeAllItems(GuildWarSponsor._ui["ListView"])
    GUI:setVisible(GuildWarSponsor._ui["ListBg"],bShow)
    GUI:setRotation(GuildWarSponsor._ui["BtnArrow"], bShow and 180 or 0)
end 

function GuildWarSponsor.showFilterPanel()
    GuildWarSponsor.refreshState(true)
    for i, var in pairs(GuildWarSponsor._timeCfg) do
        local cell = GuildWarSponsor.createCell(var)
        GUI:ListView_pushBackCustomItem(GuildWarSponsor._ui["ListView"],cell)

        local ui_text = GUI:getChildByName(cell, "Text")
        GUI:Text_setString(ui_text, string.format("%s小时", var))
        GUI:Text_setFontSize(ui_text, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))

        local ui_imgSel = GUI:getChildByName(cell, "ImageSel")
        GUI:setVisible(ui_imgSel, i == GuildWarSponsor._select)

        GUI:addOnClickEvent(cell, function()
            GuildWarSponsor._select = i
            GuildWarSponsor.refreshState(false)
            GuildWarSponsor.refreshCost()
        end)
    end 
end

function GuildWarSponsor.createCell(info)
    local parent = GUI:Widget_Create(GuildWarSponsor._ui["PMainUI"], "widget"..info, 0, 0)
    GUI:LoadExport(parent, "guild/guild_war_sponsor_cell")
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end 