AuctionBid = {}

local fixMinPrice = 1
local fixMaxPrice = 2000000000

function AuctionBid.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.AuctionBidGUI, 0, 0, 0, 0, false, false, true, true)
    local itemData = GUI:GetLayerOpenParam()
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_bid" or "auction/auction_bid")

    AuctionBid._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(AuctionBid._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(AuctionBid._ui["Panel_1"], screenW, screenH)

    GUI:addOnClickEvent(AuctionBid._ui["Button_close"], function()
        UIOperator:CloseAuctionBidUI()
    end)

    GUI:addOnClickEvent(AuctionBid._ui["Button_cancel"], function()
        UIOperator:CloseAuctionBidUI()
    end)

    -- 价格限制
    fixMinPrice = SL:GetValue("AUCTION_BIDPRICE_MIN") or fixMinPrice
    fixMaxPrice = SL:GetValue("AUCTION_BIDPRICE_MAX") or fixMaxPrice

    -- 加价
    local textAddPrice = AuctionBid._ui["TextField_add_price"]
    GUI:TextInput_setTextHorizontalAlignment(textAddPrice, 2)
    GUI:TextInput_addOnEvent(textAddPrice, function(_, eventType)
        if eventType == 0 then
            GUI:TextInput_setString(textAddPrice, "")

        elseif eventType == 1 then
            local input = GUI:TextInput_getString(textAddPrice)
            local inputAddPrice = tonumber(input) or 0
            inputAddPrice = math.min(inputAddPrice, fixMaxPrice - itemData.nCurPrice)
            inputAddPrice = math.max(inputAddPrice, fixMinPrice)
            GUI:TextInput_setString(textAddPrice, inputAddPrice)

            -- 出价
            local curPrice = tonumber(GUI:Text_getString(AuctionBid._ui["Text_price"])) or 0
            GUI:Text_setString(AuctionBid._ui["Text_bid_price"], curPrice + inputAddPrice)
        end
    end)

    GUI:addOnClickEvent(AuctionBid._ui["Button_submit"], function(sender)
        GUI:delayTouchEnabled(sender)
        local buyAble       = SL:GetValue("AUCTION_CAN_BUY", itemData)
        local price         = tonumber(GUI: Text_getString(AuctionBid._ui["Text_bid_price"])) or 0
        local checkPrice    = buyAble and math.min(price, itemData.nLastPrice) or price
        local currencyCount = tonumber(SL:GetValue("ITEM_COUNT", itemData.btType))

        -- 货币不足
        if currencyCount and currencyCount < checkPrice then
            SL:ShowSystemTips(string.format("您的%s不足", SL:GetValue("ITEM_NAME", itemData.btType)))
            return
        end

        -- 竞拍价超过一口价，提醒一口价购买
        if buyAble and price >= itemData.nLastPrice then
            local function callback(bType, custom)
                if bType == 1 then
                    -- 背包已满
                    if BagData.isToBeFull(true) then
                        return
                    end

                    SL:RequestAuctionBid(itemData.item.MakeIndex, itemData.nLastPrice)
                end
            end
            local data    = {}
            data.str      = "当前竞价已超过一口价，是否直接一口价购买"
            data.btnDesc  = { "确定", "取消" }
            data.callback =  callback
            UIOperator:OpenCommonTipsUI(data)
            return
        end

        SL:RequestAuctionBid(itemData.item.MakeIndex, price)
    end)

    -- item
    local Image_icon = AuctionBid._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = itemData.item, look = true, index = itemData.item.Index }
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    -- name
    GUI:Text_setString(AuctionBid._ui["Text_name"], SL:GetValue("ITEM_NAME", itemData.item.Index))

    goodsItem = GUI:ItemShow_Create(AuctionBid._ui["Node_money1"], "goodsItem1", 0, 0, itemData.btType)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.7)

    goodsItem = GUI:ItemShow_Create(AuctionBid._ui["Node_money2"], "goodsItem2", 0, 0, itemData.btType)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.7)

    goodsItem = GUI:ItemShow_Create(AuctionBid._ui["Node_money3"], "goodsItem3", 0, 0, itemData.btType)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.7)

    GUI:Text_setString(AuctionBid._ui["Text_price"], itemData.nCurPrice)

    local addprice = 1
    GUI:TextInput_setString(AuctionBid._ui["TextField_add_price"], addprice)

    GUI:Text_setString(AuctionBid._ui["Text_bid_price"], itemData.nCurPrice + addprice)

    AuctionBid.RegisterEvent()

    SL:AttachTXTSUI({
        root  = AuctionBid._ui.Panel_2,
        index = SLDefine.SUIComponentTable.AuctionBid
    })
end

function AuctionBid.Close()
    UIOperator:CloseAuctionBidUI()
end

function AuctionBid.OnClose(UID)
    if UID ~= UIConst.LAYERID.AuctionBidGUI then
        return false
    end

    AuctionBid.UnRegisterEvent()

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.AuctionBid
    })
end


function AuctionBid.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionBid", AuctionBid.OnClose)                                 -- 关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_BID, "AuctionBid", AuctionBid.Close)                                 -- 关闭界面
end

function AuctionBid.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionBid")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_BID, "AuctionBid")
end

AuctionBid.main()