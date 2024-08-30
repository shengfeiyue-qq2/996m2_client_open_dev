GuildAllyApply = {}

function GuildAllyApply.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.GuildAllyApplyGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.GuildAllyApplyGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "guild/guild_ally_apply")
    GuildAllyApply._layer = parent

    GuildAllyApply._ui = GUI:ui_delegate(parent)
    if not GuildAllyApply._ui then
        return false
    end

    GuildAllyApply._cells = {}

    local mainPanel = GuildAllyApply._ui["PMainUI"]
    local closeLayout = GuildAllyApply._ui["CloseLayout"]
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(closeLayout, winSizeW, winSizeH)
    GUI:setPosition(mainPanel, winSizeW / 2, winSizeH / 2)

    -- 全屏关闭
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:setVisible(closeLayout, false)
        GUI:setPosition(mainPanel, winSizeW / 2, SL:GetValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, mainPanel)
        GUI:Win_SetZPanel(parent, mainPanel)
    else
        GUI:setVisible(closeLayout, true)
        GUI:addOnClickEvent(closeLayout, function()
            UIOperator:CloseGuildAllyApplyUI()
        end)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(GuildAllyApply._ui["CloseButton"], function() 
        UIOperator:CloseGuildAllyApplyUI()
    end)

    -- 发送请求
    SL:RequestGuildAllyApplyList()

    -- 添加监听事件
    GuildAllyApply.RegisterEvent()
end

function GuildAllyApply.OnRefreshAllyApplyList()
    local allyList = SL:GetValue("GUILD_ALLY_APPLY_LIST")
    GUI:ListView_removeAllItems(GuildAllyApply._ui["ListView"])
    GuildAllyApply._cells = {}
    for i, info in pairs(allyList) do
        local guildID = info.GuildID
        local cell = GuildAllyApply.CreateAllyCell(info)
        GUI:ListView_pushBackCustomItem(GuildAllyApply._ui["ListView"], cell)
        GuildAllyApply._cells[guildID] = cell

        local ui = GUI:ui_delegate(cell)
        local sliceStr = SL:Split(SL:GetValue("GAME_DATA", "alliance_time"), "#")
        GUI:removeAllChildren(ui.Node_tips)
        local str = "<font color='#28EF01'>%s</font>向您发起结盟申请，持续<font color='#28EF01'>%s分钟</font>"
        local richText = GUI:RichText_Create(ui.Node_tips, "richText", 0, 0, string.format(str, info.GuildName, info.InviteTime), 400, 16, "#ffffff")
        GUI:setAnchorPoint(richText, 0, 0.5)

        -- 同意
        GUI:addOnClickEvent(ui.btnAgree, function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestGuildApproveAllyApply(guildID)
            GuildAllyApply.RemoveCell(guildID)
        end)

        -- 拒绝
        GUI:addOnClickEvent(ui.btnDisAgree, function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestGuildRejectAllyApply(guildID)
            GuildAllyApply.RemoveCell(guildID)
        end)
        
    end 
end

function GuildAllyApply.CreateAllyCell(info)
    local parent = GUI:Widget_Create(-1, "widget" .. info.GuildID, 0, 0)
    GUI:LoadExport(parent, "guild/guild_ally_apply_cell")
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(cell)
    return cell
end 

function GuildAllyApply.RemoveCell(guildID)
    local cell = GuildAllyApply._cells[guildID]
    if not cell then
        return false
    end
    GUI:ListView_removeChild(GuildAllyApply._ui["ListView"], cell)
    GuildAllyApply._cells[guildID] = nil
end

-------------------------------------------------------
function GuildAllyApply.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_APPLY_ALLY_LIST, "GuildAllyApplyGUI", GuildAllyApply.OnRefreshAllyApplyList, GuildAllyApply._layer)
end

--------------------------------------------------------

GuildAllyApply.main()