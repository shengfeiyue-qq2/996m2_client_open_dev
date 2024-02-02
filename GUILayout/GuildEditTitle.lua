GuildEditTitle = {}
GuildEditTitle._EditInputs = {}

function GuildEditTitle.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_edit_title")
    GuildEditTitle._ui = GUI:ui_delegate(parent)

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    local PMainUI = GuildEditTitle._ui["PMainUI"]
    local CloseLayout = GuildEditTitle._ui["CloseLayout"]
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)

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
    GUI:addOnClickEvent(GuildEditTitle._ui["CloseButton"], function()
        GUI:Win_Close(parent)
    end)

    GUI:addOnClickEvent(GuildEditTitle._ui["BtnCancel"], function()
        GUI:Win_Close(parent)
    end)

    -- 确定
    GUI:addOnClickEvent(GuildEditTitle._ui["BtnOk"], function()
        GuildEditTitle._SaveOpt(GuildEditTitle._EditInputs)
    end)

    -- 获取 title 数据列表
    local TitleDatas = GuildEditTitle._GetGuildTitleData()
    GUI:removeAllChildren(GuildEditTitle._ui["List"])
    for i, v in ipairs(TitleDatas) do
        local cell = GuildEditTitle.createCell(i)
        GUI:ListView_pushBackCustomItem(GuildEditTitle._ui["List"], cell)

        -- 获得 title 名字
        local ui_EditInput = GUI:getChildByName(cell, "EditInput")
        local titleName = GuildEditTitle._GetTitleNameByIndex(i)
        GUI:TextInput_setString(ui_EditInput, titleName)

        -- 把 EditInput 存储在 GuildEditTitle._EditInputs 中
        GuildEditTitle._EditInputs[i] = ui_EditInput

        -- 称谓标签
        local ui_text = GUI:getChildByName(cell, "Text")
        GUI:Text_setString(ui_text, "称谓".. i)
    end
end

function GuildEditTitle.createCell(i)
    local parent = GUI:Widget_Create(GuildEditTitle._ui["PMainUI"], "widget"..i, 0, 0)
    GUI:LoadExport(parent, "guild/guild_edit_title_cell")
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end