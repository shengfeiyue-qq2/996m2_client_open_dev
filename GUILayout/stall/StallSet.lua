StallSet = {}

function StallSet.main()
    StallPut._parent = GUI:Win_Create(UIConst.LAYERID.StallSetGUI, 0, 0, 0, 0, false, false, true, true)
    StallSet.InitData()
    StallSet.InitUI()
end

function StallSet.InitData()
    StallSet._isWinMode =  SL:GetValue("IS_PC_OPER_MODE")
end

function StallSet.InitUI()
    GUI:LoadExport(StallPut._parent, StallSet._isWinMode and  "stall/stall_set_layer_win32" or "stall/stall_set_layer")
    StallSet._ui = GUI:ui_delegate(StallPut._parent)
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setPosition(StallSet._ui.PMainUI, winSizeW / 2, StallSet._isWinMode and SL:GetValue("PC_POS_Y") or winSizeH / 2)

    local showStallName =  SL:GetValue("SERVER_OPTION",SW_KEY_SHOW_STALL_NAME)  
    local placeHolder = showStallName == 0 and SL:GetValue("GAME_DATA","StallName") or nil
    if placeHolder then
        placeHolder = string.gsub(placeHolder, "<$USERNAME>", SL:GetValue("USER_NAME"))
        GUI:Text_setString(StallSet._ui.Text_name, placeHolder)
    end

    GUI:TextInput_setMaxLength(StallSet._ui.TextField_name, 50)

    GUI:addOnClickEvent(StallSet._ui.Button_close, function ()
        UIOperator:CloseStallSetLayerUI()
    end)

    local function SellCallBack()
        local name = GUI:Text_getString(StallSet._ui.TextField_name)
        if name ~= "" and string.len(name) > 0 then
        else
            name = placeHolder or ""
        end

        -- 敏感字
        local function handle_Func(state)
            if not state then
                SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                return
            end
            if SL:GetValue("STALL_MY_TRADING_STATUS") then 
                SL:ShowSystemTips("已经开始摆摊")
                return 
            end 
            SL:RequestAutoStall(name)
            UIOperator:CloseStallSetLayerUI()
        end
        SL:RequestCheckSensitiveWord(name, 1, handle_Func)
        GUI:delayTouchEnabled(StallSet._ui.Button_ok)
    end
    GUI:addOnClickEvent(StallSet._ui.Button_ok, SellCallBack)

    --输入框事件
    local function editBoxTextEventHandle(pSender, eventName)
        if eventName == GUIDefine.TextInputEventType.BEGAN then
            GUI:setVisible(StallSet._ui.Text_name, false)
        elseif eventName == GUIDefine.TextInputEventType.ENDED or eventName == GUIDefine.TextInputEventType.RETURN then                                 --键盘消失
            if SL:GetValue("M2_FORBID_NAME", true) then
                GUI:Text_setString(pSender, "")
            end
            local str = GUI:Text_getString(pSender)
            GUI:setVisible(StallSet._ui.Text_name, string.len(str) <= 0)
        end
    end
    GUI:TextInput_addOnEvent(StallSet._ui.TextField_name, editBoxTextEventHandle)
end

StallSet.main()