GuildCreate = {}

GuildCreate._condition = 1

function GuildCreate.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_create")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildCreate._ui = ui

    GuildCreate.AdaptUI(parent, ui)

    GuildCreate._condition = 1

    SL:RegisterLUAEvent(LUA_EVENT_RESPONSE_GUILD_CREATE_COST, "GuildCreate", GuildCreate.UpdateUI)
    SL:RequestGuildCreateCost()

    GuildCreate.InitEvent()

    -- 默认1级
    SL:SetCreateAutoLevel(1)
    
    -- 默认自动加入
    GUI:CheckBox_setSelected(GuildCreate._ui["CheckBox"], true)
    SL:SetCreateAutoApply(1)
end

function GuildCreate.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_RESPONSE_GUILD_CREATE_COST, "GuildCreate")
end

function GuildCreate.AdaptUI(parent, ui)
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
        GUI:addOnClickEvent(cLayout, function ()
            GUI:Win_Close(parent)
        end)
        GUI:setVisible(cLayout, true)
    end

    GUI:setPosition(fLayout, screenW / 2, screenH / 2)

    GUI:addOnClickEvent(ui["CloseButton"], function ()
        SL:CloseGuildCreateUI()
        SL:OpenGuildMainUI()
    end)
end

function GuildCreate.InitEvent()
    GUI:addOnClickEvent(GuildCreate._ui["BtnCreate"], function ()
        if GuildCreate._condition == -1 then
            return SL:ShowSystemTips("材料不足")
        end

        local inputStr = GUI:TextInput_getString(GuildCreate._ui["Input"])
        if string.len(inputStr) < 1 then
            return SL:ShowSystemTips("行会名不能为空")
        end

        local callback = function ()
            SL:RequestCreateGuild(inputStr)
        end
        SL:CheckSensitive(inputStr, callback)
    end)


    GUI:TextInput_addOnEvent(GuildCreate._ui["Input_level"], function (sender, eventType)
        if eventType == 3 then
            local level = GUI:TextInput_getString(sender)
            SL:SetCreateAutoLevel(level)
        end
    end)

    GUI:CheckBox_addOnEvent(GuildCreate._ui["CheckBox"], function (sender, eventType)
        local value = GUI:CheckBox_isSelected(sender) and 1 or 0
        SL:SetCreateAutoApply(value)
    end)
end

function GuildCreate.CreateNeedItemTips(parent, itemID, itemName)
    local isLack = SL:GetItemNumberByIndex(itemID) < 1
    if isLack then
        GuildCreate._condition = -1
    end
    local color = isLack and "#ff0500" or "#28ef01"
    local str = string.format("创建需要1：<font color='%s'>%sx%s</font>", color, itemName, 1)
    GUI:RichText_Create(parent, "rech1", -83, -70, str, 200, 16, "#28ef01")
end

function GuildCreate.CreateNeedGoldTips(parent, itemID, needCount)
    local isLack = SL:GetItemNumberByIndex(itemID) < needCount
    if isLack then
        GuildCreate._condition = -1
    end
    local name  = SL:GetMetaValue("ITEM_NAME", itemID)
    local color = isLack and "#ff0500" or "#28ef01"
    local str = string.format("创建需要2：<font color='%s'>%sx%s</font>", color, name, needCount)
    GUI:RichText_Create(parent, "rech2", -83, -100, str, 200, 16, "#28ef01")
end

function GuildCreate.UpdateUI(costs)
    if not costs or not next(costs) then
        GuildCreate._condition = -1
        return false
    end

    GuildCreate._costs = costs

    local nItem = GuildCreate._ui["Node_item"]
    GUI:removeAllChildren(nItem)

    -- 道具名字
    local itemName = costs.item
    local itemID = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
    if itemID then
        GUI:ItemShow_Create(nItem, "item", -30, -30, {index = itemID, look = true, count = 1, bgVisible = true})
        GuildCreate.CreateNeedItemTips(nItem, itemID, itemName)
    else
        GuildCreate._condition = -1
    end

    -- 检测是否货币
    local goldStr = SL:Split(costs.gold or "", "|")
    local itemID = tonumber(goldStr[1]) or 0
    if itemID > 0 then
        GUI:setPositionY(nItem, GUI:getPositionY(nItem) + 20)
        GuildCreate.CreateNeedGoldTips(nItem, itemID, tonumber(goldStr[2]) or 0)
    end
end
