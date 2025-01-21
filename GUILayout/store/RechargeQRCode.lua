RechargeQRCode = {}

local RichTextHelp = requireUtil("RichTextHelp")

function RechargeQRCode.main()
    local data = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.RechargeQRCodeGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "store/store_recharge_qrcode_panel_win32")

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    RechargeQRCode._ui = GUI:ui_delegate(parent)
    GUI:setPosition(RechargeQRCode._ui.PMainUI, screenW / 2, SL:GetValue("PC_POS_Y"))
    GUI:Win_SetZPanel(parent, RechargeQRCode._ui.PMainUI)

    -- 关闭
    GUI:addOnClickEvent(RechargeQRCode._ui.Button_close, function()
        UIOperator:CloseRechargeQRCodeUI();
    end)

    RechargeQRCode.ShowQRCode(data)
end

function RechargeQRCode.ShowQRCode(data)
    local imageQRCode = nil
    -- qrcode
    local filename = data.filename
    local fullPath = SL:GetFullPathForFilename(filename)
    if SL:IsFileExist(fullPath) then
        imageQRCode = GUI:Image_Create(-1, "QRCode", 0, 0, fullPath)
        GUI:setAnchorPoint(imageQRCode, 0.5, 0.5)
        local imgSize = GUI:getContentSize(imageQRCode)
        if imgSize.width > 350 or imgSize.height > 350 then
            GUI:setIgnoreContentAdaptWithSize(imageQRCode, false)
            GUI:setContentSize(imageQRCode, 200, 200)
        end
        GUI:removeAllChildren(RechargeQRCode._ui.Node_qrcode)
        GUI:addChild(RechargeQRCode._ui.Node_qrcode, imageQRCode)
    end

    -- qrcode tips
    local PAY_CHANNEL = SL:GetValue("PAY_CHANNEL")
    local channel     = data.channel
    local setTip      = SL:GetValue("RECHARGE_TIP")
    local tips        =
    {
        [PAY_CHANNEL.WEIXIN] = setTip or "请使用手机 <font color='#00ff00'>微信</font> 扫描二维码支付",
        [PAY_CHANNEL.ALIPAY] = setTip or "请使用手机 <font color='#00ff00'>支付宝</font> 扫描二维码支付",
        [PAY_CHANNEL.HUABEI] = setTip or "请使用手机 <font color='#00ff00'>支付宝</font> 扫描二维码支付",
    }

    local richText    = RichTextHelp:CreateRichTextWithXML(tips[channel], 500,
        SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE") or 16, "#ffffff")
    GUI:removeAllChildren(RechargeQRCode._ui.Node_qrcode_tips)
    GUI:addChild(RechargeQRCode._ui.Node_qrcode_tips, richText)

    local leftTime = 40 -- 倒计时40秒
    local function showLeftTime()
        GUI:Text_setString(RechargeQRCode._ui.Text_time, string.format("剩余时间：%s秒", leftTime))
        if leftTime <= 0 then
            GUI:stopAllActions(RechargeQRCode._ui.Text_time)
            GUI:SetShaderShadow(imageQRCode)
            GUI:Text_setString(RechargeQRCode._ui.Text_time, "二维码已过期")
            SL:ShowSystemTips("二维码已过期")
        end
        leftTime = math.max(0, leftTime - 1)
    end
    showLeftTime()
    SL:schedule(RechargeQRCode._ui.Text_time, showLeftTime, 1)
end

function RechargeQRCode.OnClose(UID)
    if UID ~= UIConst.LAYERID.RechargeQRCodeGUI then
        return false
    end

    RechargeQRCode.UnRegisterEvent()
end

function RechargeQRCode:OnRechargeReceived(data)
    UIOperator:CloseRechargeQRCodeUI()
end

function RechargeQRCode.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "RechargeQRCode", RechargeQRCode.OnClose)
    SL:RegisterLUAEvent(LUA_EVENT_RECHARGE_RECEIVED, "RechargeQRCode", RechargeQRCode.OnRechargeReceived)
end

function RechargeQRCode.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "RechargeQRCode")
    SL:UnRegisterLUAEvent(LUA_EVENT_RECHARGE_RECEIVED, "RechargeQRCode")
end

RechargeQRCode.main()
