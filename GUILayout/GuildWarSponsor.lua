GuildWarSponsor = {}

function GuildWarSponsor.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_war_sponsor")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildWarSponsor._ui = ui

    GuildWarSponsor.AdaptUI(parent, ui)

    -- 取消按钮
    GUI:addOnClickEvent(ui["BtnCancel"], GuildWarSponsor.OnClose)

    GUI:addOnClickEvent(ui["BtnOk"], GuildWarSponsor.OnOpt)

    GUI:addOnClickEvent(ui["TimeBg"], GuildWarSponsor.OnShowFilterPanel)

    GUI:addOnClickEvent(ui["BtnArrow"], GuildWarSponsor.OnShowFilterPanel)

    GuildWarSponsor._data = data
    GuildWarSponsor._type = data.type
    GuildWarSponsor._guildID = data.guildId

    if not (GuildWarSponsor._type == 1 or GuildWarSponsor._type == 2) then
        return GuildWarSponsor.OnClose()
    end

    GuildWarSponsor._index = 1
    GuildWarSponsor._costConfig,  GuildWarSponsor._timeConfig = GuildWarSponsor.GetData()


    GuildWarSponsor.SetReset()

    local str = string.format(
        ({
            [1] = "是否对 <font color='#ebf291'>%s</font> 行会发起宣战？",
            [2] = "是否对 <font color='#ebf291'>%s</font> 行会发起结盟？"
        })[GuildWarSponsor._type]
    , data.guildName)

    GUI:removeAllChildren(ui["NodeTitle"])
    local richText = GUI:RichText_Create(ui["NodeTitle"], "richText", 0, 0, str, 400, 16, "#ffffff")
    GUI:setAnchorPoint(richText, 0.5, 0.5)
    
    GuildWarSponsor.RefreshCost()
    GuildWarSponsor.RefreshFliterStr()
end

function GuildWarSponsor.GetData()
    return (({
        [1] = function ()
            GUI:Text_setString(GuildWarSponsor._ui["TextTime"], "宣战时长:")
            GUI:Text_setString(GuildWarSponsor._ui["labCost"], "宣战花费:")
            return SL:Split(SL:GetGameData("declareWar"), "&"), SL:Split(SL:GetGameData("declareWar_time"), "#")
        end,
        [2] = function ()
            GUI:Text_setString(GuildWarSponsor._ui["TextTime"], "结盟时长:")
            GUI:Text_setString(GuildWarSponsor._ui["labCost"], "结盟将花费:")
            return SL:Split(SL:GetGameData("alliance"), "&"), SL:Split(SL:GetGameData("alliance_time"), "#")
        end,
    })[GuildWarSponsor._type])()
end

function GuildWarSponsor.AdaptUI(parent, ui)
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local fLayout = ui["FrameLayout"]
    local cLayout = ui["CloseLayout"]

    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, fLayout)
        GUI:setMouseEnabled(fLayout, true)
        
        GUI:setVisible(cLayout, false)
    else
        GUI:setContentSize(cLayout, screenW, screenH)
        GUI:addOnClickEvent(cLayout, GuildWarSponsor.OnClose)
        GUI:setVisible(cLayout, true)
    end

    GUI:setPosition(fLayout, screenW / 2, screenH / 2)
end

function GuildWarSponsor.OnClose()
    SL:CloseGuildWarSponsorUI()
end

function GuildWarSponsor.OnOpt()
    (({
        [1] = function ()
            SL:RequestGuildSponsor(GuildWarSponsor._guildID, GuildWarSponsor._index)
        end,
        [2] = function ()
            SL:RequestGuildAlly(GuildWarSponsor._guildID, GuildWarSponsor._index)
        end
    })[GuildWarSponsor._type])()

    SL:CloseGuildWarSponsorUI()
end

function GuildWarSponsor.SetReset()
    GUI:setRotation(GuildWarSponsor._ui["BtnArrow"], 0)
    GUI:setVisible(GuildWarSponsor._ui["ListBg"], false)
end

function GuildWarSponsor.RefreshFliterStr()
    GUI:Text_setString(GuildWarSponsor._ui["Time"], string.format("%s小时", GuildWarSponsor._timeConfig[GuildWarSponsor._index]))
end

function GuildWarSponsor.RefreshCost()
    local costStr = SL:Split(GuildWarSponsor._costConfig[GuildWarSponsor._index], "#")
    local ID    = tonumber(costStr[2])
    local count = tonumber(costStr[3])
    GUI:Text_setString(GuildWarSponsor._ui["TextCost"], count .. SL:GetMetaValue("ITEM_NAME", ID))
end


function GuildWarSponsor.OnShowFilterPanel()
    if GUI:getVisible(GuildWarSponsor._ui["ListBg"]) then
        return GuildWarSponsor.SetReset()
    end

    if not GuildWarSponsor._timeConfig then
        return GuildWarSponsor.SetReset()
    end

    GUI:setRotation(GuildWarSponsor._ui["BtnArrow"], 180)
    GUI:setVisible(GuildWarSponsor._ui["ListBg"], true)

    local list = GuildWarSponsor._ui["ListView"]
    GUI:removeAllChildren(list)

    local size   = GUI:getContentSize(GuildWarSponsor._ui["Item"])
    local count  = #GuildWarSponsor._timeConfig
    local width  = size.width
    local height = size.height * count
    GUI:setContentSize(list, width, height)

    GUI:setContentSize(GuildWarSponsor._ui["ListBg"], width + 10, height + 10)

    for index, time in pairs(GuildWarSponsor._timeConfig) do
        local item = GUI:Clone(GuildWarSponsor._ui["Item"])
        GUI:ListView_pushBackCustomItem(list, item)
        GUI:setVisible(item, true)

        GUI:ui_IterChilds(item, item)

        GUI:Text_setString(item["Text"], string.format("%s小时", time))

        GUI:setVisible(item["ImageSel"], index == GuildWarSponsor._index)

        GUI:addOnClickEvent(item, function ()
            GuildWarSponsor._index = index
            GuildWarSponsor.SetReset()
            GuildWarSponsor.RefreshCost()
            GuildWarSponsor.RefreshFliterStr()
        end)
    end
end
