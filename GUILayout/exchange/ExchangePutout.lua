ExchangePutout = {}

local function TimeFormatToStr(time)
    local day, hour, min, sec = 0, 0, 0, 0
    day                       = math.floor(time / 86400)
    hour                      = math.fmod(math.floor(time / 3600), 24)
    min                       = math.fmod(math.floor(time / 60), 60)
    sec                       = math.fmod(time, 60)
    if day < 1 then
        return string.format("%02d:%02d:%02d", hour, min, sec)
    end
    return string.format("%02d天%02d时%02d分", day, hour, min)
end

function ExchangePutout.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.ExchangePutoutGUI, 0, 0, 0, 0, false, false, true, true)
    local itemData = GUI:GetLayerOpenParam();
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_putout" or "exchange/exchange_putout")

    ExchangePutout._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(ExchangePutout._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(ExchangePutout._ui["Panel_1"], screenW, screenH)

    GUI:addOnClickEvent(ExchangePutout._ui["Button_cancel"], function()
        UIOperator:CloseExchangePutOutUI()
    end)
    GUI:addOnClickEvent(ExchangePutout._ui["Button_submit"], function(sender)
        GUI:delayTouchEnabled(sender)
        if not itemData then
            return
        end

        if BagData.isToBeFull() then
            SL:ShowSystemTips("背包空间不足！")
            return
        end

        SL:RequestExchangePutOutItem(itemData.guid)
    end)
    local Image_icon = ExchangePutout._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = SL:GetValue("ITEM_DATA", itemData.itemid), look = true, index = itemData.itemid, disShowCount = true, }
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

    -- name
    GUI:Text_setString(ExchangePutout._ui["Text_name"], SL:GetValue("ITEM_NAME", itemData.itemid))

    -- 数量
    GUI:Text_setString(ExchangePutout._ui["Text_count"], "数量：" .. (itemData.totalqty or 1))

    -- 状态
    local Text_status = ExchangePutout._ui["Text_status"]
    local Text_remaining = ExchangePutout._ui["Text_remaining"]
    local function callback()
        local status, remaining = SL:GetValue("EXCHANGE_ITEM_STATE", itemData)
        if status == 0 then
            GUI:Text_setString(Text_status, "出售中")
            GUI:Text_setTextColor(Text_status, "#28ef01")
            GUI:setVisible(Text_remaining,false)
        elseif status == 2 then
            GUI:Text_setString(Text_status, "出售中")
            GUI:Text_setTextColor(Text_status, "#28ef01")
            local timeStr = TimeFormatToStr(remaining)
            GUI:Text_setString(Text_remaining, "出售中 " .. timeStr)
            GUI:Text_setTextColor(Text_remaining, "#28ef01")
        elseif status == 3 then
            GUI:Text_setString(Text_status, "超时")
            GUI:Text_setTextColor(Text_status, "#ff0500")
            GUI:Text_setString(Text_remaining, "超时")
            GUI:Text_setTextColor(Text_remaining, "#ff0500")
        end
    end
    SL:schedule(Text_remaining, callback, 1)
    callback()

    -- 总价
    local money_bid = ExchangePutout._ui["Node_money_bid"]
    GUI:removeAllChildren(money_bid)
    local goodsItem = GUI:ItemShow_Create(money_bid, "goodsBid", 0, 0, { index = itemData.currency, look = true })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.7)
    GUI:Text_setString(ExchangePutout._ui["Text_price"], itemData.amount)

    -- 注册事件监听
    ExchangePutout:RegisterEvent()

    SL:AttachTXTSUI({
        root  = ExchangePutout._ui.Panel_2,
        index = SLDefine.SUIComponentTable.ExchangePutout
    })
end

function ExchangePutout.Close()
    GUI:Win_CloseByID(UIConst.LAYERID.ExchangePutoutGUI)
end

-- 界面关闭回调
function ExchangePutout.OnClose()
    ExchangePutout.UnRegisterEvent()

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.ExchangePutout
    })
end

function ExchangePutout.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_OUT, "ExchangePutout", ExchangePutout.Close)
end

function ExchangePutout.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_OUT, "ExchangePutout")
end

ExchangePutout.main()
