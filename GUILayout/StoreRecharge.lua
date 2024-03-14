StoreRecharge = {}

StoreRecharge.PAY_CHANNEL = {
    ALIPAY = "ALIPAY",
    HUABEI = "HUABEI",
    WEIXIN = "WEIXIN",
}



function StoreRecharge.main()
    local parent = GUI:Attach_Parent()
    
    StoreRecharge._isPC = SL:GetMetaValue("WINPLAYMODE")
    if StoreRecharge._isPC then
        GUI:LoadExport(parent, "store/store_recharge_win32")
    else
        GUI:LoadExport(parent, "store/store_recharge")
    end

    StoreRecharge._parent = parent
    StoreRecharge._ui = GUI:ui_delegate(parent)

    StoreRecharge._productID = nil     -- 商品ID
    StoreRecharge._exchange = 0        -- 获得货币值
    StoreRecharge._payChannel = nil    -- 选择的支付渠道 微信/支付宝/花呗
    StoreRecharge._productCells = {}

    StoreRecharge.InitInput()
    StoreRecharge.InitProducts()
    StoreRecharge.UpdateExchange()

    --第三方支付不显示花呗
    local bSDKPay = SL:GetMetaValue("IS_SDK_PAY")
    if bSDKPay then
        GUI:setVisible(StoreRecharge._ui.Button_huabei, false)
        GUI:setVisible(StoreRecharge._ui.Text_more, false)
        GUI:setVisible(StoreRecharge._ui.Button_weixin, true)

        local pos = GUI:getPosition(StoreRecharge._ui.Button_huabei)
        GUI:setPosition(StoreRecharge._ui.Button_weixin, pos.x, pos.y)
    end
end

function StoreRecharge.InitProducts()
    -- 商品列表
    local listview = StoreRecharge._ui.ListView_cells
    local products = SL:GetMetaValue("RECHARGE_PRODUCTS")

    for _, product in ipairs(products) do
        local productID = product.currency_itemid
        local cell = StoreRecharge.CreateProductCell(product) 
        GUI:ListView_pushBackCustomItem(listview, cell)
        StoreRecharge._productCells[productID] = cell
    end

    -- 默认选择
    if #products > 0 then
        StoreRecharge.SelectProduct(products[1].currency_itemid)
    end
end 

function StoreRecharge.SelectProduct(productID)
    if not productID then 
        return 
    end 
    
    StoreRecharge._productID = productID

    for k, cell in pairs(StoreRecharge._productCells) do
        local ui_select = GUI:getChildByName(cell, "Image_select") 
        GUI:setVisible(ui_select, StoreRecharge._productID == k)
    end

    StoreRecharge.UpdateExchange()
    StoreRecharge.UpdateDesc()
end

function StoreRecharge.UpdateExchange()
    -- 选择货币
    if not StoreRecharge._productID then
        GUI:Text_setString(StoreRecharge._ui.Text_exchange, "")
        return nil
    end

    -- 有货币信息
    local product = SL:GetMetaValue("RECHARGE_PRODUCT_BY_ID", StoreRecharge._productID)
    if not product then
        GUI:Text_setString(StoreRecharge._ui.Text_exchange, "")
        return nil
    end
    
    -- 输入是否有效
    local input = GUI:Text_getString(StoreRecharge._ui.TextField_input)
    input = tonumber(input) or 0
    if input <= 0  then
        GUI:Text_setString(StoreRecharge._ui.Text_exchange, "")
        return nil
    end

    -- 实际获得
    local exchange = 0

    -- 充值
    if product.currency_ratio and tonumber(product.currency_ratio) then
        exchange = exchange + input * tonumber(product.currency_ratio)
    end

    -- 赠送
    if product.present_ratio and tonumber(product.present_ratio) and tonumber(product.present_ratio) > 0 then
        exchange = exchange + exchange * (tonumber(product.present_ratio) / 100)
    end

    -- 单笔赠送
    if product.per_pay_present then
        -- 从大到小排序
        local items = clone(product.per_pay_present)
        table.sort(items, function(a, b)
            return tonumber(a.pay) > tonumber(b.pay)
        end)

        for _, v in pairs(items) do
            if input >= tonumber(v.pay) then
                exchange = exchange + tonumber(v.present) * tonumber(product.currency_ratio)
                break
            end
        end
    end

    -- 获得货币
    StoreRecharge._exchange = exchange
    local currencyStr = string.format("元=%s", exchange) .. product.currency_name
    -- 额外赠送
    local extraStr = ""
    if product.present_deploy and #product.present_deploy > 0 then
        local str = ""
        for _, v in ipairs(product.present_deploy) do
            str = str .. string.format("%s*%s", v.name, v.ratio * input)
            str = str .. "    "
        end
        extraStr = extraStr .. str
    end
    local showStr = currencyStr .. "    " .. extraStr
    local maxWidth = StoreRecharge._isPC and 450 or 520
    GUI:Text_setMaxLineWidth(StoreRecharge._ui.Text_exchange, maxWidth)
    GUI:Text_setString(StoreRecharge._ui.Text_exchange, showStr)
end 

function StoreRecharge.UpdateDesc()
    GUI:removeAllChildren(StoreRecharge._ui.Node_desc)

    -- 选择货币
    if not StoreRecharge._productID then
        return nil
    end

    -- 有货币信息
    local product = SL:GetMetaValue("RECHARGE_PRODUCT_BY_ID", StoreRecharge._productID)
    if not product then
        return nil
    end

    local desc = {}

    -- 额外赠送
    if product.present_deploy and #product.present_deploy > 0 then
        local str = ""
        for i, v in ipairs(product.present_deploy) do
            str = str .. string.format("%s 1:%s", v.name, v.ratio)
            str = str .. "    "
            str = str .. (i%5 == 0 and "<br>" or "")
        end
        table.insert(desc, string.format("额外赠送    %s", str))
    end

    -- 赠送比例
    if product.present_ratio and tonumber(product.present_ratio) and tonumber(product.present_ratio) > 0 then
        local str = string.format("%s%%", product.present_ratio)
        table.insert(desc, string.format("赠送比例    %s", str))
    end

    -- 单笔充值
    if product.per_pay_present and #product.per_pay_present > 0 then
        local str = ""
        for i, v in ipairs(product.per_pay_present) do
            str = str .. string.format("充%s送%s", v.pay, v.present)
            str = str .. "    "
            str = str .. (i%5 == 0 and "<br>" or "")
        end
        table.insert(desc, string.format("单笔充值    %s", str))
    end

    if #desc > 0 then
        local str = "本服充值赠送说明"
        str = str .. "<br>"
        str = str .. "&nbsp;<br>"
        for _, v in ipairs(desc) do
            str = str .. v
            str = str .. "<br>"
            str = str .. "<br>" .. "&nbsp;<br>"
        end

        local richText = GUI:RichText_Create(StoreRecharge._ui.Node_desc, "richText", 0, 0, str, 700)
        GUI:setAnchorPoint(richText, 0, 1)
    end
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
    local inputMin = tonumber(SL:GetMetaValue("GAME_DATA", "minRecharge")) or 10
    local inputMax = tonumber(SL:GetMetaValue("GAME_DATA", "maxRecharge")) or 99999999
    GUI:TextInput_setString(textInput, inputMin)
    GUI:TextInput_addOnEvent(textInput, function(sender, type)
        if type == 1 or type == 3 or type == 4 then
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

function StoreRecharge.onClickSubmitPay(channel)
    StoreRecharge._payChannel = channel
    GUI:setClickDelay(StoreRecharge._ui.Button_submit, 1)

    -- 输入金额
    local input = GUI:Text_getString(StoreRecharge._ui.TextField_input)
    input = tonumber(input) or 0
    if input <= 0 then
        SL:ShowSystemTips("请输入有效充值金额")
        return false
    end

    -- 是否有商品
    local product = SL:GetMetaValue("RECHARGE_PRODUCT_BY_ID", StoreRecharge._productID)
    if not product then
        SL:ShowSystemTips("不是有效商品")
        return false
    end

    local PayType = {
        ALIPAY = 1,
        HUABEI = 2,
        WEIXIN = 3
    }

    SL:RequestPay(PayType[channel], product.currency_itemid, input, nil)
end 