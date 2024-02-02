StoreRecharge = {}

StoreRecharge.PAY_CHANNEL = {
    ALIPAY = "ALIPAY",
    HUABEI = "HUABEI",
    WEIXIN = "WEIXIN",
}

StoreRecharge._payChannel = nil

function StoreRecharge.main()
    local parent = GUI:Attach_Parent()

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "store/store_recharge_win32")
    else
        GUI:LoadExport(parent, "store/store_recharge")
    end

    StoreRecharge._parent = parent
    StoreRecharge._ui = GUI:ui_delegate(parent)
end

function StoreRecharge.InitInput()
    local serverName = SL:GetMetaValue("SERVER_NAME")
    GUI:Text_setString(StoreRecharge._ui["Text_servername"], serverName)

    local playerName = SL:GetMetaValue("REAL_USER_NAME")
    GUI:Text_setString(StoreRecharge._ui["Text_rolename"], playerName)

    local bSDKlogin = SL:GetMetaValue("IS_SDK_LOGIN")

    local textInput = StoreRecharge._ui["TextField_input"]
    GUI:TextInput_setInputMode(textInput, 2)
    GUI:TextInput_setMaxLength(textInput, 8)
    GUI:TextInput_setString(textInput, "10")
    GUI:TextInput_addOnEvent(textInput, function(sender, type)
        if type == 1 or type == 3 or type == 4 then
            local inputMin = SL:GetMetaValue("GAME_DATA", "minRecharge") or 10
            local inputMax = SL:GetMetaValue("GAME_DATA", "maxRecharge") or 99999999
            if bSDKlogin then
                inputMin = 10
            end

            local input = tonumber(GUI:TextInput_getString(textInput)) or 0

            input = math.floor(input)

            if input < inputMin then
                SL:ShowSystemTips(string.format("最低充值%s元", inputMin))
            end

            input = math.max(input, inputMin)

            if inputMax and input > inputMax then
                SL:ShowSystemTips(string.format("最高充值%s元", inputMax))
                input = math.min(input, inputMax)
            end

            GUI:TextInput_setString(textInput, input)
            StoreRecharge.UpdateExchange()
        end
    end)

    StoreRecharge.SelectChannel(StoreRecharge.PAY_CHANNEL.ALIPAY)

    GUI:addOnClickEvent(StoreRecharge._ui["Button_alipay"], function()
        StoreRecharge.SelectChannel(StoreRecharge.PAY_CHANNEL.ALIPAY)
    end)

    GUI:addOnClickEvent(StoreRecharge._ui["Button_huabei"], function()
        StoreRecharge.SelectChannel(StoreRecharge.PAY_CHANNEL.HUABEI)
    end)

    GUI:addOnClickEvent(StoreRecharge._ui["Button_weixin"], function()
        StoreRecharge.SelectChannel(StoreRecharge.PAY_CHANNEL.WEIXIN)
    end)

    GUI:addOnClickEvent(StoreRecharge._ui["Text_more"], function()
        local bShow = GUI:getVisible(StoreRecharge._ui["Button_weixin"])
        if not bShow then
            GUI:setVisible(StoreRecharge._ui["Button_weixin"], true)
            GUI:setVisible(StoreRecharge._ui["Text_more"], false)
        end
    end)

    GUI:addOnClickEvent(StoreRecharge._ui["Button_submit"], function()
        StoreRecharge.onClickSubmitPay(StoreRecharge._payChannel)
    end)

    if bSDKlogin then
        GUI:setVisible(StoreRecharge._ui["Text_5"], false)
        GUI:setVisible(StoreRecharge._ui["Button_alipay"], false)
        GUI:setVisible(StoreRecharge._ui["Button_huabei"], false)
        GUI:setVisible(StoreRecharge._ui["Button_weixin"], false)
        GUI:setVisible(StoreRecharge._ui["Text_more"], false)
    end
end


function StoreRecharge.SelectChannel(channel)
    StoreRecharge._payChannel = channel

    local ui_alipay = StoreRecharge._ui["Button_alipay"]
    local ui_aliflag = GUI:getChildByName(ui_alipay, "Image_flag")
    GUI:setVisible(ui_aliflag, StoreRecharge._payChannel == StoreRecharge.PAY_CHANNEL.ALIPAY)
    GUI:setTouchEnabled(ui_alipay, StoreRecharge._payChannel ~= StoreRecharge.PAY_CHANNEL.ALIPAY)

    local ui_huabeipay = StoreRecharge._ui["Button_huabei"]
    local ui_huabeiflag = GUI:getChildByName(ui_huabeipay, "Image_flag")
    GUI:setVisible(ui_huabeiflag, StoreRecharge._payChannel == StoreRecharge.PAY_CHANNEL.HUABEI)
    GUI:setTouchEnabled(ui_huabeipay, StoreRecharge._payChannel ~= StoreRecharge.PAY_CHANNEL.HUABEI)

    local ui_weixinpay = StoreRecharge._ui["Button_weixin"]
    local ui_weixinflag = GUI:getChildByName(ui_weixinpay, "Image_flag")
    GUI:setVisible(ui_weixinflag, StoreRecharge._payChannel == StoreRecharge.PAY_CHANNEL.WEIXIN)
    GUI:setTouchEnabled(ui_weixinpay, StoreRecharge._payChannel ~= StoreRecharge.PAY_CHANNEL.WEIXIN)
end

function StoreRecharge.CreateProductCell(product)
    local parent = GUI:Widget_Create(StoreRecharge._ui["Panel_input"], "widget" .. product.currency_itemid, 0, 0)
    GUI:LoadExport(parent, "store/store_recharge_product_cell")

    local cell = GUI:getChildByName(parent, "Panel_cell")

    -- 名字
    local ui_name = GUI:getChildByName(cell, "Text_name")
    GUI:Text_setString(ui_name, product.currency_name)

    -- 比例
    local ui_ratio = GUI:getChildByName(cell, "Text_ratio")
    GUI:Text_setString(ui_ratio, string.format("1:%s", product.currency_ratio))

    -- 点击
    GUI:addOnClickEvent(cell, function()
        StoreRecharge.SelectProduct(product.currency_itemid)
    end)

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end 