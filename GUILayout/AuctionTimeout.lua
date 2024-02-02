AuctionTimeout = {}

local fixMinPrice = 1
local fixMaxPrice = 2000000000

function AuctionTimeout.main(itemData)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_putin" or "auction/auction_putin")

    AuctionTimeout._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetMetaValue("SCREEN_WIDTH") / 2
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(AuctionTimeout._ui["Panel_2"], posX, posY)

    AuctionTimeout._bidAble        = true
    AuctionTimeout._buyAble        = true
    AuctionTimeout._isShowCurrency = false
    AuctionTimeout._currencyIndex  = 1
    AuctionTimeout._currcies       = SL:GetMetaValue("AUCTION_MONEY")
    AuctionTimeout._isShowRebate   = false
    AuctionTimeout._rebateIndex    = 1
    AuctionTimeout._rebateItems    = {}
    table.insert(AuctionTimeout._rebateItems, { value = 100, name = "无" })
    for i = 9, 1, -1 do
        table.insert(AuctionTimeout._rebateItems, { value = i * 10, name = string.format("%s折", i) })
    end

    -- 价格限制
    local fixLowBidPrice  = SL:GetMetaValue("AUCTION_BIDPRICE_MIN") or fixMinPrice
    local fixHighBidPrice = SL:GetMetaValue("AUCTION_BIDPRICE_MAX") or fixMaxPrice

    local fixLowBuyPrice  = SL:GetMetaValue("AUCTION_BUYPRICE_MIN") or fixMinPrice
    local fixHighBuyPrice = SL:GetMetaValue("AUCTION_BUYPRICE_MAX") or fixMaxPrice

    GUI:addOnClickEvent(AuctionTimeout._ui["Button_close"], function()
        SL:CloseAuctionTimeoutUI()
    end)

    -- 取消上架
    GUI:addOnClickEvent(AuctionTimeout._ui["Button_cancel"], function()
        if SL:GetMetaValue("BAG_IS_FULL", true) then
            return
        end
        SL:RequestAuctionPutout(itemData.MakeIndex)        
    end)

    -- 上架
    GUI:addOnClickEvent(AuctionTimeout._ui["Button_submit"], function()
        if not itemData then
            return
        end

        -- 不可竞价和一口价
        if not AuctionTimeout._bidAble and not AuctionTimeout._buyAble then
            SL:ShowSystemTips("需竞拍价或一口价")
            return
        end

        -- 数量
        local inputCount = tonumber(GUI:TextInput_getString(AuctionTimeout._ui["TextField_count"])) or 0
        if inputCount < 1 or inputCount > itemData.OverLap then
            SL:ShowSystemTips("请输入有效数量")
            return
        end

        -- 价格
        local currencyID    = AuctionTimeout._currcies[AuctionTimeout._currencyIndex].id
        local inputBidPrice = tonumber(GUI:TextInput_getString(AuctionTimeout._ui["TextField_bid_price"])) or 0
        inputBidPrice       = AuctionTimeout._bidAble and inputBidPrice or 0
        local inputBuyPrice = tonumber(GUI:TextInput_getString(AuctionTimeout._ui["TextField_buy_price"])) or 0
        inputBuyPrice       = AuctionTimeout._buyAble and inputBuyPrice or 0

        -- 可以一口价时，竞拍价需<一口价
        if AuctionTimeout._bidAble and AuctionTimeout._buyAble and inputBidPrice > inputBuyPrice then
            SL:ShowSystemTips("价格输入有误，一口价要高于竞价")
            return
        end
        if (AuctionTimeout._bidAble and inputBidPrice < fixLowBidPrice) or (AuctionTimeout._buyAble and inputBuyPrice < fixLowBuyPrice) then
            SL:ShowSystemTips("价格过低，请重新输入")
            return
        end
        if (AuctionTimeout._bidAble and inputBidPrice > fixHighBidPrice) or (AuctionTimeout._buyAble and inputBuyPrice > fixHighBuyPrice) then
            SL:ShowSystemTips("价格过高，请重新输入")
            return
        end

        -- 折扣
        local rebate = AuctionTimeout._rebateItems[AuctionTimeout._rebateIndex]

        SL:RequestAuctionRePutin(itemData.MakeIndex, inputCount, inputBidPrice, inputBuyPrice, currencyID, rebate.value)        
    end)

    -- 上架数量
    local TextField_count = AuctionTimeout._ui["TextField_count"]
    GUI:TextInput_setTextHorizontalAlignment(TextField_count, 1)
    GUI:TextInput_setInputMode(TextField_count, 2)
    GUI:TextInput_setFontSize(TextField_count, 18)
    GUI:TextInput_addOnEvent(TextField_count, function(_, eventType)
        if eventType == 1 then
            SL:ShowSystemTips("无法修改数量")
            GUI:TextInput_setString(TextField_count, itemData.OverLap)
        end
    end)

    -- 数量加
    GUI:Button_setGrey(AuctionTimeout._ui["Button_countadd"], true)
    GUI:setTouchEnabled(AuctionTimeout._ui["Button_countadd"], false)

    -- 数量减
    GUI:Button_setGrey(AuctionTimeout._ui["Button_countsub"], true)
    GUI:setTouchEnabled(AuctionTimeout._ui["Button_countsub"], false)

    -- 竞拍价
    local textBidPrice = AuctionTimeout._ui["TextField_bid_price"]
    GUI:TextInput_setTextHorizontalAlignment(textBidPrice, 1)
    GUI:TextInput_setInputMode(textBidPrice, 2)
    GUI:TextInput_setString(textBidPrice, fixLowBidPrice)
    GUI:TextInput_addOnEvent(textBidPrice, function(_, eventType)
        if eventType == 0 then
            GUI:TextInput_setString(textBidPrice, "")

        elseif eventType == 1 then
            -- 不允许小数
            local inputBidPrice = tonumber(GUI:TextInput_getString(textBidPrice)) or 0
            inputBidPrice = math.min(math.max(inputBidPrice, fixLowBidPrice), fixHighBidPrice)
            inputBidPrice = math.floor(inputBidPrice)
            GUI:TextInput_setString(textBidPrice, inputBidPrice)
        end
    end)
    -- 竞拍价复选框
    local CheckBox_bid = AuctionTimeout._ui["CheckBox_bid"]
    AuctionTimeout.CheckBox_bid = CheckBox_bid
    GUI:CheckBox_addOnEvent(CheckBox_bid, function()
        AuctionTimeout._bidAble = GUI:CheckBox_isSelected(CheckBox_bid)
        AuctionTimeout.UpdateAuctionAble()
    end)

    -- 一口价
    local textBuyPrice = AuctionTimeout._ui["TextField_buy_price"]
    GUI:TextInput_setTextHorizontalAlignment(textBuyPrice, 1)
    GUI:TextInput_setInputMode(textBuyPrice, 2)
    GUI:TextInput_setString(textBuyPrice, fixLowBuyPrice)
    GUI:TextInput_addOnEvent(textBuyPrice, function(_, eventType)
        if eventType == 0 then
            GUI:TextInput_setString(textBuyPrice, "")

        elseif eventType == 1 then
            -- 不允许小数
            local inputBuyPrice = tonumber(GUI:TextInput_getString(textBuyPrice)) or 0
            inputBuyPrice = math.min(math.max(inputBuyPrice, fixLowBuyPrice), fixHighBuyPrice)
            inputBuyPrice = math.floor(inputBuyPrice)
            GUI:TextInput_setString(textBuyPrice, inputBuyPrice)
        end
    end)
    -- 一口价复选框
    local CheckBox_buy = AuctionTimeout._ui["CheckBox_buy"]
    AuctionTimeout.CheckBox_buy = CheckBox_buy
    GUI:CheckBox_addOnEvent(CheckBox_buy, function()
        AuctionTimeout._buyAble = GUI:CheckBox_isSelected(CheckBox_buy)
        AuctionTimeout.UpdateAuctionAble()
    end)

    -- item icon
    local Image_icon = AuctionTimeout._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = itemData, look = true, index = itemData.Index, disShowCount = true,}
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    -- name
    GUI:Text_setString(AuctionTimeout._ui["Text_name"], itemData.Name)
    -- count
    GUI:TextInput_setString(TextField_count, itemData.OverLap)

    -- default
    local defaultCurrency = 1
    local defaultRebate = 1
    for k, v in pairs(AuctionTimeout._currcies) do
        if itemData.type == v.id then
            defaultCurrency = k
            break
        end
    end
    for k, v in pairs(AuctionTimeout._rebateItems) do
        if itemData.meguildrate == v.value then
            defaultRebate = k
            break
        end
    end
    AuctionTimeout._currencyIndex = defaultCurrency
    AuctionTimeout._rebateIndex = defaultRebate
    GUI:TextInput_setString(textBidPrice, itemData.price)
    GUI:TextInput_setString(textBuyPrice, itemData.lastprice)
    AuctionTimeout._bidAble = itemData.price > 0
    AuctionTimeout._buyAble = itemData.lastprice > 0

    -- 出售货币
    AuctionTimeout.Image_currency = AuctionTimeout._ui["Image_currency"]
    AuctionTimeout.ListView_currency = AuctionTimeout._ui["ListView_currency"]
    AuctionTimeout.HideCurrencyCells()
    AuctionTimeout.UpdateCurrency()

    -- 行会折扣
    AuctionTimeout.Image_rebate = AuctionTimeout._ui["Image_rebate"]
    AuctionTimeout.ListView_rebate = AuctionTimeout._ui["ListView_rebate"]
    AuctionTimeout.HideRebateCells()
    AuctionTimeout.UpdateRebate()

    -- auction able
    AuctionTimeout.UpdateAuctionAble()
end

function AuctionTimeout.UpdateAuctionAble()
    GUI:CheckBox_setSelected(AuctionTimeout.CheckBox_bid, AuctionTimeout._bidAble)
    GUI:CheckBox_setSelected(AuctionTimeout.CheckBox_buy, AuctionTimeout._buyAble)
    GUI:setVisible(AuctionTimeout._ui["Panel_bid_able"], not AuctionTimeout._bidAble)
    GUI:setVisible(AuctionTimeout._ui["Panel_buy_able"], not AuctionTimeout._buyAble)
    if not AuctionTimeout._bidAble then
        GUI:TextInput_setString(AuctionTimeout._ui["TextField_bid_price"], 0)
    end
    if not AuctionTimeout._buyAble then
        GUI:TextInput_setString(AuctionTimeout._ui["TextField_buy_price"], 0)
    end
end

function AuctionTimeout.UpdateCurrency()
    local currency = AuctionTimeout._currcies[AuctionTimeout._currencyIndex]
    local cell = AuctionTimeout.CreateCurrencyCell()
    GUI:removeAllChildren(AuctionTimeout._ui["Node_currency"])
    GUI:setVisible(cell["Image_line"], false)
    local goodsItem = GUI:ItemShow_Create(cell["Node_item"], "goodsItem", 0, 0, { index = currency.item.Index, itemData = currency.item })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.6)
    GUI:Text_setString(cell["Text_name"], currency.name)
    GUI:addChild(AuctionTimeout._ui["Node_currency"], cell["nativeUI"])
    GUI:addOnClickEvent(cell["nativeUI"], function()
        if AuctionTimeout._isShowCurrency then
            AuctionTimeout.HideCurrencyCells()
        else
            AuctionTimeout.ShowCurrencyCells()
        end
    end)

    -- 竞拍价
    local Node_money_bid = AuctionTimeout._ui["Node_money_bid"]
    GUI:removeAllChildren(Node_money_bid)
    local goodsItem = GUI:ItemShow_Create(Node_money_bid, "GoodsItem", 0, 0, { index = currency.id, look = true })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.6)

    -- 一口价
    local Node_money_buy = AuctionTimeout._ui["Node_money_buy"]
    GUI:removeAllChildren(Node_money_buy)
    local goodsItem = GUI:ItemShow_Create(Node_money_buy, "GoodsItem", 0, 0, { index = currency.id, look = true })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.6)
end

function AuctionTimeout.CreateCurrencyCell()
    local parent = GUI:Node_Create(AuctionTimeout._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_putin_currency_cell" or "auction/auction_putin_currency_cell")
    local currency_cell = GUI:getChildByName(parent, "currency_cell")
    GUI:removeFromParent(currency_cell)
    GUI:removeFromParent(parent)

    local ui = GUI:ui_delegate(currency_cell)
    return ui
end

function AuctionTimeout.ShowCurrencyCells()
    AuctionTimeout._isShowCurrency = true
    GUI:ListView_removeAllItems(AuctionTimeout.ListView_currency)
    GUI:setVisible(AuctionTimeout.ListView_currency, true)
    GUI:setVisible(AuctionTimeout.Image_currency, true)

    for key, value in ipairs(AuctionTimeout._currcies) do
        local cell = AuctionTimeout.CreateCurrencyCell(value)
        GUI:setVisible(cell["Image_bg"], false)
        local goodsItem = GUI:ItemShow_Create(cell["Node_item"], "goodsItem", 0, 0, { index = value.item.Index, itemData = value.item })
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:setScale(goodsItem, 0.6)
        GUI:Text_setString(cell["Text_name"], value.name)
        GUI:ListView_pushBackCustomItem(AuctionTimeout.ListView_currency, cell["nativeUI"])
        GUI:addOnClickEvent(cell["nativeUI"], function()
            AuctionTimeout._currencyIndex = key
            AuctionTimeout.HideCurrencyCells()
            AuctionTimeout.UpdateCurrency()
        end)
    end

    local height = math.min(#AuctionTimeout._currcies * 30, 235)
    GUI:setContentSize(AuctionTimeout.ListView_currency, 150, height)
    GUI:setContentSize(AuctionTimeout.Image_currency, 150, height + 5)
end

function AuctionTimeout.HideCurrencyCells()
    AuctionTimeout._isShowCurrency = false
    GUI:ListView_removeAllItems(AuctionTimeout.ListView_currency)
    GUI:setVisible(AuctionTimeout.ListView_currency, false)
    GUI:setVisible(AuctionTimeout.Image_currency, false)
end

function AuctionTimeout.UpdateRebate()
    local rebate = AuctionTimeout._rebateItems[AuctionTimeout._rebateIndex]
    local cell = AuctionTimeout.CreateCurrencyCell()
    GUI:removeAllChildren(AuctionTimeout._ui["Node_rebate"])
    GUI:setVisible(cell["Image_line"], false)
    GUI:Text_setString(cell["Text_name"], rebate.name)
    GUI:addChild(AuctionTimeout._ui["Node_rebate"], cell["nativeUI"])
    GUI:addOnClickEvent(cell["nativeUI"], function()
        if AuctionTimeout._isShowRebate then
            AuctionTimeout.HideRebateCells()
        else
            AuctionTimeout.ShowRebateCells()
        end
    end)
end

function AuctionTimeout.ShowRebateCells()
    AuctionTimeout._isShowRebate = true
    GUI:ListView_removeAllItems(AuctionTimeout.ListView_rebate)
    GUI:setVisible(AuctionTimeout.ListView_rebate, true)
    GUI:setVisible(AuctionTimeout.Image_rebate, true)

    for key, value in ipairs(AuctionTimeout._rebateItems) do
        local cell = AuctionTimeout.CreateCurrencyCell()
        GUI:setVisible(cell["Image_bg"], false)
        GUI:Text_setString(cell["Text_name"], value.name)
        GUI:ListView_pushBackCustomItem(AuctionTimeout.ListView_rebate, cell["nativeUI"])
        GUI:addOnClickEvent(cell["nativeUI"], function()
            AuctionTimeout._rebateIndex = key
            AuctionTimeout.HideRebateCells()
            AuctionTimeout.UpdateRebate()
        end)
    end

    local height = math.min(#AuctionTimeout._rebateItems * 30, 235)
    GUI:setContentSize(AuctionTimeout.ListView_rebate, 150, height)
    GUI:setContentSize(AuctionTimeout.Image_rebate, 150, height + 5)
end

function AuctionTimeout.HideRebateCells()
    AuctionTimeout._isShowRebate = false
    GUI:ListView_removeAllItems(AuctionTimeout.ListView_rebate)
    GUI:setVisible(AuctionTimeout.ListView_rebate, false)
    GUI:setVisible(AuctionTimeout.Image_rebate, false)
end