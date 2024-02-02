GuildApplyList = {}

function GuildApplyList.main()
    local parent = GUI:Attach_Parent()

    GUI:LoadExport(parent, "guild/guild_apply_list")

    GuildApplyList._parent = parent
    GuildApplyList._ui = GUI:ui_delegate(parent)
    GuildApplyList._cells = {}

    local PMainUI = GuildApplyList._ui["PMainUI"]
    local CloseLayout = GuildApplyList._ui["CloseLayout"]
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:setVisible(CloseLayout, false)
        GUI:setPosition(PMainUI, winSizeW / 2, SL:GetMetaValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:Win_SetZPanel(parent, PMainUI)
    else
        -- 全屏关闭
        GUI:setVisible(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout,function()
            GUI:Win_Close(parent)
        end)
    end

    GUI:addOnClickEvent(
        GuildApplyList._ui["CloseButton"],
        function()
            SL:CloseGuildApplyListUI()
        end
    )

    GuildApplyList.RegisterEvent()
end

function GuildApplyList.RefreshApplyList()
    local applyList = SL:GetMetaValue("GUILD_APPLY_LIST")
    GUI:ListView_removeAllItems(GuildApplyList._ui["ListView"])
    for i, info in pairs(applyList) do
        local cell = GuildApplyList.CreateApplyCell(info)
        GUI:ListView_pushBackCustomItem(GuildApplyList._ui["ListView"], cell)
        GuildApplyList._cells[info.UserID] = cell
    end
end

function GuildApplyList.CreateApplyCell(info)
    local parent = GUI:Widget_Create(GuildApplyList._ui["PMainUI"], "widget" .. info.UserID, 0, 0)
    GUI:LoadExport(parent, "guild/guild_apply_cell")
    local cell = GUI:getChildByName(parent, "ListCell")

    local ui_name = GUI:getChildByName(cell, "username")
    GUI:Text_setString(ui_name, info.Name)

    local ui_level = GUI:getChildByName(cell, "level")
    GUI:Text_setString(ui_level, info.Level)

    local ui_job = GUI:getChildByName(cell, "job")
    GUI:Text_setString(ui_job, SL:GetMetaValue("JOB_NAME", info.Job))

    local btnAgree = GUI:getChildByName(cell, "btnAgree")
    GUI:addOnClickEvent(
        btnAgree,
        function()
            GuildApplyList.clickBtnAgree(info.UserID)
            GuildApplyList.RemoveApplyCell(info.UserID)
        end
    )

    local btnDisAgree = GUI:getChildByName(cell, "btnDisAgree")
    GUI:addOnClickEvent(
        btnDisAgree,
        function()
            GuildApplyList.clickBtnDisagree(info.UserID)
            GuildApplyList.RemoveApplyCell(info.UserID)
        end
    )

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end

function GuildApplyList.RemoveApplyCell(userID)
    local cell = GuildApplyList._cells[userID]
    if cell then
        GUI:ListView_removeChild(GuildApplyList._ui["ListView"], cell)
        GuildApplyList._cells[userID] = nil
    end
end

-----------------------------------注册事件--------------------------------------
function GuildApplyList.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_APPLYLIST, "GuildApplyList", GuildApplyList.RefreshApplyList)
end

function GuildApplyList.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_APPLYLIST, "GuildApplyList")
end
