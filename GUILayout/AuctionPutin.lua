AuctionPutin = {}

local fixMinPrice = 1
local fixMaxPrice = 2000000000

function AuctionPutin.main(itemData)
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "auction_win32/auction_putin" or "auction/auction_putin")

    AuctionPutin._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(AuctionPutin._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(AuctionPutin._ui["Panel_1"], screenW, screenH)

    AuctionPutin._bidAble        = true
    AuctionPutin._buyAble        = true
    AuctionPutin._isShowCurrency = false
    AuctionPutin._currencyIndex  = 1
    AuctionPutin._currcies       = SL:GetMetaValue("AUCTION_MONEY")
    AuctionPutin._isShowRebate   = false
    AuctionPutin._rebateIndex    = 1
    AuctionPutin._rebateItems    = {}
    table.insert(AuctionPutin._rebateItems, { value = 100, name = "无" })
    for i = 9, 1, -1 do
        table.insert(AuctionPutin._rebateItems, { value = i * 10, name = string.format("%s折", i) })
    end

    -- 价格限制
    local fixLowBidPrice  = SL:GetMetaValue("AUCTION_BIDPRICE_MIN") or fixMinPrice
    local fixHighBidPrice = SL:GetMetaValue("AUCTION_BIDPRICE_MAX") or fixMaxPrice

    local fixLowBuyPrice  = SL:GetMetaValue("AUCTION_BUYPRICE_MIN") or fixMinPrice
    local fixHighBuyPrice = SL:GetMetaValue("AUCTION_BUYPRICE_MAX") or fixMaxPrice

    GUI:addOnClickEvent(AuctionPutin._ui["Button_close"], function()
        SL:CloseAuctionPutinUI()
    end)

    GUI:addOnClickEvent(AuctionPutin._ui["Button_cancel"], function()
        SL:CloseAuctionPutinUI()
    end)

    GUI:addOnClickEvent(AuctionPutin._ui["Button_submit"], function()
        if not itemData then
            return
        end

        -- 货架满
        if SL:GetMetaValue("AUCTION_PUT_LIST_CNT") >= SL:GetMetaValue("AUCTION_DEFAULT_SHELF") then
            SL:ShowSystemTips("货架已满")
            return
        end

        -- 不可竞价和一口价
        if not AuctionPutin._bidAble and not AuctionPutin._buyAble then
            SL:ShowSystemTips("需竞拍价或一口价")
            return
        end

        -- 数量
        local inputCount = tonumber(GUI:TextInput_getString(AuctionPutin._ui["TextField_count"])) or 0
        if inputCount < 1 or inputCount > itemData.OverLap then
            SL:ShowSystemTips("请输入有效数量")
            return
        end

        -- 价格
        local currencyID    = AuctionPutin._currcies[AuctionPutin._currencyIndex].id
        local inputBidPrice = tonumber(GUI:TextInput_getString(AuctionPutin._ui["TextField_bid_price"])) or 0
        inputBidPrice       = AuctionPutin._bidAble and inputBidPrice or 0
        local inputBuyPrice = tonumber(GUI:TextInput_getString(AuctionPutin._ui["TextField_buy_price"])) or 0
        inputBuyPrice       = AuctionPutin._buyAble and inputBuyPrice or 0

        -- 可以一口价时，竞拍价需<一口价
        if AuctionPutin._bidAble and AuctionPutin._buyAble and inputBidPrice > inputBuyPrice then
            SL:ShowSystemTips("价格输入有误，一口价要高于竞价")
            return
        end
        if (AuctionPutin._bidAble and inputBidPrice < fixLowBidPrice) or (AuctionPutin._buyAble and inputBuyPrice < fixLowBuyPrice) then
            SL:ShowSystemTips("价格过低，请重新输入")
            return
        end
        if (AuctionPutin._bidAble and inputBidPrice > fixHighBidPrice) or (AuctionPutin._buyAble and inputBuyPrice > fixHighBuyPrice) then
            SL:ShowSystemTips("价格过高，请重新输入")
            return
        end

        -- 折扣
        local rebate = AuctionPutin._rebateItems[AuctionPutin._rebateIndex]

        SL:RequestAuctionPutin(itemData.MakeIndex, inputCount, inputBidPrice, inputBuyPrice, currencyID, rebate.value)        
    end)

    -- 上架数量
    local TextField_count = AuctionPutin._ui["TextField_count"]
    GUI:TextInput_setTextHorizontalAlignment(TextField_count, 1)
    GUI:TextInput_setInputMode(TextField_count, 2)
    GUI:TextInput_setFontSize(TextField_count, 18)
    GUI:TextInput_addOnEvent(TextField_count, function(_, eventType)
        if eventType == 0 then
            GUI:TextInput_setString(TextField_count, "")

        elseif eventType == 1 then
            if not itemData then
                return
            end
            local input = tonumber(GUI:TextInput_getString(TextField_count)) or 0
            if input < 1 or input > itemData.OverLap then
                SL:ShowSystemTips("请输入有效数量")
                GUI:TextInput_setString(TextField_count, math.min(math.max(input, 1), itemData.OverLap))
            end
        end
    end)

    -- 数量加
    GUI:addOnClickEvent(AuctionPutin._ui["Button_countadd"], function()
        if not itemData then
            return
        end

        local inputCount = tonumber(GUI:TextInput_getString(TextField_count)) or 0
        inputCount = inputCount + 1
        inputCount = math.min(math.max(inputCount, 1), itemData.OverLap)
        GUI:TextInput_setString(TextField_count, inputCount)
    end)

    -- 数量减
    GUI:addOnClickEvent(AuctionPutin._ui["Button_countsub"], function()
        if not itemData then
            return
        end

        local inputCount = tonumber(GUI:TextInput_getString(TextField_count)) or 0
        inputCount = inputCount - 1
        inputCount = math.min(math.max(inputCount, 1), itemData.OverLap)
        GUI:TextInput_setString(TextField_count, inputCount)
    end)

    -- 竞拍价
    local textBidPrice = AuctionPutin._ui["TextField_bid_price"]
    GUI:TextInput_setTextHorizontalAlignment(textBidPrice, 1)
    GUI:TextInput_setInputMode(textBidPrice, 2)
    GUI:TextInput_setString(textBidPrice, fixLowBidPrice)
    GUI:TextInput_setFontSize(textBidPrice, 17)
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
    local CheckBox_bid = AuctionPutin._ui["CheckBox_bid"]
    AuctionPutin.CheckBox_bid = CheckBox_bid
    GUI:CheckBox_addOnEvent(CheckBox_bid, function()
        AuctionPutin._bidAble = GUI:CheckBox_isSelected(CheckBox_bid)
        AuctionPutin.UpdateAuctionAble()
    end)

    -- 一口价
    local textBuyPrice = AuctionPutin._ui["TextField_buy_price"]
    GUI:TextInput_setTextHorizontalAlignment(textBuyPrice, 1)
    GUI:TextInput_setInputMode(textBuyPrice, 2)
    GUI:TextInput_setString(textBuyPrice, fixLowBuyPrice)
    GUI:TextInput_setFontSize(textBuyPrice, 17)
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
    local CheckBox_buy = AuctionPutin._ui["CheckBox_buy"]
    AuctionPutin.CheckBox_buy = CheckBox_buy
    GUI:CheckBox_addOnEvent(CheckBox_buy, function()
        AuctionPutin._buyAble = GUI:CheckBox_isSelected(CheckBox_buy)
        AuctionPutin.UpdateAuctionAble()
    end)

    -- auction able
    AuctionPutin.UpdateAuctionAble()

    -- item icon
    local Image_icon = AuctionPutin._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = itemData, look = true, index = itemData.Index, disShowCount = true,}
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    -- name
    GUI:Text_setString(AuctionPutin._ui["Text_name"], itemData.Name)
    -- count
    GUI:TextInput_setString(TextField_count, itemData.OverLap)

    -- 出售货币
    AuctionPutin.Image_currency = AuctionPutin._ui["Image_currency"]
    AuctionPutin.ListView_currency = AuctionPutin._ui["ListView_currency"]
    AuctionPutin.HideCurrencyCells()
    AuctionPutin.UpdateCurrency()

    -- 行会折扣
    AuctionPutin.Image_rebate = AuctionPutin._ui["Image_rebate"]
    AuctionPutin.ListView_rebate = AuctionPutin._ui["ListView_rebate"]
    AuctionPutin.HideRebateCells()
    AuctionPutin.UpdateRebate()

    -- 隐藏行会拍卖
    local isHideAuctionGuild = SL:GetMetaValue("GAME_DATA", "isHideAuctionGuild")
    isHideAuctionGuild = (isHideAuctionGuild or 0) == 1
    if isHideAuctionGuild then
        GUI:setVisible(AuctionPutin.Image_rebate, false)
        GUI:setVisible(AuctionPutin._ui["Text_1_0_0"], false)
        GUI:setVisible(AuctionPutin._ui["Node_rebate"], false)
    end
end

function AuctionPutin.UpdateAuctionAble()
    GUI:CheckBox_setSelected(AuctionPutin.CheckBox_bid, AuctionPutin._bidAble)
    GUI:CheckBox_setSelected(AuctionPutin.CheckBox_buy, AuctionPutin._buyAble)
    GUI:setVisible(AuctionPutin._ui["Panel_bid_able"], not AuctionPutin._bidAble)
    GUI:setVisible(AuctionPutin._ui["Panel_buy_able"], not AuctionPutin._buyAble)
    if not AuctionPutin._bidAble then
        GUI:TextInput_setString(AuctionPutin._ui["TextField_bid_price"], 0)
    end
    if not AuctionPutin._buyAble then
        GUI:TextInput_setString(AuctionPutin._ui["TextField_buy_price"], 0)
    end
end

function AuctionPutin.UpdateCurrency()
    local currency = AuctionPutin._currcies[AuctionPutin._currencyIndex]
    local cell = AuctionPutin.CreateCurrencyCell()
    GUI:removeAllChildren(AuctionPutin._ui["Node_currency"])
    GUI:setVisible(cell["Image_line"], false)
    local goodsItem = GUI:ItemShow_Create(cell["Node_item"], "goodsItem", 0, 0, { index = currency.item.Index, itemData = currency.item })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.6)
    GUI:Text_setString(cell["Text_name"], currency.name)
    GUI:addChild(AuctionPutin._ui["Node_currency"], cell["nativeUI"])
    GUI:addOnClickEvent(cell["nativeUI"], function()
        if AuctionPutin._isShowCurrency then
            AuctionPutin.HideCurrencyCells()
        else
            AuctionPutin.ShowCurrencyCells()
        end
    end)

    -- 竞拍价
    local Node_money_bid = AuctionPutin._ui["Node_money_bid"]
    GUI:removeAllChildren(Node_money_bid)
    local goodsItem = GUI:ItemShow_Create(Node_money_bid, "GoodsItem", 0, 0, { index = currency.id, look = true })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.6)

    -- 一口价
    local Node_money_buy = AuctionPutin._ui["Node_money_buy"]
    GUI:removeAllChildren(Node_money_buy)
    local goodsItem = GUI:ItemShow_Create(Node_money_buy, "GoodsItem", 0, 0, { index = currency.id, look = true })
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.6)
end

function AuctionPutin.CreateCurrencyCell()
    local parent = GUI:Node_Create(AuctionPutin._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_putin_currency_cell" or "auction/auction_putin_currency_cell")
    local currency_cell = GUI:getChildByName(parent, "currency_cell")
    GUI:removeFromParent(currency_cell)
    GUI:removeFromParent(parent)

    local ui = GUI:ui_delegate(currency_cell)
    return ui
end

function AuctionPutin.ShowCurrencyCells()
    AuctionPutin._isShowCurrency = true
    GUI:ListView_removeAllItems(AuctionPutin.ListView_currency)
    GUI:setVisible(AuctionPutin.ListView_currency, true)
    GUI:setVisible(AuctionPutin.Image_currency, true)

    for key, value in ipairs(AuctionPutin._currcies) do
        local cell = AuctionPutin.CreateCurrencyCell(value)
        GUI:setVisible(cell["Image_bg"], false)
        local goodsItem = GUI:ItemShow_Create(cell["Node_item"], "goodsItem", 0, 0, { index = value.item.Index, itemData = value.item })
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:setScale(goodsItem, 0.6)
        GUI:Text_setString(cell["Text_name"], value.name)
        GUI:ListView_pushBackCustomItem(AuctionPutin.ListView_currency, cell["nativeUI"])
        GUI:addOnClickEvent(cell["nativeUI"], function()
            AuctionPutin._currencyIndex = key
            AuctionPutin.HideCurrencyCells()
            AuctionPutin.UpdateCurrency()
        end)
    end

    local height = math.min(#AuctionPutin._currcies * 30, 235)
    GUI:setContentSize(AuctionPutin.ListView_currency, 150, height)
    GUI:setContentSize(AuctionPutin.Image_currency, 150, height + 5)
end

function AuctionPutin.HideCurrencyCells()
    AuctionPutin._isShowCurrency = false
    GUI:ListView_removeAllItems(AuctionPutin.ListView_currency)
    GUI:setVisible(AuctionPutin.ListView_currency, false)
    GUI:setVisible(AuctionPutin.Image_currency, false)
end

function AuctionPutin.UpdateRebate()
    local rebate = AuctionPutin._rebateItems[AuctionPutin._rebateIndex]
    local cell = AuctionPutin.CreateCurrencyCell()
    GUI:removeAllChildren(AuctionPutin._ui["Node_rebate"])
    GUI:setVisible(cell["Image_line"], false)
    GUI:Text_setString(cell["Text_name"], rebate.name)
    GUI:addChild(AuctionPutin._ui["Node_rebate"], cell["nativeUI"])
    GUI:addOnClickEvent(cell["nativeUI"], function()
        if AuctionPutin._isShowRebate then
            AuctionPutin.HideRebateCells()
        else
            AuctionPutin.ShowRebateCells()
        end
    end)
end

function AuctionPutin.ShowRebateCells()
    AuctionPutin._isShowRebate = true
    GUI:ListView_removeAllItems(AuctionPutin.ListView_rebate)
    GUI:setVisible(AuctionPutin.ListView_rebate, true)
    GUI:setVisible(AuctionPutin.Image_rebate, true)

    for key, value in ipairs(AuctionPutin._rebateItems) do
        local cell = AuctionPutin.CreateCurrencyCell()
        GUI:setVisible(cell["Image_bg"], false)
        GUI:Text_setString(cell["Text_name"], value.name)
        GUI:ListView_pushBackCustomItem(AuctionPutin.ListView_rebate, cell["nativeUI"])
        GUI:addOnClickEvent(cell["nativeUI"], function()
            AuctionPutin._rebateIndex = key
            AuctionPutin.HideRebateCells()
            AuctionPutin.UpdateRebate()
        end)
    end

    local height = math.min(#AuctionPutin._rebateItems * 30, 235)
    GUI:setContentSize(AuctionPutin.ListView_rebate, 150, height)
    GUI:setContentSize(AuctionPutin.Image_rebate, 150, height + 5)
end

function AuctionPutin.HideRebateCells()
    AuctionPutin._isShowRebate = false
    GUI:ListView_removeAllItems(AuctionPutin.ListView_rebate)
    GUI:setVisible(AuctionPutin.ListView_rebate, false)
    GUI:setVisible(AuctionPutin.Image_rebate, false)
end