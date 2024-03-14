PurchaseSell = {}

function PurchaseSell.main(data)
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "purchase_win32/purchase_sell" or "purchase/purchase_sell")

    PurchaseSell._ui = GUI:ui_delegate(parent)
    PurchaseSell._data = data

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(PurchaseSell._ui["Panel_1"], screenW / 2, posY)
    GUI:setContentSize(PurchaseSell._ui["Panel_close"], screenW, screenH)

    -- 关闭
    GUI:addOnClickEvent(PurchaseSell._ui.Button_close, function()
        SL:ClosePurchaseSellUI()
    end)

    PurchaseSell.InitShow()
end

function PurchaseSell.InitShow()
    local item = PurchaseSell._data
    if not item or not next(item) then
        return
    end
    local colorHex = SL:GetMetaValue("ITEM_NAME_COLOR_VALUE", item.itemid)
    local itemName = SL:GetMetaValue("ITEM_NAME", item.itemid)
    GUI:Text_setString(PurchaseSell._ui.Text_name, itemName)
    GUI:Text_setTextColor(PurchaseSell._ui.Text_name, colorHex)

    -- 货币类型
    local coinName = SL:GetMetaValue("ITEM_NAME", item.currency)
    GUI:Text_setString(PurchaseSell._ui.Text_coin_1, coinName)
    GUI:Text_setString(PurchaseSell._ui.Text_coin_2, coinName)
    -- 单价
    GUI:Text_setString(PurchaseSell._ui.Text_single, item.price)
    -- 总价
    GUI:Text_setString(PurchaseSell._ui.Text_total, item.price * item.totalqty)
    -- 剩余数量
    GUI:Text_setString(PurchaseSell._ui.Text_remain, item.remainqty)
    -- 拥有数量
    local haveNum = SL:GetMetaValue("ITEM_COUNT", item.itemid)
    GUI:Text_setString(PurchaseSell._ui.Text_have, haveNum)
    local minQty = math.min(item.minqty, item.remainqty)
    local isEnough = haveNum >= minQty
    GUI:Text_setTextColor(PurchaseSell._ui.Text_have, isEnough and "#00FF00" or "#FF0000")

    GUI:TextInput_addOnEvent(PurchaseSell._ui.Input_sell, function(_, type)
        local inputStr = GUI:TextInput_getString(PurchaseSell._ui.Input_sell)
        if tonumber(inputStr) then
            local value = math.min(tonumber(inputStr), haveNum)
            value = math.max(value, 0)
            GUI:TextInput_setString(PurchaseSell._ui.Input_sell, value)
        end
    end)

    GUI:addOnClickEvent(PurchaseSell._ui.Button_confirm, function ()
        if haveNum == 0 or haveNum < minQty then 
            SL:ShowSystemTips("没有足够物品可出售")
            return
        end
        local inputStr = GUI:TextInput_getString(PurchaseSell._ui.Input_sell)
        if not tonumber(inputStr) or tonumber(inputStr) <= 0 then
            SL:ShowSystemTips("未输入出售数量")
            return
        end
        if tonumber(inputStr) < minQty then
            SL:ShowSystemTips("该物品最小出售数量为" .. minQty)
            return
        end
        local reqNum = math.min(tonumber(inputStr), item.remainqty)
        if item.guid then
            SL:RequestPurchaseSell({guid = item.guid, qty = reqNum})
        end
        SL:ClosePurchaseSellUI()
    end)

end