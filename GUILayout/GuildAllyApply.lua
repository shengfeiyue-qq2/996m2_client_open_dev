GuildAllyApply = {}

function GuildAllyApply.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_ally_apply")

    GuildAllyApply._ui = GUI:ui_delegate(parent)
    if not GuildAllyApply._ui then
        return false
    end

    GuildAllyApply._cells = {}

    local PMainUI = GuildAllyApply._ui["PMainUI"]
    local CloseLayout = GuildAllyApply._ui["CloseLayout"]

    -- 全屏关闭
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)

        GUI:setVisible(CloseLayout, false)
    else
        GUI:addOnClickEvent(CloseLayout, function() GUI:Win_Close(parent) end)
        GUI:setVisible(CloseLayout, true)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(GuildAllyApply._ui["CloseButton"], function() 
        SL:CloseGuildAllyApplyUI()
    end)

    -- 发送请求
    SL:RequestGuildAllyApplyList()

    -- 移除监听事件
    GuildAllyApply.RegisterEvent()
end

function GuildAllyApply.onRefreshAllyApply()
    local allyList = SL:GetMetaValue("GUILD_ALLY_APPLY_LIST")
    GUI:ListView_removeAllItems(GuildAllyApply._ui["ListView"])
    for i, info in pairs(allyList) do 
        local cell = GuildAllyApply.CreateAllyCell(info)
        GUI:ListView_pushBackCustomItem(GuildAllyApply._ui["ListView"],cell)
        GuildAllyApply._cells[info.i] = cell

        local sliceStr = SL:Split(SL:GetMetaValue("GAME_DATA", "alliance_time"), "#")
        local Node_tips = GUI:getChildByName(cell, "Node_tips")
        GUI:removeAllChildren(Node_tips)
        local str = "<font color='#28EF01'>%s</font>向您发起结盟申请，持续<font color='#28EF01'>%s小时</font>"
        local richText = GUI:RichText_Create(Node_tips, "richText", 0, 0, string.format(str, info.n, sliceStr[info.t]), 400, 16, "#ffffff")
        GUI:setAnchorPoint(richText, 0, 0.5)

        local btnDisAgree = GUI:getChildByName(cell, "btnDisAgree")
        GUI:addOnClickEvent(btnDisAgree,function ()
            local guildID = info.i
            SL:RequestAllyOperate(guildID, 2)
            GuildAllyApply.removeCell(guildID)
        end)

        local btnAgree = GUI:getChildByName(cell, "btnAgree")
        GUI:addOnClickEvent(btnAgree,function ()
            local guildID = info.i
            SL:RequestAllyOperate(guildID, 1)
            GuildAllyApply.removeCell(guildID)
        end)
    end 
end

function GuildAllyApply.CreateAllyCell(info)
    local parent = GUI:Widget_Create(GuildAllyApply._ui["PMainUI"], "widget"..info.i, 0, 0)
    GUI:LoadExport(parent, "guild/guild_ally_apply_cell")
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end 

function GuildAllyApply.removeCell(guildID)
    local cell = GuildAllyApply._cells[guildID]
    if not cell then
        return false
    end
    GUI:ListView_removeChild(GuildAllyApply._ui["ListView"], cell)
    GuildAllyApply._cells[guildID] = nil
end


-----------------------------------注册事件--------------------------------------
function GuildAllyApply.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILDE_ALLY_APPLY_UPDATE, "GuildAllyApplyGUI", GuildAllyApply.onRefreshAllyApply)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildAllyApplyGUI", GuildAllyApply.RemoveEvent)
end

function GuildAllyApply.RemoveEvent(ID)
    if ID ~= "GuildAllyApplyGUI" then 
        return 
    end
    
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILDE_ALLY_APPLY_UPDATE, "GuildAllyApplyGUI")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildAllyApplyGUI")
end