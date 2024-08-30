GuildEditTitle = {}

function GuildEditTitle.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.GuildEditTitleGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.GuildEditTitleGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "guild/guild_edit_title")
    GuildEditTitle._ui = GUI:ui_delegate(parent)
    GuildEditTitle._EditInputs = {}

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    local mainPanel = GuildEditTitle._ui["PMainUI"]
    local closeLayout = GuildEditTitle._ui["CloseLayout"]
    GUI:setContentSize(closeLayout, winSizeW, winSizeH)

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
            UIOperator:CloseGuildEditTitleUI()
        end)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(GuildEditTitle._ui["CloseButton"], function()
        UIOperator:CloseGuildEditTitleUI()
    end)

    GUI:addOnClickEvent(GuildEditTitle._ui["BtnCancel"], function()
        UIOperator:CloseGuildEditTitleUI()
    end)

    -- 确定
    GUI:addOnClickEvent(GuildEditTitle._ui["BtnOk"], function(sender)
        if SL:GetValue("M2_FORBID_SAY", true) then
            return
        end
        local strList = {}
        for _, input in ipairs(GuildEditTitle._EditInputs) do
            local inputStr = GUI:TextInput_getString(input)
            table.insert(strList, inputStr)
        end

        local function callback(state)
            if not state then
                SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                return
            end

            SL:RequestGuildSetTitle(strList)
            UIOperator:CloseGuildEditTitleUI()
        end
        SL:RequestCheckSensitiveWordEx(strList, 1, callback)
        GUI:delayTouchEnabled(sender)
    end)

    -- 获取行会称谓列表
    local titleList = SL:GetValue("GUILD_TIELE_LIST")
    GUI:ListView_removeAllItems(GuildEditTitle._ui["List"])
    GuildEditTitle._EditInputs = {}
    for i, v in ipairs(titleList) do
        local cell = GuildEditTitle.CreateCell(i)
        GUI:ListView_pushBackCustomItem(GuildEditTitle._ui["List"], cell)

        local rank = v.rank
        -- 称谓名
        local ui_EditInput = GUI:getChildByName(cell, "EditInput")
        GUI:TextInput_setString(ui_EditInput, SL:GetValue("GUILD_OFFICIAL_NAME_BY_RANK", rank))
        GuildEditTitle._EditInputs[i] = ui_EditInput

        -- 称谓标签
        local ui_text = GUI:getChildByName(cell, "Text")
        GUI:Text_setString(ui_text, "称谓" .. rank)
    end
end

function GuildEditTitle.CreateCell(i)
    local parent = GUI:Widget_Create(-1, "widget" .. i, 0, 0)
    GUI:LoadExport(parent, "guild/guild_edit_title_cell")
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(cell)
    return cell
end


GuildEditTitle.main()