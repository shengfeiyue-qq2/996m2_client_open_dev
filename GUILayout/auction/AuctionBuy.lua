AuctionBuy = {}

local fixMinPrice = 1
local fixMaxPrice = 2000000000

function AuctionBuy.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.AuctionBuyGUI, 0, 0, 0, 0, false, false, true, true)
    local itemData = GUI:GetLayerOpenParam()
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_buy" or "auction/auction_buy")

    AuctionBuy._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(AuctionBuy._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(AuctionBuy._ui["Panel_1"], screenW, screenH)

    GUI:addOnClickEvent(AuctionBuy._ui["Button_close"], function()
        UIOperator:CloseAuctionBuyUI()
    end)

    GUI:addOnClickEvent(AuctionBuy._ui["Button_cancel"], function()
        UIOperator:CloseAuctionBuyUI()
    end)

    GUI:addOnClickEvent(AuctionBuy._ui["Button_submit"], function(sender)
        GUI:delayTouchEnabled(sender)
        if not itemData then
            return
        end

        -- 背包已满
        if BagData.isToBeFull(true) then
            return
        end

        -- 货币不足
        local currencyCount = tonumber(SL:GetValue("ITEM_COUNT", itemData.btType))
        if currencyCount and currencyCount < itemData.nLastPrice then
            SL:ShowSystemTips(string.format("您的%s不足", SL:GetValue("ITEM_NAME", itemData.btType)))
            return
        end

        SL:RequestAuctionBid(itemData.item.MakeIndex, itemData.nLastPrice)
    end)

    -- item
    local Image_icon = AuctionBuy._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = itemData.item, look = true, index = itemData.item.Index }
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

    -- name
    GUI:Text_setString(AuctionBuy._ui["Text_name"], SL:GetValue("ITEM_NAME", itemData.item.Index))

    local goodsItem = GUI:ItemShow_Create(AuctionBuy._ui["Node_money"], "goodsItem", 0, 0, itemData.btType)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.7)

    GUI:Text_setString(AuctionBuy._ui["Text_count"], itemData.item.OverLap)
    GUI:Text_setString(AuctionBuy._ui["Text_price"], itemData.nLastPrice)

    AuctionBuy.RegisterEvent()

    SL:AttachTXTSUI({
        root  = AuctionBuy._ui.Panel_2,
        index = SLDefine.SUIComponentTable.AuctionBuy
    })
end

function AuctionBuy.Close()
    UIOperator:CloseAuctionBuyUI()
end

function AuctionBuy.OnClose(UID)
    if UID ~= UIConst.LAYERID.AuctionBuyGUI then
        return false
    end

    AuctionBuy.UnRegisterEvent()

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.AuctionBuy
    })
end


function AuctionBuy.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionBuy", AuctionBuy.OnClose)                                 -- 关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_BID, "AuctionBuy", AuctionBuy.Close)                                 -- 关闭界面
end

function AuctionBuy.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionBuy")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_BID, "AuctionBuy")
end

AuctionBuy.main()