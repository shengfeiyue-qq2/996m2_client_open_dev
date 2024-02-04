GuildEditTitle = {}

function GuildEditTitle.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_edit_title")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildEditTitle._ui = ui

    GuildEditTitle.AdaptUI(parent, ui)

    GUI:addOnClickEvent(ui["BtnOk"], GuildEditTitle.OnSaveGuildTitle)

    -- 取消
    GUI:addOnClickEvent(ui["BtnCancel"], GuildEditTitle.OnClose)

    -- 关闭按钮
    GUI:addOnClickEvent(ui["CloseButton"], GuildEditTitle.OnClose)

    GuildEditTitle.UpdateUI(ui)
end

function GuildEditTitle.AdaptUI(parent, ui)
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
        GUI:addOnClickEvent(cLayout, GuildEditTitle.OnClose)
        GUI:setVisible(cLayout, true)
    end

    GUI:setPosition(fLayout, screenW / 2, screenH / 2)
end

function GuildEditTitle.UpdateUI(ui)
    -- 列表
    local List = ui["List"]

    GuildEditTitle._Titles = {}

    local list = ui["List"]
    GUI:removeAllChildren(list)

    -- 获取 title 数据列表
    local datas = SL:GetMetaValue("GUILD_TITLE_LIST")
    for i,title in ipairs(datas) do
        local item = GUI:Clone(ui["Item"])
        GUI:ListView_pushBackCustomItem(list, item)
        GUI:setVisible(item, true)
        
        GUI:ui_IterChilds(item, item)
        
        GUI:Text_setString(item["Text"], "称谓"..i)

        local input = SL:CreateInput(item)
        GUI:TextInput_setString(input, title)
        GUI:setTag(input, i)

        GuildEditTitle._Titles[i] = input
    end
end

function SL:CreateInput(item)
    local Input = GUI:TextInput_Create(item, "Input", 96.00, 16.00, 148.00, 20.00, 16)
	GUI:TextInput_setString(Input, "")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:setAnchorPoint(Input, 0.00, 0.50)
	GUI:setTouchEnabled(Input, true)

    local funcSuccuss = function (sender, inputStr)
        if GUI:Win_IsNull(sender) then
            return false
        end
        GUI:TextInput_setString(sender, inputStr)
    end

    local funcFail = function (sender)
        if GUI:Win_IsNull(sender) then
            return false
        end
        GUI:TextInput_setString(sender, "xxx") 
    end

    local function onEditEvent(sender, eventType)
        if eventType == 1 or eventType == 4 then
            local inputStr = GUI:TextInput_getString(sender) or ""
            SL:CheckSensitive(inputStr, function () funcSuccuss(sender, inputStr) end, function () funcFail(sender) end)
        end
    end
    GUI:TextInput_addOnEvent(Input, onEditEvent)

    return Input
end

function GuildEditTitle.OnClose()
    SL:CloseGuildEditTitleUI()
end

function GuildEditTitle.OnSaveGuildTitle()
    if SL:GetMetaValue("M2_FORBID_SAY", true) then
        return false
    end

    local data = {}
    for k,edit in ipairs(GuildEditTitle._Titles) do
        data["rank"..k] = GUI:TextInput_getString(edit)
    end
    SL:RequestSetGuildTitle(data)
    GuildEditTitle.OnClose()
end
