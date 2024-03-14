
CommonTipsPop = {}

CommonTipsPop.Event = {
    Confirm = 1,
    Other   = 2,
    Return  = 3,
}

function CommonTipsPop.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_tips")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    CommonTipsPop._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonTipsPop._ui.Layout, screenW, screenH)
    GUI:setPosition(CommonTipsPop._ui.PMainUI, screenW / 2, screenH / 2)

    CommonTipsPop._posX     = GUI:getPositionX(CommonTipsPop._ui.Btn_2)
    CommonTipsPop._editBox  = CommonTipsPop._ui.TextField
    CommonTipsPop._data     = data and CommonTipsPop.setData(data) or {}
    CommonTipsPop._showEdit = CommonTipsPop._data.showEdit

    CommonTipsPop.InitDesc()
    CommonTipsPop.InitBtnShow()
    CommonTipsPop.InitEdit()
    CommonTipsPop.InitCheckBox()

    CommonTipsPop.RegisterEvent()
end

function CommonTipsPop.setData(data)
    data.str = data.str
    if data.btnType == 1 then
        data.btnDesc = {"确认"}
    elseif data.btnType == 2 then
        data.btnDesc = {"确定", "取消"}
    end
    return data
end

function CommonTipsPop.InitDesc()
    GUI:removeAllChildren(CommonTipsPop._ui.DescList)

    if not CommonTipsPop._data.str then
        return
    end

    local limitWid = GUI:getContentSize(CommonTipsPop._ui.PMainUI).width - 40
    local commonTipsFontPath = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("GAME_DATA", "COMMONTIPS_FONT_PATH")
    local richText = GUI:RichText_Create(CommonTipsPop._ui.DescList, "desc_text", 0, 0, CommonTipsPop._data.str, limitWid, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", nil, nil, commonTipsFontPath)
    if richText then
        GUI:setAnchorPoint(richText, 0, 1)
        local autoSize = GUI:getContentSize(richText).height <= GUI:getContentSize(CommonTipsPop._ui.DescList).height
        GUI:UserUILayout(CommonTipsPop._ui.DescList, {autosize = autoSize})
        GUI:RefPosByParent(CommonTipsPop._ui.DescList)
    end
end

function CommonTipsPop.InitBtnShow()
    GUI:setVisible(CommonTipsPop._ui.Btn_1, false)
    GUI:setVisible(CommonTipsPop._ui.Btn_2, false)

    local btnType  = CommonTipsPop._data.btnType
    local btnDesc  = CommonTipsPop._data.btnDesc

    local function clickCallBack(tag)
        local data = {}
        data.event = tag
        data.checkBoxState = GUI:CheckBox_isSelected(CommonTipsPop._ui.CheckBox_state)

        if CommonTipsPop._showEdit then
            local editStr = GUI:TextInput_getString(CommonTipsPop._editBox)
            data.editStr = editStr
        end
        SL:onLUAEvent("LUA_EVENT_COMMONTIPS_EVENT", data)
    end
    CommonTipsPop._clickCallBack = clickCallBack

    if btnDesc then
        local num = #btnDesc
        for i, name in ipairs(btnDesc) do
            local btn = CommonTipsPop._ui["Btn_" .. i]
            local posX = CommonTipsPop._posX - (num - i) * (GUI:getContentSize(btn).width + 30)
            if btn then
                GUI:setVisible(btn, true)
                GUI:setPositionX(btn, posX)
                GUI:Button_setTitleText(btn, name)
                GUI:addOnClickEvent(btn, function()
                    clickCallBack(i)
                end)
            end
        end
    end

end

function CommonTipsPop.InitEdit()
    if not CommonTipsPop._showEdit then
        GUI:setVisible(CommonTipsPop._ui.TextFieldBg, false)
        return
    end
    GUI:setVisible(CommonTipsPop._ui.TextFieldBg, true)

    GUI:TextInput_addOnEvent(CommonTipsPop._editBox, function(_, eventType)
        if eventType == 2 then
            local input = GUI:TextInput_getString(CommonTipsPop._editBox)
            if string.len(input) > 0 and string.find(input, "\n") then
                input = string.gsub(input, "\r\n", "")
                input = string.gsub(input, "\n", "")
                SL:onLUAEvent("LUA_EVENT_COMMONTIPS_EVENT", {
                    event = 1,
                    editStr = input
                })
            end
        end
    end)

    local editParams = CommonTipsPop._data.editParams
    if CommonTipsPop._editBox and editParams then
        if editParams.inputMode then
            GUI:TextInput_setInputMode(CommonTipsPop._editBox, editParams.inputMode)
        end
        if editParams.maxLength then
            GUI:TextInput_setMaxLength(CommonTipsPop._editBox, editParams.maxLength)
        end
        if editParams.str then
            GUI:TextInput_setString(CommonTipsPop._editBox, editParams.str)
        end
    end

    -- 进入编辑状态
    GUI:TextInput_touchDownAction(CommonTipsPop._editBox, 2)
end

-- 复选框
function CommonTipsPop.InitCheckBox()
    if CommonTipsPop._data.checkBoxState == nil then
        return false
    end

    GUI:setVisible(CommonTipsPop._ui.CheckBox_state, true)
    GUI:CheckBox_setSelected(CommonTipsPop._ui.CheckBox_state, CommonTipsPop._data.checkBoxState==true)
    GUI:Text_setString(CommonTipsPop._ui.Text_state, CommonTipsPop._data.checkBoxStr or "")
end

function CommonTipsPop.HandleEvent(data)
    local tag = data.event
    if tag then
        SL:CloseCommonTipsPop()
        if CommonTipsPop._data.callback then
            CommonTipsPop._data.callback(tag, data)
        end
    end
end

function CommonTipsPop.HandlePressEnter()
    if SL:GetMetaValue("WINPLAYMODE") and not CommonTipsPop._showEdit then
        if CommonTipsPop._clickCallBack then
            CommonTipsPop._clickCallBack(CommonTipsPop.Event.Confirm)
        else
            SL:CloseCommonTipsPop()
        end
    end
end

function CommonTipsPop.RemoveEvent(tag)
    if tag == "CommonTipsGUI" then
        SL:UnRegisterLUAEvent("LUA_EVENT_COMMONTIPS_EVENT", "CommonTipsPop")
        SL:UnRegisterLUAEvent("LUA_EVENT_CLOSEWIN", "CommonTipsPop")
    end
end

function CommonTipsPop.RegisterEvent()
    SL:RegisterLUAEvent("LUA_EVENT_COMMONTIPS_EVENT", "CommonTipsPop", CommonTipsPop.HandleEvent)
    SL:RegisterLUAEvent("LUA_EVENT_CLOSEWIN", "CommonTipsPop", CommonTipsPop.RemoveEvent)
end