GuildCreate = {}

function GuildCreate.main()
    local parent = GUI:Attach_Parent()

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_create_win32")
    else
        GUI:LoadExport(parent, "guild/guild_create")
    end

    GuildCreate._ui = GUI:ui_delegate(parent)

    local PMainUI = GuildCreate._ui["PMainUI"]
    local CloseLayout = GuildCreate._ui["CloseLayout"]
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

    -- 关闭按钮
    GUI:addOnClickEvent(GuildCreate._ui["CloseButton"], function()
        SL:CloseGuildCreateUI()
    end)

    GuildCreate.RegisterEvent()
end

function GuildCreate.OnRefreshGuildCreate()
    local cost = SL:GetMetaValue("GUILD_CREATE")

    -- icon
    GUI:removeAllChildren(GuildCreate._ui["Node_item"])
    local goodsData = {index = cost.index, count = 1, look = true, bgVisible = true}
    GUI:ItemShow_Create(GuildCreate._ui["Node_item"],"goods",0,0,goodsData)

    -- text1
    local richStr = string.format("%s x%s", cost.item, 1)
    local richColor = "#ff0000"
    local haveNum = tonumber(SL:GetMetaValue("ITEM_COUNT", cost.index))
    if haveNum and haveNum > 0 then 
        richColor = "#28ef01"
    end 
    local ui_rich1 = GUI:RichText_Create(GuildCreate._ui["Node_item"], "rich", -15, -30, richStr, 200, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), richColor)
    GUI:setAnchorPoint(ui_rich1, 0, 0)

    -- text2
    if cost.gold ~= "" then
        local st = string.split(cost.gold, "|");
        local currencyID = tonumber(st[1])
        local needCount = tonumber(st[2])
        local richStr2 = string.format("%s x%s", SL:GetMetaValue("ITEM_NAME", currencyID), needCount)
        local richColor = "#ff0000"
        local curNum = tonumber(SL:GetMetaValue("MONEY", currencyID))
        if curNum and curNum >  needCount then 
            richColor = "#28ef01"
        end
        local ui_rich2 = GUI:RichText_Create(GuildCreate._ui["Node_item"], "rich2", -15, -55, richStr2, 200, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), richColor)
        GUI:setAnchorPoint(ui_rich2, 0, 0)    
    end 
end 

-----------------------------------注册事件--------------------------------------
function GuildCreate.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_CREATE, "GuildCreate", GuildCreate.OnRefreshGuildCreate)
end

function GuildCreate.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_CREATE, "GuildCreate")
end